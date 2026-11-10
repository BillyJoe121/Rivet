import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_back_button.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_more_menu.dart';
import 'client_home_view.dart';
import 'contractor_home_view.dart';
import '../account/profile_screen.dart';
import '../contractors/contractors_directory_screen.dart';
import '../messaging/messaging_screens.dart';
import '../projects/my_projects_screen.dart';
import '../proposals/all_proposals_screen.dart';
import '../supplier/materials_catalog_screen.dart';
import '../under_construction/under_construction_screen.dart';

/// Pantallas que se muestran dentro del shell.
enum _Page {
  home,
  projects,
  contractors,
  catalog,
  proposals,
  messages,
  profile,
}

/// Shell principal con la barra de navegación según el rol activo. Cada
/// destino tiene su propia pila de navegación, así la barra sigue visible en
/// las pantallas internas y cada pestaña conserva dónde quedó. "Más" abre un
/// panel con el resto de destinos sin cambiar la pantalla actual.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialRole = UserRole.client});

  final UserRole initialRole;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // Mismo orden que AppNavDestinations (la barra sin "Más" y el panel).
  static const _clientBar = [
    _Page.home,
    _Page.projects,
    _Page.contractors,
    _Page.catalog,
  ];
  static const _clientMore = [_Page.proposals, _Page.messages, _Page.profile];
  static const _proBar = [
    _Page.home,
    _Page.projects,
    _Page.proposals,
    _Page.messages,
  ];
  static const _proMore = [_Page.catalog, _Page.profile];

  late UserRole _currentRole;
  _Page _page = _Page.home;
  bool _moreOpen = false;

  /// Pila de cada destino ya visitado; se crea al abrirlo por primera vez.
  final Map<_Page, GlobalKey<NavigatorState>> _navigators = {
    _Page.home: GlobalKey<NavigatorState>(),
  };

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
      // Las pilas del rol anterior no aplican al nuevo.
      _navigators
        ..clear()
        ..[_Page.home] = GlobalKey<NavigatorState>();
    });
  }

  void _open(_Page page) {
    // Al tocar cualquier botón de la barra inferior siempre se vuelve a la
    // pantalla principal de esa sección.
    _navigators[page]?.currentState?.popUntil((route) => route.isFirst);
    setState(() {
      _navigators.putIfAbsent(page, GlobalKey<NavigatorState>.new);
      _page = page;
      _moreOpen = false;
    });
  }

  void _onBarSelected(int index) {
    if (index == _barPages.length) {
      setState(() => _moreOpen = !_moreOpen);
    } else {
      _open(_barPages[index]);
    }
  }

  /// Atrás del sistema: cierra "Más", luego la pantalla interna de la pestaña,
  /// luego vuelve a Inicio y por último sale de la app.
  Future<void> _handleBack() async {
    if (_moreOpen) {
      setState(() => _moreOpen = false);
      return;
    }
    final navigator = _navigators[_page]?.currentState;
    if (navigator != null && navigator.canPop()) {
      await navigator.maybePop();
      return;
    }
    if (_page != _Page.home) {
      _open(_Page.home);
      return;
    }
    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final moreIndex = _morePages.indexOf(_page);
    final barIndex = _moreOpen || moreIndex >= 0
        ? _barPages.length
        : _barPages.indexOf(_page);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      child: NotificationListener<AppShellBackNotification>(
        onNotification: (_) {
          _handleBack();
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColors.paper100,
          resizeToAvoidBottomInset: false,
          body: Stack(
          children: [
            for (final entry in _navigators.entries)
              Offstage(
                key: ValueKey(entry.key),
                offstage: entry.key != _page,
                child: TickerMode(
                  enabled: entry.key == _page,
                  child: _TabNavigator(
                    navigatorKey: entry.value,
                    builder: (_) => _buildPage(entry.key),
                  ),
                ),
              ),
            AppMoreMenu(
              open: _moreOpen,
              items: _isClient
                  ? AppNavDestinations.clientMore
                  : AppNavDestinations.professionalMore,
              selectedIndex: moreIndex >= 0 ? moreIndex : null,
              onSelected: (i) => _open(_morePages[i]),
              onDismiss: () => setState(() => _moreOpen = false),
            ),
          ],
        ),
          bottomNavigationBar: AppBottomNav(
            destinations: _isClient
                ? AppNavDestinations.client
                : AppNavDestinations.professional,
            currentIndex: barIndex,
            onSelected: _onBarSelected,
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_Page page) {
    return switch (page) {
      _Page.home =>
        _isContractor
            ? ContractorHomeView(onSwitchRole: _switchRole)
            : ClientHomeView(onOpenProjects: () => _open(_Page.projects)),
      _Page.projects =>
        _isClient
            ? const MyProjectsScreen()
            : UnderConstructionScreen(section: _sectionName(page)),
      _Page.contractors =>
        _isClient
            ? const ContractorsDirectoryScreen()
            : UnderConstructionScreen(section: _sectionName(page)),
      _Page.catalog => const MaterialsCatalogScreen(),
      _Page.proposals =>
        _isClient
            ? const AllProposalsScreen()
            : UnderConstructionScreen(section: _sectionName(page)),
      _Page.messages =>
        _isClient
            ? const ConversationsListScreen()
            : UnderConstructionScreen(section: _sectionName(page)),
      _Page.profile => ProfileScreen(
        currentRole: _currentRole,
        onSwitchRole: _switchRole,
        onBack: () => _open(_Page.home),
      ),
    };
  }

  String _sectionName(_Page page) => switch (page) {
    _Page.projects => 'Proyectos',
    _Page.contractors => 'Contratistas',
    _Page.catalog => 'Bodega',
    _Page.proposals => 'Propuestas',
    _Page.messages => 'Mensajes',
    _ => '',
  };
}

/// Pila de navegación de un destino del shell.
class _TabNavigator extends StatelessWidget {
  const _TabNavigator({required this.navigatorKey, required this.builder});

  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) => PageRouteBuilder<void>(
        settings: settings,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, _, _) => builder(context),
      ),
    );
  }
}
