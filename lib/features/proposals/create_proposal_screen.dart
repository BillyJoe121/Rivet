import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Pantalla donde el contratista crea y envía su propuesta (P-027).
class CreateProposalScreen extends StatefulWidget {
  const CreateProposalScreen({super.key, required this.project});

  final Project project;

  @override
  State<CreateProposalScreen> createState() => _CreateProposalScreenState();
}

class _CreateProposalScreenState extends State<CreateProposalScreen> {
  final _laborCostController = TextEditingController(text: '750000');
  final _materialsCostController = TextEditingController(text: '380000');
  final _daysController = TextEditingController(text: '3');
  final _notesController = TextEditingController(
    text: 'Incluye resane de fisuras, imprimación y 2 manos de Viniltex lavable. Protección de piso con plástico.',
  );

  int get _total =>
      (int.tryParse(_laborCostController.text) ?? 0) +
      (int.tryParse(_materialsCostController.text) ?? 0);

  @override
  void dispose() {
    _laborCostController.dispose();
    _materialsCostController.dispose();
    _daysController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: 'Crear Propuesta',
        subtitle: widget.project.title,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Resumen de la obra
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Datos de la obra a cotizar', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(widget.project.title, style: AppTypography.subheading),
                    Text('${widget.project.city} · ${widget.project.neighborhood}', style: AppTypography.caption),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Área total: ${widget.project.totalAreaM2.toStringAsFixed(1)} m² (${widget.project.surfaces.length} paredes)',
                      style: AppTypography.badgeText.copyWith(color: AppColors.brand700),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Text('Desglose de Cotización (P-027)', style: AppTypography.subheading.copyWith(fontSize: 18)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Especifica tu mano de obra por separado de los materiales calculados.',
                style: AppTypography.bodySmall,
              ),

              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                label: 'Mano de Obra (COP)',
                hint: 'Ej. 750000',
                keyboardType: TextInputType.number,
                controller: _laborCostController,
                suffixText: 'COP',
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Materiales Estimados (COP)',
                hint: 'Ej. 380000',
                keyboardType: TextInputType.number,
                controller: _materialsCostController,
                suffixText: 'COP',
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Plazo de ejecución (Días hábiles)',
                hint: 'Ej. 3',
                keyboardType: TextInputType.number,
                controller: _daysController,
              ),

              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Observaciones y alcance técnico',
                hint: 'Explica qué incluye tu oferta y cómo protegerás el espacio.',
                maxLines: 3,
                controller: _notesController,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Total Resumen
              AppCard(
                backgroundColor: AppColors.brandLight,
                borderColor: AppColors.brand700.withValues(alpha: 0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL ESTIMADO PROPUESTA', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                        Text('\$${_formatCurrency(_total)} COP', style: AppTypography.sectionTitle.copyWith(color: AppColors.brand700)),
                      ],
                    ),
                    const Icon(Icons.check_circle_outline, color: AppColors.brand700, size: 28),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              AppButton(
                text: 'Enviar Propuesta al Cliente',
                icon: Icons.send,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Propuesta enviada con éxito al cliente!'),
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

  static String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
