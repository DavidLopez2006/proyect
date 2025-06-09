// Archivo: lib/modelos/usuario.dart
import 'package:gestor_biblioteca_digital/modelos/identificable.dart';
import 'package:gestor_biblioteca_digital/modelos/notificable.dart';
import 'package:gestor_biblioteca_digital/modelos/recurso_biblioteca.dart';

/// Clase que representa a un usuario de la biblioteca.
/// Implementa Identificable y Notificable.
class Usuario implements Identificable, Notificable {
  @override
  final String id;
  String nombre;
  String email;
  List<RecursoBiblioteca> recursosPrestados; // Lista de recursos que el usuario tiene actualmente prestados

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    List<RecursoBiblioteca>? recursosPrestados, // Permite inicialización opcional
  }) : this.recursosPrestados = recursosPrestados ?? [];

  /// Añade un recurso a la lista de recursos prestados por el usuario.
  void tomarPrestado(RecursoBiblioteca recurso) {
    recursosPrestados.add(recurso);
    print('Usuario "${nombre}" ha tomado prestado "${recurso.titulo}".');
  }

  /// Elimina un recurso de la lista de recursos prestados por el usuario.
  void devolverRecurso(RecursoBiblioteca recurso) {
    recursosPrestados.removeWhere((r) => r.id == recurso.id);
    print('Usuario "${nombre}" ha devuelto "${recurso.titulo}".');
  }

  @override
  void enviarNotificacion(String mensaje) {
    print('[NOTIFICACIÓN a ${nombre}]: $mensaje');
  }

  /// Muestra la información básica del usuario, incluyendo los recursos prestados.
  void mostrarInformacion() {
    print('--- Usuario ---');
    print('  ID: $id');
    print('  Nombre: $nombre');
    print('  Email: $email');
    if (recursosPrestados.isNotEmpty) {
      print('  Recursos Prestados:');
      for (var recurso in recursosPrestados) {
        print('    - ${recurso.titulo} (ID: ${recurso.id})');
      }
    } else {
      print('  Recursos Prestados: Ninguno');
    }
  }
}