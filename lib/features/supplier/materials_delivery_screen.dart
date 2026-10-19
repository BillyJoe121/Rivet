import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Recepción y reporte de entrega de materiales en obra (P-037).
class MaterialsDeliveryScreen extends StatefulWidget {
  const MaterialsDeliveryScreen({
    super.key,
    this.orderId = 'PED-901',
  });

  final String orderId;

  @override
  State<MaterialsDeliveryScreen> createState() => _MaterialsDeliveryScreenState();
}

class _MaterialsDeliveryScreenState extends State<MaterialsDeliveryScreen> {
  final Map<String, bool> _checklist = {
    '1 Cuñete Viniltex Blanco Hueso (Sellado de fábrica)': true,
    '1 Balde Estuco Acrílico Corona 20kg': true,
    '1 Kit Rodillo Master + Bandeja': false,
  };
  bool _noDamagesConfirmed = true;

  bool get _allChecked => _checklist.values.every((v) => v) && _noDamagesConfirmed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: 'Recepción de Materiales',
        subtitle: widget.orderId,
      ),
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
                      Text('DESPACHO EN OBRA (P-037)', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                      const AppBadge(text: 'En Verificación', variant: AppBadgeVariant.warning),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('FerreCasa Central → Obra Valle del Lili', style: AppTypography.subheading),
                  Text('Destinatario: Carlos Mendoza (Contratista)', style: AppTypography.caption),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text('Checklist de Insumos Recibidos', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.xs),
            Text('Verifica que cada producto coincida en referencia y esté en buen estado.', style: AppTypography.bodySmall),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Column(
                children: _checklist.keys.map((item) {
                  return CheckboxListTile(
                    value: _checklist[item],
                    onChanged: (val) => setState(() => _checklist[item] = val ?? false),
                    title: Text(item, style: AppTypography.bodyMedium),
                    activeColor: AppColors.brand700,
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            AppCard(
              backgroundColor: AppColors.surfaceSubtle,
              child: CheckboxListTile(
                value: _noDamagesConfirmed,
                onChanged: (val) => setState(() => _noDamagesConfirmed = val ?? false),
                title: Text(
                  'Confirmo que los baldes no presentan fisuras ni derrames y los sellos están intactos.',
                  style: AppTypography.bodySmall,
                ),
                activeColor: AppColors.brand700,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            AppButton(
              text: 'Confirmar Recepción Completa en Obra',
              icon: Icons.check_circle_outline,
              onPressed: _allChecked
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Recepción de materiales confirmada! Bodega notificada.'),
                          backgroundColor: AppColors.brand700,
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
}
