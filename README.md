
# BiblioIA

## Sistema de Gestion de Biblioteca con Agente de Inteligencia Artificial

### Trabajo Práctico Integrador | Bases de Datos (2026)

#### UTN FRCU

Este proyecto provee un entorno de desarrollo basado en Docker que incluye:

- **Jupyter Notebook** para el desarrollo y ejecución de código Python.
- **Ollama** para ejecutar modelos de inteligencia artificial localmente.
- Integración opcional con GPU para acelerar la inferencia de modelos.

###### Equipo Jirafa

- Emmanuel Díaz [@emmanueldiaz707](https://github.com/emmanueldiaz707)
- Juliana Sigales [@mjulianasig1-cloud](https://github.com/mjulianasig1-cloud)
- Luciana Farabello [@lfarabello24-beep](https://github.com/lfarabello24-beep)
- Mia Buet
- Rodrigo Rodríguez [@NTVG-Rodri](https://github.com/NTVG-Rodri)

---

## Estructura del entorno

Al iniciar el proyecto se crean los siguientes contenedores: 

| Nombre                    | Puerto | Imagen                  |
| ------------------------- | ------ | ----------------------- |
| `integrador-bd-jupyter-1` | 8888   | `integrador-bd-jupyter` |
| `integrador-bd-ollama-1`  | 11434  | `ollama/ollama:latest`  |

---

## Requisitos previos

- Docker Desktop instalado y funcionando.
- Windows 10/11 con WSL2 habilitado.

---

## Guía de inicio

### 1. Iniciar el entorno

Abrir una terminal en la raíz del proyecto y ejecutar: 

```
docker compose up -d
```

La primera ejecución puede tardar varios minutos debido a la descarga y construcción de imágenes.

### 2. Verificar el estado

Para verificar que los contenedores están funcionando:

```
docker ps
```

Deberían aparecer los contenedores de Jupyter y Ollama en estado Up.

### 3. Acceder a Jupyter Notebook

Una vez iniciado el entorno, abrir en el navegador:

```
http://localhost:8888
```

Utilizar el token configurado en el archivo `docker-compose.yml`.

---

## Configuración de Ollama

El contenedor de Ollama viene vacío por defecto. Es necesario descargar un modelo. 

### Descargar el modelo

Para descargar el modelo (por ejemplo `llama3.2`), ejecutar: 

```
docker exec -it integrador-bd-ollama-1 ollama run llama3.2
```

La primera ejecución descargará el modelo automáticamente.

### Prueba de funcionamiento

Se puede verificar rápidamente el motor de IA enviando una consulta directa desde la terminal: 
 
```
docker exec -it integrador-bd-ollama-1 ollama run llama3.2 "Hola"
```

---

## Aceleración por Hardware (Opcional)

Ollama puede utilizar una tarjeta gráfica dedicada para acelerar significativamente la generación de respuestas.

Es necesario tener instalados los drivers más recientes desde el sitio oficial del fabricante.

***NOTA**: por el momento la aceleración sólo se ha validado para GPUs NVIDIA.*

Si no se dispone de una GPU compatible o de los drivers adecuados, Ollama utilizará la CPU automáticamente. El proyecto funcionará normalmente, aunque con menor rendimiento.

### 1. Verificar acceso a la GPU desde Docker

#### NVIDIA (CUDA)

Ejecutar: 

```
docker run --rm --gpus all nvidia/cuda:12.9.0-base-ubuntu22.04 nvidia-smi
```

La primera ejecución descargará una imagen de prueba de NVIDIA.

Si la configuración es correcta se mostrará información sobre la GPU instalada.

Esta prueba verifica que:

- Los drivers NVIDIA están instalados correctamente.
- Docker Desktop tiene acceso a la GPU.
- WSL2 está configurado correctamente.
- Los contenedores pueden utilizar CUDA.

### 2. Verificar que el modelo esté utilizando la GPU

Con el entorno corriendo y el modelo bajo uso, ejecutar el siguiente comando para auditar los recursos que está consumiendo Ollama: 

```
docker exec -it integrador-bd-ollama-1 ollama ps
```

Si aparece una salida similar a:

```
NAME             PROCESSOR      
llama3.2:latest  100% GPU         
```

significa que el modelo está alojado completamente en la VRAM de la GPU.

Si aparece `100% CPU` o una combinación de CPU y GPU, el modelo está utilizando recursos del procesador. 


---

## Detener el entorno

Para detener los contenedores de forma segura:

```
docker compose down
```

Los modelos descargados en Ollama y los notebooks de Jupyter permanecerán almacenados localmente.

