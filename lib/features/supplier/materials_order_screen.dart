import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Pantalla para armar y cotizar la orden formal de materiales a bodega (P-036).
class MaterialsOrderScreen extends StatefulWidget {
  const MaterialsOrderScreen({
    super.key,
    this.initialProducts = const [],
  });

  final List<MaterialProduct> initialProducts;

  @override
  State<MaterialsOrderScreen> createState() => _MaterialsOrderScreenState();
}

class _MaterialsOrderScreenState extends State<MaterialsOrderScreen> {
  late List<MaterialProduct> _orderItems;
  final _addressController = TextEditingController(text: 'Carrera 98 # 42-15, Valle del Lili, Cali');
  bool _deliveryNeeded = true;

  @override
  void initState() {
    super.initState();
    _orderItems = widget.initialProducts.isNotEmpty
        ? widget.initialProducts
        : [MockData.materials[0], MockData.materials[2]];
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  int get _subtotal => _orderItems.fold(0, (acc, item) => acc + item.proPriceCop);
  int get _shipping => _deliveryNeeded ? 25000 : 0;
  int get _total => _subtotal + _shipping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(
        title: 'Pedido de Materiales',
        subtitle: 'FerreCasa Central · Cali',
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            Text('Ítems del Pedido (P-036)', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.xs),
            Text('Tarifas profesionales aplicadas a tu orden.', style: AppTypography.caption),
            const SizedBox(height: AppSpacing.md),

            ..._orderItems.map((mat) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    child: Row(
                      children: [
                        const Icon(Icons.format_paint, color: AppColors.brand700),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mat.name, style: AppTypography.subheading.copyWith(fontSize: 14)),
                              Text('${mat.brand} · ${mat.unit}', style: AppTypography.caption),
                            ],
                          ),
                        ),
                        Text('\$${_formatCurrency(mat.proPriceCop)}', style: AppTypography.badgeText),
                      ],
                    ),
                  ),
                )),

            const SizedBox(height: AppSpacing.xl),

            // Modalidad de entrega
            Text('Método de Entrega', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.md),

            RadioGroup<bool>(
              groupValue: _deliveryNeeded,
              onChanged: (val) => setState(() => _deliveryNeeded = val ?? true),
              child: AppCard(
                child: Column(
                  children: [
                    RadioListTile<bool>(
                      value: true,
                      title: const Text('Despacho directo a la obra (+ \$25.000 COP)'),
                      subtitle: const Text('Entrega programada en camión cerrado'),
                      activeColor: AppColors.brand700,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(color: AppColors.line300),
                    RadioListTile<bool>(
                      value: false,
                      title: const Text('Retiro en bodega principal (\$0)'),
                      subtitle: const Text('FerreCasa Sede Norte'),
                      activeColor: AppColors.brand700,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),

            if (_deliveryNeeded) ...[
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Dirección de obra para entrega',
                controller: _addressController,
                prefixIcon: Icons.local_shipping_outlined,
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            // Resumen de costos
            AppCard(
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal materiales', '\$${_formatCurrency(_subtotal)}'),
                  _buildSummaryRow('Flete de despacho', '\$${_formatCurrency(_shipping)}'),
                  const Divider(color: AppColors.line300, thickness: 1.5),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL PEDIDO', style: AppTypography.subheading),
                      Text(
                        '\$${_formatCurrency(_total)} COP',
                        style: AppTypography.sectionTitle.copyWith(color: AppColors.brand700),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            AppButton(
              text: 'Enviar Pedido a Bodega (\$${_formatCurrency(_total)})',
              icon: Icons.send,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Pedido enviado a FerreCasa Central! En preparación.'),
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

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
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
