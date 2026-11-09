import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../supplier/material_price_tier.dart';
import 'presentation/bloc/proposals_bloc.dart';
import 'proposals_service.dart';

/// Ficha técnica y detalle de una cotización para aceptación formal del cliente (P-031).
class ProposalDetailScreen extends StatelessWidget {
  const ProposalDetailScreen({
    super.key,
    required this.proposal,
    this.proposalsBloc,
  });

  final Proposal proposal;
  final ProposalsBloc? proposalsBloc;

  @override
  Widget build(BuildContext context) {
    if (proposalsBloc != null) {
      return BlocProvider<ProposalsBloc>.value(
        value: proposalsBloc!,
        child: _ProposalDetailView(proposal: proposal),
      );
    }

    try {
      context.read<ProposalsBloc>();
      return _ProposalDetailView(proposal: proposal);
    } catch (_) {
      return BlocProvider<ProposalsBloc>(
        create: (_) => ProposalsBloc(
          ProposalsService.instance.getReceivedProposalsUseCase,
          ProposalsService.instance.acceptProposalUseCase,
        ),
        child: _ProposalDetailView(proposal: proposal),
      );
    }
  }
}

class _ProposalDetailView extends StatelessWidget {
  const _ProposalDetailView({required this.proposal});

  final Proposal proposal;

  Future<void> _confirmAcceptance(BuildContext context) async {
    final confirmed = await showAppConfirmDialog(
      context,
      title: '¿Aceptar esta propuesta?',
      message:
          'Al aceptar, fijarás las condiciones de mano de obra y materiales con ${proposal.contractor.name}.',
      confirmLabel: 'Aceptar propuesta',
      cancelLabel: 'Revisar después',
    );

    if (confirmed == true && context.mounted) {
      context.read<ProposalsBloc>().add(AcceptProposalSubmitted(proposal.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProposalsBloc, ProposalsState>(
      listener: (context, state) {
        if (state.acceptedProposalId == proposal.id) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Propuesta aceptada. Se formalizó el acuerdo de obra.'),
              backgroundColor: AppColors.brand700,
            ),
          );
        }
      },
      builder: (context, state) {
        final currentProposal = state.proposals.firstWhere(
          (p) => p.id == proposal.id,
          orElse: () => proposal,
        );

        final isAccepted = currentProposal.status == 'Aceptada' ||
            state.acceptedProposalId == proposal.id;

        return RivetScaffold(
          title: 'Detalle de cotización',
          showBackButton: true,
          backgroundImagePath: 'Fondos/Checklist, plantas y cajas sostenibles.png',
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.sm),
              AppCard(
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
                              Text(
                                currentProposal.contractor.name,
                                style: AppTypography.sectionTitle.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentProposal.contractor.trade,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.ink700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppBadge(
                          text: isAccepted ? 'Aceptada' : currentProposal.status,
                          variant: isAccepted
                              ? AppBadgeVariant.success
                              : AppBadgeVariant.brand,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        const Icon(LucideIcons.star, size: 16, color: Color(0xFFD97706)),
                        const SizedBox(width: 4),
                        Text(
                          '${currentProposal.contractor.rating}',
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '(${currentProposal.contractor.reviewCount} reseñas)',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.brandLight,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Mano de obra:', style: AppTypography.bodySmall),
                              Text(
                                '\$ ${formatCop(currentProposal.laborCostCop)} COP',
                                style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Materiales Bodega Rivet:', style: AppTypography.bodySmall),
                              Text(
                                '\$ ${formatCop(currentProposal.materialsCostCop)} COP',
                                style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const Divider(height: 16, color: AppColors.line300),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total cotizado:',
                                style: AppTypography.subheading.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '\$ ${formatCop(currentProposal.totalCostCop)} COP',
                                style: AppTypography.subheading.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brand700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppSpecRow(
                      icon: LucideIcons.calendar,
                      label: 'Tiempo estimado de ejecución',
                      value: '${currentProposal.estimatedDays} días hábiles',
                    ),
                    if (currentProposal.observations.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Alcance y especificaciones',
                        style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentProposal.observations,
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (!isAccepted)
                AppButton(
                  text: state.isLoading ? 'Formalizando...' : 'Aceptar propuesta',
                  icon: LucideIcons.check,
                  onPressed: state.isLoading ? () {} : () => _confirmAcceptance(context),
                )
              else
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.brandLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.checkCircle2, color: AppColors.brand700, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Propuesta aceptada formalmente',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.brand700,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }
}

