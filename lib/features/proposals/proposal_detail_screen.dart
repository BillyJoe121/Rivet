import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../messaging/proposal_chat_screen.dart';
import '../execution/work_progress_screen.dart';

/// Pantalla de detalle de cotización y aceptación de acuerdo (P-028 / P-031).
class ProposalDetailScreen extends StatefulWidget {
  const ProposalDetailScreen({super.key, required this.proposal});

  final Proposal proposal;

  @override
  State<ProposalDetailScreen> createState() => _ProposalDetailScreenState();
}

class _ProposalDetailScreenState extends State<ProposalDetailScreen> {
  bool _agreementAccepted = false;
  bool _isPaying = false;

  Future<void> _handlePayment(Proposal prop) async {
    setState(() => _isPaying = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isPaying = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Acuerdo fijado con éxito! Se inició el seguimiento de obra.'),
        backgroundColor: AppColors.brand700,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WorkProgressScreen(proposal: prop),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prop = widget.proposal;
    final total = prop.totalCostCop;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: 'Detalle de Cotización',
        subtitle: prop.contractor.name,
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Perfil del Contratista
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
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
                            const Icon(Icons.verified, color: AppColors.brand700, size: 16),
                          ],
                        ),
                        Text(prop.contractor.trade, style: AppTypography.caption),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.clay600, size: 14),
                            const SizedBox(width: 2),
                            Text('${prop.contractor.rating}', style: AppTypography.badgeText),
                            Text(' (${prop.contractor.reviewCount} reseñas)', style: AppTypography.caption),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    text: 'Conversar',
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.sm,
                    isFullWidth: false,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProposalChatScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Desglose Transparente de Costos (P-028)
            Text('Desglose de Costos de Obra', style: AppTypography.subheading.copyWith(fontSize: 18)),
            const SizedBox(height: AppSpacing.xs),
            Text('Valores fijados para esta cotización.', style: AppTypography.bodySmall),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Column(
                children: [
                  _buildCostRow('Mano de obra profesional', prop.laborCostCop),
                  const Divider(color: AppColors.line300),
                  _buildCostRow('Materiales e insumos calculados', prop.materialsCostCop),
                  const Divider(color: AppColors.line300),
                  _buildCostRow('Tarifa de gestión Rivet (0% prototipo)', 0),
                  const Divider(color: AppColors.line300, thickness: 1.5),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL DEL ACUERDO', style: AppTypography.subheading),
                      Text(
                        '\$${_formatCurrency(total)} COP',
                        style: AppTypography.sectionTitle.copyWith(color: AppColors.brand700),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Alcance técnico
            Text('Alcance y Condiciones', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppColors.brand700, size: 18),
                      const SizedBox(width: AppSpacing.sm),
                      Text('Tiempo estimado: ${prop.estimatedDays} días hábiles', style: AppTypography.badgeText),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(prop.observations, style: AppTypography.bodyMedium),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Confirmación de Acuerdo (P-031)
            AppCard(
              backgroundColor: AppColors.surfaceSubtle,
              child: Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: CheckboxListTile(
                      value: _agreementAccepted,
                      onChanged: (val) => setState(() => _agreementAccepted = val ?? false),
                      title: Text(
                        'Acepto los términos de mano de obra y materiales fijados en esta propuesta.',
                        style: AppTypography.bodySmall,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.brand700,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'En V1 el pago es una simulación de prueba académica. No se realizarán cargos a tarjetas reales.',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Botón de Pago / Formalización
            AppButton(
              text: 'Fijar Acuerdo e Iniciar Obra (\$${_formatCurrency(total)})',
              icon: Icons.lock_outline,
              isLoading: _isPaying,
              onPressed: _agreementAccepted ? () => _handlePayment(prop) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, int amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.bodyMedium),
          Text('\$${_formatCurrency(amount)}', style: AppTypography.subheading.copyWith(fontSize: 14)),
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
