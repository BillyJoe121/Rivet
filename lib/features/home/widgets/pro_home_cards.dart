import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/design_system/design_system.dart';

/// Proyecto resumido en tarjetas de inicio del contratista.
class ProProjectSummary {
  const ProProjectSummary({
    required this.title,
    required this.category,
    required this.location,
    required this.image,
    this.badge,
    this.stagesDone,
    this.stagesTotal,
    this.progress,
  });

  final String title;
  final String category;
  final String location;
  final String image;
  final String? badge;
  final int? stagesDone;
  final int? stagesTotal;

  /// Avance mostrado en la barra; si falta, se usa etapas hechas / total.
  final double? progress;
}

/// Evento de actividad reciente en el inicio del contratista.
class ProActivity {
  const ProActivity(this.icon, this.title, this.detail);

  final IconData icon;
  final String title;
  final String detail;
}

/// Tarjeta oscura "Nuevos proyectos cerca de ti" con un proyecto destacado.
class ProFeaturedProjectCard extends StatelessWidget {
  const ProFeaturedProjectCard({super.key, required this.project, this.onTap});

  final ProProjectSummary project;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.brand800,
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Nuevos proyectos cerca de ti',
            style: AppTypography.subheadingProportional.copyWith(
              color: AppColors.surface0,
            ),
          ),
          const SizedBox(height: 9),
          ProProjectCard(project: project, imageSize: 78, onTap: onTap),
        ],
      ),
    );
  }
}

/// Tarjeta de proyecto con foto, datos y estado o progreso. Con [onTap] se
/// puede tocar y muestra un chevron a la derecha.
class ProProjectCard extends StatelessWidget {
  const ProProjectCard({
    super.key,
    required this.project,
    this.imageSize = 72,
    this.onTap,
  });

  final ProProjectSummary project;
  final double imageSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final done = project.stagesDone;
    final total = project.stagesTotal;
    return AppCard(
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      borderWidth: AppSpacing.strokeHairline,
      padding: const EdgeInsets.all(7),
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Image.asset(
              project.image,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              cacheWidth: 320,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => Container(
                width: imageSize,
                height: imageSize,
                color: AppColors.brandLight,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: AppTypography.labelStrongProportional,
                      ),
                    ),
                    if (project.badge != null) ...[
                      const SizedBox(width: 4),
                      AppBadge(
                        text: project.badge!,
                        variant: AppBadgeVariant.warning,
                        compact: true,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${project.category}\n${project.location}',
                  style: AppTypography.proportional(
                    11,
                    color: AppColors.ink500,
                    lineHeight: 12.65,
                  ),
                ),
                if (done != null && total != null) ...[
                  const SizedBox(height: 3),
                  AppProgressBar(
                    value: project.progress ?? done / total,
                    label: '$done de $total etapas',
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            const Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: AppColors.ink500,
            ),
          ],
        ],
      ),
    );
  }
}

/// Tarjeta de actividad reciente con filas separadas por líneas de 1 px.
class ProActivityCard extends StatelessWidget {
  const ProActivityCard({super.key, required this.items, this.onTap});

  final List<ProActivity> items;
  final ValueChanged<ProActivity>? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            AppListTile(
              leadingIcon: items[i].icon,
              title: items[i].title,
              subtitle: items[i].detail,
              showDivider: i < items.length - 1,
              onTap: onTap == null ? null : () => onTap!(items[i]),
            ),
        ],
      ),
    );
  }
}
