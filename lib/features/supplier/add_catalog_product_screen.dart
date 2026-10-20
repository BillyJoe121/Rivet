import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../home/widgets/kit/kit.dart';
import 'catalog_product_info.dart';
import 'widgets/catalog_common.dart';
import 'widgets/catalog_detail_parts.dart';

/// Agregar material al catálogo (frame 66:14377). Con [existingProduct] precarga sus datos.
class AddCatalogProductScreen extends StatefulWidget {
  const AddCatalogProductScreen({super.key, this.existingProduct});

  final MaterialProduct? existingProduct;

  @override
  State<AddCatalogProductScreen> createState() => _AddCatalogProductScreenState();
}

class _AddCatalogProductScreenState extends State<AddCatalogProductScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _clientPriceController;
  late final TextEditingController _proPriceController;
  final _skuController = TextEditingController(text: 'PV-003');
  final _presentationController = TextEditingController(text: 'Galón (1 gal)');
  final _descriptionController = TextEditingController(text: 'Pintura interior lavable, blanco mate. Para muros y cielos.');
  final _quantityController = TextEditingController(text: '60 unidades');
  final _minStockController = TextEditingController(text: '10 unidades');

  @override
  void initState() {
    super.initState();
    final product = widget.existingProduct;
    _nameController = TextEditingController(text: product?.name ?? 'Pintura vinilo premium');
    _brandController = TextEditingController(text: product?.brand ?? 'Rivet');
    _clientPriceController = TextEditingController(text: '\$ ${formatCop(product?.clientPriceCop ?? 87000)}');
    _proPriceController = TextEditingController(text: '\$ ${formatCop(product?.proPriceCop ?? 82000)}');
  }

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _brandController,
      _skuController,
      _presentationController,
      _descriptionController,
      _quantityController,
      _clientPriceController,
      _proPriceController,
      _minStockController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      backgroundAsset: ProAssets.headerPaintCorner,
      navWhenPushed: ProNavDestination.home,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100,
            child: Stack(
              children: [
                const Positioned(left: 24, top: 8, child: ProBackButton()),
                const Positioned(
                  left: 39,
                  top: 28,
                  child: SizedBox(width: 232, child: ProPageTitle('Agregar material')),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 5,
              children: [
                CatalogFormField(label: 'Nombre *', controller: _nameController),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(child: CatalogFormField(label: 'Categoría *', value: 'Pinturas  ⌄')),
                    Expanded(child: CatalogFormField(label: 'Marca *', controller: _brandController)),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(child: CatalogFormField(label: 'SKU o referencia *', controller: _skuController)),
                    Expanded(child: CatalogFormField(label: 'Presentación *', controller: _presentationController)),
                  ],
                ),
                Text(
                  '✓ Referencia disponible, sin duplicados.',
                  style: ProText.r(11, color: ProColors.brand700, lineHeight: 13.75),
                ),
                CatalogFormField(
                  label: 'Descripción *',
                  controller: _descriptionController,
                  height: 70,
                  maxLines: 2,
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(child: CatalogFormField(label: 'Unidad de venta *', value: 'Galón  ⌄')),
                    Expanded(child: CatalogFormField(label: 'Cantidad disponible *', controller: _quantityController)),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(child: CatalogFormField(label: 'Precio cliente * · COP', controller: _clientPriceController)),
                    Expanded(
                      child: CatalogFormField(label: 'Precio contratista * · COP', controller: _proPriceController),
                    ),
                  ],
                ),
                Text(
                  '✓ Precios por galón. Exclusivo solo con vínculo aprobado.',
                  style: ProText.r(11, color: ProColors.brand700, lineHeight: 13.75),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(child: CatalogFormField(label: 'Stock mínimo *', controller: _minStockController)),
                    Expanded(
                      child: CatalogFormField(label: 'Opciones de entrega *', value: '✓ Retiro  ✓ Domicilio'),
                    ),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    CatalogImage(
                      image: ProAssets.rivetPaint,
                      width: 70,
                      height: 55,
                      fit: BoxFit.contain,
                      radius: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 3,
                        children: [
                          Text(
                            'Imagen del producto *',
                            style: ProText.r(12, weight: FontWeight.w600, lineHeight: 15),
                          ),
                          Text(
                            'pintura-premium.jpg · JPG · 1,2 MB',
                            style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75),
                          ),
                          const _ChangeImageButton(),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  'Retiro gratis. Domicilio: costo y fecha al cotizar.',
                  style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: CatalogActionButton(
                        label: 'Cancelar',
                        outlined: true,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    Expanded(
                      child: CatalogActionButton(
                        label: 'Guardar material',
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Botón "Cambiar imagen" de 34 px con contorno de marca (sin acción por ahora).
class _ChangeImageButton extends StatelessWidget {
  const _ChangeImageButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ProColors.paper100,
        borderRadius: BorderRadius.circular(ProRadii.button),
        border: Border.all(color: ProColors.brand700, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Cambiar imagen',
              textAlign: TextAlign.center,
              style: ProText.r(12, weight: FontWeight.w600, color: ProColors.brand700, lineHeight: 14.4),
            ),
          ),
          const ProChevron(),
        ],
      ),
    );
  }
}
