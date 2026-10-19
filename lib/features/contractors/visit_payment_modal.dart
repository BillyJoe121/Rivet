import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Confirmación y pago simulado de visita técnica acordada (P-022).
class VisitPaymentModal extends StatefulWidget {
  const VisitPaymentModal({
    super.key,
    required this.contractor,
    this.visitFeeCop = 35000,
    required this.scheduledDate,
  });

  final Contractor contractor;
  final int visitFeeCop;
  final DateTime scheduledDate;

  @override
  State<VisitPaymentModal> createState() => _VisitPaymentModalState();
}

class _VisitPaymentModalState extends State<VisitPaymentModal> {
  bool _isProcessing = false;
  String _selectedMethod = 'Nequi / Daviplata';

  Future<void> _handlePayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Pago simulado de visita registrado! Fecha confirmada en agenda.'),
        backgroundColor: AppColors.brand700,
      ),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(title: 'Confirmación de Visita'),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('VISITA PRESENCIAL', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                      const AppBadge(text: 'Acordada', variant: AppBadgeVariant.brand),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Profesional: ${widget.contractor.name}', style: AppTypography.subheading),
                  Text(
                    'Fecha: ${widget.scheduledDate.day}/${widget.scheduledDate.month}/${widget.scheduledDate.year}',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tarifa acordada de visita:', style: AppTypography.bodyMedium),
                      Text(
                        '\$${widget.visitFeeCop > 0 ? _formatCurrency(widget.visitFeeCop) : '0 (Cortesía)'} COP',
                        style: AppTypography.subheading.copyWith(
                          color: AppColors.brand700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text('Método de Pago Simulado (V1)', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.xs),
            Text('Entorno de demostración académica. No se debitará dinero real.', style: AppTypography.caption),
            const SizedBox(height: AppSpacing.md),

            ...['Nequi / Daviplata', 'PSE / Cuenta bancaria', 'Tarjeta de Débito'].map((method) {
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
                  Icon(Icons.info_outline, color: AppColors.ink700, size: 20),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Si contratas la obra con este profesional, el valor de la visita podrá descontarse del saldo final si ambas partes lo acuerdan.',
                      style: TextStyle(fontSize: 12, color: AppColors.ink700),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            AppButton(
              text: 'Confirmar Visita (\$${_formatCurrency(widget.visitFeeCop)} COP)',
              icon: Icons.check_circle_outline,
              isLoading: _isProcessing,
              onPressed: _handlePayment,
            ),
          ],
        ),
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
