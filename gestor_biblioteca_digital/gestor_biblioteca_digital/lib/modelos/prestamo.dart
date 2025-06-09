// Archivo: lib/modelos/prestamo.dart
import 'package:gestor_biblioteca_digital/modelos/identificable.dart';
import 'package:gestor_biblioteca_digital/modelos/recurso_biblioteca.dart';
import 'package:gestor_biblioteca_digital/modelos/usuario.dart';

/// Clase que representa la operación de préstamo de un recurso a un usuario.
/// Implementa la interfaz Identificable.
class Prestamo implements Identificable {
  @override
  final String id;
  RecursoBiblioteca recurso; // El recurso prestado
  Usuario usuario; // El usuario que tomó el préstamo
  DateTime fechaPrestamo; // Fecha y hora en que se realizó el préstamo
  DateTime fechaDevolucionPrevista; // Fecha y hora límite para la devolución
  bool devuelto; // Indica si el préstamo ha sido devuelto

  Prestamo({
    required this.id,
    required this.recurso,
    required this.usuario,
    required this.fechaPrestamo,
    required this.fechaDevolucionPrevista,
    this.devuelto = false, // Por defecto, un préstamo no ha sido devuelto
  });

  /// Marca el préstamo como devuelto y actualiza el estado del recurso.
  void registrarDevolucion() {
    if (!devuelto) {
      devuelto = true;
      recurso.marcarComoDevuelto(); // El recurso vuelve a estar disponible
      print('Préstamo ID: $id marcado como devuelto. Recurso "${recurso.titulo}" disponible de nuevo.');
    } else {
      print('Advertencia: El préstamo ID: $id ya había sido marcado como devuelto.');
    }
  }

  /// Muestra información detallada del préstamo.
  void mostrarDetalles() {
    print('--- Préstamo ---');
    print('  ID: $id');
    print('  Recurso: "${recurso.titulo}" (ID: ${recurso.id})');
    print('  Usuario: ${usuario.nombre} (ID: ${usuario.id})');
    print('  Fecha de Préstamo: ${fechaPrestamo.toLocal().toString().split(' ')[0]}');
    print('  Fecha de Devolución Prevista: ${fechaDevolucionPrevista.toLocal().toString().split(' ')[0]}');
    print('  Estado: ${devuelto ? 'Devuelto' : 'Activo'}');
  }
}