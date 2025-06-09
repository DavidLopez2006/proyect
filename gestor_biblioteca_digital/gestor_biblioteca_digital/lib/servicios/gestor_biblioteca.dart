// Archivo: lib/servicios/gestor_biblioteca.dart
import 'package:gestor_biblioteca_digital/modelos/autor.dart';
import 'package:gestor_biblioteca_digital/modelos/libro.dart';
import 'package:gestor_biblioteca_digital/modelos/prestamo.dart';
import 'package:gestor_biblioteca_digital/modelos/recurso_biblioteca.dart';
import 'package:gestor_biblioteca_digital/modelos/revista.dart';
import 'package:gestor_biblioteca_digital/modelos/usuario.dart';
import 'package:gestor_biblioteca_digital/utilidades/buscador_mixin.dart';

/// Clase central que orquesta todas las operaciones de la biblioteca.
/// Utiliza el mixin Buscador para funcionalidades de búsqueda.
class GestorBiblioteca with Buscador {
  final List<RecursoBiblioteca> catalogoRecursos = [];
  final Set<Autor> autoresRegistrados = {}; // Usa Set para evitar duplicados por ID
  final List<Usuario> usuariosRegistrados = [];
  final List<Prestamo> prestamosActivos = [];
  final Map<String, List<RecursoBiblioteca>> recursosPorAutor = {};

  int _contadorIdRecursos = 0;
  int _contadorIdAutores = 0;
  int _contadorIdUsuarios = 0;
  int _contadorIdPrestamos = 0;

  // --- Generación de IDs ---
  String _generarIdUnico(String prefijo) {
    String id;
    switch (prefijo) {
      case 'LIB':
      case 'REV':
        _contadorIdRecursos++;
        id = '$prefijo-${_contadorIdRecursos.toString().padLeft(3, '0')}';
        break;
      case 'AUT':
        _contadorIdAutores++;
        id = '$prefijo-${_contadorIdAutores.toString().padLeft(3, '0')}';
        break;
      case 'USU':
        _contadorIdUsuarios++;
        id = '$prefijo-${_contadorIdUsuarios.toString().padLeft(3, '0')}';
        break;
      case 'PRE':
        _contadorIdPrestamos++;
        id = '$prefijo-${_contadorIdPrestamos.toString().padLeft(3, '0')}';
        break;
      default:
        id = '$prefijo-${DateTime.now().millisecondsSinceEpoch}'; // Fallback
    }
    return id;
  }

  // --- Gestión de Recursos ---
  void agregarLibro(String titulo, int anioPublicacion, String isbn, String genero, Autor autor) {
    if (catalogoRecursos.any((r) => r is Libro && r.isbn == isbn)) {
      print('Error: Ya existe un libro con el ISBN $isbn.');
      return;
    }
    final id = _generarIdUnico('LIB');
    final libro = Libro(
      id: id,
      titulo: titulo,
      anioPublicacion: anioPublicacion,
      autor: autor,
      isbn: isbn,
      genero: genero,
    );
    catalogoRecursos.add(libro);
    recursosPorAutor.putIfAbsent(autor.id, () => []).add(libro);
    print('Libro "${libro.titulo}" agregado al catálogo con ID: ${libro.id}');
  }

  void agregarRevista(String titulo, int anioPublicacion, int numeroEdicion, String periodicidad) {
    final id = _generarIdUnico('REV');
    final revista = Revista(
      id: id,
      titulo: titulo,
      anioPublicacion: anioPublicacion,
      numeroEdicion: numeroEdicion,
      periodicidad: periodicidad,
    );
    catalogoRecursos.add(revista);
    print('Revista "${revista.titulo}" agregada al catálogo con ID: ${revista.id}');
  }

  RecursoBiblioteca? obtenerRecursoPorId(String idRecurso) {
    try {
      return catalogoRecursos.firstWhere((r) => r.id == idRecurso);
    } catch (e) {
      return null;
    }
  }

