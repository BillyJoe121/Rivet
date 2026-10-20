import 'package:flutter/material.dart';

import 'kit/kit.dart';
import 'pro_home_mock.dart';

/// Tarjeta oscura "Nuevos proyectos cerca de ti" con un proyecto destacado.
class ProFeaturedProjectCard extends StatelessWidget {
  const ProFeaturedProjectCard({super.key, required this.project, this.onTap});

  final ProProjectSummary project;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      color: ProColors.brand800,
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Nuevos proyectos cerca de ti', style: ProText.subheading.copyWith(color: ProColors.surface0)),
          const SizedBox(height: 9),
          ProProjectCard(project: project, imageSize: 78, onTap: onTap),
        ],
      ),
    );
  }
}

/// Tarjeta de proyecto con foto, datos, estado o progreso y chevron.
class ProProjectCard extends StatelessWidget {
  const ProProjectCard({super.key, required this.project, this.imageSize = 72, this.onTap});

  final ProProjectSummary project;
  final double imageSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final done = project.stagesDone;
    final total = project.stagesTotal;
    return ProCard(
      radius: ProRadii.card,
      borderWidth: ProStroke.hairline,
      padding: const EdgeInsets.all(7),
      onTap: onTap,
      child: Row(
        children: [
          ProImage(project.image, width: imageSize, height: imageSize),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(project.title, style: ProText.labelStrong)),
                    if (project.badge != null) ...[
                      const SizedBox(width: 4),
                      ProChip(
                        project.badge!,
                        background: ProColors.warningLight,
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        textStyle: ProText.r(11, color: ProColors.sun300, lineHeight: 13.2),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${project.category}\n♧ ${project.location}',
                  style: ProText.r(11, color: ProColors.ink500, lineHeight: 12.65),
                ),
                if (done != null && total != null) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(child: ProProgressBar(value: project.progress ?? done / total)),
                      const SizedBox(width: 8),
                      Text('$done de $total etapas', style: ProText.r(9, color: ProColors.ink500, lineHeight: 10.8)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 9),
          const ProIcon(LucideIcon.chevronRight, size: 14),
        ],
      ),
    );
  }
}

/// Tarjeta de actividad reciente con filas separadas por líneas de 0.5 px.
class ProActivityCard extends StatelessWidget {
  const ProActivityCard({super.key, required this.items, this.onTap});

  final List<ProActivity> items;
  final ValueChanged<ProActivity>? onTap;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          for (final item in items)
            SizedBox(
              height: 40,
              child: ProOptionRow(
                icon: item.icon,
                title: item.title,
                subtitle: item.detail,
                titleStyle: ProText.r(12, weight: FontWeight.w600, lineHeight: 15.6),
                onTap: onTap == null ? null : () => onTap!(item),
              ),
            ),
        ],
      ),
    );
  }
}
