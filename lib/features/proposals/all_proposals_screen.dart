import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../../injection_container.dart';
import '../agreements/agreements_screens.dart';
import '../projects/domain/repositories/project_repository.dart';
import 'presentation/bloc/proposals_bloc.dart';
import 'proposal_detail_screen.dart';
import 'domain/repositories/proposal_repository.dart';
import 'widgets/proposal_card.dart';

/// Destino global "Cotizaciones" del menú Más: agrupa cotizaciones por proyecto.
class AllProposalsScreen extends StatelessWidget {
  const AllProposalsScreen({super.key});

  /// Pantalla con su propio [ProposalsBloc] cargando las propuestas.
  static Widget withBloc() {
    return BlocProvider<ProposalsBloc>(
      create: (context) => resolveBloc<ProposalsBloc>(
        () => ProposalsBloc.fromRepository(
          context.read<ProposalRepository>(),
          projectRepository: context.read<ProjectRepository>(),
        ),
      )..add(const LoadReceivedProposals()),
      child: const AllProposalsScreen(),
    );
  }

  static Route<void> route() {
    return RivetPageRoute<void>(builder: (_) => withBloc());
  }

  String _projectTitle(ProposalsState state, String projectId) {
    final title = state.projectTitles[projectId]?.trim();
    if (title != null && title.isNotEmpty) return title;
    final shortId = projectId.length > 8 ? projectId.substring(0, 8) : projectId;
    return 'Proyecto $shortId';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalsBloc, ProposalsState>(
      builder: (context, state) {
        final grouped = <String, List<Proposal>>{};
        for (final proposal in state.proposals) {
          grouped.putIfAbsent(proposal.projectId, () => []).add(proposal);
        }

        return RivetScaffold(
          title: 'Propuestas',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.documents,
          body: AppPageBody(
            onRefresh: () async {
              context.read<ProposalsBloc>().add(
                const LoadReceivedProposals(),
              );
            },
            children: [
              if (state.isLoading && state.proposals.isEmpty)
                const AppLoadingState(label: 'Cargando propuestas')
              else if (state.status == ProposalsStatus.failure &&
                  state.proposals.isEmpty)
                AppErrorState(
                  message:
                      state.errorMessage ??
                      'No pudimos consultar las propuestas.',
                  onRetry: () => context.read<ProposalsBloc>().add(
                    const LoadReceivedProposals(),
                  ),
                )
              else if (state.proposals.isEmpty)
                const AppEmptyState(
                  title: 'Aún no has recibido propuestas',
                  message:
                      'Cuando los contratistas envíen sus propuestas para tus proyectos publicados, aparecerán agrupadas aquí.',
                  icon: LucideIcons.fileSpreadsheet,
                )
              else
                for (final entry in grouped.entries) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSectionHeader(
                          title: _projectTitle(state, entry.key),
                          count: entry.value.length,
                          actionLabel: entry.value.length >= 2
                              ? 'Comparar'
                              : null,
                          onAction: entry.value.length >= 2
                              ? () => AppNavigator.push(
                                  context,
                                  ProposalsCompareScreen(
                                    projectId: entry.key,
                                    proposals: entry.value,
                                    projectTitle: _projectTitle(
                                      state,
                                      entry.key,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        for (var i = 0; i < entry.value.length; i++) ...[
                          ProposalCard(
                            proposal: entry.value[i],
                            onTap: () => Navigator.of(context).push(
                              ProposalDetailScreen.route(entry.value[i]),
                            ),
                          ),
                          if (i < entry.value.length - 1)
                            const SizedBox(height: AppSpacing.md),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
            ],
          ),
        );
      },
    );
  }
}
