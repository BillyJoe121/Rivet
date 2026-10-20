import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

/// Indicador de pasos: círculos de 28 px con el paso activo en degradado.
class ProposalStepper extends StatelessWidget {
  const ProposalStepper({super.key, required this.labels, required this.active});

  final List<String> labels;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Column(
                spacing: 5,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == active ? null : ProColors.progressTrack,
                      gradient: i == active
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [ProColors.brandGradientStart, ProColors.brandGradientEnd],
                            )
                          : null,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: i == active
                          ? ProText.r(14, weight: FontWeight.w600, color: ProColors.surface0, lineHeight: 16.8)
                          : ProText.r(14, weight: FontWeight.w600, lineHeight: 16.8),
                    ),
                  ),
                  Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: ProText.r(
                      10,
                      color: i == active ? ProColors.brand700 : ProColors.ink500,
                      lineHeight: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Fila de resumen de la propuesta: ícono, etiqueta, valor y chevron.
class ProposalSummaryRow extends StatelessWidget {
  const ProposalSummaryRow({super.key, required this.icon, required this.label, required this.value});

  final LucideIcon icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ProColors.line300, width: ProStroke.hairline)),
      ),
      child: Row(
        children: [
          ProIcon(icon, size: 21),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: ProText.r(12, weight: FontWeight.w600, lineHeight: 15.6))),
          Text(value, style: ProText.r(12, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 14.4)),
          const SizedBox(width: 10),
          const ProIcon(LucideIcon.chevronRight, size: 15),
        ],
      ),
    );
  }
}

/// Tarjeta de material: foto cuadrada y cuatro líneas de precios.
class ProposalMaterialCard extends StatelessWidget {
  const ProposalMaterialCard({super.key, required this.image, required this.text});

  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    return ProCard(
      height: 61,
      radius: ProRadii.card,
      borderWidth: ProStroke.hairline,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          ProImage(image, width: 51, height: 48, radius: 10, fit: BoxFit.contain),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < lines.length; i++)
                  Text(
                    lines[i],
                    style: i == lines.length - 1
                        ? ProText.r(12, weight: FontWeight.w600, color: ProColors.ink900, lineHeight: 14.4)
                        : ProText.r(11, color: ProColors.ink500, lineHeight: 13.2),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const ProIcon(LucideIcon.chevronRight, size: 15),
        ],
      ),
    );
  }
}
