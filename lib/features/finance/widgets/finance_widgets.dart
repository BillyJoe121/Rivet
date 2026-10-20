import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import '../../home/widgets/kit/kit.dart';

/// Colores de la insignia de estado según la variante de la operación.
({Color background, Color foreground}) _statusColors(AppBadgeVariant variant) {
  return switch (variant) {
    AppBadgeVariant.warning => (background: ProColors.warningLight, foreground: ProColors.warning800),
    AppBadgeVariant.success => (background: ProColors.successLight, foreground: ProColors.successText),
    AppBadgeVariant.brand => (background: ProColors.brandLight, foreground: ProColors.brand700),
    AppBadgeVariant.danger => (background: ProColors.dangerLight, foreground: ProColors.danger700),
    AppBadgeVariant.info => (background: ProColors.infoLight, foreground: ProColors.brand700),
    AppBadgeVariant.neutral => (background: ProColors.progressTrack, foreground: ProColors.ink700),
  };
}

/// Saldo protegido sobre el degradado de marca.
class FinanceBalanceCard extends StatelessWidget {
  const FinanceBalanceCard({super.key, required this.title, required this.amount, required this.note});

  final String title;
  final String amount;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: ProColors.brandGradient,
        borderRadius: BorderRadius.circular(ProRadii.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: ProText.r(11, weight: FontWeight.w600, color: ProColors.brandLight, lineHeight: 13.2)),
          const SizedBox(height: 6),
          Text(amount, style: ProText.serif(26, color: ProColors.surface0, lineHeight: 31.2)),
          const SizedBox(height: 8),
          Text(note, style: ProText.r(12, color: ProColors.brandLight, lineHeight: 15)),
        ],
      ),
    );
  }
}

/// Insignia de estado en píldora con color y texto explícito.
class FinanceStatusChip extends StatelessWidget {
  const FinanceStatusChip({super.key, required this.text, required this.variant});

  final String text;
  final AppBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors(variant);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(ProRadii.xl)),
      child: Text(
        text,
        style: ProText.r(11, weight: FontWeight.w600, color: colors.foreground, lineHeight: 13.2),
      ),
    );
  }
}

/// Fila de movimiento: ícono, concepto, contraparte y fecha, monto y estado.
class FinanceTransactionCard extends StatelessWidget {
  const FinanceTransactionCard({
    super.key,
    required this.icon,
    required this.concept,
    required this.party,
    required this.date,
    required this.amount,
    required this.status,
    required this.variant,
    this.isIncome = false,
  });

  final LucideIcon icon;
  final String concept;
  final String party;
  final String date;
  final String amount;
  final String status;
  final AppBadgeVariant variant;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: ProColors.brandLight, borderRadius: BorderRadius.circular(ProRadii.sm)),
            child: ProIcon(icon, size: 18, color: ProColors.brand700),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(concept, style: ProText.r(13, weight: FontWeight.w600, lineHeight: 15.6)),
                const SizedBox(height: 3),
                Text('$party · $date', style: ProText.caption),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                amount,
                style: ProText.r(
                  13,
                  weight: FontWeight.w600,
                  color: isIncome ? ProColors.success700 : ProColors.ink900,
                  lineHeight: 15.6,
                ),
              ),
              const SizedBox(height: 4),
              FinanceStatusChip(text: status, variant: variant),
            ],
          ),
        ],
      ),
    );
  }
}
