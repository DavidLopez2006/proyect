// Archivo: lib/modelos/autor.dart
import '\gestor_biblioteca_digital\lib\modelos\autor.dart';

/// Clase que representa a un autor de libros o creador de recursos.
/// Implementa la interfaz Identificable.
class Autor implements Identificable {
  @override
  final String id;
  String nombreCompleto;
  String nacionalidad;
  DateTime fechaNacimiento;

  Autor({
    required this.id,
    required this.nombreCompleto,
    required this.nacionalidad,
    required this.fechaNacimiento,
  });

  /// Muestra la información básica del autor.
  void mostrarInformacion() {
    print('Autor ID: $id');
    print('  Nombre: $nombreCompleto');
    print('  Nacionalidad: $nacionalidad');
    print('  Fecha de Nacimiento: ${fechaNacimiento.toLocal().toString().split(' ')[0]}');
  }

  // Sobrescribir hashCode y == para usar Autor en un Set correctamente (si el ID es el identificador único)
  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Autor && runtimeType == other.runtimeType && id == other.id;
}