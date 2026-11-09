/// Error del catálogo de materiales.
class CatalogFailure implements Exception {
  final String message;

  const CatalogFailure(this.message);

  @override
  String toString() => message;
}

