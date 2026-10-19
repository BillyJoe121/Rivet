import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Seguimiento, plazos y resolución de una reclamación (P-041).
class IncidentDetailScreen extends StatelessWidget {
  const IncidentDetailScreen({
    super.key,
    this.caseId = 'CASO-1082',
    this.projectTitle = 'Pintura y resane en sala',
  });

  final String caseId;
  final String projectTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: 'Detalle de Caso',
        subtitle: caseId,
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Cabecera del Caso
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(caseId, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                      const AppBadge(text: 'En Mediación', variant: AppBadgeVariant.warning),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(projectTitle, style: AppTypography.subheading),
                  Text('Apertura: 19 Octubre 2026 · Plazo máximo: 72 horas', style: AppTypography.caption),
                  const SizedBox(height: AppSpacing.md),
                  const AppStatTile(
                    label: 'SALDO AFECTADO EN REVISIÓN',
                    value: '\$780.000 COP',
                    subtitle: 'Mano de obra retenida preventivamente',
                    highlight: true,
                    icon: Icons.gavel,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Línea de Tiempo del Caso
            Text('Línea de Tiempo del Expediente (P-041)', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.xs),
            Text('Respuestas y evidencias aportadas por ambas partes.', style: AppTypography.caption),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Column(
                children: [
                  _buildTimelineItem(
                    title: 'Caso Radicado por Cliente',
                    date: '19 Oct · 09:30 AM',
                    description: 'Reporte de grieta visible sin resanar adecuadamente tras la primera mano.',
                    isDone: true,
                  ),
                  const Divider(color: AppColors.line300),
                  _buildTimelineItem(
                    title: 'Respuesta del Contratista Recibida',
                    date: '19 Oct · 11:15 AM',
                    description: 'Carlos Mendoza acordó aplicar masilla elastomérica y lija fina sin costo extra.',
                    isDone: true,
                  ),
                  const Divider(color: AppColors.line300),
                  _buildTimelineItem(
                    title: 'Visita de Verificación Programada',
                    date: 'Pendiente · 20 Oct',
                    description: 'Acuerdo de visita para verificar el resane antes de autorizar el cierre.',
                    isDone: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Regla de Protección
            const AppCard(
              backgroundColor: AppColors.surfaceSubtle,
              child: Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: AppColors.brand700),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'El paso de la fecha límite no libera automáticamente los fondos. Se requiere comprobación de acuerdo entre las partes.',
                      style: TextStyle(fontSize: 12, color: AppColors.ink700),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            AppButton(
              text: 'Aceptar Acuerdo Propuesto por Contratista',
              icon: Icons.check,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Acuerdo aceptado! Se programó la rectificación en obra.'),
                    backgroundColor: AppColors.brand700,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String date,
    required String description,
    required bool isDone,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? AppColors.brand700 : AppColors.ink500,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTypography.subheading.copyWith(fontSize: 13)),
                    Text(date, style: AppTypography.caption),
                  ],
                ),
                const SizedBox(height: 2),
                Text(description, style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
