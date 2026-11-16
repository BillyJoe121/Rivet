import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import 'wizard/presentation/project_wizard_screen.dart';

/// Envoltorio compatible que abre el asistente de proyecto con su Bloc.
class CreateProjectScreen extends StatelessWidget {
  const CreateProjectScreen({super.key, this.initialProject});

  final Project? initialProject;

  /// Ruta del asistente; se resuelve con el proyecto guardado o `null`.
  static Route<Project> route({Project? initialProject}) =>
      ProjectWizardScreen.route(initialProject: initialProject);

  @override
  Widget build(BuildContext context) {
    return ProjectWizardScreen.withBloc(initialProject: initialProject);
  }
}
