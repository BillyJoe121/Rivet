import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Pantalla para agregar o actualizar un producto al catálogo de bodega (P-025).
class AddCatalogProductScreen extends StatefulWidget {
  const AddCatalogProductScreen({super.key, this.existingProduct});

  final MaterialProduct? existingProduct;

  @override
  State<AddCatalogProductScreen> createState() => _AddCatalogProductScreenState();
}

class _AddCatalogProductScreenState extends State<AddCatalogProductScreen> {
  final _skuController = TextEditingController(text: 'PINT-VTX-01');
  final _nameController = TextEditingController(text: 'Viniltex Satinado Antibacterial');
  final _brandController = TextEditingController(text: 'Pintuco');
  final _clientPriceController = TextEditingController(text: '72000');
  final _proPriceController = TextEditingController(text: '61000');
  final _coverageController = TextEditingController(text: '28');
  String _category = 'Pintura';
  String _unit = 'Galón';

  @override
  void dispose() {
    _skuController.dispose();
    _nameController.dispose();
    _brandController.dispose();
    _clientPriceController.dispose();
    _proPriceController.dispose();
    _coverageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingProduct != null;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: isEditing ? 'Editar Producto' : 'Agregar Material',
        subtitle: 'FerreCasa Central · Catálogo',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Ficha de Inventario (P-025)', style: AppTypography.subheading.copyWith(fontSize: 18)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Define las tarifas diferenciadas para venta a clientes y contratistas vinculados.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),

              AppCard(
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Código SKU o Referencia',
                      controller: _skuController,
                      hint: 'Ej. PINT-VTX-01',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Nombre Comercial',
                      controller: _nameController,
                      hint: 'Ej. Viniltex Blanco',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Marca / Fabricante',
                            controller: _brandController,
                            hint: 'Ej. Pintuco, Corona',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Categoría', style: AppTypography.subheading.copyWith(fontSize: 14)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.surface0,
                                  borderRadius: AppSpacing.roundedSm,
                                  border: Border.all(color: AppColors.line300),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _category,
                                    isExpanded: true,
                                    items: ['Pintura', 'Estuco', 'Impermeabilizante', 'Herramientas']
                                        .map((c) => DropdownMenuItem(value: c, child: Text(c, style: AppTypography.bodyMedium)))
                                        .toList(),
                                    onChanged: (val) => setState(() => _category = val ?? _category),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Presentación / Unidad', style: AppTypography.subheading.copyWith(fontSize: 14)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.surface0,
                                  borderRadius: AppSpacing.roundedSm,
                                  border: Border.all(color: AppColors.line300),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _unit,
                                    isExpanded: true,
                                    items: ['Galón', 'Cuñete (5 gal)', 'Balde (20 kg)', 'Bulto 25kg', 'Kit']
                                        .map((u) => DropdownMenuItem(value: u, child: Text(u, style: AppTypography.bodyMedium)))
                                        .toList(),
                                    onChanged: (val) => setState(() => _unit = val ?? _unit),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppTextField(
                            label: 'Rendimiento (m²)',
                            controller: _coverageController,
                            keyboardType: TextInputType.number,
                            suffixText: 'm²',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Text('Tarifas Comerciales', style: AppTypography.subheading),
              const SizedBox(height: AppSpacing.xs),
              Text('El contratista verá su tarifa autorizada al armar su propuesta.', style: AppTypography.caption),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Precio Público General',
                      controller: _clientPriceController,
                      keyboardType: TextInputType.number,
                      suffixText: 'COP',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Tarifa Profesional (Pro)',
                      controller: _proPriceController,
                      keyboardType: TextInputType.number,
                      suffixText: 'COP',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              AppButton(
                text: isEditing ? 'Guardar Cambios' : 'Publicar en Catálogo',
                icon: Icons.check,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Material guardado en el catálogo con éxito!'),
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
