import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Ficha de producto y cálculo de rendimiento técnico (P-024).
class MaterialDetailScreen extends StatelessWidget {
  const MaterialDetailScreen({
    super.key,
    required this.material,
    this.isProRate = false,
  });

  final MaterialProduct material;
  final bool isProRate;

  @override
  Widget build(BuildContext context) {
    final price = isProRate ? material.proPriceCop : material.clientPriceCop;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: material.brand,
        subtitle: material.category,
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Imagen Hero
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: material.imageAsset != null
                    ? Image.asset(
                        material.imageAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(color: AppColors.surfaceSubtle),
                      )
                    : Container(color: AppColors.surfaceSubtle),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Nombre y Precio
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(material.brand, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                      AppBadge(
                        text: material.inStock ? 'Disponible' : 'Agotado',
                        variant: material.inStock ? AppBadgeVariant.success : AppBadgeVariant.danger,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(material.name, style: AppTypography.sectionTitle),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Precio ${isProRate ? 'Tarifa Profesional' : 'General'}', style: AppTypography.caption),
                          Text(
                            '\$${_formatCurrency(price)} COP',
                            style: AppTypography.pageTitle.copyWith(color: AppColors.brand700, fontSize: 24),
                          ),
                        ],
                      ),
                      Text(material.unit, style: AppTypography.subheading),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Ficha Técnica de Rendimiento (P-018 / P-024)
            Text('Especificaciones y Rendimiento', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: AppStatTile(
                    label: 'RENDIMIENTO ESTIMADO',
                    value: material.coverageM2 > 0 ? '${material.coverageM2} m²' : 'N/A',
                    subtitle: 'A 2 manos en repinte',
                    icon: Icons.square_foot,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppStatTile(
                    label: 'PROVEEDOR',
                    value: material.supplierName,
                    subtitle: 'Despacho directo Cali',
                    icon: Icons.storefront,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Garantía técnica
            const AppCard(
              backgroundColor: AppColors.surfaceSubtle,
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.brand700),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Ficha técnica provista por el fabricante. La cobertura final puede variar según la porosidad de la pared.',
                      style: TextStyle(fontSize: 12, color: AppColors.ink700),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            AppButton(
              text: 'Agregar al Pedido de Obra (\$${_formatCurrency(price)})',
              icon: Icons.add_shopping_cart,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${material.name} agregado a la lista de insumos.'),
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

  static String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
