import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuración centralizada de Supabase para Rivet.
abstract final class SupabaseConfig {
  /// Valores por defecto en caso de no cargarse el .env (garantía de fallback)
  static const String _defaultUrl = 'https://oumkiwdqolagbbmxfihz.supabase.co';
  static const String _defaultKey =
      'sb_publishable_fEQlwuQHKNw127FZ4mbKXQ_t65ZZGTI';

  static String get url {
    final fromEnv = dotenv.maybeGet('SUPABASE_URL');
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    return _defaultUrl;
  }

  static String get anonKey {
    final fromEnv = dotenv.maybeGet('SUPABASE_ANON_KEY');
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    return _defaultKey;
  }

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  /// Inicializa Dotenv y el cliente oficial de Supabase.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      debugPrint('[SupabaseConfig] Advertencia cargando .env: $e (usando fallback seguro)');
    }

    try {
      await Supabase.initialize(
        url: url,
        publishableKey: anonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );
      _initialized = true;
      debugPrint('[SupabaseConfig] Supabase inicializado exitosamente en $url');
    } catch (e) {
      debugPrint('[SupabaseConfig] Error inicializando Supabase: $e');
    }
  }

  /// Instancia directa del cliente de Supabase.
  static SupabaseClient get client => Supabase.instance.client;
}
