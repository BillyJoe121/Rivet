import 'package:flutter/material.dart';

import '../../../features/home/widgets/kit/kit.dart';

/// Tarjeta verde claro con precio, unidad, disponibilidad y existencias (368×70).
class CatalogPriceCard extends StatelessWidget {
  const CatalogPriceCard({
    super.key,
    required this.price,
    required this.unit,
    required this.available,
    this.stock,
  });

  final String price;
  final String unit;
  final bool available;
  final String? stock;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      color: ProColors.brandLight,
      radius: ProRadii.lg,
      borderWidth: ProStroke.card,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 9,
        children: [
          Row(
            children: [
              Expanded(child: Text(price, style: ProText.r(20, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 24))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: ProColors.successLight,
                  borderRadius: BorderRadius.circular(ProRadii.xl),
                ),
                child: Text(
                  available ? '● Disponible' : '● Agotado',
                  style: ProText.r(11, color: ProColors.brand700, lineHeight: 13.2),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text(unit, style: ProText.r(11, color: ProColors.ink700, lineHeight: 13.2))),
              if (stock != null) Text(stock!, style: ProText.r(11, color: ProColors.ink700, lineHeight: 13.2)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tarjeta blanca con filas de especificación separadas por líneas de 0.5 px.
class CatalogSpecCard extends StatelessWidget {
  const CatalogSpecCard({super.key, required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      radius: ProRadii.lg,
      borderWidth: ProStroke.card,
      padding: const EdgeInsets.all(3),
      child: Column(children: rows),
    );
  }
}

/// Fila de especificación: ícono de 23 px, etiqueta, valor opcional y chevron.
class CatalogSpecRow extends StatelessWidget {
  const CatalogSpecRow({super.key, required this.icon, required this.label, this.value, this.subtitle});

  final LucideIcon icon;
  final String label;
  final String? value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: subtitle == null ? 38 : 40),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ProColors.line300, width: ProStroke.hairline)),
      ),
      child: Row(
        children: [
          ProIcon(icon, size: 23),
          const SizedBox(width: 10),
          Expanded(child: _RowText(label: label, subtitle: subtitle)),
          if (value != null) ...[
            Text(value!, style: ProText.r(12, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 14.4)),
            const SizedBox(width: 10),
          ],
          const ProIcon(LucideIcon.chevronRight, size: 15),
        ],
      ),
    );
  }
}

/// Fila sin tarjeta (Entrega, Proveedor, Especificaciones) con separador inferior.
class CatalogPlainRow extends StatelessWidget {
  const CatalogPlainRow({super.key, required this.icon, required this.title, this.subtitle, this.onTap});

  final LucideIcon icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CatalogSpecRow(icon: icon, label: title, subtitle: subtitle),
    );
  }
}

class _RowText extends StatelessWidget {
  const _RowText({required this.label, this.subtitle});

  final String label;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: ProText.r(12, weight: FontWeight.w600, lineHeight: 15.6)),
        if (subtitle != null) Text(subtitle!, style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.2)),
      ],
    );
  }
}

/// Botón píldora de 48 px: contorno de marca o degradado; el texto puede ocupar dos líneas.
class CatalogActionButton extends StatelessWidget {
  const CatalogActionButton({super.key, required this.label, this.onTap, this.outlined = false});

  final String label;
  final VoidCallback? onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final color = outlined ? ProColors.brand700 : ProColors.surface0;
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: outlined ? ProColors.paper100 : null,
            gradient: outlined ? null : ProColors.brandGradient,
            borderRadius: BorderRadius.circular(ProRadii.button),
            border: outlined ? Border.all(color: ProColors.brand700, width: 1) : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: ProText.r(14, weight: FontWeight.w600, color: color, lineHeight: 16.8),
                ),
              ),
              const SizedBox(width: 6),
              ProIcon(LucideIcon.chevronRight, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
