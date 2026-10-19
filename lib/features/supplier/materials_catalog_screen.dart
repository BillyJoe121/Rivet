import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'material_detail_screen.dart';

/// Catálogo de materiales y bodega (P-023 / P-025).
class MaterialsCatalogScreen extends StatefulWidget {
  const MaterialsCatalogScreen({
    super.key,
    this.isProRateView = false,
    this.isSupplierAdmin = false,
  });

  final bool isProRateView;
  final bool isSupplierAdmin;

  @override
  State<MaterialsCatalogScreen> createState() => _MaterialsCatalogScreenState();
}

class _MaterialsCatalogScreenState extends State<MaterialsCatalogScreen> {
  late bool _proRateActive;
  String _selectedCategory = 'Todos';

  @override
  void initState() {
    super.initState();
    _proRateActive = widget.isProRateView;
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Todos', 'Pintura', 'Estuco', 'Impermeabilizante', 'Herramientas'];
    final allMaterials = MockData.materials;
    final filtered = _selectedCategory == 'Todos'
        ? allMaterials
        : allMaterials.where((m) => m.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: 'Bodega de Materiales',
        subtitle: 'FerreCasa Central · Cali',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            tooltip: 'Carrito',
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Interruptor de Tarifa (Cliente vs Profesional)
          AppCard(
            backgroundColor: _proRateActive ? AppColors.brandLight : AppColors.surface0,
            borderColor: _proRateActive ? AppColors.brand700 : AppColors.line300,
            child: Row(
              children: [
                Icon(
                  _proRateActive ? Icons.verified : Icons.lock_outline,
                  color: _proRateActive ? AppColors.brand700 : AppColors.ink500,
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _proRateActive ? 'Tarifa Profesional Activa' : 'Tarifa Público General',
                        style: AppTypography.subheading.copyWith(fontSize: 14),
                      ),
                      Text(
                        _proRateActive
                            ? 'Precios mayoristas autorizados por el proveedor.'
                            : 'Precios de referencia para el cliente.',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _proRateActive,
                  onChanged: (val) => setState(() => _proRateActive = val),
                  activeTrackColor: AppColors.brand700,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Categorías en Pills horizontales
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.brand700 : AppColors.surface0,
                        borderRadius: AppSpacing.roundedPill,
                        border: Border.all(
                          color: isSelected ? AppColors.brand700 : AppColors.line300,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: AppTypography.badgeText.copyWith(
                          color: isSelected ? Colors.white : AppColors.ink700,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Lista de Productos
          ...filtered.map((mat) {
            final price = _proRateActive ? mat.proPriceCop : mat.clientPriceCop;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MaterialDetailScreen(
                        material: mat,
                        isProRate: _proRateActive,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 72,
                        height: 72,
                        color: AppColors.surfaceSubtle,
                        child: mat.imageAsset != null
                            ? Image.asset(
                                mat.imageAsset!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const Icon(Icons.format_paint, color: AppColors.ink500),
                              )
                            : const Icon(Icons.format_paint, color: AppColors.ink500),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(mat.brand, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(width: AppSpacing.xs),
                              const Icon(Icons.circle, size: 4, color: AppColors.ink500),
                              const SizedBox(width: AppSpacing.xs),
                              Text(mat.unit, style: AppTypography.caption),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(mat.name, style: AppTypography.subheading.copyWith(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(
                            '\$${_formatCurrency(price)} COP',
                            style: AppTypography.subheading.copyWith(
                              color: AppColors.brand700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_proRateActive)
                            Text(
                              'Ahorro: \$${_formatCurrency(mat.clientPriceCop - mat.proPriceCop)}',
                              style: AppTypography.caption.copyWith(color: AppColors.clay600, fontWeight: FontWeight.w600),
                            ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.ink500),
                  ],
                ),
              ),
            );
          }),
        ],
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
