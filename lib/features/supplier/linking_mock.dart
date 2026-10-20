import 'package:flutter/material.dart';
import '../home/widgets/kit/kit.dart';

/// Solicitud de vinculación de un contratista con el proveedor.
class LinkRequest {
  const LinkRequest({required this.name, required this.detail, this.avatar});

  final String name;
  final String detail;
  final String? avatar;
}

/// Estado de una solicitud enviada por el contratista a un proveedor.
class LinkStatus {
  const LinkStatus({
    required this.name,
    required this.label,
    required this.background,
    required this.foreground,
    required this.place,
    required this.access,
  });

  final String name;
  final String label;
  final Color background;
  final Color foreground;
  final String place;
  final String access;
}

/// Datos simulados de vinculación de proveedores.
abstract final class LinkingMock {
  static const pendingRequests = [
    LinkRequest(
      name: 'Carlos Ramírez',
      detail: 'Pintor y estucador · 5 años · Medellín',
      avatar: ProAssets.avatarCarlos,
    ),
    LinkRequest(name: 'Laura Gómez', detail: 'Acabados interiores · 3 años · Envigado'),
  ];

  static const approvedRequests = [
    LinkRequest(name: 'Andrés Molina', detail: 'Remodelación · 7 años · Bello'),
  ];

  static const statuses = [
    LinkStatus(
      name: 'Acabados del Norte',
      label: 'Pendiente',
      background: ProColors.warningLight,
      foreground: ProColors.warning800,
      place: 'Bello · Enviada el 15 de mayo. Espera aprobación del proveedor.',
      access: 'Sin vínculo activo · Precios exclusivos bloqueados',
    ),
    LinkStatus(
      name: 'Materiales La 80',
      label: 'Aprobada',
      background: ProColors.successLight,
      foreground: ProColors.brand700,
      place: 'Medellín · Aprobada por el proveedor el 14 de mayo.',
      access: '✓ Vínculo activo · Acceso a precios exclusivos',
    ),
    LinkStatus(
      name: 'ConstruCasa',
      label: 'Rechazada',
      background: ProColors.dangerLight,
      foreground: ProColors.danger700,
      place: 'Envigado · El proveedor no aprobó el acceso.',
      access: 'Sin vínculo activo · Precios exclusivos bloqueados',
    ),
  ];
}
