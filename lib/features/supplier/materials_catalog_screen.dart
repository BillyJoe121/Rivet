import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'material_detail_screen.dart';

/// Catálogo de materiales y bodega refinado estilo Figma (P-023 / P-025).
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
    final categories = ['Todos', 'Pintura', 'Estuco', 'Impermeabilizante'];
    final allMaterials = MockData.materials;
    final filtered = _selectedCategory == 'Todos'
        ? allMaterials
        : allMaterials.where((m) => m.category == _selectedCategory).toList();

    return RivetScaffold(
      title: 'Bodega de\nMateriales',
      showBackButton: false,
      backgroundImagePath: 'Fondos/Tienda minimalista entre plantas verdes.png',
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.ink900, size: 24),
          tooltip: 'Carrito',
          onPressed: () {},
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.sm),

          // Interruptor de Tarifa (Cliente vs Profesional) estilo Figma
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Row(
              children: [
                const Icon(Icons.lock_outline, color: AppColors.ink500, size: 22),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _proRateActive ? 'Tarifa Profesional' : 'Tarifa Público General',
                        style: AppTypography.subheading.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _proRateActive
                            ? 'Precios mayoristas activos para compras de obra.'
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

          // Filtro de Categorías en Píldoras Horizontales
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
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.brand700 : AppColors.surface0,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.brand700 : AppColors.line300,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: AppTypography.caption.copyWith(
                          color: isSelected ? Colors.white : AppColors.ink700,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Lista de Productos en Tarjetas Flotantes con Chevron y Thumbnail
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
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 68,
                        height: 68,
                        color: AppColors.brandLight,
                        child: Image.asset(
                          'Fondos/Rincón natural de pintura DIY.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(Icons.format_paint, color: AppColors.brand700),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${mat.brand} · ${mat.unit}',
                            style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            mat.name,
                            style: AppTypography.subheading.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$ ${_formatCurrency(price)} COP',
                            style: AppTypography.subheading.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.brand700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 20, color: AppColors.ink500),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.xxl),
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
