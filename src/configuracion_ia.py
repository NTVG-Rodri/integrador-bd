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
        max_tokens=300
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
    print(f"Pregunta del usuario: \n> {pregunta}\n")
    try:
        print(f"SQL Generado por el modelo:",end="\n", flush=True)
        sql = text_to_sql(pregunta)



        if not sql.strip():
            raise Exception("El modelo devolvió SQL vacío")

        if not sql.lower().strip().startswith("select"):
            raise Exception(f"SQL inválido generado: {sql}")
        print("\n")
        
        print("Conectando a la base de datos...")
                
        df_resultado = ejecutar_consulta(sql)

        print("Resultado:")
        display(df_resultado)
        
    except Exception as e:
        print(f"Ocurrió un error:\n{e}\n\n")