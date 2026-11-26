import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../messaging/messaging_screens.dart';
import 'visit_request_screen.dart';

export 'visit_request_screen.dart';

/// Perfil público de contratista con jerarquía clara de decisión (P-020).
class ContractorProfileScreen extends StatelessWidget {
  const ContractorProfileScreen({
    super.key,
    required this.contractor,
    this.projectId,
  });

  final Contractor contractor;
  final String? projectId;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'C';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasProject = projectId != null && projectId!.isNotEmpty;
    final portfolio = contractor.portfolioImages;

    return RivetScaffold(
      title: 'Perfil del\ncontratista',
      showBackButton: true,
      backgroundImagePath: AppHeroImages.paintRoller,
      body: AppPageBody(
        footer: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                text: 'Solicitar visita técnica',
                showChevron: true,
                onPressed: () => Navigator.of(context).push(
                  VisitRequestScreen.route(
                    contractor: contractor,
                    projectId: projectId ?? '',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                text: 'Escribir mensaje',
                variant: AppButtonVariant.outline,
                icon: LucideIcons.messageSquare,
                onPressed: () => Navigator.of(context).push(
                  hasProject
                      ? ProjectChatScreen.route(
                          projectId: projectId,
                          contractorId: contractor.id,
                          contractorName: contractor.name,
                        )
                      : ConversationsListScreen.route(),
                ),
              ),
            ],
          ),
        ),
        children: [
          const SizedBox(height: AppSpacing.md),
          // 1. Foco principal: Identidad y métricas clave de confianza
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppAvatar(initials: _initials(contractor.name), size: 56),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  contractor.name,
                                  style: AppTypography.sectionTitle,
                                ),
                              ),
                              if (contractor.isVerified) ...[
                                const SizedBox(width: AppSpacing.xs),
                                const Icon(
                                  LucideIcons.badgeCheck,
                                  size: 18,
                                  color: AppColors.brand700,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            contractor.trade,
                            style: AppTypography.bodyStrong.copyWith(
                              color: AppColors.brand700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(contractor.zone, style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.paper100,
                    borderRadius: AppSpacing.roundedSm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MetricColumn(
                        value: '${contractor.rating.toStringAsFixed(1)} ★',
                        label: '${contractor.reviewCount} reseñas',
                      ),
                      Container(width: 1, height: 28, color: AppColors.line300),
                      _MetricColumn(
                        value: '${contractor.completedJobs}',
                        label: 'Obras entregadas',
                      ),
                      Container(width: 1, height: 28, color: AppColors.line300),
                      _MetricColumn(
                        value: contractor.isVerified ? 'Verificado' : 'Activo',
                        label: 'Estado en Cali',
                      ),
                    ],
                  ),
                ),
                if (contractor.bio.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(contractor.bio, style: AppTypography.bodyMedium),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // 2. Evidencia visual: Portafolio de trabajos recientes
          AppSectionHeader(
            title: 'Trabajos recientes',
            count: portfolio.length,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (portfolio.isEmpty)
            const AppEmptyState(
              title: 'Sin fotos publicadas aún',
              message:
                  'Este profesional todavía no ha subido evidencias de obras recientes.',
              icon: LucideIcons.image,
            )
          else
            SizedBox(
              height: 152,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: portfolio.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) => _PortfolioCard(
                  source: portfolio[index],
                  caption: 'Obra reciente ${index + 1}',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard({required this.source, required this.caption});

  final String source;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final isRemote =
        source.startsWith('http://') || source.startsWith('https://');
    final image = isRemote
        ? Image.network(
            source,
            height: 102,
            width: 215,
            cacheWidth: 430,
            cacheHeight: 204,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Container(height: 102, color: AppColors.brandLight),
          )
        : Image.asset(
            source,
            height: 102,
            width: 215,
            cacheWidth: 430,
            cacheHeight: 204,
            gaplessPlayback: true,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Container(height: 102, color: AppColors.brandLight),
          );

    return SizedBox(
      width: 215,
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusLg),
              ),
              child: image,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(
                caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelStrong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.subheading.copyWith(color: AppColors.brand700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}
