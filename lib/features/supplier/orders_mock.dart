import '../home/widgets/kit/kit.dart';

/// Tono de la etiqueta de estado de un pedido.
enum OrderTone {
  /// Pastilla ámbar ("En preparación").
  preparing,

  /// Texto ámbar sin pastilla ("Sin despachar").
  pending,

  /// Pastilla verde ("Listo para retiro").
  ready,
}

/// Pedido simulado del proveedor (frames 2027:119 y 2027:210).
class SupplierOrder {
  const SupplierOrder({
    required this.client,
    required this.statusLabel,
    required this.tone,
    required this.material,
    required this.action,
    this.image,
    this.materialInfo,
    this.quantity,
    this.unitPrice,
    this.summary,
    this.delivery,
    this.total,
    this.detail,
  });

  final String client;
  final String statusLabel;
  final OrderTone tone;
  final String material;
  final String action;

  /// Fotografía del material; solo en las tarjetas con bloque de material.
  final String? image;
  final String? materialInfo;
  final String? quantity;
  final String? unitPrice;

  /// Línea de cantidad y total de las tarjetas compactas.
  final String? summary;
  final String? delivery;
  final String? total;
  final String? detail;
}

/// Datos simulados de la lista de pedidos.
abstract final class SupplierOrdersMock {
  static const juanPreparing = SupplierOrder(
    client: 'Juan Pérez · FerreCasa',
    statusLabel: 'En preparación',
    tone: OrderTone.preparing,
    material: 'Pintura vinilo premium',
    materialInfo: 'Rivet · Blanco mate · PV-001',
    quantity: '4 galones (1 gal c/u)',
    unitPrice: '\$ 87.000 COP / galón',
    total: 'Total aprobado: \$ 348.000 COP',
    detail: 'FC-1605 · Retiro en tienda · \$ 0 COP\n16 de mayo de 2024 · 8:00–18:00\nFerreCasa · Medellín, Antioquia',
    image: ProAssets.rivetPaint,
    action: 'Preparar y despachar',
  );

  static const juanReady = SupplierOrder(
    client: 'Juan Pérez · FerreCasa',
    statusLabel: 'Listo para retiro',
    tone: OrderTone.ready,
    material: 'Pintura vinilo premium',
    materialInfo: 'Rivet · Blanco mate · PV-001',
    quantity: '4 galones (1 gal c/u)',
    unitPrice: '\$ 87.000 COP / galón',
    total: 'Total aprobado: \$ 348.000 COP',
    detail: 'FC-1605 · Retiro en tienda · \$ 0 COP\n16 de mayo de 2024 · 8:00–18:00\nFerreCasa · Medellín, Antioquia',
    image: ProAssets.rivetPaint,
    action: 'Hacer seguimiento',
  );

  static const mariaGomez = SupplierOrder(
    client: 'María Gómez',
    statusLabel: 'Sin despachar',
    tone: OrderTone.pending,
    material: 'Estuco plástico blanco',
    summary: 'EP-002 · 20 galones · Total \$ 480.000 COP',
    delivery: 'Retiro en tienda · 17 de mayo de 2024',
    action: 'Preparar y despachar',
  );

  static const carlosLopez = SupplierOrder(
    client: 'Carlos López',
    statusLabel: 'Sin despachar',
    tone: OrderTone.pending,
    material: 'Pintura vinilo premium',
    summary: 'PV-001 · 10 galones · Total \$ 870.000 COP',
    delivery: 'Retiro en tienda · 18 de mayo de 2024',
    action: 'Preparar y despachar',
  );

  /// Pedidos pendientes de despacho según la vista.
  static List<SupplierOrder> pending({required bool dispatched}) =>
      dispatched ? const [mariaGomez, carlosLopez] : const [juanPreparing, mariaGomez, carlosLopez];

  /// Pedidos ya despachados (listos para retiro) según la vista.
  static List<SupplierOrder> dispatchedOrders({required bool dispatched}) =>
      dispatched ? const [juanReady] : const [];
}
