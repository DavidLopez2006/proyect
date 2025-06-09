// Archivo: lib/utilidades/buscador_mixin.dart
import 'package:gestor_biblioteca_digital/modelos/recurso_biblioteca.dart';
import 'package:gestor_biblioteca_digital/modelos/libro.dart'; // Necesario para el ejemplo de búsqueda por autor

/// Mixin que provee funcionalidades de búsqueda genéricas.
mixin Buscador {
  /// Permite buscar en una lista de RecursoBiblioteca (o subtipos)
  /// basándose en un criterio y una función de condición.
  ///
  /// [listaRecursos]: La lista de recursos donde buscar.
  /// [criterioBusqueda]: El término de búsqueda.
  /// [condicion]: Una función que define cómo se compara el recurso con el criterio.
  /// Retorna una lista de recursos que cumplen la condición.
  List<T> buscarPorCriterio<T extends RecursoBiblioteca>(
    List<T> listaRecursos,
    String criterioBusqueda,
    bool Function(T recurso, String criterio) condicion,
  ) {
    if (criterioBusqueda.isEmpty) {
      return []; // Si no hay criterio, no hay resultados de búsqueda
    }
    return listaRecursos
        .where((recurso) => condicion(recurso, criterioBusqueda))
        .toList();
  }

  // Métodos de condición de ejemplo que se pueden pasar al buscador:
  // static bool porTitulo<T extends RecursoBiblioteca>(T recurso, String criterio) {
  //   return recurso.titulo.toLowerCase().contains(criterio.toLowerCase());
  // }

  // static bool porAutorLibro(RecursoBiblioteca recurso, String criterio) {
  //   return recurso is Libro &&
  //       recurso.autor.nombreCompleto.toLowerCase().contains(criterio.toLowerCase());
  // }
}