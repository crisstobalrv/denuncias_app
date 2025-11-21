class Denuncia {
  final int id;
  final String correo;
  final String descripcion;
  final String fotoUrl;
  final double lat;
  final double lng;
  final DateTime fecha;

  Denuncia({
    required this.id,
    required this.correo,
    required this.descripcion,
    required this.fotoUrl,
    required this.lat,
    required this.lng,
    required this.fecha,
  });

  factory Denuncia.fromJson(Map<String, dynamic> json) {
    return Denuncia(
      id: json['id'] ?? 0,
      correo: json['correo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fotoUrl: json['foto_url'] ?? '',
      lat: (json['ubicacion']?['lat'] ?? 0).toDouble(),
      lng: (json['ubicacion']?['lng'] ?? 0).toDouble(),
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
    );
  }
}
