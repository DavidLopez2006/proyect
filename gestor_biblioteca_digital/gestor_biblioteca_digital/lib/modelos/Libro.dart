  // Archivo: lib/modelos/libro.dart
import 'package:gestor_biblioteca_digital/modelos/recurso_biblioteca.dart';
import 'package:gestor_biblioteca_digital/modelos/autor.dart'; // Importar la clase Autor

/// Clase que representa un libro en la biblioteca.
/// Hereda de RecursoBiblioteca.
class Libro extends RecursoBiblioteca {
  Autor autor; // Objeto de la clase Autor
  String isbn; // Debe ser único para cada libro
  String genero;

  Libro({
    required super.id,
    required super.titulo,
    required super.anioPublicacion,
    super.disponible,
    required this.autor,
    required this.isbn,
    required this.genero,
  });

  @override
  void mostrarDetalles() {
    print('--- Libro ---');
    print('  ID: $id');
    print('  Título: $titulo');
    print('  Autor: ${autor.nombreCompleto} (ID: ${autor.id})');
    print('  Año de Publicación: $anioPublicacion');
    print('  ISBN: $isbn');
    print('  Género: $genero');
    print('  Disponibilidad: ${disponible ? 'Disponible' : 'Prestado'}');
  }
}