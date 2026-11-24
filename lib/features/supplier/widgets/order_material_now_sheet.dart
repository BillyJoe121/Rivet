import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../material_price_tier.dart';

/// Abre el flujo de compra directa ("Pedir ahora mismo") con pago simulado.
Future<void> showOrderMaterialNowSheet(
  BuildContext context, {
  required MaterialProduct product,
  required MaterialPriceTier tier,
}) {
  return showAppBottomSheet<void>(
    context,
    builder: (_) => _OrderMaterialNowSheet(product: product, tier: tier),
  );
}

class _OrderMaterialNowSheet extends StatefulWidget {
  const _OrderMaterialNowSheet({required this.product, required this.tier});

  final MaterialProduct product;
  final MaterialPriceTier tier;

  @override
  State<_OrderMaterialNowSheet> createState() => _OrderMaterialNowSheetState();
}

class _OrderMaterialNowSheetState extends State<_OrderMaterialNowSheet> {
  int _quantity = 1;
  bool _confirmed = false;
  final TextEditingController _addressController = TextEditingController(
    text: 'Cra. 102 #14-80, Ciudad Jardín, Cali',
  );

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitPrice = widget.tier.priceOf(widget.product);
    final total = unitPrice * _quantity;

    if (_confirmed) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.circleCheck,
                color: AppColors.brand700,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Pedido registrado · Pago simulado',
                  style: AppTypography.sectionTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppSpecRow(
            icon: LucideIcons.packageCheck,
            label: 'Producto',
            value: '$_quantity × ${widget.product.name}',
          ),
          AppSpecRow(
            icon: LucideIcons.mapPin,
            label: 'Dirección de despacho',
            value: _addressController.text,
          ),
          AppSpecRow(
            icon: LucideIcons.truck,
            label: 'Entrega estimada en Cali',
            value: '24 a 48 horas hábiles',
          ),
          AppSpecRow(
            icon: LucideIcons.coins,
            label: 'Total Pago simulado',
            value: '\$ ${formatCop(total)} COP',
            showDivider: false,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'Listo',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pedir ahora mismo',
                  style: AppTypography.sectionTitle,
                ),
              ),
              const AppBadge(
                text: 'Pago simulado',
                variant: AppBadgeVariant.warning,
                compact: true,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.product.name} · Despacho directo desde Bodega Rivet Cali',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cantidad (${widget.product.unit})',
                style: AppTypography.labelStrong,
              ),
              AppQuantityStepper(
                value: _quantity,
                min: 1,
                onChanged: (val) => setState(() => _quantity = val),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _addressController,
            label: 'Dirección de entrega en Cali',
            prefixIcon: LucideIcons.mapPin,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.brandLight,
              borderRadius: AppSpacing.roundedMd,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total a pagar (simulado):',
                  style: AppTypography.bodySmall,
                ),
                Text(
                  '\$ ${formatCop(total)} COP',
                  style: AppTypography.subheading.copyWith(
                    color: AppColors.brand700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'Confirmar pedido · Pago simulado (\$ ${formatCop(total)})',
            showChevron: true,
            onPressed: () => setState(() => _confirmed = true),
          ),
        ],
      ),
    );
  }
}
