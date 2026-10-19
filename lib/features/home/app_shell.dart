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

/// Shell principal con navegación por pestañas adaptada al rol activo.
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
    final navItems = _buildNavItems();
    final currentBody = _buildBody();

    return Scaffold(
      body: currentBody,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface0,
          border: Border(top: BorderSide(color: AppColors.line300, width: 1)),
        ),
        child: SafeArea(
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
            backgroundColor: AppColors.surface0,
            indicatorColor: AppColors.brandLight,
            elevation: 0,
            height: 62,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: navItems,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
        backgroundColor: AppColors.ink900,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.grid_view_outlined, size: 18),
        label: const Text(
          'Explorador 45 Pantallas',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  List<NavigationDestination> _buildNavItems() {
    return switch (_currentRole) {
      UserRole.client => const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.brand700),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: AppColors.brand700),
            label: 'Proyectos',
          ),
          NavigationDestination(
            icon: Icon(Icons.engineering_outlined),
            selectedIcon: Icon(Icons.engineering, color: AppColors.brand700),
            label: 'Pintores',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: AppColors.brand700),
            label: 'Bodega',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.brand700),
            label: 'Perfil',
          ),
        ],
      UserRole.contractor => const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.brand700),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search, color: AppColors.brand700),
            label: 'Obras',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: AppColors.brand700),
            label: 'Ofertas',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: AppColors.brand700),
            label: 'Bodega',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.brand700),
            label: 'Perfil',
          ),
        ],
      UserRole.supplier => const [
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store, color: AppColors.brand700),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2, color: AppColors.brand700),
            label: 'Catálogo',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping, color: AppColors.brand700),
            label: 'Pedidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group, color: AppColors.brand700),
            label: 'Red Pro',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.brand700),
            label: 'Perfil',
          ),
        ],
    };
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
          1 => const MaterialsCatalogScreen(isProRateView: true, isSupplierAdmin: true),
          2 => const SupplierHomeView(initialTab: 1),
          3 => const SupplierHomeView(initialTab: 2),
          _ => ProfileScreen(currentRole: _currentRole, onSwitchRole: _switchRole),
        };
    }
  }
}
