import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../proposals/proposal_detail_screen.dart';
import '../supplier/material_price_tier.dart';
import 'agreements_screens.dart';

/// Comparador lado a lado de propuestas recibidas según diseño Figma (P-029).
class ProposalsCompareScreen extends StatefulWidget {
  const ProposalsCompareScreen({
    super.key,
    required this.projectId,
    required this.proposals,
    this.projectTitle = 'Proyecto',
  });

  final String projectId;
  final List<Proposal> proposals;
  final String projectTitle;

  @override
  State<ProposalsCompareScreen> createState() => _ProposalsCompareScreenState();
}

class _ProposalsCompareScreenState extends State<ProposalsCompareScreen> {
  int _selectedIndex = 0;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'C';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.proposals]
      ..sort((a, b) => a.totalCostCop.compareTo(b.totalCostCop));
    final compared = sorted.take(2).toList();
    final selectedProposal = compared.isEmpty
        ? null
        : compared[_selectedIndex.clamp(0, compared.length - 1)];

    return RivetScaffold(
      title: 'Comparar\npropuestas',
      showBackButton: true,
      backgroundImagePath: AppHeroImages.storefront,
      body: AppPageBody(
        footer: selectedProposal == null || compared.length < 2
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    text: 'Elegir y revisar acuerdo',
                    showChevron: true,
                    onPressed: () => AppNavigator.push(
                      context,
                      AgreementSummaryScreen(
                        proposal: selectedProposal,
                        projectTitle: widget.projectTitle,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppButton(
                    text: 'Ver oferta completa',
                    variant: AppButtonVariant.outline,
                    onPressed: () => AppNavigator.push(
                      context,
                      ProposalDetailScreen(proposal: selectedProposal),
                    ),
                  ),
                ],
              ),
        children: [
          if (compared.length < 2)
            const AppEmptyState(
              title: 'Necesitas al menos dos propuestas',
              message:
                  'Cuando tengas dos o más propuestas en este proyecto podrás compararlas lado a lado.',
              icon: LucideIcons.columns2,
            )
          else ...[
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 92),
                      for (var i = 0; i < compared.length; i++)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedIndex = i),
                            child: Container(
                              margin: EdgeInsets.only(left: i == 0 ? 0 : 6),
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: _selectedIndex == i
                                    ? AppColors.brandLight
                                    : AppColors.paper100,
                                borderRadius: AppSpacing.roundedMd,
                                border: Border.all(
                                  color: _selectedIndex == i
                                      ? AppColors.brand700
                                      : AppColors.line300,
                                  width: _selectedIndex == i ? 1.2 : 0.6,
                                ),
                              ),
                              child: Column(
                                children: [
                                  if (i == 0)
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 6),
                                      child: AppBadge(
                                        text: 'Mejor opción',
                                        variant: AppBadgeVariant.brand,
                                        compact: true,
                                      ),
                                    )
                                  else
                                    const SizedBox(height: 24),
                                  AppAvatar(
                                    initials: _initials(
                                      compared[i].contractor.name,
                                    ),
                                    size: 40,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    compared[i].contractor.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.labelStrong,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '★ ${compared[i].contractor.rating.toStringAsFixed(1)} (${compared[i].contractor.reviewCount})',
                                    style: AppTypography.captionStrong.copyWith(
                                      color: AppColors.brand700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: AppSpacing.lg, color: AppColors.line300),
                  _CompareTableRow(
                    icon: LucideIcons.coins,
                    label: 'Total',
                    leftValue: '\$ ${formatCop(compared[0].totalCostCop)}',
                    rightValue: '\$ ${formatCop(compared[1].totalCostCop)}',
                    emphasize: true,
                    selectedIndex: _selectedIndex,
                  ),
                  _CompareTableRow(
                    icon: LucideIcons.hammer,
                    label: 'Mano de obra',
                    leftValue: '\$ ${formatCop(compared[0].laborCostCop)}',
                    rightValue: '\$ ${formatCop(compared[1].laborCostCop)}',
                    selectedIndex: _selectedIndex,
                  ),
                  _CompareTableRow(
                    icon: LucideIcons.paintBucket,
                    label: 'Materiales',
                    leftValue: '\$ ${formatCop(compared[0].materialsCostCop)}',
                    rightValue: '\$ ${formatCop(compared[1].materialsCostCop)}',
                    selectedIndex: _selectedIndex,
                  ),
                  _CompareTableRow(
                    icon: LucideIcons.clock,
                    label: 'Duración',
                    leftValue: '${compared[0].estimatedDays} días',
                    rightValue: '${compared[1].estimatedDays} días',
                    selectedIndex: _selectedIndex,
                  ),
                  _CompareTableRow(
                    icon: LucideIcons.briefcase,
                    label: 'Obras',
                    leftValue: '${compared[0].contractor.completedJobs} obras',
                    rightValue: '${compared[1].contractor.completedJobs} obras',
                    selectedIndex: _selectedIndex,
                  ),
                  _CompareTableRow(
                    icon: LucideIcons.fileText,
                    label: 'Incluye',
                    leftValue: compared[0].observations,
                    rightValue: compared[1].observations,
                    selectedIndex: _selectedIndex,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const AppInfoBanner(
              compact: true,
              message:
                  'Toca una columna para seleccionarla y revisar el acuerdo o la oferta completa antes de decidir.',
            ),
          ],
        ],
      ),
    );
  }
}

class _CompareTableRow extends StatelessWidget {
  const _CompareTableRow({
    required this.icon,
    required this.label,
    required this.leftValue,
    required this.rightValue,
    required this.selectedIndex,
    this.emphasize = false,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String leftValue;
  final String rightValue;
  final int selectedIndex;
  final bool emphasize;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final textStyle = emphasize
        ? AppTypography.labelStrong.copyWith(color: AppColors.brand700)
        : AppTypography.caption.copyWith(color: AppColors.ink900);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 92,
                child: Row(
                  children: [
                    Icon(icon, size: 14, color: AppColors.brand700),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(label, style: AppTypography.captionStrong),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: selectedIndex == 0
                        ? AppColors.brandLight.withValues(alpha: 0.45)
                        : null,
                    borderRadius: AppSpacing.roundedSm,
                  ),
                  child: Text(
                    leftValue,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: selectedIndex == 1
                        ? AppColors.brandLight.withValues(alpha: 0.45)
                        : null,
                    borderRadius: AppSpacing.roundedSm,
                  ),
                  child: Text(
                    rightValue,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.line300),
      ],
    );
  }
}

