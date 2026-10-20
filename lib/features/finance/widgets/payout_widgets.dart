import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

/// Campo de solo lectura de la cuenta: etiqueta gris y valor, en caja de 0.8 px.
class PayoutField extends StatelessWidget {
  const PayoutField({super.key, required this.label, required this.value, this.height = 49});

  final String label;
  final String value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ProColors.surface0,
        borderRadius: BorderRadius.circular(ProRadii.md),
        border: Border.all(color: ProColors.line300, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75)),
          const SizedBox(height: 3),
          Text(value, style: ProText.r(13, color: ProColors.ink900, lineHeight: 16.25)),
        ],
      ),
    );
  }
}

/// Tarjeta de resumen protegido en verde suave con borde de marca.
class PayoutSummaryCard extends StatelessWidget {
  const PayoutSummaryCard({
    super.key,
    required this.title,
    required this.status,
    required this.summary,
    required this.note,
  });

  final String title;
  final String status;
  final String summary;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
      decoration: BoxDecoration(
        color: ProColors.brandLight,
        borderRadius: BorderRadius.circular(ProRadii.lg),
        border: Border.all(color: ProColors.brand700, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(child: Text(title, style: ProText.r(13, weight: FontWeight.w600, lineHeight: 16.25))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: ProColors.warningLight,
                  borderRadius: BorderRadius.circular(ProRadii.xl),
                ),
                child: Text(status, style: ProText.r(11, color: ProColors.warning800, lineHeight: 13.2)),
              ),
            ],
          ),
          Text(summary, style: ProText.r(12, lineHeight: 15)),
          Text(note, style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75)),
        ],
      ),
    );
  }
}
