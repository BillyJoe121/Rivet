import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../../injection_container.dart';
import 'agreements_module.dart';

/// Registro de avance de obra del contratista con checklist mutuo y fotos (frame 66:14265).
class RegisterProgressScreen extends StatefulWidget {
  const RegisterProgressScreen({
    super.key,
    required this.agreementId,
  });

  final String agreementId;

  static Widget withBloc({required String agreementId}) {
    return BlocProvider<ProgressBloc>(
      create: (_) => sl<ProgressBloc>()..add(LoadProgressRequested(agreementId)),
      child: RegisterProgressScreen(agreementId: agreementId),
    );
  }

  static Route<void> route({required String agreementId}) {
    return RivetPageRoute<void>(
      builder: (_) => withBloc(agreementId: agreementId),
    );
  }

  @override
  State<RegisterProgressScreen> createState() => _RegisterProgressScreenState();
}

class _RegisterProgressScreenState extends State<RegisterProgressScreen> {
  final _descController = TextEditingController();

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProgressBloc, ProgressState>(
      listener: (context, state) {
        if (state.submittedSuccessfully) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Avance registrado correctamente en la obra.'),
              ),
            );
          Navigator.of(context).pop();
        } else if (state.status == ProgressStatus.failure &&
            state.errorMessage != null &&
            state.agreement != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final agreement = state.agreement;

        return RivetScaffold(
          title: 'Registrar\navance',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.paintRoller,
          body: AppPageBody(
            footer: agreement == null
                ? null
                : AppButton(
                    text: 'Enviar avance al cliente',
                    isLoading: state.isSubmitting,
                    showChevron: true,
                    onPressed: () {
                      context.read<ProgressBloc>().add(
                            SubmitProgressUpdateRequested(
                              agreementId: widget.agreementId,
                              milestoneId: state.selectedMilestoneId,
                              percent: state.draftPercent,
                              description: _descController.text,
                              photos: state.draftPhotos,
                            ),
                          );
                    },
                  ),
            children: [
              if (state.isLoading && agreement == null)
                const AppLoadingState(label: 'Cargando checklist del acuerdo')
              else if (agreement == null)
                AppErrorState(
                  title: state.isSessionExpired
                      ? 'Sesión vencida'
                      : (state.isPermissionDenied
                            ? 'Permiso insuficiente'
                            : 'No pudimos cargar la obra'),
                  message: state.errorMessage ?? 'Intenta nuevamente.',
                  onRetry: () => context.read<ProgressBloc>().add(
                        LoadProgressRequested(widget.agreementId),
                      ),
                )
              else ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agreement.projectTitle,
                        style: AppTypography.sectionTitle,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Porcentaje acumulado',
                            style: AppTypography.subheading,
                          ),
                          AppBadge(
                            text: '${state.draftPercent}%',
                            variant: AppBadgeVariant.brand,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppSegmentedControl<int>(
                        items: const {
                          25: '25%',
                          50: '50%',
                          75: '75%',
                          100: '100%',
                        },
                        selected: state.draftPercent <= 25
                            ? 25
                            : (state.draftPercent <= 50
                                  ? 50
                                  : (state.draftPercent <= 75 ? 75 : 100)),
                        onChanged: (v) => context.read<ProgressBloc>().add(
                              ProgressPercentChanged(v),
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _descController,
                        label: 'Descripción del avance',
                        hint: 'Qué superficies se trabajaron hoy y detalles clave',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeader(title: 'Checklist mutuo de hitos'),
                      const SizedBox(height: AppSpacing.sm),
                      for (final m in agreement.milestoneItems)
                        AppListTile(
                          title: m.title,
                          subtitle: m.isDone
                              ? 'Confirmado por ambas partes'
                              : (m.contractorConfirmedAt != null
                                    ? 'Confirmado por ti · Falta cliente'
                                    : 'Activa para confirmar tu avance'),
                          leadingIcon: m.isDone
                              ? LucideIcons.circleCheck
                              : LucideIcons.circle,
                          showChevron: false,
                          trailing: AppSwitch(
                            value: m.contractorConfirmedAt != null,
                            onChanged: m.contractorConfirmedAt != null
                                ? null
                                : (_) {
                                    context.read<ProgressBloc>()
                                      ..add(ProgressMilestoneSelected(m.id))
                                      ..add(
                                        ConfirmMilestoneRequested(
                                          milestoneId: m.id,
                                          asClient: false,
                                        ),
                                      );
                                  },
                          ),
                          onTap: () => context.read<ProgressBloc>().add(
                                ProgressMilestoneSelected(m.id),
                              ),
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
                        title: 'Evidencia fotográfica',
                        count: state.draftPhotos.length,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        text: 'Adjuntar foto de evidencia',
                        variant: AppButtonVariant.outline,
                        onPressed: () {
                          context.read<ProgressBloc>().add(
                                ProgressPhotoAdded(
                                  ProgressPhotoUpload(
                                    fileName:
                                        'avance_${state.draftPhotos.length + 1}.jpg',
                                    bytes: Uint8List.fromList(
                                      [0xFF, 0xD8, 0xFF, 0xE0],
                                    ),
                                  ),
                                ),
                              );
                        },
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
