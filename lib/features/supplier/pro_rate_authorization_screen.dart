import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Pantalla de decisión y gestión de autorización de tarifa profesional (P-026).
class ProRateAuthorizationScreen extends StatefulWidget {
  const ProRateAuthorizationScreen({
    super.key,
    required this.contractor,
  });

  final Contractor contractor;

  @override
  State<ProRateAuthorizationScreen> createState() => _ProRateAuthorizationScreenState();
}

class _ProRateAuthorizationScreenState extends State<ProRateAuthorizationScreen> {
  bool _isAuthorized = false;
  final _reasonController = TextEditingController(text: 'Contratista con más de 20 obras certificadas en Cali sur.');

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.contractor;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: 'Autorización Tarifa Pro',
        subtitle: c.name,
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Tarjeta del Contratista Solicitante
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.brandLight,
                    child: Text(
                      c.name.split(' ').map((n) => n[0]).take(2).join(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.brand700),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(c.name, style: AppTypography.subheading),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, color: AppColors.brand700, size: 16),
                          ],
                        ),
                        Text(c.trade, style: AppTypography.caption),
                        Text('${c.completedJobs} obras completadas · ${c.rating} ★', style: AppTypography.caption),
                      ],
                    ),
                  ),
                  AppBadge(
                    text: _isAuthorized ? 'Autorizado' : 'Pendiente',
                    variant: _isAuthorized ? AppBadgeVariant.success : AppBadgeVariant.warning,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text('Condiciones de la Tarifa Preferencial (P-026)', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Al autorizar al profesional, este podrá comprar pinturas y estucos a precio mayorista en tu bodega para sus cotizaciones de Rivet.',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Column(
                children: [
                  _buildDiscountRow('Vinilos y Esmaltes Pintuco', '12% de descuento'),
                  const Divider(color: AppColors.line300),
                  _buildDiscountRow('Estucos Corona y Masillas', '15% de descuento'),
                  const Divider(color: AppColors.line300),
                  _buildDiscountRow('Herramientas y Rodillos Master', '10% de descuento'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            AppTextField(
              label: 'Motivo o notas de vinculación',
              controller: _reasonController,
              maxLines: 2,
            ),

            const SizedBox(height: AppSpacing.xxl),

            if (!_isAuthorized) ...[
              AppButton(
                text: 'Aprobar y Vincular Contratista',
                icon: Icons.check,
                onPressed: () {
                  setState(() => _isAuthorized = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Tarifa profesional autorizada para este contratista!'),
                      backgroundColor: AppColors.brand700,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                text: 'Rechazar Solicitud',
                variant: AppButtonVariant.outline,
                onPressed: () => Navigator.pop(context),
              ),
            ] else ...[
              AppButton(
                text: 'Revocar Tarifa Profesional',
                variant: AppButtonVariant.danger,
                icon: Icons.block,
                onPressed: () {
                  setState(() => _isAuthorized = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tarifa profesional revocada.'),
                      backgroundColor: AppColors.danger700,
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountRow(String category, String benefit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(category, style: AppTypography.bodyMedium),
          Text(benefit, style: AppTypography.badgeText.copyWith(color: AppColors.brand700)),
        ],
      ),
    );
  }
}
