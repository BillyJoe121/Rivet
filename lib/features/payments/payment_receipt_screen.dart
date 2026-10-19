import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../execution/work_progress_screen.dart';

/// Comprobante de pago y verificación de transacción (P-033).
class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({
    super.key,
    required this.proposal,
    required this.paymentMethod,
    required this.transactionRef,
  });

  final Proposal proposal;
  final String paymentMethod;
  final String transactionRef;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(
        title: 'Comprobante de Pago',
        showBackButton: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Icono de Éxito
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.brandLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.brand700, size: 36),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '¡Pago Registrado con Éxito!',
              style: AppTypography.pageTitle.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Los fondos han quedado en custodia simulada para el inicio de la obra.',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Tarjeta de Recibo
            AppCard(
              child: Column(
                children: [
                  _buildReceiptRow('Referencia', transactionRef),
                  const Divider(color: AppColors.line300),
                  _buildReceiptRow('Medio de pago', paymentMethod),
                  const Divider(color: AppColors.line300),
                  _buildReceiptRow('Contratista', proposal.contractor.name),
                  const Divider(color: AppColors.line300),
                  _buildReceiptRow('Fecha', '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                  const Divider(color: AppColors.line300),
                  _buildReceiptRow('Mano de obra', '\$${_formatCurrency(proposal.laborCostCop)}'),
                  _buildReceiptRow('Materiales calculados', '\$${_formatCurrency(proposal.materialsCostCop)}'),
                  const Divider(color: AppColors.line300, thickness: 1.5),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL SIMULADO', style: AppTypography.subheading),
                      Text(
                        '\$${_formatCurrency(proposal.totalCostCop)} COP',
                        style: AppTypography.sectionTitle.copyWith(color: AppColors.brand700),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            AppButton(
              text: 'Ir al Seguimiento de Obra',
              icon: Icons.arrow_forward,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkProgressScreen(proposal: proposal),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
          Text(value, style: AppTypography.bodySmall),
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
