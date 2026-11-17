import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_page_route.dart';
import '../../../core/widgets/widgets.dart';
import '../../agreements/agreements_screens.dart';
import '../../projects/domain/repositories/project_repository.dart';
import '../../supplier/material_price_tier.dart';
import '../domain/repositories/proposal_repository.dart';
import 'create_proposal_screen.dart';
import 'my_proposals_bloc.dart';

/// Mis propuestas y trabajos activos del contratista (22:145904).
class MyProposalsJobsScreen extends StatelessWidget {
  const MyProposalsJobsScreen({super.key});

  static Widget withBloc({int initialTab = 0}) {
    return BlocProvider<MyProposalsBloc>(
      create: (context) => MyProposalsBloc.fromRepositories(
        context.read<ProposalRepository>(),
        context.read<ProjectRepository>(),
        initialTab: initialTab,
      )..add(const LoadMyProposalsAndJobs()),
      child: const MyProposalsJobsScreen(),
    );
  }

  static Route<void> route({int initialTab = 0}) {
    return RivetPageRoute<void>(builder: (_) => withBloc(initialTab: initialTab));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProposalsBloc, MyProposalsState>(
      builder: (context, state) {
        return RivetScaffold(
          title: 'Mis propuestas\ny trabajos',
          showBackButton: Navigator.of(context).canPop(),
          backgroundImagePath: AppHeroImages.documents,
          body: AppPageBody(
            onRefresh: () async {
              context.read<MyProposalsBloc>().add(
                const LoadMyProposalsAndJobs(),
              );
            },
            children: [
              AppSegmentedControl<int>(
                items: const {0: 'Propuestas', 1: 'Trabajos'},
                selected: state.tabIndex,
                onChanged: (tab) => context.read<MyProposalsBloc>().add(
                  MyProposalsTabChanged(tab),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (state.tabIndex == 0) ...[
                Row(
                  children: [
                    Expanded(
                      child: AppStatTile(
                        value: '${state.draftCount}',
                        label: 'Borradores',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: AppStatTile(
                        value: '${state.sentCount}',
                        label: 'Enviadas',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: AppStatTile(
                        value: '${state.acceptedCount}',
                        label: 'Aceptadas',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (state.isLoading && state.proposals.isEmpty)
                const AppLoadingState(label: 'Cargando tus propuestas')
              else if (state.isFailure && state.proposals.isEmpty)
                AppErrorState(
                  message:
                      state.errorMessage ??
                      'No pudimos cargar tus propuestas y trabajos.',
                  onRetry: () => context.read<MyProposalsBloc>().add(
                    const LoadMyProposalsAndJobs(),
                  ),
                )
              else if (state.tabIndex == 0)
                _buildProposalsList(context, state)
              else
                _buildJobsList(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProposalsList(BuildContext context, MyProposalsState state) {
    if (state.proposals.isEmpty) {
      return const AppEmptyState(
        title: 'Aún no tienes propuestas',
        message:
            'Explora los proyectos disponibles y envía tu primera cotización.',
        icon: LucideIcons.fileText,
      );
    }

    return Column(
      children: [
        for (final proposal in state.proposals) ...[
          _ContractorProposalCard(
            proposal: proposal,
            project: state.projectFor(proposal.projectId),
            onTap: proposal.status == ProposalStatus.draft
                ? () async {
                    final fallbackProject =
                        state.projectFor(proposal.projectId) ??
                        Project(
                          id: proposal.projectId,
                          title: 'Proyecto ${proposal.projectId}',
                          clientName: 'Cliente',
                          city: 'Cali',
                          neighborhood: '',
                          surfaces: const [],
                          status: ProjectStatus.published,
                          createdAt: DateTime.now(),
                        );
                    final bloc = context.read<MyProposalsBloc>();
                    await Navigator.of(context).push(
                      CreateProposalScreen.route(
                        project: fallbackProject,
                        initialProposal: proposal,
                      ),
                    );
                    bloc.add(const LoadMyProposalsAndJobs());
                  }
                : null,
            onWithdraw: proposal.status == ProposalStatus.sent
                ? () => context.read<MyProposalsBloc>().add(
                    WithdrawProposalRequested(proposal.id),
                  )
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _buildJobsList(BuildContext context, MyProposalsState state) {
    final jobs = state.activeJobs;
    if (jobs.isEmpty) {
      return const AppEmptyState(
        title: 'Sin trabajos activos aún',
        message:
            'Cuando un cliente acepte tu propuesta, verás el trabajo activo aquí.',
        icon: LucideIcons.briefcaseBusiness,
      );
    }

    return Column(
      children: [
        for (final job in jobs) ...[
          _ContractorProposalCard(
            proposal: job,
            project: state.projectFor(job.projectId),
            onTap: () => Navigator.of(context).push(
              AgreementSummaryScreen.route(
                proposal: job,
                projectTitle:
                    state.projectFor(job.projectId)?.title ?? 'Proyecto Rivet',
                asClient: false,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _ContractorProposalCard extends StatelessWidget {
  const _ContractorProposalCard({
    required this.proposal,
    this.project,
    this.onTap,
    this.onWithdraw,
  });

  final Proposal proposal;
  final Project? project;
  final VoidCallback? onTap;
  final VoidCallback? onWithdraw;

  AppBadgeVariant _badgeVariant(ProposalStatus status) => switch (status) {
    ProposalStatus.accepted => AppBadgeVariant.success,
    ProposalStatus.draft => AppBadgeVariant.warning,
    ProposalStatus.rejected || ProposalStatus.withdrawn => AppBadgeVariant.danger,
    ProposalStatus.sent => AppBadgeVariant.brand,
  };

  @override
  Widget build(BuildContext context) {
    final title = project?.title ?? 'Proyecto ${proposal.projectId}';
    final subtitle = project != null
        ? '${project!.totalAreaM2.toStringAsFixed(1)} m² · ${project!.city}'
        : '${proposal.estimatedDays} días hábiles';

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: AppTypography.subheading)),
              const SizedBox(width: AppSpacing.sm),
              AppBadge(
                text: proposal.status.label,
                variant: _badgeVariant(proposal.status),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTypography.caption),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                '\$ ${formatCop(proposal.totalCostCop)} COP',
                style: AppTypography.bodyStrong.copyWith(
                  color: AppColors.brand700,
                ),
              ),
              const Spacer(),
              if (onWithdraw != null)
                TextButton(
                  onPressed: onWithdraw,
                  child: const Text('Retirar'),
                )
              else if (onTap != null)
                const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.brand700,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
