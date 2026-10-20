import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Pantalla de seguimiento de obra y doble confirmación final (P-034 / P-042).
class WorkProgressScreen extends StatefulWidget {
  const WorkProgressScreen({super.key, required this.proposal});

  final Proposal proposal;

  @override
  State<WorkProgressScreen> createState() => _WorkProgressScreenState();
}

class _WorkProgressScreenState extends State<WorkProgressScreen> {
  bool _clientApproved = false;
  bool _contractorApproved = true;
  double _rating = 5.0;
  final _commentController = TextEditingController(text: 'Excelente pulcritud y cumplimiento con los tiempos acordados.');

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prop = widget.proposal;
    final bothApproved = _clientApproved && _contractorApproved;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: 'Seguimiento de Obra',
        subtitle: prop.contractor.name,
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Estado General
            AppCard(
              backgroundColor: bothApproved ? AppColors.brandLight : AppColors.surface0,
              borderColor: bothApproved ? AppColors.brand700 : AppColors.line300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ESTADO DE LA OBRA', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                      AppBadge(
                        text: bothApproved ? 'Finalizado y Pagado' : 'En Ejecución',
                        variant: bothApproved ? AppBadgeVariant.success : AppBadgeVariant.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Pintura y resane en sala', style: AppTypography.subheading),
                  Text('Profesional: ${prop.contractor.name}', style: AppTypography.caption),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: AppStatTile(
                          label: 'MANO DE OBRA',
                          value: '\$${_formatCurrency(prop.laborCostCop)}',
                          subtitle: bothApproved ? 'Liberada' : 'En custodia simulada',
                          icon: Icons.payments_outlined,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppStatTile(
                          label: 'TIEMPO ESTIMADO',
                          value: '${prop.estimatedDays} días',
                          icon: Icons.schedule,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Regla de Doble Confirmación (P-034)
            Text('Doble Confirmación de Cierre (P-034)', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Por regla de seguridad, los fondos solo se liberan cuando AMBAS partes confirman que el trabajo fue entregado a satisfacción.',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: _contractorApproved,
                      onChanged: (val) => setState(() => _contractorApproved = val ?? false),
                      title: const Text('Confirmación del Contratista: Trabajo terminado y entregado'),
                      subtitle: const Text('Registrado por Carlos Mendoza', style: TextStyle(fontSize: 12)),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.brand700,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(color: AppColors.line300),
                    CheckboxListTile(
                      value: _clientApproved,
                      onChanged: (val) => setState(() => _clientApproved = val ?? false),
                      title: const Text('Confirmación del Cliente: Recibí el trabajo a conformidad'),
                      subtitle: const Text('Marca para autorizar el desembolso', style: TextStyle(fontSize: 12)),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.brand700,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Calificación del Servicio (P-042)
            if (bothApproved) ...[
              Text('Calificación y Reseña (P-042)', style: AppTypography.subheading),
              const SizedBox(height: AppSpacing.xs),
              Text('Tu opinión ayudará a otros clientes a elegir profesionales confiables.', style: AppTypography.caption),
              const SizedBox(height: AppSpacing.md),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        return IconButton(
                          icon: Icon(
                            starValue <= _rating ? Icons.star : Icons.star_border,
                            color: AppColors.clay600,
                            size: 32,
                          ),
                          onPressed: () => setState(() => _rating = starValue.toDouble()),
                        );
                      }),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Comentario sobre la labor realizada',
                      controller: _commentController,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              AppButton(
                text: 'Enviar Calificación y Cerrar Obra',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Reseña registrada y obra finalizada exitosamente!'),
                      backgroundColor: AppColors.brand700,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ] else ...[
              AppButton(
                text: 'Solicitar Prórroga de Fecha (P-035)',
                variant: AppButtonVariant.outline,
                icon: Icons.event_repeat_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Solicitud de prórroga enviada para acuerdo mutuo.')),
                  );
                },
              ),
            ],
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
