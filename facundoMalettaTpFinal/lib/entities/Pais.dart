class Pais {
  final String nombre;
  final String continente;
  final String poblacion;
  final String poster;

  Pais({
    required this.nombre,
    required this.continente,
    required this.poblacion,
    required this.poster,
  });

  factory Pais.fromFirestore(Map<String, dynamic> data) {
    return Pais(
      nombre: data['nombre'],
      continente: data['continente'],
      poblacion: data['poblacion'],
      poster: data['poster'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'continente': continente,
      'poblacion': poblacion,
      'poster': poster,
    };
  }
}
