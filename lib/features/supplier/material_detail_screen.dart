import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Ficha de detalle de material idéntica al diseño editorial de Figma.
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
    final formattedPrice = '\$ ${_formatCurrency(price)}';

    return RivetScaffold(
      title: 'Detalle de\nmaterial',
      backgroundImagePath: 'Fondos/Rincón natural de pintura DIY.png',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.sm),

          // Imagen Central del Balde de Pintura
          Center(
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('Fondos/Rincón natural de pintura DIY.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Título de Producto y Marca
          Text(
            material.name,
            style: AppTypography.editorialHeading.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.home_outlined, size: 14, color: AppColors.ink500),
              const SizedBox(width: 4),
              Text(material.brand, style: AppTypography.caption.copyWith(color: AppColors.ink700)),
              Text(' · Interior lavable · Blanco mate', style: AppTypography.caption),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Píldora de Precio y Disponibilidad estilo Figma
          AppPriceBadge(
            priceCop: formattedPrice,
            unitText: 'por ${material.unit.toLowerCase()}',
            statusText: material.inStock ? 'Disponible' : 'Agotado',
            stockText: 'Más de 50 unidades',
          ),

          const SizedBox(height: AppSpacing.lg),

          // Lista de Especificaciones en Tarjeta Unificada
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppSpecRow(
                  icon: Icons.brightness_low_outlined,
                  label: 'Marca',
                  value: material.brand,
                ),
                AppSpecRow(
                  icon: Icons.work_outline,
                  label: 'Presentación',
                  value: material.unit,
                ),
                AppSpecRow(
                  icon: Icons.verified_outlined,
                  label: 'Rendimiento',
                  value: '${material.coverageM2} m² por galón',
                ),
                const AppSpecRow(
                  icon: Icons.shield_outlined,
                  label: 'Uso recomendado',
                  value: 'Interiores (muros y cielos)',
                ),
                const AppSpecRow(
                  icon: Icons.local_shipping_outlined,
                  label: 'Entrega',
                  value: 'A domicilio o retiro',
                ),
                AppSpecRow(
                  icon: Icons.storefront_outlined,
                  label: 'Proveedor',
                  value: material.supplierName,
                ),
                const AppSpecRow(
                  icon: Icons.description_outlined,
                  label: 'Especificaciones técnicas',
                  value: 'Ver PDF',
                  showDivider: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 100), // Espacio para botones fijos
        ],
      ),
      bottomBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.paper100,
          border: Border(top: BorderSide(color: AppColors.line300.withValues(alpha: 0.6))),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: AppButton(
                text: 'Guardar',
                variant: AppButtonVariant.secondary,
                trailingIcon: Icons.chevron_right,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 3,
              child: AppButton(
                text: 'Agregar al presupuesto',
                variant: AppButtonVariant.primary,
                trailingIcon: Icons.chevron_right,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${material.name} agregado al presupuesto.'),
                      backgroundColor: AppColors.brand700,
                    ),
                  );
                },
              ),
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
