import 'package:flutter/material.dart';
import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

/// Paso 4: Dossier final y revisión de la solicitud antes de publicar (P-015).
class ProjectReviewStep extends StatelessWidget {
  const ProjectReviewStep({
    super.key,
    required this.title,
    required this.city,
    required this.neighborhood,
    required this.surfaces,
    required this.totalArea,
  });

  final String title;
  final String city;
  final String neighborhood;
  final List<SurfaceItem> surfaces;
  final double totalArea;

  @override
  Widget build(BuildContext context) {
    final estimatedPaintGallons = (totalArea / 25.0).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dossier y Revisión Final (P-015)', style: AppTypography.subheading.copyWith(fontSize: 18)),
        const SizedBox(height: AppSpacing.xs),
        Text('Revisa cómo verán los contratistas tu solicitud.', style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.lg),

        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.subheading),
              Text('$city · $neighborhood', style: AppTypography.caption),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppStatTile(
                      label: 'ÁREA TOTAL',
                      value: '${totalArea.toStringAsFixed(1)} m²',
                      icon: Icons.square_foot,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppStatTile(
                      label: 'PINTURA SUGERIDA',
                      value: '$estimatedPaintGallons Galones',
                      icon: Icons.format_paint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Superficies incluidas (${surfaces.length}):',
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              ...surfaces.map((s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('• ${s.name} (${s.areaM2.toStringAsFixed(1)} m²)', style: AppTypography.bodySmall),
                  )),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
        const AppCard(
          backgroundColor: AppColors.brandLight,
          child: Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppColors.brand700),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Publicar no tiene costo. Los pintores te enviarán propuestas separando mano de obra de insumos.',
                  style: TextStyle(fontSize: 13, color: AppColors.brand700, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
