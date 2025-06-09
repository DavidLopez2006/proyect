// Archivo: lib/modelos/revista.dart
import 'package:gestor_biblioteca_digital/modelos/recurso_biblioteca.dart';

/// Clase que representa una revista en la biblioteca.
/// Hereda de RecursoBiblioteca.
class Revista extends RecursoBiblioteca {
  int numeroEdicion;
  String periodicidad; // Ej: "Mensual", "Semanal"

  Revista({
    required super.id,
    required super.titulo,
    required super.anioPublicacion,
    super.disponible,
    required this.numeroEdicion,
    required this.periodicidad,
  });

  @override
  void mostrarDetalles() {
    print('--- Revista ---');
    print('  ID: $id');
    print('  Título: $titulo');
    print('  Año de Publicación: $anioPublicacion');
    print('  Número de Edición: $numeroEdicion');
    print('  Periodicidad: $periodicidad');
    print('  Disponibilidad: ${disponible ? 'Disponible' : 'Prestado'}');
  }
}