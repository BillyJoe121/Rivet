import 'dart:io';

/// Permite resolución confiable de hosts en entornos donde el DNS local falla,
/// manteniendo conexión TLS estándar con DNS del sistema como primera opción.
class RivetHttpOverrides extends HttpOverrides {
  static const Map<String, String> _dnsMap = {
    'oumkiwdqolagbbmxfihz.supabase.co': '104.18.38.10',
  };

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.connectionFactory =
        (Uri uri, String? proxyHost, int? proxyPort) async {
          final host = proxyHost ?? uri.host;
          final port = proxyPort ?? uri.port;
          final fallbackIp = _dnsMap[host];
          // Con proxy, el cliente abre el túnel y aplica TLS por su cuenta.
          final secure = uri.isScheme('https') && proxyHost == null;

          if (!secure) {
            try {
              return await Socket.startConnect(host, port);
            } on SocketException {
              if (fallbackIp == null) rethrow;
              return Socket.startConnect(fallbackIp, port);
            }
          }

          try {
            return await SecureSocket.startConnect(
              host,
              port,
              context: context,
            );
          } on SocketException {
            if (fallbackIp == null) rethrow;
            return _connectSecureWithIp(fallbackIp, host, port, context);
          }
        };
    return client;
  }

  Future<ConnectionTask<Socket>> _connectSecureWithIp(
    String ip,
    String host,
    int port,
    SecurityContext? context,
  ) async {
    final task = await Socket.startConnect(ip, port);
    return ConnectionTask.fromSocket(
      task.socket.then(
        (raw) => SecureSocket.secure(raw, host: host, context: context),
      ),
      task.cancel,
    );
  }
}

/// Configura los overrides globales de red para plataformas IO.
void setupHttpOverrides() {
  HttpOverrides.global = RivetHttpOverrides();
}
