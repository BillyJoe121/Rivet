import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

/// Tarjeta de orden de despacho para la vista del proveedor.
class SupplierOrderCard extends StatelessWidget {
  const SupplierOrderCard({
    super.key,
    required this.id,
    required this.projectTitle,
    required this.contractorName,
    required this.items,
    required this.totalCop,
    required this.status,
    required this.statusVariant,
    this.hasActionButton = false,
    this.onAction,
  });

  final String id;
  final String projectTitle;
  final String contractorName;
  final String items;
  final String totalCop;
  final String status;
  final AppBadgeVariant statusVariant;
  final bool hasActionButton;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
              AppBadge(text: status, variant: statusVariant),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(projectTitle, style: AppTypography.subheading),
          Text('Para contratista: $contractorName', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.ink500),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(items, style: AppTypography.bodySmall)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total pedido: $totalCop', style: AppTypography.badgeText.copyWith(color: AppColors.brand700)),
              if (hasActionButton)
                AppButton(
                  text: 'Marcar despachado',
                  size: AppButtonSize.sm,
                  isFullWidth: false,
                  onPressed: onAction ?? () {},
                ),
            ],
          ),
        ],
      ),
    );
  }
}
