import 'dart:io';

/// Permite resolución confiable de hosts en entornos de emulador o redes con VPN
/// donde el proxy DNS virtual QEMU (10.0.2.3) no responde adecuadamente.
class RivetHttpOverrides extends HttpOverrides {
  static const Map<String, String> _dnsMap = {
    'oumkiwdqolagbbmxfihz.supabase.co': '104.18.38.10',
  };

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.connectionFactory = (Uri uri, String? host, int? port) async {
      final effectiveHost = host ?? uri.host;
      final ip = _dnsMap[effectiveHost] ?? effectiveHost;
      final effectivePort = port ?? uri.port;
      return Socket.startConnect(ip, effectivePort);
    };
    return client;
  }
}

/// Configura los overrides globales de red para plataformas IO.
void setupHttpOverrides() {
  HttpOverrides.global = RivetHttpOverrides();
}
