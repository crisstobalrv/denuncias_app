import os
from datetime import timedelta

from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
from sqlalchemy.orm import Session
from dotenv import load_dotenv
from flask_jwt_extended import (
    JWTManager,
    create_access_token,
    jwt_required,
    get_jwt_identity,
)

from database import Base, engine, SessionLocal
from models import Denuncia

# Cargar variables de entorno (.env)
load_dotenv()

UPLOAD_FOLDER = "uploads"

app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

# Claves desde .env (NO hardcodear)
app.config["SECRET_KEY"] = os.getenv("SECRET_KEY", "fallback-secret")
app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY", "fallback-jwt-secret")

# Tiempo de expiración del token (opcional, también puedes usar la var de entorno)
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(
    seconds=int(os.getenv("JWT_ACCESS_TOKEN_EXPIRES", "3600"))
)

CORS(app)
jwt = JWTManager(app)

os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# Crear tablas si no existen
Base.metadata.create_all(bind=engine)


# ===== Helper para DB =====
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# ===== Endpoint de Login (JWT) =====
@app.post("/login")
def login():
    """
    Login muy simple: valida usuario/clave y retorna JWT.
    En un caso real, deberías validar contra una tabla de usuarios en BD.
    """
    data = request.get_json()
    if not data:
        return jsonify({"msg": "JSON requerido"}), 400

    correo = data.get("correo")
    password = data.get("password")

    # DEMO: usuario "alumno@duoc.cl" con contraseña "123456"
    if correo == "alumno@duoc.cl" and password == "123456":
        # identity puede ser el correo o un id de usuario
        access_token = create_access_token(identity=correo)
        return jsonify({"access_token": access_token}), 200

    return jsonify({"msg": "Credenciales inválidas"}), 401


# ===== Endpoint: Crear denuncia (PROTEGIDO) =====
@app.post("/api/denuncias")
@jwt_required()
def crear_denuncia():
    current_user = get_jwt_identity()  # por si quieres usarlo
    db = next(get_db())

    correo = request.form.get("correo")
    descripcion = request.form.get("descripcion")
    lat = request.form.get("lat")
    lng = request.form.get("lng")
    foto = request.files.get("foto")

    if not correo or not descripcion or not lat or not lng or not foto:
        return jsonify({"error": "Datos incompletos"}), 422  # 422 Unprocessable Entity

    # Guardar imagen
    filename = foto.filename
    save_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
    foto.save(save_path)

    denuncia = Denuncia(
        correo=correo,
        descripcion=descripcion,
        foto=filename,
        lat=float(lat),
        lng=float(lng)
    )

    db.add(denuncia)
    db.commit()
    db.refresh(denuncia)

    return jsonify({"message": "Denuncia creada", "id": denuncia.id}), 201


# ===== Endpoint: Listar denuncias (puede ser público o protegido) =====
@app.get("/api/denuncias")
def listar_denuncias():
    db = next(get_db())
    denuncias = db.query(Denuncia).all()

    data = []
    for d in denuncias:
        data.append({
            "id": d.id,
            "correo": d.correo,
            "descripcion": d.descripcion,
            "foto_url": f"{request.host_url}uploads/{d.foto}",
            "ubicacion": {"lat": d.lat, "lng": d.lng},
            "fecha": d.fecha.isoformat()
        })

    return jsonify(data), 200


# ===== Endpoint: Detalle por ID (puede ser público o protegido) =====
@app.get("/api/denuncias/<int:id>")
def obtener_denuncia(id):
    db = next(get_db())
    d = db.query(Denuncia).filter(Denuncia.id == id).first()

    if not d:
        return jsonify({"error": "No encontrada"}), 404

    return jsonify({
        "id": d.id,
        "correo": d.correo,
        "descripcion": d.descripcion,
        "foto_url": f"{request.host_url}uploads/{d.foto}",
        "ubicacion": {"lat": d.lat, "lng": d.lng},
        "fecha": d.fecha.isoformat()
    }), 200


# ===== Servir imágenes =====
@app.get("/uploads/<filename>")
def get_image(filename):
    return send_from_directory(app.config["UPLOAD_FOLDER"], filename)


# ===== Manejo de errores JWT (401, 422) =====
@jwt.unauthorized_loader
def unauthorized_callback(reason):
    # Cuando no se manda el header Authorization
    return jsonify({"msg": "Token faltante o inválido", "detail": reason}), 401


@jwt.invalid_token_loader
def invalid_token_callback(reason):
    # Token mal formado
    return jsonify({"msg": "Token inválido", "detail": reason}), 422


@jwt.expired_token_loader
def expired_token_callback(jwt_header, jwt_payload):
    # Token expirado
    return jsonify({"msg": "Token expirado"}), 401


if __name__ == "__main__":
    app.run(debug=True, port=5000)
