import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../agreements/agreements_screens.dart';
import '../projects/presentation/bloc/projects_bloc.dart';
import 'presentation/bloc/proposals_bloc.dart';
import 'proposal_detail_screen.dart';
import 'domain/repositories/proposal_repository.dart';
import 'domain/usecases/accept_proposal_usecase.dart';
import 'domain/usecases/get_received_proposals_usecase.dart';
import 'widgets/proposal_card.dart';

/// Destino global "Cotizaciones" del menú Más: agrupa cotizaciones por proyecto.
class AllProposalsScreen extends StatefulWidget {
  const AllProposalsScreen({super.key, this.proposalsBloc});

  final ProposalsBloc? proposalsBloc;

  @override
  State<AllProposalsScreen> createState() => _AllProposalsScreenState();
}

class _AllProposalsScreenState extends State<AllProposalsScreen> {
  ProposalsBloc? _localBloc;

  ProposalsBloc _resolveBloc(BuildContext context) {
    if (widget.proposalsBloc != null) return widget.proposalsBloc!;
    try {
      return context.read<ProposalsBloc>();
    } catch (_) {
      final repository = context.read<ProposalRepository>();
      return _localBloc ??= ProposalsBloc(
        GetReceivedProposalsUseCase(repository),
        AcceptProposalUseCase(repository),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = _resolveBloc(context);
    if (bloc.state.proposals.isEmpty && !bloc.state.isLoading) {
      bloc.add(const LoadReceivedProposals());
    }
  }

  @override
  void dispose() {
    _localBloc?.close();
    super.dispose();
  }

  String _projectTitle(BuildContext context, String projectId) {
    try {
      final projects = context.read<ProjectsBloc>().state.projects;
      for (final p in projects) {
        if (p.id == projectId) return p.title;
      }
    } catch (_) {}
    return 'Pintura sala y comedor en Ciudad Jardín';
  }

  @override
  Widget build(BuildContext context) {
    final bloc = _resolveBloc(context);
    return BlocProvider<ProposalsBloc>.value(
      value: bloc,
      child: BlocBuilder<ProposalsBloc, ProposalsState>(
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
                            title: _projectTitle(context, entry.key),
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
                                        context,
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
                              onTap: () => AppNavigator.push(
                                context,
                                ProposalDetailScreen(proposal: entry.value[i]),
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
      ),
    );
  }
}
