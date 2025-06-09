// Archivo: lib/modelos/notificable.dart

/// Interfaz que define un contrato para entidades que pueden recibir notificaciones.
abstract interface class Notificable {
  /// Envía una notificación con un mensaje dado.
  void enviarNotificacion(String mensaje);
}