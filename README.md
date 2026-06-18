# BiblioIA

## Sistema de Gestión de Biblioteca con Agente de Inteligencia Artificial

### Trabajo Práctico Integrador | Bases de Datos (2026)

#### UTN FRCU

Este proyecto provee un entorno de desarrollo basado en Docker que incluye:

- **Jupyter Notebook** para desarrollo y ejecución de Python
- **Groq API** para ejecución de modelos de inteligencia artificial (LLMs)
- Integración con base de datos SQL para análisis y consultas mediante lenguaje natural

---

## Descripción del sistema

BiblioIA es un sistema que convierte preguntas en lenguaje natural en consultas SQL automáticamente mediante un agente de IA.

El flujo del sistema es:
```md
Usuario → Lenguaje natural → LLM (Groq) → SQL → Base de datos → Resultado
```

---

## Equipo Jirafa

- Emmanuel Díaz [@emmanueldiaz707](https://github.com/emmanueldiaz707)
- Juliana Sigales [@mjulianasig1-cloud](https://github.com/mjulianasig1-cloud)
- Luciana Farabello [@lfarabello24-beep](https://github.com/lfarabello24-beep)
- Mia Buet [@buetmia-sudo](https://github.com/buetmia-sudo)
- Rodrigo Rodríguez [@NTVG-Rodri](https://github.com/NTVG-Rodri)

---

## Estructura del entorno

Al iniciar el proyecto se crean los siguientes contenedores:

| Nombre                    | Puerto | Imagen                   |
| ------------------------- | ------ | ------------------------ |
| `integrador-bd-jupyter-1` | 8888   | `integrador-bd-jupyter` |

> Nota: Ollama fue reemplazado por Groq (API cloud)

---

## Requisitos previos

- Docker Desktop instalado y funcionando
- WSL2 (en Windows)
- Cuenta en Groq Cloud para obtener API Key

---

## Guía de inicio

### 1. Configurar variables de entorno

Crear un archivo `.env` en la raíz del proyecto:

```env
GROQ_API_KEY=tu_api_key
GROQ_MODEL=llama-3.3-70b-versatile
```

### 2. Iniciar el entorno

```Bash 
docker compose up -d
```
### 3. Verificar contenedores
```Bash
docker ps
```
### 4. Acceder a Jupyter
Abrir en el navegador:
```Bash
http://localhost:8888
```
---

## Configuracion de Groq
El sistema utiliza la API de Groq para ejecutar modelos LLM en la nube.

### Modelos recomendados:
- llama-3.3-70b-versatile
- llama-3.1-8b-instant
- mixtral-8x7b-32768

---

## Base de datos
El sistema se conecta a una base de datos SQL (MySQL).

El agente utiliza:
- Tablas Normalizadas
- Vistas SQL como capa semantica
- Consultas generadas automaticamente por IA

---

## Consideraciones
- Se puede adaptar la infraestructura local de modelos (Ollama).
- En este caso con Groq la IA depende de conexion a internet.
- La API de Groq tiene limites de uso gratuitos.

---

## Detener el entorno
```Bash
docker compose down
```
---

## Conclusion
Este proyecto demuestra:
- Integracion de IA con bases de datos.
- Generacion automatica de SQL.
- Arquitectura moderna basada en LLMs cloud.

