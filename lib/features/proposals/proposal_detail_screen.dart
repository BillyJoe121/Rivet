import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../agreements/agreements_screens.dart';
import '../contractors/contractors_screens.dart';
import '../messaging/messaging_screens.dart';
import '../supplier/material_price_tier.dart';
import 'presentation/bloc/proposals_bloc.dart';
import 'domain/repositories/proposal_repository.dart';
import 'domain/usecases/accept_proposal_usecase.dart';
import 'domain/usecases/get_received_proposals_usecase.dart';

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
        create: (context) {
          final repository = context.read<ProposalRepository>();
          return ProposalsBloc(
            GetReceivedProposalsUseCase(repository),
            AcceptProposalUseCase(repository),
          );
        },
        child: _ProposalDetailView(proposal: proposal),
      );
    }
  }
}

class _ProposalDetailView extends StatelessWidget {
  const _ProposalDetailView({required this.proposal});

  final Proposal proposal;

  Future<void> _confirmAcceptance(
    BuildContext context,
    Proposal currentProposal,
  ) async {
    final confirmed = await showAppConfirmDialog(
      context,
      title: '¿Aceptar esta propuesta?',
      message:
          'Al aceptar, revisarás el acuerdo de obra y el pago simulado con ${currentProposal.contractor.name}.',
      confirmLabel: 'Aceptar propuesta',
      cancelLabel: 'Revisar después',
    );

    if (confirmed == true && context.mounted) {
      context.read<ProposalsBloc>().add(
        AcceptProposalSubmitted(currentProposal.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProposalsBloc, ProposalsState>(
      listener: (context, state) {
        if (state.acceptedProposalId == proposal.id) {
          final currentProposal = state.proposals.firstWhere(
            (p) => p.id == proposal.id,
            orElse: () => proposal,
          );
          AppNavigator.push(
            context,
            AgreementSummaryScreen(proposal: currentProposal),
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
          title: 'Detalle de\npropuesta',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.greenery,
          body: AppPageBody(
            footer: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isAccepted)
                  AppButton(
                    text: state.isLoading
                        ? 'Formalizando...'
                        : 'Aceptar propuesta y ver acuerdo',
                    isLoading: state.isLoading,
                    showChevron: true,
                    onPressed: () =>
                        _confirmAcceptance(context, currentProposal),
                  )
                else
                  AppButton(
                    text: 'Ir al acuerdo y pago simulado',
                    showChevron: true,
                    onPressed: () => AppNavigator.push(
                      context,
                      AgreementSummaryScreen(proposal: currentProposal),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  text: 'Escribir o contraofertar',
                  variant: AppButtonVariant.outline,
                  icon: LucideIcons.messageSquare,
                  onPressed: () => AppNavigator.push(
                    context,
                    ProjectChatScreen(
                      conversationId: 'conv-001',
                      contractorName: currentProposal.contractor.name,
                    ),
                  ),
                ),
              ],
            ),
            children: [
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
                                style: AppTypography.sectionTitle,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${currentProposal.contractor.trade} · ${currentProposal.contractor.zone}',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.ink700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        AppBadge(
                          text: isAccepted
                              ? 'Aceptada'
                              : currentProposal.status,
                          variant: isAccepted
                              ? AppBadgeVariant.success
                              : AppBadgeVariant.brand,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.star,
                          size: 16,
                          color: AppColors.sun300,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${currentProposal.contractor.rating}',
                          style: AppTypography.bodyStrong,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '(${currentProposal.contractor.reviewCount} reseñas · ${currentProposal.contractor.completedJobs} obras)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.caption,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppListTile(
                      leadingIcon: LucideIcons.userCheck,
                      title: 'Ver perfil completo del contratista',
                      subtitle: 'Portafolio y solicitud de visita técnica',
                      showDivider: false,
                      onTap: () => AppNavigator.push(
                        context,
                        ContractorProfileScreen(
                          contractor: currentProposal.contractor,
                          projectId: currentProposal.projectId,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: const BoxDecoration(
                        color: AppColors.brandLight,
                        borderRadius: AppSpacing.roundedSm,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Mano de obra:',
                                  style: AppTypography.bodySmall,
                                ),
                              ),
                              Text(
                                '\$ ${formatCop(currentProposal.laborCostCop)} COP',
                                style: AppTypography.bodyStrong,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Materiales Bodega Rivet:',
                                  style: AppTypography.bodySmall,
                                ),
                              ),
                              Text(
                                '\$ ${formatCop(currentProposal.materialsCostCop)} COP',
                                style: AppTypography.bodyStrong,
                              ),
                            ],
                          ),
                          const Divider(height: 16, color: AppColors.line300),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Total cotizado:',
                                  style: AppTypography.subheading,
                                ),
                              ),
                              Text(
                                '\$ ${formatCop(currentProposal.totalCostCop)} COP',
                                style: AppTypography.subheading.copyWith(
                                  color: AppColors.brand700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppSpecRow(
                      icon: LucideIcons.calendar,
                      label: 'Tiempo estimado de ejecución',
                      value: '${currentProposal.estimatedDays} días hábiles',
                      showDivider: false,
                    ),
                    if (currentProposal.observations.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Alcance y especificaciones',
                        style: AppTypography.captionStrong,
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
            ],
          ),
        );
      },
    );
  }
}
