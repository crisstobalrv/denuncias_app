from sqlalchemy import Column, Integer, String, Float, DateTime
from datetime import datetime
from database import Base

class Denuncia(Base):
    __tablename__ = "denuncias"

    id = Column(Integer, primary_key=True, index=True)
    correo = Column(String, nullable=False)
    descripcion = Column(String, nullable=False)
    foto = Column(String, nullable=False)   #
    lat = Column(Float, nullable=False)
    lng = Column(Float, nullable=False)
    fecha = Column(DateTime, default=datetime.utcnow)
