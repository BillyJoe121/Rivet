import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Directorio y catálogo de pintores y estucadores (P-019).
class ContractorsDirectoryScreen extends StatelessWidget {
  const ContractorsDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contractors = MockData.contractors;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(
        title: 'Pintores y Estucadores',
        subtitle: 'Cali · Profesionales con trabajos verificados',
        showBackButton: false,
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Buscador / Filtro
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.ink500),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar por oficio, zona o nombre...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.ink500),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text('Profesionales Disponibles (${contractors.length})', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.xs),
          Text('Reseñas e historial respaldados por cotizaciones cerradas en la app.', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),

          ...contractors.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.brandLight,
                            child: Text(
                              c.name.split(' ').map((n) => n[0]).take(2).join(),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.brand700, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(c.name, style: AppTypography.subheading),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified, color: AppColors.brand700, size: 16),
                                  ],
                                ),
                                Text(c.trade, style: AppTypography.caption),
                                const SizedBox(height: 2),
                                Text(c.zone, style: AppTypography.caption.copyWith(color: AppColors.ink500)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star, color: AppColors.clay600, size: 16),
                                  const SizedBox(width: 2),
                                  Text('${c.rating}', style: AppTypography.subheading.copyWith(fontSize: 14)),
                                ],
                              ),
                              Text('${c.reviewCount} opiniones', style: AppTypography.caption),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(c.bio, style: AppTypography.bodySmall),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          const AppBadge(text: 'Pintura interior', variant: AppBadgeVariant.neutral),
                          const SizedBox(width: AppSpacing.xs),
                          const AppBadge(text: 'Estuco', variant: AppBadgeVariant.neutral),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
