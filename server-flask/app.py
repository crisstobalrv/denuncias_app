import os
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
from sqlalchemy.orm import Session
from database import Base, engine, SessionLocal
from models import Denuncia

UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

CORS(app)

Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/api/denuncias")
def crear_denuncia():
    db = next(get_db())

    correo = request.form.get("correo")
    descripcion = request.form.get("descripcion")
    lat = request.form.get("lat")
    lng = request.form.get("lng")
    foto = request.files.get("foto")

    if not correo or not descripcion or not lat or not lng or not foto:
        return jsonify({"error": "Datos incompletos"}), 400

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


# ===== Endpoint: Listar denuncias =====
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


# ===== Endpoint: Detalle por ID =====
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


if __name__ == "__main__":
    app.run(debug=True, port=5000)
