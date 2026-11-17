import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import 'agreements_module.dart';

/// Solicitud y resolución de cancelación con reembolso simulado (frame 66-14092).
class CancellationRefundScreen extends StatefulWidget {
  const CancellationRefundScreen({
    super.key,
    required this.agreementId,
  });

  final String agreementId;

  static Widget withBloc({required String agreementId}) {
    return BlocProvider<ClosureBloc>(
      create: (context) =>
          ClosureBloc.fromRepository(context.read<AgreementRepository>())
            ..add(LoadClosureRequested(agreementId)),
      child: CancellationRefundScreen(agreementId: agreementId),
    );
  }

  static Route<void> route({required String agreementId}) {
    return RivetPageRoute<void>(
      builder: (_) => withBloc(agreementId: agreementId),
    );
  }

  @override
  State<CancellationRefundScreen> createState() =>
      _CancellationRefundScreenState();
}

class _CancellationRefundScreenState extends State<CancellationRefundScreen> {
  final _reasonController = TextEditingController();
  final _descController = TextEditingController();
  final List<ProgressPhotoUpload> _photos = [];

  @override
  void dispose() {
    _reasonController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _attachSamplePhoto() {
    setState(() {
      _photos.add(
        ProgressPhotoUpload(
          fileName: 'soporte_${_photos.length + 1}.jpg',
          bytes: Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0]),
        ),
      );
    });
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

        return RivetScaffold(
          title: 'Cancelación\ny reembolso',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.documents,
          body: AppPageBody(
            footer: agreement == null
                ? null
                : AppButton(
                    text: 'Enviar solicitud de cancelación',
                    isLoading: state.isSubmitting,
                    showChevron: true,
                    onPressed: () {
                      context.read<ClosureBloc>().add(
                            RequestCancellationRequested(
                              reason: _reasonController.text,
                              description: _descController.text,
                              photos: List<ProgressPhotoUpload>.unmodifiable(
                                _photos,
                              ),
                            ),
                          );
                    },
                  ),
            children: [
              if (state.isLoading && agreement == null)
                const AppLoadingState(label: 'Cargando solicitudes')
              else if (agreement == null)
                AppErrorState(
                  title: state.isSessionExpired
                      ? 'Sesión vencida'
                      : (state.isPermissionDenied
                            ? 'Permiso insuficiente'
                            : 'No pudimos cargar el acuerdo'),
                  message: state.errorMessage ?? 'Intenta nuevamente.',
                )
              else ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Solicitar cancelación',
                        style: AppTypography.subheading,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _reasonController,
                        label: 'Motivo principal',
                        hint: 'Ej. Cambio de fechas o mutuo acuerdo',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _descController,
                        label: 'Detalle de la solicitud',
                        hint: 'Explica el estado actual de la obra y el saldo',
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        text: 'Adjuntar foto de soporte (${_photos.length})',
                        variant: AppButtonVariant.outline,
                        onPressed: _attachSamplePhoto,
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
                        title: 'Historial de solicitudes',
                        count: state.cancellations.length,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (state.cancellations.isEmpty)
                        const AppEmptyState(
                          title: 'Sin solicitudes registradas',
                          message:
                              'Si alguna parte solicita cancelar el acuerdo, aparecerá aquí para su resolución.',
                          icon: LucideIcons.circleAlert,
                        )
                      else
                        for (final c in state.cancellations)
                          AppListTile(
                            title: '${c.reason} · ${c.status.label}',
                            subtitle: c.description.isEmpty
                                ? '${c.photoPaths.length} foto(s) de soporte'
                                : c.description,
                            leadingIcon: LucideIcons.fileText,
                            showChevron: false,
                            trailing: c.status == CancellationStatus.requested
                                ? TextButton(
                                    onPressed: state.isSubmitting
                                        ? null
                                        : () => context
                                              .read<ClosureBloc>()
                                              .add(
                                                ResolveCancellationRequested(
                                                  cancellationId: c.id,
                                                  approved: true,
                                                ),
                                              ),
                                    child: const Text('Aprobar'),
                                  )
                                : null,
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
