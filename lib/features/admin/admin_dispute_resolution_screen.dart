import 'package:flutter/material.dart';
import '../home/widgets/kit/kit.dart';
import 'widgets/admin_widgets.dart';

/// Resolución fundada de casos y configuración de tarifas comerciales (P-046 / P-047).
class AdminDisputeResolutionScreen extends StatefulWidget {
  const AdminDisputeResolutionScreen({super.key});

  @override
  State<AdminDisputeResolutionScreen> createState() => _AdminDisputeResolutionScreenState();
}

class _AdminDisputeResolutionScreenState extends State<AdminDisputeResolutionScreen> {
  final _clientCommissionController = TextEditingController(text: '0');
  final _contractorCommissionController = TextEditingController(text: '5');
  final _materialsFeeController = TextEditingController(text: '0.8');
  final _resolutionNotesController = TextEditingController(
    text: 'Se ratifica el acuerdo de rectificación técnica sin alterar los valores de mano de obra fijados.',
  );

  @override
  void dispose() {
    _clientCommissionController.dispose();
    _contractorCommissionController.dispose();
    _materialsFeeController.dispose();
    _resolutionNotesController.dispose();
    super.dispose();
  }

  void _notifyResolution() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resolución registrada y notificada a las partes.'),
        backgroundColor: ProColors.brand700,
      ),
    );
  }

  void _saveParameters() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Parámetros comerciales actualizados y versionados!'),
        backgroundColor: ProColors.brand700,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const decimal = TextInputType.numberWithOptions(decimal: true);
    return ProScreen(
      backgroundAsset: ProAssets.headerPrivacy,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Políticas y Casos',
            lucideChevron: true,
            height: 120,
            padding: EdgeInsets.fromLTRB(24, 10, 24, 8),
            gap: 6,
            titleWidth: 300,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: ProColors.brandLight,
                      borderRadius: BorderRadius.circular(ProRadii.xl),
                    ),
                    child: Text(
                      'P-046 / P-047',
                      style: ProText.r(11, color: ProColors.brand700, lineHeight: 13.2),
                    ),
                  ),
                ),
                Text('Resolución Fundada de Casos (P-046)', style: ProText.subheading),
                Text(
                  'Cada decisión administrativa debe quedar motivada con evidencia verificada sin borrar registros contables anteriores.',
                  style: ProText.bodySmall,
                ),
                ProCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 10,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('CASO #1082 · Pintura sala', style: ProText.captionStrong),
                          ProChip(
                            'Resolución Lista',
                            background: ProColors.brandLight,
                            foreground: ProColors.brand700,
                            textStyle: ProText.r(11, weight: FontWeight.w600, color: ProColors.brand700, lineHeight: 13.2),
                          ),
                        ],
                      ),
                      Text('Partes: Juan Camilo Pérez vs. Carlos Mendoza', style: ProText.titleSmall),
                      AdminField(
                        label: 'Fundamento de la resolución administrativa',
                        controller: _resolutionNotesController,
                        maxLines: 3,
                      ),
                      ProPrimaryButton('Registrar y Notificar Decisión', onTap: _notifyResolution),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text('Configuración de Tarifas de Plataforma (P-047)', style: ProText.subheading),
                Text(
                  'Parámetros comerciales globales. Los cambios solo aplican a acuerdos futuros.',
                  style: ProText.bodySmall,
                ),
                ProCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      AdminField(
                        label: 'Tarifa de gestión al Cliente (%)',
                        controller: _clientCommissionController,
                        keyboardType: decimal,
                        suffixText: '%',
                        helperText: 'En V1 prototipo académico se mantiene en 0%',
                      ),
                      AdminField(
                        label: 'Comisión al Contratista (%)',
                        controller: _contractorCommissionController,
                        keyboardType: decimal,
                        suffixText: '%',
                        helperText: 'Deducción aplicable al desembolso de mano de obra',
                      ),
                      AdminField(
                        label: 'Cargo sobre Materiales de Bodega (%)',
                        controller: _materialsFeeController,
                        keyboardType: decimal,
                        suffixText: '%',
                        helperText: 'Tarifa menor al 1% conforme a política aprobada',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                ProPrimaryButton(
                  'Guardar y Versionar Parámetros Comerciales',
                  onTap: _saveParameters,
                  height: 48,
                  horizontalPadding: 16,
                  labelStyle: ProText.r(14, weight: FontWeight.w600, color: ProColors.surface0, lineHeight: 16.8),
                  trailing: null,
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
