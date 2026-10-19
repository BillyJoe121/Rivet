import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

/// Paso 3: Carga de fotos y política de minimización/privacidad con IA (P-011).
class PhotosPrivacyStep extends StatelessWidget {
  const PhotosPrivacyStep({
    super.key,
    required this.aiMinimizationAccepted,
    required this.noPrivateDataConfirmed,
    required this.onAiMinimizationChanged,
    required this.onNoPrivateDataChanged,
  });

  final bool aiMinimizationAccepted;
  final bool noPrivateDataConfirmed;
  final ValueChanged<bool> onAiMinimizationChanged;
  final ValueChanged<bool> onNoPrivateDataChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fotos y Autorización de IA (P-011)', style: AppTypography.subheading.copyWith(fontSize: 18)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Para proteger tu intimidad, las fotos se procesan para difuminar personas, cuadros y objetos personales antes de ser visibles para los pintores.',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: AppSpacing.lg),

        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    'Fondos/Sala minimalista con plantas y luz suave.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(color: AppColors.brandLight),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.brand700, size: 18),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Foto minimizada: objetos personales ocultos, textura de pared resaltada para cotización.',
                        style: TextStyle(fontSize: 12, color: AppColors.ink700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        CheckboxListTile(
          value: aiMinimizationAccepted,
          onChanged: (val) => onAiMinimizationChanged(val ?? false),
          title: Text('Autorizo el procesamiento de IA para ocultar elementos privados', style: AppTypography.bodySmall),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.brand700,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          value: noPrivateDataConfirmed,
          onChanged: (val) => onNoPrivateDataChanged(val ?? false),
          title: Text('Confirmo que la foto no contiene documentos ni datos sensibles', style: AppTypography.bodySmall),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.brand700,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
