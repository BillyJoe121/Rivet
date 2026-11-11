import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/models/models.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../presentation/bloc/projects_bloc.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/usecases/usecases.dart';
import '../domain/estimate_materials_usecase.dart';
import '../domain/project_draft_repository.dart';
import '../domain/publish_project_wizard_usecase.dart';
import 'bloc/project_wizard_bloc.dart';
import 'widgets/wizard_steps_early.dart';
import 'widgets/wizard_steps_late.dart';

/// Asistente de 5 pasos para crear o editar un proyecto (Datos, Medidas, Fotos, Materiales, Publicar).
class ProjectWizardScreen extends StatefulWidget {
  const ProjectWizardScreen({
    super.key,
    this.initialProject,
    this.projectsBloc,
    this.wizardBloc,
    this.draftRepository,
  });

  final Project? initialProject;
  final ProjectsBloc? projectsBloc;
  final ProjectWizardBloc? wizardBloc;
  final ProjectDraftRepository? draftRepository;

  @override
  State<ProjectWizardScreen> createState() => _ProjectWizardScreenState();
}

class _ProjectWizardScreenState extends State<ProjectWizardScreen> {
  ProjectWizardBloc? _ownedWizardBloc;
  Timer? _errorTimer;

  ProjectsBloc? _resolveProjectsBloc(BuildContext context) {
    if (widget.projectsBloc != null) return widget.projectsBloc;
    try {
      return context.read<ProjectsBloc>();
    } catch (_) {
      return null;
    }
  }

  ProjectWizardBloc _resolveWizardBloc() {
    if (widget.wizardBloc != null) return widget.wizardBloc!;
    if (_ownedWizardBloc != null) return _ownedWizardBloc!;

    final draftRepo =
        widget.draftRepository ?? context.read<ProjectDraftRepository>();
    final projectRepository = context.read<ProjectRepository>();
    final bloc = ProjectWizardBloc(
      draftRepository: draftRepo,
      estimateMaterialsUseCase: const EstimateMaterialsUseCase(),
      publishProjectWizardUseCase: PublishProjectWizardUseCase(
        createProjectUseCase: CreateProjectUseCase(projectRepository),
        updateProjectUseCase: UpdateProjectUseCase(projectRepository),
        draftRepository: draftRepo,
      ),
    )..add(WizardInitialized(initialProject: widget.initialProject));

    _ownedWizardBloc = bloc;
    return bloc;
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    _ownedWizardBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wizardBloc = _resolveWizardBloc();

    return BlocProvider<ProjectWizardBloc>.value(
      value: wizardBloc,
      child: BlocConsumer<ProjectWizardBloc, ProjectWizardState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            _errorTimer?.cancel();
            _errorTimer = Timer(const Duration(seconds: 5), () {
              if (mounted) {
                context.read<ProjectWizardBloc>().add(
                  const WizardErrorDismissed(),
                );
              }
            });
          }

          if (state.isPublished && state.publishedProject != null) {
            final saved = state.publishedProject!;
            final projectsBloc = _resolveProjectsBloc(context);
            projectsBloc?.add(UpdateProjectSubmitted(saved));
            if (mounted) {
              Navigator.of(context).pop(saved);
            }
          }
        },
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
