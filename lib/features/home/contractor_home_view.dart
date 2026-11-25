import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/design_system/design_system.dart';
import '../../core/models/models.dart';
import '../../injection_container.dart';
import '../agreements/agreements_screens.dart';
import '../auth/domain/entities/rivet_user.dart';
import '../auth/presentation/bloc/auth/auth_bloc.dart';
import '../messaging/client_notifications_screen.dart';
import '../projects/contractor/contractor_project_detail_screen.dart';
import '../projects/contractor/open_projects_screen.dart';
import '../proposals/contractor/my_proposals_jobs_screen.dart';
import 'contractor_home_bloc.dart';
import 'widgets/pro_home_cards.dart';

/// Inicio del contratista con datos reales (22:145582).
class ContractorHomeView extends StatelessWidget {
  const ContractorHomeView({
    super.key,
    required this.onSwitchRole,
    this.onOpenProjects,
    this.onOpenProposals,
    this.onOpenMessages,
  });

  final ValueChanged<UserRole> onSwitchRole;
  final VoidCallback? onOpenProjects;
  final VoidCallback? onOpenProposals;
  final VoidCallback? onOpenMessages;

  static Widget withBloc({
    required ValueChanged<UserRole> onSwitchRole,
    VoidCallback? onOpenProjects,
    VoidCallback? onOpenProposals,
    VoidCallback? onOpenMessages,
  }) {
    return BlocProvider<ContractorHomeBloc>(
      create: (_) => sl<ContractorHomeBloc>()..add(const LoadContractorHome()),
      child: ContractorHomeView(
        onSwitchRole: onSwitchRole,
        onOpenProjects: onOpenProjects,
        onOpenProposals: onOpenProposals,
        onOpenMessages: onOpenMessages,
      ),
    );
  }

  static String _firstNameOf(RivetUser? user) {
    final first = user?.fullName.trim().split(' ').first ?? '';
    return first.isEmpty ? '' : first[0].toUpperCase() + first.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    final name = _firstNameOf(user);

    return BlocBuilder<ContractorHomeBloc, ContractorHomeState>(
      builder: (context, state) {
        final featured = state.featuredProject;
        final active = state.activeProposal;

        return RivetScaffold(
          showBackButton: false,
          showWordmark: true,
          title: name.isEmpty ? 'Hola' : 'Hola, $name',
          backgroundImagePath: AppImages.headerBotanical,
          actions: [
            AppNotificationButton(
              onPressed: () => Navigator.of(context).push(
                ClientNotificationsScreen.route(),
              ),
            ),
          ],
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                if (state.isLoading && state.openProjects.isEmpty)
                  const AppLoadingState(label: 'Cargando tu resumen')
                else if (state.isFailure && state.openProjects.isEmpty)
                  AppErrorState(
                    message:
                        state.errorMessage ??
                        'No pudimos cargar tu resumen.',
                    onRetry: () => context.read<ContractorHomeBloc>().add(
                      const LoadContractorHome(),
                    ),
                  )
                else ...[
                  if (featured != null)
                    ProFeaturedProjectCard(
                      project: ProProjectSummary(
                        title: featured.title,
                        category:
                            '${featured.totalAreaM2.toStringAsFixed(0)} m² · ${featured.surfaces.length} muros',
                        location:
                            '${featured.city}, ${featured.neighborhood}',
                        image: AppImages.proKitchen,
                        badge: 'Nuevo',
                      ),
                      onTap: () => Navigator.of(context).push(
                        ContractorProjectDetailScreen.route(featured),
                      ),
                    ),
                  AppSectionHeader(
                    title: 'Mi trabajo en curso',
                    actionLabel: 'Ver todos',
                    onAction:
                        onOpenProposals ??
                        () => Navigator.of(context).push(
                          MyProposalsJobsScreen.route(initialTab: 1),
                        ),
                  ),
                  if (active != null)
                    ProProjectCard(
                      project: ProProjectSummary(
                        title: state.activeProject?.title ??
                            state.activeAgreement?.projectTitle ??
                            'Obra en ejecución',
                        category: '${active.estimatedDays} días hábiles',
                        location: state.activeAgreement?.status.label ??
                            'Propuesta aceptada',
                        image: AppImages.proKitchen,
                        stagesDone: state.activeStagesDone,
                        stagesTotal: state.activeStagesTotal > 0
                            ? state.activeStagesTotal
                            : 3,
                        progress: state.activeProgress,
                      ),
                      onTap: () {
                        final agr = state.activeAgreement;
                        if (agr != null) {
                          Navigator.of(context).push(
                            AgreementSummaryScreen.routeForAgreement(
                              agreementId: agr.id,
                              asClient: false,
                            ),
                          );
                        } else if (onOpenProposals != null) {
                          onOpenProposals!();
                        } else {
                          Navigator.of(context).push(
                            MyProposalsJobsScreen.route(initialTab: 1),
                          );
                        }
                      },
                    )
                  else
                    const AppEmptyState(
                      title: 'Sin trabajos activos aún',
                      message:
                          'Envía una propuesta a un proyecto abierto para iniciar tu primera obra.',
                      icon: LucideIcons.briefcaseBusiness,
                    ),
                  AppSectionHeader(
                    title: 'Actividad reciente',
                    actionLabel: 'Ver todos',
                    onAction:
                        onOpenProjects ??
                        () => Navigator.of(context).push(
                          OpenProjectsScreen.route(),
                        ),
                  ),
                  ProActivityCard(
                    items: [
                      ProActivity(
                        LucideIcons.search,
                        '${state.openProjects.length} proyectos disponibles',
                        'Listos para cotizar',
                      ),
                      ProActivity(
                        LucideIcons.fileText,
                        '${state.pendingProposalsCount} propuestas pendientes',
                        'Esperando respuesta',
                      ),
                    ],
                    onTap: (item) {
                      if (item.icon == LucideIcons.search) {
                        (onOpenProjects ??
                            () => Navigator.of(context).push(
                              OpenProjectsScreen.route(),
                            ))();
                      } else {
                        (onOpenProposals ??
                            () => Navigator.of(context).push(
                              MyProposalsJobsScreen.route(),
                            ))();
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
