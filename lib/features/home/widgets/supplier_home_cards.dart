import 'package:flutter/material.dart';

import 'kit/kit.dart';

/// Tarjeta verde con el perfil del proveedor; abre la ficha pública.
class SupplierProfileCard extends StatelessWidget {
  const SupplierProfileCard({
    super.key,
    required this.name,
    required this.type,
    required this.location,
    required this.initial,
    this.onTap,
  });

  final String name;
  final String type;
  final String location;
  final String initial;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      color: ProColors.brand700,
      radius: ProRadii.lg,
      borderWidth: ProStroke.card,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(initial, style: ProText.serif(44, color: ProColors.surface0, lineHeight: 52.8)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(name, style: ProText.serif(20, color: ProColors.surface0, lineHeight: 24)),
                Text(type, style: ProText.r(12, color: ProColors.surface0, lineHeight: 14.4)),
                Text(location, style: ProText.r(12, color: ProColors.surface0, lineHeight: 14.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cifra del resumen del negocio dentro de una tarjeta blanca de 12 px de radio.
class SupplierSummaryTile extends StatelessWidget {
  const SupplierSummaryTile({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      radius: ProRadii.md,
      borderWidth: ProStroke.hairline,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Text(value, style: ProText.r(18, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 21.6)),
          Text(label, style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.2)),
        ],
      ),
    );
  }
}

/// Fila de 36 px con separador inferior de 0.5 px: ícono, título, detalle y acción.
class SupplierListRow extends StatelessWidget {
  const SupplierListRow({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    this.trailingText,
    this.trailingStyle,
  });

  final LucideIcon icon;
  final String title;
  final String detail;
  final String? trailingText;
  final TextStyle? trailingStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ProColors.line300, width: ProStroke.hairline)),
      ),
      child: Row(
        children: [
          ProIcon(icon, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: ProText.r(12, weight: FontWeight.w600, lineHeight: 15.6), maxLines: 1),
                Text(detail, style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.2), maxLines: 1),
              ],
            ),
          ),
          if (trailingText != null) ...[
            Text(trailingText!, style: trailingStyle ?? ProText.r(11, color: ProColors.ink500, lineHeight: 13.2)),
            const SizedBox(width: 10),
          ],
          const ProIcon(LucideIcon.chevronRight, size: 15),
        ],
      ),
    );
  }
}

/// Tarjeta blanca con filas de actividad reciente.
class SupplierActivityCard extends StatelessWidget {
  const SupplierActivityCard({super.key, required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      radius: ProRadii.lg,
      borderWidth: ProStroke.card,
      padding: const EdgeInsets.all(4),
      child: Column(children: rows),
    );
  }
}

/// Tarjeta de estado de productos con cinco píxeles de margen interior.
class SupplierStockCard extends StatelessWidget {
  const SupplierStockCard({super.key, required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      radius: ProRadii.lg,
      borderWidth: ProStroke.card,
      padding: const EdgeInsets.all(5),
      child: Column(children: rows),
    );
  }
}
