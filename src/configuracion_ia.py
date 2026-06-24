import os
import requests
from sqlalchemy import text
import pandas as pd
import json
from dotenv import load_dotenv
from IPython.display import display
from groq import Groq


# Cargar las variables de entorno del archivo .env
load_dotenv("/home/jovyan/work/.env")

from src.conexion import engine

# Modelo
client = Groq(api_key=os.getenv("GROQ_API_KEY"))
llm_model = os.getenv("GROQ_MODEL")





def cargar_system_prompt():
    ruta_prompt = '/home/jovyan/work/notebooks/prompt_sistema.md'
    try: 
        with open(ruta_prompt, "r", encoding="utf-8") as f:
            return f.read()
    except FileNotFoundError:
        print("Error: no se encontró el archivo de prompt de sistema.")
        return ""


def text_to_sql(pregunta_usuario):
    system_prompt = cargar_system_prompt()

    if not system_prompt:
        raise Exception("No se pudo cargar el prompt del sistema.")

    messages = [
        {
            "role": "system",
            "content": system_prompt
        },
        {
            "role": "user",
            "content": f"Traduce a SQL: {pregunta_usuario}"
        }
    ]

    response = client.chat.completions.create(
        model=llm_model,
        messages=messages,
        temperature=0,
        max_tokens=500
    )

    sql = response.choices[0].message.content.strip()

    print("SQL GENERADO:\n", sql)

    if not sql:
        raise Exception("El modelo no devolvió SQL")

    return sql

   
def ejecutar_consulta(sql):
    sql = sql.replace("```sql", "").replace("```", "").strip()

    if not sql.lower().startswith("select"):
        raise Exception(f"Solo SELECT permitido. SQL recibido: {sql}")

    with engine.connect() as conn:
        result = conn.execute(text(sql))
        rows = result.mappings().all()

    return pd.DataFrame(rows)


def preguntar_al_agente(pregunta):
    print(f"Pregunta del usuario:\n> {pregunta}\n")

    try:

        if pregunta.lower().startswith("recomendar"):
            dato = pregunta.split(maxsplit=1)[1]

            print("Generando recomendaciones...\n")

            df = obtener_recomendaciones_ia(dato)

            display(df)

            return
        
        sql = text_to_sql(pregunta)

        if not sql.strip():
            raise Exception("El modelo devolvió SQL vacío")

        if not sql.lower().strip().startswith("select"):
            raise Exception(f"SQL inválido generado: {sql}")

        print("\nConectando a la base de datos...")

        df_resultado = ejecutar_consulta(sql)

        print("Resultado:")
        display(df_resultado)

    except Exception as e:
        print(f"Ocurrió un error:\n{e}\n")
        

