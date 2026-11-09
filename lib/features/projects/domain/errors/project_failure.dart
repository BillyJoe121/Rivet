/// Error del dominio de proyectos con mensaje comprensible para el usuario.
class ProjectFailure implements Exception {
  final String message;

  const ProjectFailure(this.message);

  @override
  String toString() => message;
}

