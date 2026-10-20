import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

/// Métrica del panel: etiqueta en mayúsculas, valor, detalle e ícono.
/// [highlight] resalta el caso abierto sobre fondo de marca.
class AdminStatTile extends StatelessWidget {
  const AdminStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.highlight = false,
  });

  final String label;
  final String value;
  final String subtitle;
  final LucideIcon icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final foreground = highlight ? ProColors.surface0 : ProColors.ink900;
    final muted = highlight ? ProColors.brandLight : ProColors.ink500;
    return ProCard(
      padding: const EdgeInsets.all(12),
      color: highlight ? ProColors.brand700 : ProColors.surface0,
      borderColor: highlight ? null : ProColors.line300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProIcon(icon, size: 18, color: highlight ? ProColors.surface0 : ProColors.brand700),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: ProText.r(10, weight: FontWeight.w600, color: muted, lineHeight: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: ProText.r(15, weight: FontWeight.w600, color: foreground, lineHeight: 18)),
          const SizedBox(height: 2),
          Text(subtitle, style: ProText.r(11, color: muted, lineHeight: 13.2)),
        ],
      ),
    );
  }
}

/// Campo de texto del kit: etiqueta, caja de 0.8 px, sufijo y ayuda opcional.
class AdminField extends StatelessWidget {
  const AdminField({
    super.key,
    required this.label,
    required this.controller,
    this.helperText,
    this.suffixText,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String? helperText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final multiline = maxLines > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ProText.r(12, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 14.4)),
        const SizedBox(height: 6),
        Container(
          height: multiline ? null : 40,
          alignment: multiline ? Alignment.topLeft : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: ProColors.surface0,
            borderRadius: BorderRadius.circular(ProRadii.md),
            border: Border.all(color: ProColors.line300, width: 0.8),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: ProText.r(13, color: ProColors.ink900, lineHeight: 15.6),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              suffixText: suffixText,
              suffixStyle: ProText.r(12, color: ProColors.ink500, lineHeight: 14.4),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(helperText!, style: ProText.caption),
        ],
      ],
    );
  }
}
