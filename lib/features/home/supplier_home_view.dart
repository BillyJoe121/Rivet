import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'widgets/supplier_order_card.dart';

/// Vista de inicio y gestión para el rol Proveedor / Ferretería ("FerreCasa Central").
class SupplierHomeView extends StatefulWidget {
  const SupplierHomeView({
    super.key,
    this.onSwitchRole,
    this.initialTab = 0,
  });

  final ValueChanged<UserRole>? onSwitchRole;
  final int initialTab;

  @override
  State<SupplierHomeView> createState() => _SupplierHomeViewState();
}

class _SupplierHomeViewState extends State<SupplierHomeView> {
  late int _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.brand700,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.storefront, color: Colors.white, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FerreCasa Central', style: AppTypography.subheading.copyWith(fontSize: 16)),
                Text('Sede Norte y Despachos Cali', style: AppTypography.caption),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            tooltip: 'Configuración comercial',
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          AppSegmentedControl<int>(
            items: const {
              0: 'Resumen',
              1: 'Despachos (2)',
              2: 'Red Pro (1)',
            },
            selected: _activeTab,
            onChanged: (tab) => setState(() => _activeTab = tab),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_activeTab == 0) ..._buildSummarySection()
          else if (_activeTab == 1) ..._buildOrdersSection()
          else ..._buildProNetworkSection(),
        ],
      ),
    );
  }

  List<Widget> _buildSummarySection() {
    return [
      Row(
        children: [
          Expanded(
            child: AppStatTile(
              label: 'PEDIDOS HOY',
              value: '4 pedidos',
              subtitle: '\$1.180.000 COP',
              highlight: true,
              icon: Icons.local_shipping_outlined,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: AppStatTile(
              label: 'CONTRATISTAS PRO',
              value: '18 activos',
              subtitle: '1 pendiente',
              icon: Icons.badge_outlined,
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.xxl),
      Text('Pedidos Urgentes por Despachar', style: AppTypography.sectionTitle.copyWith(fontSize: 18)),
      const SizedBox(height: AppSpacing.md),
      const SupplierOrderCard(
        id: 'PED-901',
        projectTitle: 'Obra Valle del Lili · Pintura sala',
        contractorName: 'Carlos Mendoza',
        items: '1 Cuñete Viniltex Blanco + 1 Balde Estuco Corona',
        totalCop: '304.000 COP',
        status: 'Por despachar',
        statusVariant: AppBadgeVariant.warning,
      ),
      const SizedBox(height: AppSpacing.md),
      const SupplierOrderCard(
        id: 'PED-902',
        projectTitle: 'Obra Ciudad Jardín · Habitación',
        contractorName: 'Jorge Eliécer Silva',
        items: '2 Galones Viniltex Verde + 1 Kit Rodillo',
        totalCop: '150.000 COP',
        status: 'En ruta',
        statusVariant: AppBadgeVariant.brand,
      ),
    ];
  }

  List<Widget> _buildOrdersSection() {
    return [
      Text('Gestión de Despachos y Envíos', style: AppTypography.sectionTitle.copyWith(fontSize: 18)),
      const SizedBox(height: AppSpacing.xs),
      Text('Separa los materiales listos para entrega directa o retiro en bodega.', style: AppTypography.caption),
      const SizedBox(height: AppSpacing.md),
      const SupplierOrderCard(
        id: 'PED-901',
        projectTitle: 'Obra Valle del Lili',
        contractorName: 'Carlos Mendoza',
        items: '1 Cuñete Viniltex Blanco + 1 Balde Estuco Corona',
        totalCop: '304.000 COP',
        status: 'Preparando paquete',
        statusVariant: AppBadgeVariant.warning,
        hasActionButton: true,
      ),
      const SizedBox(height: AppSpacing.md),
      const SupplierOrderCard(
        id: 'PED-899',
        projectTitle: 'Remodelación Granada',
        contractorName: 'Alonso Restrepo',
        items: '3 Galones Sika Impermeabilizante',
        totalCop: '195.000 COP',
        status: 'Entregado en obra',
        statusVariant: AppBadgeVariant.success,
      ),
    ];
  }

  List<Widget> _buildProNetworkSection() {
    return [
      Text('Solicitudes de Tarifa Profesional', style: AppTypography.sectionTitle.copyWith(fontSize: 18)),
      const SizedBox(height: AppSpacing.xs),
      Text('Los contratistas vinculados acceden a tus precios especiales de catálogo.', style: AppTypography.caption),
      const SizedBox(height: AppSpacing.md),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.clayLight,
                  child: const Text('AR', style: TextStyle(color: AppColors.clay600, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alonso Restrepo', style: AppTypography.subheading),
                      Text('Pintor de fachadas · 22 trabajos verificados', style: AppTypography.caption),
                    ],
                  ),
                ),
                const AppBadge(text: 'Pendiente', variant: AppBadgeVariant.warning),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Solicita acceso a tarifa preferencial para compra de 3 cuñetes mensuales de pintura para exteriores.',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Rechazar',
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.sm,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    text: 'Aprobar Tarifa Pro',
                    variant: AppButtonVariant.primary,
                    size: AppButtonSize.sm,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