  // --- Gestión de Autores ---
  Autor registrarAutor(String nombreCompleto, String nacionalidad, DateTime fechaNacimiento) {
    // Verificar si el autor ya existe por nombre completo y fecha de nacimiento (simplificado para evitar duplicados)
    final existingAuthor = autoresRegistrados.firstWhereOrNull(
      (a) => a.nombreCompleto == nombreCompleto && a.fechaNacimiento.year == fechaNacimiento.year,
    );
    if (existingAuthor != null) {
      print('Advertencia: El autor "$nombreCompleto" ya está registrado con ID: ${existingAuthor.id}. Se utilizará el existente.');
      return existingAuthor;
    }

    final id = _generarIdUnico('AUT');
    final autor = Autor(
      id: id,
      nombreCompleto: nombreCompleto,
      nacionalidad: nacionalidad,
      fechaNacimiento: fechaNacimiento,
    );
    autoresRegistrados.add(autor);
    print('Autor "${autor.nombreCompleto}" registrado con ID: ${autor.id}');
    return autor;
  }

  Autor? obtenerAutorPorId(String idAutor) {
    try {
      return autoresRegistrados.firstWhere((a) => a.id == idAutor);
    } catch (e) {
      return null;
    }
  }

  void listarAutores() {
    if (autoresRegistrados.isEmpty) {
      print('No hay autores registrados.');
      return;
    }
    print('\n--- Listado de Autores ---');
    autoresRegistrados.forEach((autor) => autor.mostrarInformacion());
    print('--------------------------');
  }

  // --- Gestión de Usuarios ---
  Usuario registrarUsuario(String nombre, String email) {
    if (usuariosRegistrados.any((u) => u.email == email)) {
      print('Error: Ya existe un usuario con el email $email.');
      // Opcional: retornar el usuario existente o null
      throw ArgumentError('El email ya está en uso.');
    }
    final id = _generarIdUnico('USU');
    final usuario = Usuario(
      id: id,
      nombre: nombre,
      email: email,
    );
    usuariosRegistrados.add(usuario);
    print('Usuario "${usuario.nombre}" registrado con ID: ${usuario.id}');
    return usuario;
  }

  Usuario? obtenerUsuarioPorId(String idUsuario) {
    try {
      return usuariosRegistrados.firstWhere((u) => u.id == idUsuario);
    } catch (e) {
      return null;
    }
  }

  void listarUsuarios() {
    if (usuariosRegistrados.isEmpty) {
      print('No hay usuarios registrados.');
      return;
    }
    print('\n--- Listado de Usuarios ---');
    usuariosRegistrados.forEach((usuario) => usuario.mostrarInformacion());
    print('---------------------------');
  }

  // --- Gestión de Préstamos (Programación Asíncrona) ---
  Future<Prestamo?> realizarPrestamo(String idRecurso, String idUsuario) async {
    print('Simulando operación de red para préstamo...');
    await Future.delayed(Duration(seconds: 2)); // Simula un retardo de red

    final recurso = obtenerRecursoPorId(idRecurso);
    final usuario = obtenerUsuarioPorId(idUsuario);

    if (recurso == null) {
      print('Error: Recurso con ID $idRecurso no encontrado.');
      return null;
    }
    if (usuario == null) {
      print('Error: Usuario con ID $idUsuario no encontrado.');
      return null;
    }
    if (!recurso.disponible) {
      print('Error: El recurso "${recurso.titulo}" (ID: ${recurso.id}) no está disponible para préstamo.');
      return null;
    }

    final id = _generarIdUnico('PRE');
    final fechaPrestamo = DateTime.now();
    final fechaDevolucionPrevista = fechaPrestamo.add(Duration(days: 14)); // Préstamo por 14 días

    final prestamo = Prestamo(
      id: id,
      recurso: recurso,
      usuario: usuario,
      fechaPrestamo: fechaPrestamo,
      fechaDevolucionPrevista: fechaDevolucionPrevista,
    );

    prestamosActivos.add(prestamo);
    recurso.marcarComoPrestado();
    usuario.tomarPrestado(recurso);
    usuario.enviarNotificacion('Has tomado prestado "${recurso.titulo}". Fecha de devolución prevista: ${fechaDevolucionPrevista.toLocal().toString().split(' ')[0]}');
    print('Préstamo realizado exitosamente. ID: ${prestamo.id}');
    return prestamo;
  }

