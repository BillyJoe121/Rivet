import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

/// Pestañas de dos opciones en píldora: la activa con degradado de marca.
class AccountTabs extends StatelessWidget {
  const AccountTabs({super.key, required this.labels, required this.selected, required this.onSelect});

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == selected ? null : ProColors.brandLight,
                  gradient: i == selected ? ProColors.brandGradient : null,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  labels[i],
                  style: i == selected
                      ? ProText.r(12, weight: FontWeight.w600, color: ProColors.surface0, lineHeight: 14.4)
                      : ProText.r(12, color: ProColors.ink500, lineHeight: 14.4),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Resumen numérico de 59 px con borde de 0.5 px.
class AccountCountCard extends StatelessWidget {
  const AccountCountCard({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 59,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: ProColors.surface0,
        borderRadius: BorderRadius.circular(ProRadii.md),
        border: Border.all(color: ProColors.line300, width: ProStroke.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: ProText.r(18, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 21.6)),
          const SizedBox(height: 4),
          Text(label, style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.2)),
        ],
      ),
    );
  }
}

/// Fila de propuesta: foto, título con estado, datos y chevron (79 px).
class AccountProposalRow extends StatelessWidget {
  const AccountProposalRow({
    super.key,
    required this.image,
    required this.title,
    required this.status,
    required this.statusBackground,
    required this.statusColor,
    required this.details,
  });

  final String image;
  final String title;
  final String status;
  final Color statusBackground;
  final Color statusColor;
  final String details;

  /// Datos de la propuesta: las líneas grises y el precio final en tinta oscura.
  TextSpan _detailsSpan() {
    final lines = details.split('\n');
    final gray = ProText.r(11, color: ProColors.ink500, lineHeight: 12.65);
    final dark = ProText.r(11, color: ProColors.ink900, lineHeight: 12.65);
    return TextSpan(
      children: [
        for (var i = 0; i < lines.length; i++)
          TextSpan(text: i == 0 ? lines[i] : '\n${lines[i]}', style: i == lines.length - 1 ? dark : gray),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProCard(
      height: 79,
      radius: ProRadii.card,
      borderWidth: ProStroke.hairline,
      padding: const EdgeInsets.all(7),
      child: Row(
        children: [
          ProImage(image, width: 60, height: 60, radius: 10),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    Expanded(child: Text(title, style: ProText.r(12, weight: FontWeight.w600, lineHeight: 14.4))),
                    ProChip(
                      status,
                      background: statusBackground,
                      foreground: statusColor,
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      textStyle: ProText.r(11, color: statusColor, lineHeight: 13.2),
                    ),
                  ],
                ),
                Text.rich(_detailsSpan()),
              ],
            ),
          ),
          const SizedBox(width: 9),
          const ProIcon(LucideIcon.chevronRight, size: 14),
        ],
      ),
    );
  }
}

/// Fila de trabajo activo: foto, estado, cliente y barra de etapas (74 px).
class AccountJobRow extends StatelessWidget {
  const AccountJobRow({
    super.key,
    required this.image,
    required this.title,
    required this.status,
    required this.statusBackground,
    required this.statusColor,
    required this.client,
    required this.progress,
    required this.progressWidth,
    required this.progressLabel,
  });

  final String image;
  final String title;
  final String status;
  final Color statusBackground;
  final Color statusColor;
  final String client;
  final double progress;
  final double progressWidth;
  final String progressLabel;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      height: 74,
      radius: ProRadii.card,
      borderWidth: ProStroke.hairline,
      padding: const EdgeInsets.all(7),
      child: Row(
        children: [
          ProImage(image, width: 60, height: 60, radius: 10),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    Expanded(child: Text(title, style: ProText.r(12, weight: FontWeight.w600, lineHeight: 14.4))),
                    ProChip(
                      status,
                      background: statusBackground,
                      foreground: statusColor,
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      textStyle: ProText.r(11, color: statusColor, lineHeight: 13.2),
                    ),
                  ],
                ),
                Text(client, style: ProText.r(11, color: ProColors.ink500, lineHeight: 12.65)),
                Row(
                  spacing: 8,
                  children: [
                    SizedBox(
                      width: progressWidth,
                      child: ProProgressBar(value: progress, height: 7),
                    ),
                    Text(progressLabel, style: ProText.r(9, color: ProColors.ink500, lineHeight: 10.8)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          const ProIcon(LucideIcon.chevronRight, size: 14),
        ],
      ),
    );
  }
}
