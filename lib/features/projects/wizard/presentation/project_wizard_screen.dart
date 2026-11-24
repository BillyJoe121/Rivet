import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/models/models.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/usecases/usecases.dart';
import '../domain/estimate_materials_usecase.dart';
import '../domain/project_draft_repository.dart';
import '../domain/publish_project_wizard_usecase.dart';
import 'bloc/project_wizard_bloc.dart';
import 'widgets/wizard_steps_early.dart';
import 'widgets/wizard_steps_late.dart';

/// Asistente de 5 pasos para crear o editar un proyecto (Datos, Medidas, Fotos, Materiales, Publicar).
///
/// Espera un [ProjectWizardBloc] en el contexto; [route] y [withBloc] lo
/// arman con los repositorios inyectados. Al publicar cierra la pantalla y
/// devuelve el [Project] guardado.
class ProjectWizardScreen extends StatefulWidget {
  const ProjectWizardScreen({super.key});

  /// Pantalla con su [ProjectWizardBloc] listo, para crear o editar.
  static Widget withBloc({Project? initialProject}) {
    return BlocProvider<ProjectWizardBloc>(
      create: (context) => resolveBloc<ProjectWizardBloc>(() {
        final draftRepository = context.read<ProjectDraftRepository>();
        final projectRepository = context.read<ProjectRepository>();
        return ProjectWizardBloc(
          draftRepository: draftRepository,
          estimateMaterialsUseCase: const EstimateMaterialsUseCase(),
          publishProjectWizardUseCase: PublishProjectWizardUseCase(
            createProjectUseCase: CreateProjectUseCase(projectRepository),
            updateProjectUseCase: UpdateProjectUseCase(projectRepository),
            draftRepository: draftRepository,
          ),
        );
      })..add(WizardInitialized(initialProject: initialProject)),
      child: const ProjectWizardScreen(),
    );
  }

  /// Ruta del asistente; se resuelve con el proyecto guardado o `null`.
  static Route<Project> route({Project? initialProject}) {
    return RivetPageRoute<Project>(
      builder: (_) => withBloc(initialProject: initialProject),
    );
  }

  @override
  State<ProjectWizardScreen> createState() => _ProjectWizardScreenState();
}

class _ProjectWizardScreenState extends State<ProjectWizardScreen> {
  Timer? _errorTimer;

  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProjectWizardBloc, ProjectWizardState>(
          listenWhen: (previous, current) =>
              current.errorMessage != null &&
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            _errorTimer?.cancel();
            _errorTimer = Timer(const Duration(seconds: 5), () {
              if (mounted) {
                context.read<ProjectWizardBloc>().add(
                  const WizardErrorDismissed(),
                );
              }
            });
          },
        ),
        BlocListener<ProjectWizardBloc, ProjectWizardState>(
          listenWhen: (previous, current) =>
              current.publishedProject != null &&
              previous.publishedProject != current.publishedProject,
          listener: (context, state) {
            Navigator.of(context).pop(state.publishedProject);
          },
        ),
      ],
      child: BlocBuilder<ProjectWizardBloc, ProjectWizardState>(
        builder: (context, state) {
          final draft = state.draft;
          final currentStep = draft.currentStep.clamp(
            0,
            ProjectWizardState.stepLabels.length - 1,
          );
          final isLastStep =
              currentStep == ProjectWizardState.stepLabels.length - 1;

          return RivetScaffold(
            title: draft.isEditing ? 'Editar\nproyecto' : 'Crear\nproyecto',
            showBackButton: true,
            backgroundImagePath: AppHeroImages.planning,
            onBack: () {
              if (currentStep > 0) {
                context.read<ProjectWizardBloc>().add(
                  const WizardPreviousStepRequested(),
                );
              } else {
                Navigator.of(context).maybePop();
              }
            },
            body: AppPageBody(
              footer: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isLastStep)
                    Row(
                      children: [
                        if (currentStep > 0) ...[
                          Expanded(
                            child: AppButton(
                              text: 'Anterior',
                              variant: AppButtonVariant.outline,
                              onPressed: () {
                                context.read<ProjectWizardBloc>().add(
                                  const WizardPreviousStepRequested(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Expanded(
                          child: AppButton(
                            text: 'Siguiente paso',
                            showChevron: true,
                            onPressed: () {
                              context.read<ProjectWizardBloc>().add(
                                const WizardNextStepRequested(),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Anterior',
                            variant: AppButtonVariant.outline,
                            onPressed: () {
                              context.read<ProjectWizardBloc>().add(
                                const WizardPreviousStepRequested(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          flex: 2,
                          child: AppButton(
                            text: draft.isEditing
                                ? 'Guardar cambios'
                                : 'Publicar proyecto',
                            isLoading: state.isPublishing,
                            showChevron: true,
                            onPressed: () {
                              context.read<ProjectWizardBloc>().add(
                                const WizardPublishRequested(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              children: [
                AppStepProgress(
                  steps: ProjectWizardState.stepLabels,
                  currentStep: currentStep,
                  onStepTap: (target) {
                    context.read<ProjectWizardBloc>().add(
                      WizardStepChangeRequested(target),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                if (state.errorMessage != null) ...[
                  AppInfoBanner(
                    message: state.errorMessage!,
                    variant: AppInfoBannerVariant.danger,
                    icon: LucideIcons.circleAlert,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                _buildStepContent(currentStep, draft),
                SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepContent(int step, draft) {
    return switch (step) {
      0 => WizardStepBasics(draft: draft),
      1 => WizardStepSurfaces(draft: draft),
      2 => WizardStepPhotos(draft: draft),
      3 => WizardStepMaterials(draft: draft),
      4 => WizardStepBudget(draft: draft),
      _ => WizardStepPublish(draft: draft),
    };
  }
}
