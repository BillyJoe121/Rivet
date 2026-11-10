import '../../../../../core/models/models.dart';

sealed class ProjectWizardEvent {
  const ProjectWizardEvent();
}

final class WizardInitialized extends ProjectWizardEvent {
  const WizardInitialized({this.initialProject});
  final Project? initialProject;
}

final class WizardBasicsChanged extends ProjectWizardEvent {
  const WizardBasicsChanged({
    this.title,
    this.description,
    this.city,
    this.neighborhood,
    this.materialsBudgetCop,
    this.laborBudgetCop,
    this.budgetEstimateCop,
  });

  final String? title;
  final String? description;
  final String? city;
  final String? neighborhood;
  final int? materialsBudgetCop;
  final int? laborBudgetCop;
  final int? budgetEstimateCop;
}

final class WizardSurfaceAdded extends ProjectWizardEvent {
  const WizardSurfaceAdded({
    required this.name,
    required this.widthMeters,
    required this.heightMeters,
    this.finishType = 'Vinilo Tipo 1',
  });

  final String name;
  final double widthMeters;
  final double heightMeters;
  final String finishType;
}

final class WizardSurfaceRemoved extends ProjectWizardEvent {
  const WizardSurfaceRemoved(this.index);
  final int index;
}

final class WizardPhotoAdded extends ProjectWizardEvent {
  const WizardPhotoAdded(this.photoPath);
  final String photoPath;
}

final class WizardPhotoRemoved extends ProjectWizardEvent {
  const WizardPhotoRemoved(this.index);
  final int index;
}

final class WizardPhotoToggled extends ProjectWizardEvent {
  const WizardPhotoToggled(this.assetPath);
  final String assetPath;
}

final class WizardAiConsentChanged extends ProjectWizardEvent {
  const WizardAiConsentChanged(this.authorized);
  final bool authorized;
}

final class WizardMaterialQuantityChanged extends ProjectWizardEvent {
  const WizardMaterialQuantityChanged({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final int quantity;
}

final class WizardStepChangeRequested extends ProjectWizardEvent {
  const WizardStepChangeRequested(this.targetStep);
  final int targetStep;
}

final class WizardNextStepRequested extends ProjectWizardEvent {
  const WizardNextStepRequested();
}

final class WizardPreviousStepRequested extends ProjectWizardEvent {
  const WizardPreviousStepRequested();
}

final class WizardPublishRequested extends ProjectWizardEvent {
  const WizardPublishRequested();
}

final class WizardErrorDismissed extends ProjectWizardEvent {
  const WizardErrorDismissed();
}
