import 'package:flutter/material.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/theme.dart';
import 'features/onboarding/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const RivetApp());
}

/// Aplicación principal Rivet configurada con el tema global y tokens de marca.
class RivetApp extends StatelessWidget {
  const RivetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rivet · Cotizaciones para tu obra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scrollBehavior: const RivetScrollBehavior(),
      home: const WelcomeScreen(),
    );
  }
}

