// Archivo: bin/main.dart
import 'dart:io';
import 'package:gestor_biblioteca_digital/servicios/gestor_biblioteca.dart';
import 'package:gestor_biblioteca_digital/modelos/autor.dart';

void main() async {
  final gestor = GestorBiblioteca();

  // Datos de ejemplo para pruebas rápidas
  final autor1 = gestor.registrarAutor('Gabriel García Márquez', 'Colombiana', DateTime(1927, 3, 6));
  final autor2 = gestor.registrarAutor('Julio Cortázar', 'Argentina', DateTime(1914, 8, 26));
  gestor.agregarLibro('Cien años de soledad', 1967, '978-0307474474', 'Realismo Mágico', autor1);
  gestor.agregarRevista('National Geographic Vol. 1', 2023, 1, 'Mensual');
  gestor.agregarLibro('Rayuela', 1963, '978-8437604910', 'Novela', autor2);
  final usuario1 = gestor.registrarUsuario('Maria Lopez', 'maria.lopez@example.com');
  final usuario2 = gestor.registrarUsuario('Juan Perez', 'juan.perez@example.com');


  while (true) {
    print('\n--- GESTOR DE BIBLIOTECA DIGITAL ---');
    print('1. Gestión de Recursos');
    print('2. Gestión de Autores');
    print('3. Gestión de Usuarios');
    print('4. Gestión de Préstamos');
    print('5. Salir');
    stdout.write('Seleccione una opción: ');
    String? opcion = stdin.readLineSync();

    if (opcion == null || opcion.isEmpty) {
      print('Opción inválida. Intente de nuevo.');
      continue;
    }

    switch (opcion) {
      case '1':
        await _gestionDeRecursos(gestor);
        break;
      case '2':
        await _gestionDeAutores(gestor);
        break;
      case '3':
        await _gestionDeUsuarios(gestor);
        break;
      case '4':
        await _gestionDePrestamos(gestor);
        break;
      case '5':
        print('Saliendo del sistema...');
        exit(0);
      default:
        print('Opción no reconocida. Por favor, intente de nuevo.');
    }
  }
}

Future<void> _gestionDeRecursos(GestorBiblioteca gestor) async {
  while (true) {
    print('\n--- GESTIÓN DE RECURSOS ---');
    print('1. Agregar Nuevo Libro');
    print('2. Agregar Nueva Revista');
    print('3. Ver Catálogo Completo');
    print('4. Buscar Recurso por Título');
    print('5. Buscar Recursos por Nombre de Autor');
    print('6. Volver al Menú Principal');
    stdout.write('Seleccione una opción: ');
    String? subopcion = stdin.readLineSync();

    if (subopcion == null || subopcion.isEmpty) {
      print('Opción inválida. Intente de nuevo.');
      continue;
    }

    switch (subopcion) {
      case '1':
        String titulo = _getNonEmptyInput('Título: ');
        int? anio = _getPositiveIntegerInput('Año de Publicación: ');
        if (anio == null) break;
        String isbn = _getNonEmptyInput('ISBN: ');
        String genero = _getNonEmptyInput('Género: ');

        Autor? autor;
        do {
          String idAutor = _getNonEmptyInput('ID del Autor (ej. AUT-001): ');
          autor = gestor.obtenerAutorPorId(idAutor);
          if (autor == null) {
            print('Autor no encontrado con ese ID. Por favor, ingrese un ID válido.');
            print('Autores registrados:');
            gestor.listarAutores(); // Ayuda al usuario a ver IDs existentes
          }
        } while (autor == null);

        gestor.agregarLibro(titulo, anio, isbn, genero, autor);
        print('Libro agregado con éxito.');
        break;
      case '2':
        String titulo = _getNonEmptyInput('Título: ');
        int? anio = _getPositiveIntegerInput('Año de Publicación: ');
        if (anio == null) break;
        int? edicion = _getPositiveIntegerInput('Número de Edición: ');
        if (edicion == null) break;
        String periodicidad = _getNonEmptyInput('Periodicidad (ej. Mensual, Semanal): ');
        gestor.agregarRevista(titulo, anio, edicion, periodicidad);
        print('Revista agregada con éxito.');
        break;
      case '3':
        gestor.mostrarCatalogoCompleto();
        break;
      case '4':
        String criterioTitulo = _getNonEmptyInput('Título a buscar: ');
        final resultadosTitulo = gestor.buscarRecursoPorTitulo(criterioTitulo);
        if (resultadosTitulo.isEmpty) {
          print('No se encontraron recursos con ese título.');
        } else {
          print('\n--- Resultados de búsqueda por título ---');
          resultadosTitulo.forEach((r) => r.mostrarDetalles());
        }
        break;
      case '5':
        String criterioAutor = _getNonEmptyInput('Nombre del autor a buscar: ');
        final resultadosAutor = gestor.buscarRecursosPorNombreAutor(criterioAutor);
        if (resultadosAutor.isEmpty) {
          print('No se encontraron libros de ese autor.');
        } else {
          print('\n--- Resultados de búsqueda por autor ---');
          resultadosAutor.forEach((r) => r.mostrarDetalles());
        }
        break;
      case '6':
        return; // Volver al menú principal
      default:
        print('Opción no reconocida. Por favor, intente de nuevo.');
    }
  }
}

