import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(
        title: 'Políticas y Casos',
        subtitle: 'P-046 / P-047',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Resolución Fundada de Casos (P-046)', style: AppTypography.subheading),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Cada decisión administrativa debe quedar motivada con evidencia verificada sin borrar registros contables anteriores.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CASO #1082 · Pintura sala', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                        const AppBadge(text: 'Resolución Lista', variant: AppBadgeVariant.brand),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Partes: Juan Camilo Pérez vs. Carlos Mendoza', style: AppTypography.subheading.copyWith(fontSize: 14)),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Fundamento de la resolución administrativa',
                      controller: _resolutionNotesController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      text: 'Registrar y Notificar Decisión',
                      size: AppButtonSize.sm,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Resolución registrada y notificada a las partes.'),
                            backgroundColor: AppColors.brand700,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              Text('Configuración de Tarifas de Plataforma (P-047)', style: AppTypography.subheading),
              const SizedBox(height: AppSpacing.xs),
              Text('Parámetros comerciales globales. Los cambios solo aplican a acuerdos futuros.', style: AppTypography.caption),
              const SizedBox(height: AppSpacing.md),

              AppCard(
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Tarifa de gestión al Cliente (%)',
                      controller: _clientCommissionController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      suffixText: '%',
                      helperText: 'En V1 prototipo académico se mantiene en 0%',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Comisión al Contratista (%)',
                      controller: _contractorCommissionController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      suffixText: '%',
                      helperText: 'Deducción aplicable al desembolso de mano de obra',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Cargo sobre Materiales de Bodega (%)',
                      controller: _materialsFeeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      suffixText: '%',
                      helperText: 'Tarifa menor al 1% conforme a política aprobada',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              AppButton(
                text: 'Guardar y Versionar Parámetros Comerciales',
                icon: Icons.save_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Parámetros comerciales actualizados y versionados!'),
                      backgroundColor: AppColors.brand700,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
