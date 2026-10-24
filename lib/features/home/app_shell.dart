import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_more_menu.dart';
import 'client_home_view.dart';
import 'contractor_home_view.dart';
import '../projects/my_projects_screen.dart';
import '../contractors/contractors_directory_screen.dart';
import '../proposals/received_proposals_screen.dart';
import '../supplier/materials_catalog_screen.dart';
import '../account/profile_screen.dart';
import '../messaging/notifications_screen.dart';

/// Pantallas que se muestran dentro del shell.
enum _Page { home, projects, contractors, catalog, proposals, messages, profile }

/// Shell principal con la barra de navegación según el rol activo. "Más"
/// abre un panel con el resto de destinos sin cambiar la pantalla actual.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialRole = UserRole.client});

  final UserRole initialRole;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // Mismo orden que AppNavDestinations (la barra sin "Más" y el panel).
  static const _clientBar = [_Page.home, _Page.projects, _Page.contractors, _Page.catalog];
  static const _clientMore = [_Page.proposals, _Page.messages, _Page.profile];
  static const _proBar = [_Page.home, _Page.projects, _Page.proposals, _Page.messages];
  static const _proMore = [_Page.catalog, _Page.profile];

  late UserRole _currentRole;
  _Page _page = _Page.home;
  bool _moreOpen = false;

  bool get _isClient => _currentRole == UserRole.client;
  bool get _isContractor => _currentRole == UserRole.contractor;
  List<_Page> get _barPages => _isClient ? _clientBar : _proBar;
  List<_Page> get _morePages => _isClient ? _clientMore : _proMore;

  @override
  void initState() {
    super.initState();
    _currentRole = widget.initialRole;
  }

  void _switchRole(UserRole newRole) {
    setState(() {
      _currentRole = newRole;
      _page = _Page.home;
      _moreOpen = false;
    });
  }

  void _open(_Page page) => setState(() {
        _page = page;
        _moreOpen = false;
      });

  void _onBarSelected(int index) {
    if (index == _barPages.length) {
      setState(() => _moreOpen = !_moreOpen);
    } else {
      _open(_barPages[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final moreIndex = _morePages.indexOf(_page);
    final barIndex = _moreOpen || moreIndex >= 0 ? _barPages.length : _barPages.indexOf(_page);

    return PopScope(
      canPop: !_moreOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _moreOpen = false);
      },
      child: Scaffold(
        backgroundColor: AppColors.paper100,
        body: Stack(
          children: [
            KeyedSubtree(key: ValueKey(_page), child: _buildPage(_page)),
            AppMoreMenu(
              open: _moreOpen,
              items: _isClient ? AppNavDestinations.clientMore : AppNavDestinations.professionalMore,
              selectedIndex: moreIndex >= 0 ? moreIndex : null,
              onSelected: (i) => _open(_morePages[i]),
              onDismiss: () => setState(() => _moreOpen = false),
            ),
          ],
        ),
        bottomNavigationBar: AppBottomNav(
          destinations: _isClient ? AppNavDestinations.client : AppNavDestinations.professional,
          currentIndex: barIndex,
          onSelected: _onBarSelected,
        ),
      ),
    );
  }

  Widget _buildPage(_Page page) {
    return switch (page) {
      _Page.home => _isContractor
          ? ContractorHomeView(onSwitchRole: _switchRole)
          : ClientHomeView(onOpenProjects: () => _open(_Page.projects)),
      _Page.projects => MyProjectsScreen(forContractor: !_isClient),
      _Page.contractors => const ContractorsDirectoryScreen(),
      _Page.catalog => MaterialsCatalogScreen(isProRateView: !_isClient),
      _Page.proposals => _isClient
          ? const ReceivedProposalsScreen()
          : const MyProjectsScreen(forContractor: true, showBidsOnly: true),
      _Page.messages => const NotificationsScreen(),
      _Page.profile => ProfileScreen(currentRole: _currentRole, onSwitchRole: _switchRole),
    };
  }
}
