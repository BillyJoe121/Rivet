import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../../injection_container.dart';
import 'agreements_module.dart';
import 'job_closure_screen.dart';

/// Seguimiento de obra con checklist mutuo e historial de avances (frame 22-145438).
class ProgressTrackingScreen extends StatelessWidget {
  const ProgressTrackingScreen({
    super.key,
    required this.agreementId,
    this.asClient = true,
  });

  final String agreementId;
  final bool asClient;

  static Widget withBloc({
    required String agreementId,
    bool asClient = true,
  }) {
    return BlocProvider<ProgressBloc>(
      create: (_) => sl<ProgressBloc>()..add(LoadProgressRequested(agreementId)),
      child: ProgressTrackingScreen(
        agreementId: agreementId,
        asClient: asClient,
      ),
    );
  }

  static Route<void> route({
    required String agreementId,
    bool asClient = true,
  }) {
    return RivetPageRoute<void>(
      builder: (_) => withBloc(agreementId: agreementId, asClient: asClient),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProgressBloc, ProgressState>(
      listener: (context, state) {
        if (state.status == ProgressStatus.failure &&
            state.agreement != null &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final agreement = state.agreement;

        return RivetScaffold(
          title: 'Seguimiento\nde obra',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.greenery,
          body: AppPageBody(
            footer: agreement == null
                ? null
                : AppButton(
                    text: 'Finalizar proyecto',
                    showChevron: true,
                    onPressed: () async {
                      final allDone = agreement.milestoneItems.isNotEmpty &&
                          agreement.milestoneItems.every((m) => m.isDone);
                      final go = await showFinalizeProjectModal(
                        context,
                        projectTitle: agreement.projectTitle,
                        allMilestonesDone: allDone,
                      );
                      if (go && context.mounted) {
                        await Navigator.of(context).push(
                          JobClosureScreen.route(
                            agreementId: agreement.id,
                            asClient: asClient,
                          ),
                        );
                      }
                    },
                  ),
            onRefresh: () async {
              context.read<ProgressBloc>().add(
                    LoadProgressRequested(agreementId),
                  );
            },
            children: [
              if (state.isLoading && agreement == null)
                const AppLoadingState(label: 'Cargando seguimiento')
              else if (agreement == null)
                AppErrorState(
                  title: state.isSessionExpired
                      ? 'Sesión vencida'
                      : (state.isPermissionDenied
                            ? 'Permiso insuficiente'
                            : 'No pudimos cargar el seguimiento'),
                  message: state.errorMessage ?? 'Intenta nuevamente.',
                  onRetry: () => context.read<ProgressBloc>().add(
                        LoadProgressRequested(agreementId),
                      ),
                )
              else ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBadge(
                        text: '${state.latestPercent}% completado',
                        variant: AppBadgeVariant.brand,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        agreement.projectTitle,
                        style: AppTypography.sectionTitle,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      LinearProgressIndicator(
                        value: state.latestPercent / 100,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                        backgroundColor: AppColors.line300,
                        color: AppColors.brand700,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Checklist mutuo de entrega',
                        style: AppTypography.subheading,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final m in agreement.milestoneItems)
                        AppListTile(
                          title: m.title,
                          subtitle: m.isDone
                              ? 'Confirmado por cliente y contratista'
                              : (m.contractorConfirmedAt != null
                                    ? 'Contratista confirmó · Toca para validar'
                                    : 'Pendiente de confirmación'),
                          leadingIcon: m.isDone
                              ? LucideIcons.circleCheck
                              : LucideIcons.clock,
                          showChevron: false,
                          trailing: asClient
                              ? AppSwitch(
                                  value: m.clientConfirmedAt != null,
                                  onChanged: m.clientConfirmedAt != null
                                      ? null
                                      : (_) => context
                                            .read<ProgressBloc>()
                                            .add(
                                              ConfirmMilestoneRequested(
                                                milestoneId: m.id,
                                                asClient: true,
                                              ),
                                            ),
                                )
                              : null,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSectionHeader(
                        title: 'Bitácora de avances',
                        count: state.updates.length,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (state.updates.isEmpty)
                        const AppEmptyState(
                          title: 'Sin avances registrados aún',
                          message:
                              'Cuando el contratista envíe reportes con fotos, aparecerán aquí.',
                          icon: LucideIcons.camera,
                        )
                      else
                        for (final upd in state.updates)
                          AppListTile(
                            title: '${upd.percent}% · ${upd.description}',
                            subtitle:
                                '${upd.photoPaths.length} foto(s) adjunta(s)',
                            leadingIcon: LucideIcons.checkCheck,
                            showChevron: false,
                          ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
