from sqlalchemy import create_engine
import os

# SQLAlchemy
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
database = os.getenv("DB_NAME")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")    
conexion_url = f"mysql+mysqlconnector://{user}:{password}@{host}:{port}/{database}"


engine = create_engine(conexion_url)

