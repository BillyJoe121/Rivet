import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../explorer/screen_explorer_screen.dart';
import 'client_home_view.dart';
import 'contractor_home_view.dart';
import 'supplier_home_view.dart';
import '../projects/my_projects_screen.dart';
import '../contractors/contractors_directory_screen.dart';
import '../supplier/materials_catalog_screen.dart';
import '../account/profile_screen.dart';

/// Shell principal refinado con barra de navegación limpia y elegante estilo Figma.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialRole = UserRole.client});

  final UserRole initialRole;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late UserRole _currentRole;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentRole = widget.initialRole;
  }

  void _switchRole(UserRole newRole) {
    setState(() {
      _currentRole = newRole;
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentBody = _buildBody();

    return Scaffold(
      backgroundColor: AppColors.paper100,
      body: currentBody,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.paper100,
          border: Border(top: BorderSide(color: AppColors.line300.withValues(alpha: 0.6))),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildNavTabs(),
            ),
          ),
        ),
      ),
      // Botón flotante discreto y redondeado para el explorador
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScreenExplorerScreen(
                currentRole: _currentRole,
                onRoleChanged: _switchRole,
              ),
            ),
          );
        },
        backgroundColor: AppColors.brand700,
        foregroundColor: Colors.white,
        tooltip: 'Explorador 45 Pantallas',
        child: const Icon(Icons.grid_view_outlined, size: 20),
      ),
    );
  }

  List<Widget> _buildNavTabs() {
    final tabs = switch (_currentRole) {
      UserRole.client => const [
          (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Inicio'),
          (icon: Icons.description_outlined, activeIcon: Icons.description, label: 'Proyectos'),
          (icon: Icons.local_offer_outlined, activeIcon: Icons.local_offer, label: 'Propuestas'),
          (icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: 'Mensajes'),
          (icon: Icons.more_horiz, activeIcon: Icons.more_horiz, label: 'Más'),
        ],
      UserRole.contractor => const [
          (icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Inicio'),
          (icon: Icons.search_outlined, activeIcon: Icons.search, label: 'Obras'),
          (icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'Ofertas'),
          (icon: Icons.storefront_outlined, activeIcon: Icons.storefront, label: 'Bodega'),
          (icon: Icons.more_horiz, activeIcon: Icons.more_horiz, label: 'Más'),
        ],
      UserRole.supplier => const [
          (icon: Icons.store_outlined, activeIcon: Icons.store, label: 'Inicio'),
          (icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2, label: 'Catálogo'),
          (icon: Icons.local_shipping_outlined, activeIcon: Icons.local_shipping, label: 'Pedidos'),
          (icon: Icons.group_outlined, activeIcon: Icons.group, label: 'Red Pro'),
          (icon: Icons.more_horiz, activeIcon: Icons.more_horiz, label: 'Más'),
        ],
    };

    return tabs.asMap().entries.map((entry) {
      final idx = entry.key;
      final tab = entry.value;
      final isSelected = _currentIndex == idx;

      return InkWell(
        onTap: () => setState(() => _currentIndex = idx),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? tab.activeIcon : tab.icon,
                size: 24,
                color: isSelected ? AppColors.brand700 : AppColors.ink500,
              ),
              const SizedBox(height: 3),
              Text(
                tab.label,
                style: AppTypography.caption.copyWith(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.brand700 : AppColors.ink500,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBody() {
    switch (_currentRole) {
      case UserRole.client:
        return switch (_currentIndex) {
          0 => ClientHomeView(onSwitchRole: _switchRole),
          1 => const MyProjectsScreen(),
          2 => const ContractorsDirectoryScreen(),
          3 => const MaterialsCatalogScreen(isProRateView: false),
          _ => ProfileScreen(currentRole: _currentRole, onSwitchRole: _switchRole),
        };
      case UserRole.contractor:
        return switch (_currentIndex) {
          0 => ContractorHomeView(onSwitchRole: _switchRole),
          1 => const MyProjectsScreen(forContractor: true),
          2 => const MyProjectsScreen(showBidsOnly: true),
          3 => const MaterialsCatalogScreen(isProRateView: true),
          _ => ProfileScreen(currentRole: _currentRole, onSwitchRole: _switchRole),
        };
      case UserRole.supplier:
        return switch (_currentIndex) {
          0 => SupplierHomeView(onSwitchRole: _switchRole),
          1 => const MaterialsCatalogScreen(isProRateView: true),
          2 => const SupplierHomeView(initialTab: 1),
          3 => const SupplierHomeView(initialTab: 2),
          _ => ProfileScreen(currentRole: _currentRole, onSwitchRole: _switchRole),
        };
    }
  }
}
