// Archivo: lib/modelos/recurso_biblioteca.dart
import 'package:gestor_biblioteca_digital/modelos/identificable.dart';

/// Clase base abstracta para todos los tipos de recursos de la biblioteca.
/// Implementa la interfaz Identificable.
abstract class RecursoBiblioteca implements Identificable {
  @override
  final String id;
  String titulo;
  bool disponible;
  int anioPublicacion;

  RecursoBiblioteca({
    required this.id,
    required this.titulo,
    this.disponible = true,
    required this.anioPublicacion,
  });

  /// Método abstracto para mostrar los detalles específicos del recurso.
  void mostrarDetalles();

  /// Marca el recurso como no disponible para préstamo.
  void marcarComoPrestado() {
    disponible = false;
    print('"${titulo}" (ID: $id) ha sido marcado como PRESTADO.');
  }

  /// Marca el recurso como disponible para préstamo.
  void marcarComoDevuelto() {
    disponible = true;
    print('"${titulo}" (ID: $id) ha sido marcado como DISPONIBLE.');
  }
}