def obtener_recomendaciones_ia(dni_o_id):

    campo_busqueda = (
        "id_socio"
        if str(dni_o_id).isdigit() and len(str(dni_o_id)) <= 5
        else "dni"
    )

    try:

        # ==========================
        # HISTORIAL DEL SOCIO
        # ==========================
        query_historial = f"""
        SELECT DISTINCT
            CONCAT(a.nombre, ' ', a.apellido) AS autor_nombre,
            g.nombre AS genero_nombre
        FROM socio s
        JOIN prestamo p ON s.id_socio = p.id_socio
        JOIN ejemplar e ON p.id_ejemplar = e.id_ejemplar
        JOIN libro l ON e.isbn = l.isbn
        JOIN libroAutor la ON l.isbn = la.isbn
        JOIN autor a ON la.id_autor = a.id_autor
        JOIN generoLibro gl ON l.isbn = gl.isbn
        JOIN genero g ON gl.id_genero = g.id_genero
        WHERE s.{campo_busqueda} = :valor
        """

        with engine.connect() as conn:

            historial = pd.read_sql(
                text(query_historial),
                conn,
                params={"valor": int(dni_o_id)}
            )
            print("Cantidad filas:", len(historial))


            print(historial.head())
            if historial.empty:
                return pd.DataFrame([
                    {
                        "titulo": "",
                        "autor": "",
                        "genero": "",
                        "motivo": "El socio no posee historial suficiente para generar recomendaciones."
                    }
                ])

            autores_leidos = sorted(
                historial["autor_nombre"].dropna().unique().tolist()
            )

            generos_leidos = sorted(
                historial["genero_nombre"].dropna().unique().tolist()
            )

            # ==========================
            # LIBROS CANDIDATOS
            # ==========================
            query_candidatos = f"""
            SELECT DISTINCT
                l.titulo,
                CONCAT(a.nombre, ' ', a.apellido) AS autor,
                g.nombre AS genero,
                l.stock_disponible
            FROM libro l
            JOIN libroAutor la ON l.isbn = la.isbn
            JOIN autor a ON la.id_autor = a.id_autor
            JOIN generoLibro gl ON l.isbn = gl.isbn
            JOIN genero g ON gl.id_genero = g.id_genero
            WHERE l.stock_disponible > 0
              AND l.isbn NOT IN (
                    SELECT DISTINCT e3.isbn
                    FROM prestamo p3
                    JOIN ejemplar e3 ON p3.id_ejemplar = e3.id_ejemplar
                    JOIN socio s3 ON p3.id_socio = s3.id_socio
                    WHERE s3.{campo_busqueda} = :valor
              )
            LIMIT 15
            """
            print("campo_busqueda =", campo_busqueda)
            print("dni_o_id =", dni_o_id)
            print(query_historial)

            candidatos = pd.read_sql(
                text(query_candidatos),
                conn,
                params={"valor": dni_o_id}
            )

            if candidatos.empty:
                return pd.DataFrame([
                    {
                        "titulo": "",
                        "autor": "",
                        "genero": "",
                        "motivo": "No se encontraron libros disponibles para recomendar."
                    }
                ])

            # ==========================
            # PROMPT PARA GROQ
            # ==========================
            prompt = f"""
            Sos un sistema inteligente de recomendación de libros de una biblioteca.

            Autores preferidos del socio:
            {", ".join(autores_leidos)}

            Géneros preferidos del socio:
            {", ".join(generos_leidos)}

            Libros disponibles:

            {candidatos.to_json(orient="records", force_ascii=False)}

            TAREA:

            1. Elegí exactamente 3 libros.
            2. Utilizá únicamente libros de la lista proporcionada.
            3. No inventes títulos ni autores.
            4. Priorizá coincidencias con autores y géneros ya leídos.
            5. Respondé EXCLUSIVAMENTE en JSON válido.
            6. No agregues texto fuera del JSON.

            Formato esperado:

            [
            {{
                "titulo": "Título",
                "autor": "Autor",
                "genero": "Género",
                "motivo": "Motivo de la recomendación"
            }}
            ]
            """

            response = client.chat.completions.create(
                model=llm_model,
                messages=[
                    {
                        "role": "system",
                        "content": (
                            "Sos un recomendador experto de libros. "
                            "Respondé únicamente JSON válido."
                        )
                    },
                    {
                        "role": "user",
                        "content": prompt
                    }
                ],
                temperature=0.3,
                max_tokens=300
            )

            contenido = response.choices[0].message.content.strip()

            contenido = (
                contenido
                .replace("```json", "")
                .replace("```", "")
                .strip()
            )

            recomendaciones = json.loads(contenido)

            return pd.DataFrame(recomendaciones)

    except json.JSONDecodeError:
        return pd.DataFrame([
            {
                "titulo": "",
                "autor": "",
                "genero": "",
                "motivo": "La IA devolvió un JSON inválido."
            }
        ])

    except Exception as e:
        return pd.DataFrame([
            {
                "titulo": "",
                "autor": "",
                "genero": "",
                "motivo": f"Error: {str(e)}"
            }
        ])
