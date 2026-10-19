import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../projects/create_project_screen.dart';
import '../projects/project_detail_screen.dart';

/// Vista de inicio "Explorar Rivet" idéntica a la estética editorial de Figma.
class ClientHomeView extends StatelessWidget {
  const ClientHomeView({super.key, required this.onSwitchRole});

  final ValueChanged<UserRole> onSwitchRole;

  @override
  Widget build(BuildContext context) {
    final activeProject = MockData.projects.first;

    return RivetScaffold(
      showBackButton: false,
      title: 'Explorar Rivet',
      backgroundImagePath: 'Fondos/Sala minimalista con plantas y luz suave.png',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.md),

          // 1. Selector de Accesos Rápidos (Proyectos, Contratistas, Bodega)
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.home_outlined,
                  label: 'Proyectos',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateProjectScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.people_outline,
                  label: 'Contratistas',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.inventory_2_outlined,
                  label: 'Bodega',
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // 2. Encabezado de Sección "Proyecto destacado"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Proyecto destacado', style: AppTypography.subheading.copyWith(fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  'Ver todos',
                  style: AppTypography.caption.copyWith(color: AppColors.brand700, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          // 3. Tarjeta de Proyecto Destacado estilo Figma
          AppCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: activeProject)),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: Image.asset(
                      'Fondos/Sala minimalista con plantas y luz suave.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Remodelación de sala', style: AppTypography.subheading.copyWith(fontSize: 15)),
                      const SizedBox(height: 2),
                      Text('Pintura y acabados', style: AppTypography.caption),
                      Text('Cali y alrededores', style: AppTypography.caption.copyWith(color: AppColors.ink500)),
                      const SizedBox(height: 4),
                      Text('\$ 2.500.000 – 3.800.000 COP · 62 m²',
                          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.brand700)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20, color: AppColors.ink500),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 4. Grid de Tarjetas de Fotos (Contratistas y Ferreterías)
          Row(
            children: [
              Expanded(
                child: _buildPhotoTeaserCard(
                  imagePath: 'Fondos/Rodillo sobre pincelada verde.png',
                  title: 'Contratistas verificados',
                  subtitle: 'Profesionales con experiencia',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildPhotoTeaserCard(
                  imagePath: 'Fondos/Tienda minimalista entre plantas verdes.png',
                  title: 'Materiales y proveedores',
                  subtitle: 'Todo para tu renovación',
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // 5. Banner Informativo Biofílico
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.brandLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.brand700, size: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Puedes explorar proyectos, contratistas y materiales libremente. Regístrate para publicar, cotizar, contactar o comprar.',
                    style: AppTypography.caption.copyWith(color: AppColors.brand700, height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.brand700),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink900)),
        ],
      ),
    );
  }

  Widget _buildPhotoTeaserCard({
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 1.25,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(title, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.ink900)),
        Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.ink500, fontSize: 11)),
      ],
    );
  }
}