Future<void> _gestionDeAutores(GestorBiblioteca gestor) async {
  while (true) {
    print('\n--- GESTIÓN DE AUTORES ---');
    print('1. Registrar Nuevo Autor');
    print('2. Listar Autores');
    print('3. Ver Obras de un Autor');
    print('4. Volver al Menú Principal');
    stdout.write('Seleccione una opción: ');
    String? subopcion = stdin.readLineSync();

    if (subopcion == null || subopcion.isEmpty) {
      print('Opción inválida. Intente de nuevo.');
      continue;
    }

    switch (subopcion) {
      case '1':
        String nombre = _getNonEmptyInput('Nombre Completo: ');
        String nacionalidad = _getNonEmptyInput('Nacionalidad: ');
        DateTime? fechaNacimiento;
        do {
          stdout.write('Fecha de nacimiento (YYYY-MM-DD): ');
          String? fechaStr = stdin.readLineSync();
          if (fechaStr == null || fechaStr.isEmpty) {
            print('La fecha de nacimiento no puede estar vacía.');
            continue;
          }
          try {
            fechaNacimiento = DateTime.parse(fechaStr);
          } catch (e) {
            print('Formato de fecha inválido. Use YYYY-MM-DD.');
          }
        } while (fechaNacimiento == null);

        Autor autor = gestor.registrarAutor(nombre, nacionalidad, fechaNacimiento);
        print('Autor registrado: ${autor.id}');
        break;
      case '2':
        gestor.listarAutores();
        break;
      case '3':
        String idAutor = _getNonEmptyInput('ID del Autor (ej. AUT-001): ');
        gestor.mostrarRecursosPorAutor(idAutor);
        break;
      case '4':
        return;
      default:
        print('Opción no reconocida. Por favor, intente de nuevo.');
    }
  }
}

Future<void> _gestionDeUsuarios(GestorBiblioteca gestor) async {
  while (true) {
    print('\n--- GESTIÓN DE USUARIOS ---');
    print('1. Registrar Nuevo Usuario');
    print('2. Listar Usuarios');
    print('3. Volver al Menú Principal');
    stdout.write('Seleccione una opción: ');
    String? subopcion = stdin.readLineSync();

    if (subopcion == null || subopcion.isEmpty) {
      print('Opción inválida. Intente de nuevo.');
      continue;
    }

    switch (subopcion) {
      case '1':
        String nombre = _getNonEmptyInput('Nombre: ');
        String email = _getNonEmptyInput('Email: ');
        try {
          final usuario = gestor.registrarUsuario(nombre, email);
          print('Usuario registrado: ${usuario.id}');
        } on ArgumentError catch (e) {
          print('Error al registrar usuario: ${e.message}');
        }
        break;
      case '2':
        gestor.listarUsuarios();
        break;
      case '3':
        return;
      default:
        print('Opción no reconocida. Por favor, intente de nuevo.');
    }
  }
}

Future<void> _gestionDePrestamos(GestorBiblioteca gestor) async {
  while (true) {
    print('\n--- GESTIÓN DE PRÉSTAMOS ---');
    print('1. Realizar Préstamo');
    print('2. Registrar Devolución');
    print('3. Ver Préstamos Activos');
    print('4. Volver al Menú Principal');
    stdout.write('Seleccione una opción: ');
    String? subopcion = stdin.readLineSync();

    if (subopcion == null || subopcion.isEmpty) {
      print('Opción inválida. Intente de nuevo.');
      continue;
    }

    switch (subopcion) {
      case '1':
        String idRecurso = _getNonEmptyInput('ID del Recurso (ej. LIB-001, REV-001): ');
        String idUsuario = _getNonEmptyInput('ID del Usuario (ej. USU-001): ');
        await gestor.realizarPrestamo(idRecurso, idUsuario);
        break;
      case '2':
        String idPrestamo = _getNonEmptyInput('ID del Préstamo (ej. PRE-001): ');
        await gestor.registrarDevolucion(idPrestamo);
        break;
      case '3':
        gestor.mostrarPrestamosActivos();
        break;
      case '4':
        return;
      default:
        print('Opción no reconocida. Por favor, intente de nuevo.');
    }
  }
}

// --- Funciones auxiliares para la entrada de usuario ---

/// Solicita una entrada de texto no vacía al usuario.
String _getNonEmptyInput(String prompt) {
  String? input;
  do {
    stdout.write(prompt);
    input = stdin.readLineSync();
    if (input == null || input.isEmpty) {
      print('La entrada no puede estar vacía. Por favor, inténtelo de nuevo.');
    }
  } while (input == null || input.isEmpty);
  return input;
}

/// Solicita una entrada de número entero positivo al usuario.
int? _getPositiveIntegerInput(String prompt) {
  int? number;
  String? input;
  do {
    stdout.write(prompt);
    input = stdin.readLineSync();
    if (input == null || input.isEmpty) {
      print('La entrada no puede estar vacía. Por favor, inténtelo de nuevo.');
      continue;
    }
    number = int.tryParse(input);
    if (number == null || number <= 0) {
      print('Entrada inválida. Por favor, ingrese un número entero positivo.');
    }
  } while (number == null || number <= 0);
  return number;
}