import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../messaging/proposal_chat_screen.dart';

/// Perfil detallado del profesional y portafolio con diseño editorial y fondo orgánico (P-006).
class ContractorDetailScreen extends StatelessWidget {
  const ContractorDetailScreen({super.key, required this.contractor});

  final Contractor contractor;

  @override
  Widget build(BuildContext context) {
    return RivetScaffold(
      title: 'Perfil\nProfesional',
      backgroundImagePath: 'Fondos/Rodillo sobre pincelada verde.png',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.sm),

          // Tarjeta Cabecera del Contratista
          AppCard(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.brandLight,
                  child: Text(
                    contractor.name.split(' ').map((n) => n[0]).take(2).join(),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.brand700, fontSize: 22),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(contractor.name, style: AppTypography.sectionTitle),
                    const SizedBox(width: 6),
                    const Icon(Icons.verified, color: AppColors.brand700, size: 20),
                  ],
                ),
                const SizedBox(height: 2),
                Text(contractor.trade, style: AppTypography.caption.copyWith(fontSize: 13, color: AppColors.ink700)),
                Text(contractor.zone, style: AppTypography.caption),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMetric('Calificación', '${contractor.rating} ★'),
                    Container(height: 28, width: 1, color: AppColors.line300),
                    _buildMetric('Trabajos', '${contractor.completedJobs}'),
                    Container(height: 28, width: 1, color: AppColors.line300),
                    _buildMetric('Opiniones', '${contractor.reviewCount}'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Biografía y Experiencia
          Text('Sobre el profesional', style: AppTypography.subheading.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Text(contractor.bio, style: AppTypography.bodyMedium.copyWith(height: 1.5)),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Portafolio de Obras Anteriores
          Text('Portafolio de Trabajos Recientes', style: AppTypography.subheading.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          Text('Fotografías reales verificadas en obras anteriores.', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),

          if (contractor.portfolioImages.isNotEmpty)
            ...contractor.portfolioImages.map((img) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        img,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(color: AppColors.surfaceSubtle),
                      ),
                    ),
                  ),
                ))
          else
            const AppCard(
              child: Center(
                child: Text('Sin fotos de portafolio registradas.', style: TextStyle(color: AppColors.ink500)),
              ),
            ),

          const SizedBox(height: 90), // Espacio para el botón fijo inferior
        ],
      ),
      bottomBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.paper100,
          border: Border(top: BorderSide(color: AppColors.line300.withValues(alpha: 0.6))),
        ),
        child: AppButton(
          text: 'Contactar al Profesional',
          trailingIcon: Icons.chevron_right,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProposalChatScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.subheading.copyWith(color: AppColors.brand700, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
