import 'package:flutter/material.dart';
import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

/// Proyecto del cliente con su estado y las propuestas recibidas.
class ClientProjectCard extends StatelessWidget {
  const ClientProjectCard({
    super.key,
    required this.project,
    required this.proposalCount,
  });

  final Project project;
  final int proposalCount;

  @override
  Widget build(BuildContext context) {
    final proposals = switch (proposalCount) {
      0 => 'Esperando propuestas',
      1 => '1 propuesta recibida',
      _ => '$proposalCount propuestas recibidas',
    };

    return AppCard(
      child: Row(
        children: [
          if (project.imageAsset != null) ...[
            ClipRRect(
              borderRadius: AppSpacing.roundedMd,
              child: Image.asset(
                project.imageAsset!,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(width: 72, height: 72),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.subheading.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '${project.city} · ${project.totalAreaM2.toStringAsFixed(0)} m²',
                  style: AppTypography.caption,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    AppBadge(
                      text: project.status.label,
                      variant: project.status == ProjectStatus.published
                          ? AppBadgeVariant.brand
                          : AppBadgeVariant.warning,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        proposals,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.captionStrong.copyWith(
                          color: proposalCount > 0 ? AppColors.brand700 : AppColors.ink500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
