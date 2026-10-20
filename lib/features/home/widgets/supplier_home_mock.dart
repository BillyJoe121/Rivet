import 'kit/kit.dart';

/// Datos simulados del inicio del proveedor (frame 22:146094).
abstract final class SupplierHomeMock {
  static const String initials = 'PV';
  static const String profileName = 'Pinturas del Valle';
  static const String profileType = 'Proveedor de materiales';
  static const String profileLocation = '♧ Cali, Valle del Cauca';

  static const List<({LucideIcon icon, String label})> quickAccess = [
    (icon: LucideIcon.package, label: 'Catálogo'),
    (icon: LucideIcon.fileText, label: 'Solicitudes'),
    (icon: LucideIcon.truck, label: 'Pedidos'),
    (icon: LucideIcon.tag, label: 'Precios'),
  ];

  static const List<({String value, String label})> summary = [
    (value: '28', label: 'productos'),
    (value: '6', label: 'solicitudes nuevas'),
    (value: '4', label: 'pedidos en curso'),
    (value: '3', label: 'con bajo stock'),
  ];

  static const List<({LucideIcon icon, String title, String detail, String time})> activity = [
    (
      icon: LucideIcon.fileText,
      title: 'Solicitud de cotización recibida',
      detail: 'Pintura vinilo premium, 10 galones',
      time: 'Hace 2 h',
    ),
    (icon: LucideIcon.truck, title: 'Pedido confirmado', detail: 'Estuco plástico, 20 galones', time: 'Hace 5 h'),
    (
      icon: LucideIcon.triangleAlert,
      title: 'Producto con inventario bajo',
      detail: 'Cinta de enmascarar',
      time: 'Hace 1 día',
    ),
  ];

  static const List<({LucideIcon icon, String title, String detail, String status})> stock = [
    (icon: LucideIcon.cylinder, title: 'Pintura vinilo premium', detail: '1 galón', status: 'Disponible'),
    (icon: LucideIcon.package, title: 'Estuco plástico', detail: '5 galones', status: 'Bajo stock'),
    (icon: LucideIcon.circle, title: 'Cinta de enmascarar', detail: '45 m', status: 'Pendiente'),
  ];
}
