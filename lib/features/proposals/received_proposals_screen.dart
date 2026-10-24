import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import 'proposal_detail_screen.dart';

/// Propuestas recibidas por el cliente, agrupadas por proyecto.
class ReceivedProposalsScreen extends StatelessWidget {
  const ReceivedProposalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proposals = MockData.proposals;

    // Solo los proyectos que tienen al menos una propuesta.
    final groups = <MapEntry<Project, List<Proposal>>>[];
    for (final project in MockData.projects) {
      final items = proposals.where((p) => p.projectId == project.id).toList();
      if (items.isNotEmpty) groups.add(MapEntry(project, items));
    }

    return RivetScaffold(
      title: 'Propuestas recibidas',
      showBackButton: false,
      backgroundImagePath: 'Fondos/Checklist, plantas y cajas sostenibles.png',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.sm),
          if (groups.isEmpty)
            const AppEmptyState(
              title: 'Aún no tienes propuestas',
              message:
                  'Cuando un contratista cotice uno de tus proyectos, verás su propuesta aquí.',
              icon: Icons.request_quote_outlined,
            )
          else
            for (final group in groups) ...[
              AppSectionHeader(title: group.key.title, count: group.value.length),
              const SizedBox(height: AppSpacing.md),
              for (final proposal in group.value)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _ProposalCard(proposal: proposal),
                ),
              const SizedBox(height: AppSpacing.sm),
            ],
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({required this.proposal});

  final Proposal proposal;

  @override
  Widget build(BuildContext context) {
    final contractor = proposal.contractor;

    return AppCard(
      onTap: () => AppNavigator.push(
        context,
        ProposalDetailScreen(proposal: proposal),
      ),
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
                            style: AppTypography.subheading.copyWith(fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (contractor.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 16, color: AppColors.brand700),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(contractor.trade, style: AppTypography.caption),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppBadge(text: proposal.status, variant: _statusVariant(proposal.status)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  '\$ ${_formatCurrency(proposal.totalCostCop)} COP',
                  style: AppTypography.bodyStrong.copyWith(color: AppColors.brand700),
                ),
              ),
              const Icon(Icons.schedule, size: 16, color: AppColors.brand700),
              const SizedBox(width: 4),
              Text(
                '${proposal.estimatedDays} días',
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink900),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.chevron_right, size: 20, color: AppColors.ink500),
            ],
          ),
        ],
      ),
    );
  }

  static AppBadgeVariant _statusVariant(String status) {
    switch (status) {
      case 'Aceptada':
        return AppBadgeVariant.success;
      case 'En revisión':
        return AppBadgeVariant.warning;
      default:
        return AppBadgeVariant.brand;
    }
  }

  static String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
