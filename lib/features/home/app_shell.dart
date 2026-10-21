import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_bottom_nav.dart';
import 'client_home_view.dart';
import 'contractor_home_view.dart';
import '../projects/my_projects_screen.dart';
import '../contractors/contractors_directory_screen.dart';
import '../supplier/materials_catalog_screen.dart';
import '../account/profile_screen.dart';
import '../messaging/notifications_screen.dart';

/// Shell principal con la barra de navegación del Figma según el rol activo.
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
      bottomNavigationBar: AppBottomNav(
        destinations: _currentRole == UserRole.client
            ? AppNavDestinations.client
            : AppNavDestinations.professional,
        currentIndex: _currentIndex,
        onSelected: (idx) => setState(() => _currentIndex = idx),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentRole) {
      case UserRole.client:
        return switch (_currentIndex) {
          0 => ClientHomeView(onSwitchRole: _switchRole),
          1 => const ContractorsDirectoryScreen(),
          2 => const MyProjectsScreen(),
          3 => const NotificationsScreen(),
          _ => ProfileScreen(currentRole: _currentRole, onSwitchRole: _switchRole),
        };
      case UserRole.contractor:
        return switch (_currentIndex) {
          0 => ContractorHomeView(onSwitchRole: _switchRole),
          1 => const MyProjectsScreen(forContractor: true),
          2 => const MaterialsCatalogScreen(isProRateView: true),
          3 => const NotificationsScreen(),
          _ => ProfileScreen(currentRole: _currentRole, onSwitchRole: _switchRole),
        };
      case UserRole.supplier:
        return ClientHomeView(onSwitchRole: _switchRole);
    }
  }
}
