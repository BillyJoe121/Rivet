import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import 'presentation/bloc/projects_bloc.dart';
import 'wizard/presentation/project_wizard_screen.dart';

/// Envoltorio compatible que delega en el asistente de 8 pasos (P-008..P-015).
class CreateProjectScreen extends StatelessWidget {
  const CreateProjectScreen({
    super.key,
    this.projectsBloc,
    this.initialProject,
  });

  final ProjectsBloc? projectsBloc;
  final Project? initialProject;

  @override
  Widget build(BuildContext context) {
    return ProjectWizardScreen(
      projectsBloc: projectsBloc,
      initialProject: initialProject,
    );
  }
}
