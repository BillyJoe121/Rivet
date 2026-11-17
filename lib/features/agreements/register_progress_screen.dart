import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
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
      create: (context) =>
          ProgressBloc.fromRepository(context.read<AgreementRepository>())
            ..add(LoadProgressRequested(agreementId)),
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
  double _percent = 35;
  String? _selectedMilestoneId;
  final List<ProgressPhotoUpload> _photos = [];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _attachSamplePhoto() {
    setState(() {
      _photos.add(
        ProgressPhotoUpload(
          fileName: 'avance_${_photos.length + 1}.jpg',
          bytes: Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0]),
        ),
      );
    });
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
          backgroundImagePath: AppHeroImages.documents,
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
                              milestoneId: _selectedMilestoneId,
                              percent: _percent.round(),
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
                      Text(
                        'Porcentaje acumulado: ${_percent.round()}%',
                        style: AppTypography.subheading,
                      ),
                      Slider(
                        value: _percent,
                        min: 0,
                        max: 100,
                        divisions: 20,
                        activeColor: AppColors.brand700,
                        label: '${_percent.round()}%',
                        onChanged: (v) => setState(() => _percent = v),
                      ),
                      const SizedBox(height: AppSpacing.sm),
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
                      Text(
                        'Checklist mutuo de hitos',
                        style: AppTypography.subheading,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final m in agreement.milestoneItems)
                        AppListTile(
                          title: m.title,
                          subtitle: m.isDone
                              ? 'Confirmado por ambas partes'
                              : (m.contractorConfirmedAt != null
                                    ? 'Confirmado por ti · Falta cliente'
                                    : 'Toca para confirmar tu avance'),
                          leadingIcon: m.isDone
                              ? LucideIcons.circleCheck
                              : LucideIcons.circle,
                          showChevron: false,
                          trailing: Checkbox(
                            value: m.contractorConfirmedAt != null,
                            activeColor: AppColors.brand700,
                            onChanged: m.contractorConfirmedAt != null
                                ? null
                                : (_) {
                                    setState(() => _selectedMilestoneId = m.id);
                                    context.read<ProgressBloc>().add(
                                          ConfirmMilestoneRequested(
                                            milestoneId: m.id,
                                            asClient: false,
                                          ),
                                        );
                                  },
                          ),
                          onTap: () => setState(() => _selectedMilestoneId = m.id),
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
                        count: _photos.length,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        text: 'Adjuntar foto de evidencia',
                        variant: AppButtonVariant.outline,
                        onPressed: _attachSamplePhoto,
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
