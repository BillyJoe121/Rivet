import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../../injection_container.dart';
import 'agreements_module.dart';
import 'cancellation_refund_screen.dart';
import 'payment_received_screen.dart';

/// Modal de confirmación para finalizar proyecto (frame 2006-5).
Future<bool> showFinalizeProjectModal(
  BuildContext context, {
  required String projectTitle,
  required bool allMilestonesDone,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogCtx) {
      return AlertDialog(
        backgroundColor: AppColors.surface0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Finalizar proyecto', style: AppTypography.sectionTitle),
        content: Text(
          allMilestonesDone
              ? 'Todos los hitos de "$projectTitle" están confirmados. ¿Deseas pasar al cierre y calificación mutua?'
              : 'Aún hay hitos pendientes por confirmar en "$projectTitle". Puedes revisarlos en el seguimiento antes de cerrar.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Seguir revisando'),
          ),
          ElevatedButton(
            onPressed: allMilestonesDone
                ? () => Navigator.of(dialogCtx).pop(true)
                : null,
            child: const Text('Ir al cierre'),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

/// Pantalla de cierre de obra con confirmación mutua y calificación (frame 22-145526).
class JobClosureScreen extends StatefulWidget {
  const JobClosureScreen({
    super.key,
    required this.agreementId,
    this.asClient = true,
  });

  final String agreementId;
  final bool asClient;

  static Widget withBloc({required String agreementId, bool asClient = true}) {
    return BlocProvider<ClosureBloc>(
      create: (_) => sl<ClosureBloc>()..add(LoadClosureRequested(agreementId)),
      child: JobClosureScreen(agreementId: agreementId, asClient: asClient),
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
  State<JobClosureScreen> createState() => _JobClosureScreenState();
}

class _JobClosureScreenState extends State<JobClosureScreen> {
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClosureBloc, ClosureState>(
      listener: (context, state) {
        if (state.actionMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.actionMessage!)));
        } else if (state.status == ClosureStatus.failure &&
            state.agreement != null &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final agreement = state.agreement;
        final isCompleted = agreement?.status == AgreementStatus.completed;

        return RivetScaffold(
          title: 'Cierre\nde obra',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.lounge,
          body: AppPageBody(
            footer: agreement == null
                ? null
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isCompleted)
                        AppButton(
                          text: 'Confirmar cierre del acuerdo',
                          isLoading: state.isSubmitting,
                          showChevron: true,
                          onPressed: () {
                            context.read<ClosureBloc>().add(
                              const CompleteAgreementRequested(),
                            );
                          },
                        )
                      else
                        AppButton(
                          text: 'Ver pago recibido',
                          showChevron: true,
                          onPressed: () => Navigator.of(context).push(
                            PaymentReceivedScreen.route(
                              agreementId: widget.agreementId,
                            ),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        text: 'Solicitar cancelación o reembolso',
                        variant: AppButtonVariant.outline,
                        onPressed: () => Navigator.of(context).push(
                          CancellationRefundScreen.route(
                            agreementId: widget.agreementId,
                          ),
                        ),
                      ),
                    ],
                  ),
            children: [
              if (state.isLoading && agreement == null)
                const AppLoadingState(label: 'Cargando cierre del acuerdo')
              else if (agreement == null)
                AppErrorState(
                  title: state.isSessionExpired
                      ? 'Sesión vencida'
                      : (state.isPermissionDenied
                            ? 'Permiso insuficiente'
                            : 'No pudimos cargar el cierre'),
                  message: state.errorMessage ?? 'Intenta nuevamente.',
                  onRetry: () => context.read<ClosureBloc>().add(
                    LoadClosureRequested(widget.agreementId),
                  ),
                )
              else ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBadge(
                        text: agreement.status.label,
                        variant: isCompleted
                            ? AppBadgeVariant.brand
                            : AppBadgeVariant.warning,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        agreement.projectTitle,
                        style: AppTypography.sectionTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.asClient
                            ? 'Contratista: ${agreement.contractorName}'
                            : 'Cliente: ${agreement.clientName.isEmpty ? 'Propietario' : agreement.clientName}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Calificación mutua',
                            style: AppTypography.subheading,
                          ),
                          AppBadge(
                            text: '${state.selectedStars} / 5',
                            variant: AppBadgeVariant.brand,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 1; i <= 5; i++)
                            IconButton(
                              onPressed: () => context.read<ClosureBloc>().add(
                                ClosureStarsChanged(i),
                              ),
                              icon: Icon(
                                LucideIcons.star,
                                color: i <= state.selectedStars
                                    ? AppColors.brand700
                                    : AppColors.line300,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppTextField(
                        controller: _reviewController,
                        label: 'Comentario sobre el trabajo',
                        hint: 'Puntualidad, acabados y comunicación',
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        text: 'Enviar calificación',
                        variant: AppButtonVariant.outline,
                        isLoading: state.isSubmitting,
                        onPressed: () {
                          final rateeId = widget.asClient
                              ? agreement.contractorId
                              : agreement.clientId;
                          context.read<ClosureBloc>().add(
                            SubmitRatingRequested(
                              rateeId: rateeId,
                              stars: state.selectedStars,
                              review: _reviewController.text,
                            ),
                          );
                        },
                      ),
                      if (state.ratings.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        for (final r in state.ratings)
                          AppListTile(
                            title: '${r.stars} estrellas',
                            subtitle: r.review.isEmpty
                                ? 'Sin comentario adicional'
                                : r.review,
                            leadingIcon: LucideIcons.star,
                            showChevron: false,
                          ),
                      ],
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
