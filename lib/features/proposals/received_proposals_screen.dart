import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../agreements/agreements_screens.dart';
import 'presentation/bloc/proposals_bloc.dart';
import 'proposal_detail_screen.dart';
import 'domain/repositories/proposal_repository.dart';
import 'domain/usecases/accept_proposal_usecase.dart';
import 'domain/usecases/get_received_proposals_usecase.dart';
import 'widgets/proposal_card.dart';

/// Propuestas recibidas por el cliente con Clean Architecture y BLoC (P-028).
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
      final existing = context.read<ProposalsBloc>();
      if (existing.state.proposals.isEmpty && !existing.state.isLoading) {
        existing.add(LoadReceivedProposals(projectId: projectId));
      }
      return _ReceivedProposalsView(projectId: projectId);
    } catch (_) {
      return BlocProvider<ProposalsBloc>(
        create: (context) {
          final repository = context.read<ProposalRepository>();
          return ProposalsBloc(
            GetReceivedProposalsUseCase(repository),
            AcceptProposalUseCase(repository),
          )..add(LoadReceivedProposals(projectId: projectId));
        },
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
          title: 'Propuestas\nrecibidas',
          showBackButton: projectId != null || Navigator.of(context).canPop(),
          backgroundImagePath: AppHeroImages.paintRoller,
          body: AppPageBody(
            onRefresh: () async {
              context.read<ProposalsBloc>().add(
                LoadReceivedProposals(projectId: projectId),
              );
            },
            footer: proposals.length >= 2
                ? AppButton(
                    text: 'Comparar propuestas',
                    icon: LucideIcons.columns2,
                    showChevron: true,
                    onPressed: () => AppNavigator.push(
                      context,
                      ProposalsCompareScreen(
                        projectId: projectId ?? proposals.first.projectId,
                        proposals: proposals,
                      ),
                    ),
                  )
                : null,
            children: [
              if (state.isLoading && proposals.isEmpty)
                const AppLoadingState(label: 'Cargando propuestas recibidas')
              else if (state.isFailure && proposals.isEmpty)
                AppErrorState(
                  message: state.errorMessage ??
                      'No pudimos consultar las propuestas recibidas.',
                  onRetry: () => context.read<ProposalsBloc>().add(
                    LoadReceivedProposals(projectId: projectId),
                  ),
                )
              else if (proposals.isEmpty)
                const AppEmptyState(
                  title: 'Aún no tienes propuestas',
                  message:
                      'Cuando un contratista envíe su oferta para tu proyecto, verás su propuesta desglosada aquí.',
                  icon: LucideIcons.fileText,
                )
              else
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSectionHeader(
                        title: 'Propuestas activas',
                        count: proposals.length,
                        actionLabel:
                            proposals.length >= 2 ? 'Comparar' : null,
                        onAction: proposals.length >= 2
                            ? () => AppNavigator.push(
                                context,
                                ProposalsCompareScreen(
                                  projectId:
                                      projectId ?? proposals.first.projectId,
                                  proposals: proposals,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (var i = 0; i < proposals.length; i++) ...[
                        ProposalCard(
                          proposal: proposals[i],
                          onTap: () => AppNavigator.push(
                            context,
                            ProposalDetailScreen(proposal: proposals[i]),
                          ),
                        ),
                        if (i < proposals.length - 1)
                          const SizedBox(height: AppSpacing.md),
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
