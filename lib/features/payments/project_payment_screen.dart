import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Pasarela de pago de prueba académica para obras (P-032).
class ProjectPaymentScreen extends StatefulWidget {
  const ProjectPaymentScreen({
    super.key,
    required this.proposal,
  });

  final Proposal proposal;

  @override
  State<ProjectPaymentScreen> createState() => _ProjectPaymentScreenState();
}

class _ProjectPaymentScreenState extends State<ProjectPaymentScreen> {
  String _selectedMethod = 'PSE (Bancolombia, Davivienda, etc.)';
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _isProcessing = false);

    showDialog(
      context: context,
      builder: (ctx) => AppConfirmDialog(
        title: '¡Pago Exitoso!',
        message: 'El pago ha sido procesado correctamente. Los fondos han sido depositados en garantía para el proyecto.',
        confirmLabel: 'Volver al Proyecto',
        onConfirm: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prop = widget.proposal;
    final total = prop.totalCostCop;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(
        title: 'Pago del Proyecto',
        subtitle: 'Entorno de Demostración Académica',
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Resumen de la obra y montos
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resumen de Pago (P-032)', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Obra: Pintura y acabados en sala', style: AppTypography.subheading),
                  Text('Contratista: ${prop.contractor.name}', style: AppTypography.caption),
                  const SizedBox(height: AppSpacing.md),
                  _buildRow('Mano de obra fijada', '\$${_formatCurrency(prop.laborCostCop)}'),
                  _buildRow('Materiales calculados', '\$${_formatCurrency(prop.materialsCostCop)}'),
                  _buildRow('Tarifa de gestión Rivet', '\$0 (Gratis en V1)'),
                  const Divider(color: AppColors.line300),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL A PAGAR', style: AppTypography.subheading),
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

            Text('Selecciona un Medio de Pago Simulado', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.xs),
            Text('Simula el recaudo para pruebas de flujo sin cobro real.', style: AppTypography.caption),
            const SizedBox(height: AppSpacing.md),

            ...[
              'PSE (Bancolombia, Davivienda, etc.)',
              'Nequi / Daviplata',
              'Tarjeta Débito / Crédito',
            ].map((method) {
              final isSelected = _selectedMethod == method;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedMethod = method),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppColors.brand700 : AppColors.ink500,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(method, style: AppTypography.bodyMedium),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: AppSpacing.xl),

            const AppCard(
              backgroundColor: AppColors.surfaceSubtle,
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.brand700, size: 24),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Custodia Simulada: El dinero permanece protegido y solo se transferirá al contratista tras la doble confirmación final.',
                      style: TextStyle(fontSize: 12, color: AppColors.ink700),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            AppButton(
              text: 'Confirmar y Pagar (\$${_formatCurrency(total)} COP)',
              icon: Icons.lock,
              isLoading: _isProcessing,
              onPressed: _processPayment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
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
