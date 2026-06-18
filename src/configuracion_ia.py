import os
import requests
import pandas as pd
import json
from dotenv import load_dotenv
from sqlalchemy import create_engine
import sys
sys.path.append("/home/jovyan/work/src")
import conexion

# Cargar las variables de entorno del archivo .env
load_dotenv("/home/jovyan/work/.env")

# Modelo
llm_url = os.getenv("OLLAMA_URL")
llm_model = os.getenv("LLM_MODEL")

# Precargar modelo en memoria
print("Cargando modelo...")
payload = {
    "model": llm_model,
    "prompt": "",
    "keep_alive": "-1"
}
try: 
    response = requests.post(llm_url, json=payload)
    print("Modelo cargado!")
except Exception as e:
    print(f"Error: no se pudo conectar con Ollama: {e}")




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

    full_prompt = (
        f"<|begin_of_text|><|start_header_id|>system<|end_header_id|>\n\n"
        f"{system_prompt}<|eot_id|><|start_header_id|>user<|end_header_id|>\n\n"
        f"Traduce esta pregunta a SQL: {pregunta_usuario}<|eot_id|><|start_header_id|>" 
        f"assistant<|end_header_id|>\n\n"
    )
    
    payload = {
        "model": llm_model,
        "prompt": full_prompt,
        "stream": True,
        "options": {
            "temperature": 0.0 # Precisión estricta
        }
    }
    
    response = requests.post(llm_url, json=payload, stream=True)
    sql_acumulado = ""

    for line in response.iter_lines():
        if line:
            chunk = json.loads(line.decode('utf-8'))
            texto_pedazo = chunk.get('response', '')
            print(texto_pedazo, end="", flush=True)
            sql_acumulado += texto_pedazo
    return sql_acumulado.strip()

   
def ejecutar_consulta(sql):
    try:
        with engine.connect() as conn:
            df = pd.read_sql(sql, conn)
        return df
    except Exception as e:
        raise e


def preguntar_al_agente(pregunta):
    print(f"Pregunta del usuario: \n> {pregunta}\n")
    try:
        print(f"SQL Generado por el modelo:",end="\n", flush=True)
        sql = text_to_sql(pregunta)
        print("\n")
        
        print("Conectando a la base de datos...")
        df_resultado = ejecutar_consulta(sql)

        print("Resultado:")
        display(df_resultado)
        
    except Exception as e:
        print(f"Ocurrió un error:\n{e}\n\n")