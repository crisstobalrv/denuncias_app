# App de Denuncias DUOC – Flutter + Flask + Ngrok

- Asignatura: Desarrollo de Aplicaciones en Android
- Evaluación 2 – Entrega 2
- Integrante: Cristóbal Adolfo Retamal Vásquez

---

## 1. Descripción General del Proyecto

Este proyecto consiste en una aplicación móvil Flutter conectada a una API REST desarrollada con Flask, expuesta a Internet mediante Ngrok.
La app permite a los estudiantes denunciar problemas de aseo o riesgos en el campus DUOC UC, enviando:
  - Correo DUOC
  - Descripción
  - Fotografía (cámara)
  - Ubicación (GPS)

---

## 2. Estructura del repositorio

```text
├── app-flutter/
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
    ├── server-flask/
    │   ├── app.py
    │   ├── database.py
    │   ├── models.py
    │   ├── denuncias.db        # (se genera al ejecutar)
    │   └── uploads/            # imágenes subidas
    │   └── android/ ...        # proyecto Flutter estándar
 ```
---
## 3. Backend – Servidor Flask
### 3.1. Requisitos
- Python 3.x
- Flask
- Flask-CORS
- SQLAlchemy
- Ngrok (para exponer API)
- SQLite
### 3.2 Instalacion
```text
cd server-flask
python -m venv venv
venv\Scripts\activate   # Windows
pip install flask flask-cors sqlalchemy pillow
```

### 3.3 Ejecutar servidor
```text
python app.py
```
---
## 4. Exponer API con Ngrok
### 4.1 En una terminal:
```text
ngrok http 5000
```
Usar la url entregada en la app de flutter

---

## 5. App Flutter – Instalación y configuración

### 5.1 Requisitos
- Flutter SDK 3.x
- Android Studio
- Emulador o dispositivo físico
### 5.2. Dependencias usadas
```text
http: ^1.2.0
image_picker: ^1.0.7
geolocator: ^12.0.0
```

### 5.3. Configurar baseUrl (Ngrok)
En lib/services/api_service.dart:
```text
static const String baseUrl = 'https://AQUI_TU_URL_NGROK/api';
```
### 5.4. Permisos Android
En android/app/src/main/AndroidManifest.xml:
```text
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```
### 5.5. Ejecutar la app
En Android Studio ejecutamos la aplicacion.

```text
```
---

## 6. Pruebas de API (Postman)
### 6.1. Crear denuncia (POST)
En Postman:
```text
Método: POST
URL: https://unknighted-forcingly-lavelle.ngrok-free.dev/api/denuncias
Body: form-data
correo (text)
descripcion (text)
lat (text)
lng (text)
foto (archivo)

Respuesta 201 con { "message": "Denuncia creada", "id": X }
```
### Imagen:

<img width="1161" height="729" alt="image" src="https://github.com/user-attachments/assets/35ddcc67-5e2c-4eac-8f9e-becb3694c337" />

### 6.2. Listar denuncias (GET)
En Postman:
```text
Método: GET
URL: https://unknighted-forcingly-lavelle.ngrok-free.dev/api/denuncias
Respuesta: una lista JSON con las denuncias creadas
```
### Imagen:
<img width="1148" height="766" alt="image" src="https://github.com/user-attachments/assets/7d9c0552-dd48-4ccc-8221-67e5b51bcf54" />

### 6.3. Obtener denuncia por ID (GET /<id>)
En Postman:
```text
Método: GET
URL: https://unknighted-forcingly-lavelle.ngrok-free.dev/api/denuncias/1
Respuesta: una lista JSON con el detalle de la denuncia solicitada (1)
```

#### Imagen

<img width="756" height="574" alt="image" src="https://github.com/user-attachments/assets/7dfe2359-8d00-4fc1-b403-181a34720221" />

---

## 7. Capturas de Pantalla
### 7.1. Levantamiento del servidor Flask
<img width="990" height="180" alt="7 1 upflask" src="https://github.com/user-attachments/assets/dbf0ede7-502e-47a3-9fd2-88a160f900e3" />

### 7.2. Ngrok activo
<img width="906" height="279" alt="image" src="https://github.com/user-attachments/assets/59142947-cf91-4cb9-871a-1aa3929a1a70" />

### 7.3. App Flutter – Pantalla Listado
<img width="323" height="711" alt="image" src="https://github.com/user-attachments/assets/25fff3a7-d7d6-4273-a197-ebb32d22d45e" />

### 7.4. App Flutter – Nueva Denuncia
<img width="324" height="708" alt="image" src="https://github.com/user-attachments/assets/06f15c65-7f00-4404-a442-529661def4cd" />

### 7.5. App Flutter – Detalle de Denuncia
<img width="319" height="700" alt="image" src="https://github.com/user-attachments/assets/d9ec4d75-9370-46ec-aba8-56e76b5b31f9" />














