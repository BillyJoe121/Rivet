import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Solicitud de cancelación y devolución conforme a política (P-039).
class CancellationRefundScreen extends StatefulWidget {
  const CancellationRefundScreen({
    super.key,
    required this.projectTitle,
    required this.contractorName,
    this.escrowAmountCop = 1200000,
  });

  final String projectTitle;
  final String contractorName;
  final int escrowAmountCop;

  @override
  State<CancellationRefundScreen> createState() => _CancellationRefundScreenState();
}

class _CancellationRefundScreenState extends State<CancellationRefundScreen> {
  String _selectedReason = 'Acuerdo mutuo de no continuar';
  final _explanationController = TextEditingController();
  bool _termsAcknowledged = false;

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(title: 'Solicitud de Cancelación'),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Obra Afectada (P-039)', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(widget.projectTitle, style: AppTypography.subheading),
                  Text('Contratista asignado: ${widget.contractorName}', style: AppTypography.caption),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Monto en custodia:', style: AppTypography.bodySmall),
                      Text(
                        '\$${_formatCurrency(widget.escrowAmountCop)} COP',
                        style: AppTypography.badgeText.copyWith(color: AppColors.brand700),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text('Causal de Cancelación', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.xs),
            Text('Selecciona el motivo establecido en la política de garantías.', style: AppTypography.caption),
            const SizedBox(height: AppSpacing.md),

            ...[
              'Acuerdo mutuo de no continuar',
              'Incumplimiento de fecha sin aviso (> 5 días)',
              'Discrepancia insalvable en materiales recibidos',
              'Fuerza mayor o daño imprevisto en la propiedad',
            ].map((reason) {
              final isSelected = _selectedReason == reason;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedReason = reason),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppColors.brand700 : AppColors.ink500,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: Text(reason, style: AppTypography.bodySmall)),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              label: 'Explicación detallada',
              hint: 'Describe lo ocurrido para el registro del expediente.',
              controller: _explanationController,
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.lg),

            AppCard(
              backgroundColor: AppColors.surfaceSubtle,
              child: CheckboxListTile(
                value: _termsAcknowledged,
                onChanged: (val) => setState(() => _termsAcknowledged = val ?? false),
                title: Text(
                  'Entiendo que los materiales ya entregados o abiertos no son reembolsables por bodega.',
                  style: AppTypography.bodySmall,
                ),
                activeColor: AppColors.brand700,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            AppButton(
              text: 'Radicar Solicitud de Cancelación',
              variant: AppButtonVariant.danger,
              onPressed: _termsAcknowledged
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Solicitud de cancelación radicada para revisión.'),
                          backgroundColor: AppColors.danger700,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  : null,
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
