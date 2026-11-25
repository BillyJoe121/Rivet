import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/http_overrides.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/theme.dart';
import 'core/utils/app_page_route.dart';
import 'core/widgets/keyboard_dismisser.dart';
import 'features/agreements/agreements_module.dart';
import 'features/auth/auth_gate.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/auth/reset_password_screen.dart';
import 'features/contractors/contractors_module.dart';
import 'features/messaging/messaging_module.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/wizard/domain/project_draft_repository.dart';
import 'features/proposals/domain/repositories/proposal_repository.dart';
import 'features/supplier/domain/repositories/catalog_repository.dart';
import 'injection_container.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupHttpOverrides();
  await SupabaseConfig.initialize();
  await initDependencies();
  runApp(const RivetApp());
}

/// Aplicación principal Rivet configurada con el tema global, tokens de marca
/// y resolución centralizada de dependencias vía GetIt (`sl`).
class RivetApp extends StatefulWidget {
  const RivetApp({
    super.key,
    this.authRepository,
    this.projectRepository,
    this.proposalRepository,
    this.catalogRepository,
    this.contractorRepository,
    this.agreementRepository,
    this.messagingRepository,
    this.projectDraftRepository,
  });

  final AuthRepository? authRepository;
  final ProjectRepository? projectRepository;
  final ProposalRepository? proposalRepository;
  final CatalogRepository? catalogRepository;
  final ContractorRepository? contractorRepository;
  final AgreementRepository? agreementRepository;
  final MessagingRepository? messagingRepository;
  final ProjectDraftRepository? projectDraftRepository;

  @override
  State<RivetApp> createState() => _RivetAppState();
}

class _RivetAppState extends State<RivetApp> {
  StreamSubscription<void>? _recoverySubscription;

  bool get _hasOverrides =>
      widget.authRepository != null ||
      widget.projectRepository != null ||
      widget.proposalRepository != null ||
      widget.catalogRepository != null ||
      widget.contractorRepository != null ||
      widget.agreementRepository != null ||
      widget.messagingRepository != null ||
      widget.projectDraftRepository != null;

  @override
  void initState() {
    super.initState();
    if (_hasOverrides || !sl.isRegistered<AuthRepository>()) {
      configureDependencies(
        authRepository: widget.authRepository,
        projectRepository: widget.projectRepository,
        proposalRepository: widget.proposalRepository,
        catalogRepository: widget.catalogRepository,
        contractorRepository: widget.contractorRepository,
        agreementRepository: widget.agreementRepository,
        messagingRepository: widget.messagingRepository,
        projectDraftRepository: widget.projectDraftRepository,
        allowOverride: _hasOverrides,
      );
    }
    _recoverySubscription = sl<AuthRepository>().onPasswordRecovery.listen((_) {
      rootNavigatorKey.currentState?.push(
        RivetPageRoute(builder: (_) => const ResetPasswordScreen()),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx == null) return;
      const heroAssets = [
        ...AppHeroImages.all,
        'Fondos/Sala minimalista con plantas y luz suave.png',
      ];
      for (final asset in heroAssets) {
        precacheImage(
          ResizeImage(AssetImage(asset), width: 824),
          ctx,
          onError: (_, _) {},
        );
      }
      const catalogThumbs = [
        'Fondos/pro-pintura-rivet.jpg',
        'Fondos/pro-estuco-corona.jpg',
        'Fondos/pro-cinta-enmascarar.jpg',
      ];
      for (final thumb in catalogThumbs) {
        precacheImage(
          ResizeImage(AssetImage(thumb), width: 160),
          ctx,
          onError: (_, _) {},
        );
      }
    });
  }

  @override
  void dispose() {
    _recoverySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
      child: MaterialApp(
        navigatorKey: rootNavigatorKey,
        title: 'Rivet · Cotizaciones para tu obra',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        scrollBehavior: const RivetScrollBehavior(),
        builder: (context, child) =>
            KeyboardDismisser(child: child ?? const SizedBox.shrink()),
        home: const AuthGate(),
      ),
    );
  }
}