  Future<void> registrarDevolucion(String idPrestamo) async {
    print('Simulando operación de red para devolución...');
    await Future.delayed(Duration(seconds: 1)); // Simula un retardo de red

    final prestamo = prestamosActivos.firstWhereOrNull((p) => p.id == idPrestamo);

    if (prestamo == null) {
      print('Error: Préstamo con ID $idPrestamo no encontrado o ya no está activo.');
      return;
    }
    if (prestamo.devuelto) {
      print('Error: El préstamo con ID $idPrestamo ya ha sido devuelto.');
      return;
    }

    prestamo.registrarDevolucion(); // Marca el préstamo como devuelto y actualiza el recurso
    prestamo.usuario.devolverRecurso(prestamo.recurso);
    prestamo.usuario.enviarNotificacion('Has devuelto "${prestamo.recurso.titulo}". ¡Gracias!');
    prestamosActivos.remove(prestamo); // Eliminar de préstamos activos
    print('Devolución del préstamo $idPrestamo registrada exitosamente.');
  }

  // --- Búsquedas (utilizando el mixin Buscador) ---
  List<RecursoBiblioteca> buscarRecursoPorTitulo(String titulo) {
    print('Buscando recursos por título: "$titulo"');
    return buscarPorCriterio(catalogoRecursos, titulo, (recurso, criterio) {
      return recurso.titulo.toLowerCase().contains(criterio.toLowerCase());
    });
  }

  List<Libro> buscarRecursosPorNombreAutor(String nombreAutor) {
    print('Buscando libros por autor: "$nombreAutor"');
    // Filtrar solo libros y luego buscar por nombre del autor
    return buscarPorCriterio(
      catalogoRecursos.whereType<Libro>().toList(), // Aseguramos que la lista sea de Libros
      nombreAutor,
      (libro, criterio) {
        return libro.autor.nombreCompleto.toLowerCase().contains(criterio.toLowerCase());
      },
    );
  }

  // --- Visualización ---
  void mostrarCatalogoCompleto() {
    if (catalogoRecursos.isEmpty) {
      print('El catálogo de la biblioteca está vacío.');
      return;
    }
    print('\n--- Catálogo Completo de Recursos ---');
    for (var recurso in catalogoRecursos) {
      recurso.mostrarDetalles(); // Polimorfismo en acción
      print(''); // Línea en blanco para separar
    }
    print('-------------------------------------');
  }

  void mostrarPrestamosActivos() {
    if (prestamosActivos.isEmpty) {
      print('No hay préstamos activos en este momento.');
      return;
    }
    print('\n--- Préstamos Activos ---');
    for (var prestamo in prestamosActivos) {
      if (!prestamo.devuelto) { // Asegurarse de mostrar solo los no devueltos
        prestamo.mostrarDetalles();
        print(''); // Línea en blanco para separar
      }
    }
    print('-------------------------');
  }

  void mostrarRecursosPorAutor(String idAutor) {
    final autor = obtenerAutorPorId(idAutor);
    if (autor == null) {
      print('Error: Autor con ID $idAutor no encontrado.');
      return;
    }
    final recursosDelAutor = recursosPorAutor[idAutor];
    if (recursosDelAutor == null || recursosDelAutor.isEmpty) {
      print('El autor "${autor.nombreCompleto}" no tiene recursos registrados.');
      return;
    }
    print('\n--- Recursos de ${autor.nombreCompleto} ---');
    for (var recurso in recursosDelAutor) {
      recurso.mostrarDetalles();
      print('');
    }
    print('-------------------------------------');
  }
}

// Extensión auxiliar para `firstWhereOrNull` (como en algunos paquetes utilitarios)
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}