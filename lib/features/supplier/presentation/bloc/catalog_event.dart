/// Eventos del bloque de la Bodega Rivet.
sealed class CatalogEvent {
  const CatalogEvent();
}

/// Carga inicial o actualización de productos.
final class LoadCatalogProducts extends CatalogEvent {
  const LoadCatalogProducts({
    this.category,
    this.searchQuery,
  });

  final String? category;
  final String? searchQuery;
}

/// Cambio de categoría seleccionada.
final class CatalogCategoryChanged extends CatalogEvent {
  const CatalogCategoryChanged(this.category);

  final String category;
}

/// Cambio en el texto de búsqueda.
final class CatalogSearchQueryChanged extends CatalogEvent {
  const CatalogSearchQueryChanged(this.query);

  final String query;
}

/// Descarta mensajes de error.
final class CatalogErrorDismissed extends CatalogEvent {
  const CatalogErrorDismissed();
}

