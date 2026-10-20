import 'kit/kit.dart';

/// Proyecto resumido en tarjetas de inicio.
class ProProjectSummary {
  const ProProjectSummary({
    required this.title,
    required this.category,
    required this.location,
    required this.image,
    this.badge,
    this.stagesDone,
    this.stagesTotal,
    this.progress,
  });

  final String title;
  final String category;
  final String location;
  final String image;
  final String? badge;
  final int? stagesDone;
  final int? stagesTotal;

  /// Avance mostrado en la barra; si falta, se usa etapas hechas / total.
  final double? progress;
}

/// Acceso rápido de inicio.
class ProAccess {
  const ProAccess(this.icon, this.label);

  final LucideIcon icon;
  final String label;
}

/// Evento de actividad reciente. [detail] incluye el espaciado del texto de
/// Figma que alinea la hora a la derecha.
class ProActivity {
  const ProActivity(this.icon, this.title, this.detail);

  final LucideIcon icon;
  final String title;
  final String detail;
}

/// Datos de ejemplo del inicio del contratista.
abstract final class ContractorHomeMock {
  static const nearbyProject = ProProjectSummary(
    title: 'Remodelación de cocina',
    category: 'Remodelación interior',
    location: 'Medellín, Antioquia',
    image: ProAssets.kitchen,
    badge: 'Nuevo',
  );

  static const ongoingWork = ProProjectSummary(
    title: 'Pintura exterior fachada',
    category: 'Pintura exterior',
    location: 'Cali, Valle del Cauca',
    image: ProAssets.facade,
    stagesDone: 2,
    stagesTotal: 4,
    progress: 60 / 188,
  );

  static const quickAccess = [
    ProAccess(LucideIcon.search, 'Proyectos disponibles'),
    ProAccess(LucideIcon.fileText, 'Mis propuestas'),
    ProAccess(LucideIcon.briefcaseBusiness, 'Trabajos activos'),
    ProAccess(LucideIcon.messageSquare, 'Mensajes'),
  ];

  static const activity = [
    ProActivity(LucideIcon.search, '3 proyectos nuevos en tu zona',
        'Publicados esta semana                       Hace 1 h'),
    ProActivity(LucideIcon.fileText, '2 propuestas pendientes',
        'Esperando respuesta                              Hace 3 h'),
    ProActivity(LucideIcon.calendar, '1 trabajo en ejecución',
        'Pintura exterior fachada                     Hace 1 día'),
    ProActivity(LucideIcon.messageSquare, 'Nuevo mensaje del cliente',
        'Sobre Remodelación de cocina             Hace 1 día'),
  ];
}
