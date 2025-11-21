# App de Denuncias DUOC – Flutter + Flask + Ngrok

Aplicación móvil para **denunciar problemas de aseo y riesgos** dentro de la comunidad estudiantil DUOC.

Incluye:

- **Backend** en Flask + SQLite + subida de imágenes
- **Exposición pública** de la API usando Ngrok
- **App móvil** en Flutter con 3 pantallas:
  - Crear nueva denuncia
  - Listar denuncias
  - Ver detalle de una denuncia

---

## 1. Tecnologías utilizadas

### Backend (server-flask)

- Python 3.x
- Flask
- Flask-CORS
- SQLite
- SQLAlchemy
- Ngrok

### Frontend (app-flutter)

- Flutter SDK 3.x
- Dart
- HTTP package
- Image Picker (cámara)
- Geolocator (ubicación)
- Material Design

---

## 2. Estructura del repositorio

```text
/
├── server-flask/
│   ├── app.py
│   ├── database.py
│   ├── models.py
│   ├── denuncias.db        # (se genera al ejecutar)
│   └── uploads/            # imágenes subidas
│
└── app-flutter/
    ├── lib/
    │   ├── main.dart
    │   ├── models/
    │   │   └── denuncia.dart
    │   ├── services/
    │   │   └── api_service.dart
    │   └── screens/
    │       ├── new_report_screen.dart
    │       ├── report_list_screen.dart
    │       └── report_detail_screen.dart
    └── android/ ...        # proyecto Flutter estándar
