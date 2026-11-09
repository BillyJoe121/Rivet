import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../supplier/material_price_tier.dart';
import 'presentation/bloc/proposals_bloc.dart';
import 'proposal_detail_screen.dart';
import 'proposals_service.dart';

/// Propuestas recibidas por el cliente con Clean Architecture y BLoC (P-028 / P-030).
class ReceivedProposalsScreen extends StatelessWidget {
  const ReceivedProposalsScreen({
    super.key,
    this.projectId,
    this.proposalsBloc,
  });

  final String? projectId;
  final ProposalsBloc? proposalsBloc;

  @override
  Widget build(BuildContext context) {
    if (proposalsBloc != null) {
      return BlocProvider<ProposalsBloc>.value(
        value: proposalsBloc!,
        child: _ReceivedProposalsView(projectId: projectId),
      );
    }

    try {
      context.read<ProposalsBloc>();
      return _ReceivedProposalsView(projectId: projectId);
    } catch (_) {
      return BlocProvider<ProposalsBloc>(
        create: (_) => ProposalsBloc(
          ProposalsService.instance.getReceivedProposalsUseCase,
          ProposalsService.instance.acceptProposalUseCase,
        )..add(LoadReceivedProposals(projectId: projectId)),
        child: _ReceivedProposalsView(projectId: projectId),
      );
    }
  }
}

class _ReceivedProposalsView extends StatelessWidget {
  const _ReceivedProposalsView({this.projectId});

  final String? projectId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalsBloc, ProposalsState>(
      builder: (context, state) {
        final proposals = projectId != null
            ? state.proposals.where((p) => p.projectId == projectId).toList()
            : state.proposals;

        return RivetScaffold(
          title: 'Propuestas recibidas',
          showBackButton: projectId != null,
          backgroundImagePath: 'Fondos/Checklist, plantas y cajas sostenibles.png',
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.sm),
              if (state.isLoading && proposals.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.brand700),
                    ),
                  ),
                )
              else if (proposals.isEmpty)
                const AppEmptyState(
                  title: 'Aún no tienes propuestas',
                  message:
                      'Cuando un contratista cotice tu proyecto, verás su propuesta desglosada aquí.',
                  icon: LucideIcons.fileText,
                )
              else ...[
                AppSectionHeader(
                  title: 'Cotizaciones activas',
                  count: proposals.length,
                ),
                const SizedBox(height: AppSpacing.md),
                for (final proposal in proposals)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProposalDetailScreen(proposal: proposal),
                          ),
                        );
                      },
                      child: _ProposalCard(proposal: proposal),
                    ),
                  ),
              ],
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({required this.proposal});

  final Proposal proposal;

  @override
  Widget build(BuildContext context) {
    final contractor = proposal.contractor;
    final isAccepted = proposal.status == 'Aceptada';

    return AppCard(
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
                          const Icon(LucideIcons.badgeCheck, size: 16, color: AppColors.brand700),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(contractor.trade, style: AppTypography.caption),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppBadge(
                text: isAccepted ? 'Aceptada' : proposal.status,
                variant: isAccepted ? AppBadgeVariant.success : AppBadgeVariant.brand,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(LucideIcons.star, size: 15, color: AppColors.sun300),
              const SizedBox(width: 4),
              Text(
                '${contractor.rating}',
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(LucideIcons.clock, size: 15, color: AppColors.ink700),
              const SizedBox(width: 4),
              Text('${proposal.estimatedDays} días', style: AppTypography.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.paper100,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mano de obra', style: AppTypography.caption),
                    Text('\$ ${formatCop(proposal.laborCostCop)}', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Materiales', style: AppTypography.caption),
                    Text('\$ ${formatCop(proposal.materialsCostCop)}', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Total', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
                    Text(
                      '\$ ${formatCop(proposal.totalCostCop)}',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.brand700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
