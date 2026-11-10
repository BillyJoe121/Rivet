import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../supplier/material_price_tier.dart';

/// Tarjeta reutilizable de cotización recibida (P-028).
class ProposalCard extends StatelessWidget {
  const ProposalCard({super.key, required this.proposal, this.onTap});

  final Proposal proposal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final contractor = proposal.contractor;
    final isAccepted = proposal.status == 'Aceptada';

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            contractor.name,
                            style: AppTypography.subheading,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (contractor.isVerified) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const Icon(
                            LucideIcons.badgeCheck,
                            size: 16,
                            color: AppColors.brand700,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${contractor.trade} · ${contractor.zone}',
                      style: AppTypography.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppBadge(
                text: isAccepted ? 'Aceptada' : proposal.status,
                variant: isAccepted
                    ? AppBadgeVariant.success
                    : AppBadgeVariant.brand,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(LucideIcons.star, size: 15, color: AppColors.sun300),
              const SizedBox(width: 4),
              Text(
                contractor.rating.toStringAsFixed(1),
                style: AppTypography.captionStrong,
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(LucideIcons.clock, size: 15, color: AppColors.ink700),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${proposal.estimatedDays} días hábiles',
                  style: AppTypography.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: const BoxDecoration(
              color: AppColors.paper100,
              borderRadius: AppSpacing.roundedSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mano de obra', style: AppTypography.caption),
                      Text(
                        '\$ ${formatCop(proposal.laborCostCop)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelStrong,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Materiales', style: AppTypography.caption),
                      Text(
                        '\$ ${formatCop(proposal.materialsCostCop)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelStrong,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Total', style: AppTypography.captionStrong),
                      Text(
                        '\$ ${formatCop(proposal.totalCostCop)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelStrong.copyWith(
                          color: AppColors.brand700,
                        ),
                      ),
                    ],
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
