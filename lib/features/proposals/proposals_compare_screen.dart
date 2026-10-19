import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'proposal_detail_screen.dart';

/// Pantalla de comparación de ofertas para el cliente (P-029).
/// Separa de forma transparente mano de obra y materiales.
class ProposalsCompareScreen extends StatelessWidget {
  const ProposalsCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proposals = MockData.proposals;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(
        title: 'Comparar Propuestas',
        subtitle: '2 ofertas recibidas para Sala y Comedor',
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Banner de Transparencia
          const AppCard(
            backgroundColor: AppColors.brandLight,
            borderColor: Colors.transparent,
            child: Row(
              children: [
                Icon(Icons.balance, color: AppColors.brand700),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'En Rivet la mano de obra se separa de los materiales para que sepas exactamente qué cobra el profesional y qué se va a insumos.',
                    style: TextStyle(fontSize: 12, color: AppColors.brand700, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Tarjetas de Propuesta
          ...proposals.map((prop) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.brandLight,
                            child: Text(
                              prop.contractor.name.split(' ').map((n) => n[0]).take(2).join(),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.brand700),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(prop.contractor.name, style: AppTypography.subheading),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified, size: 16, color: AppColors.brand700),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 14, color: AppColors.clay600),
                                    const SizedBox(width: 2),
                                    Text('${prop.contractor.rating}', style: AppTypography.badgeText),
                                    Text(' · ${prop.contractor.completedJobs} trabajos', style: AppTypography.caption),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${_formatCurrency(prop.totalCostCop)}',
                                style: AppTypography.subheading.copyWith(
                                  color: AppColors.brand700,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text('Total estimado', style: AppTypography.caption),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.md),
                      const Divider(color: AppColors.line300),
                      const SizedBox(height: AppSpacing.md),

                      // Desglose Mano de Obra vs Materiales
                      Row(
                        children: [
                          Expanded(
                            child: AppStatTile(
                              label: 'MANO DE OBRA',
                              value: '\$${_formatCurrency(prop.laborCostCop)}',
                              icon: Icons.person_outline,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppStatTile(
                              label: 'MATERIALES',
                              value: '\$${_formatCurrency(prop.materialsCostCop)}',
                              icon: Icons.format_paint_outlined,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.ink500),
                          const SizedBox(width: 4),
                          Text('Tiempo estimado: ${prop.estimatedDays} días hábiles', style: AppTypography.caption),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.sm),
                      Text(prop.observations, style: AppTypography.bodySmall),

                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'Ver Detalle y Desglose',
                              variant: AppButtonVariant.primary,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => ProposalDetailScreen(proposal: prop)),
                                );
                              },
                            ),
                          ),
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

  static String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
