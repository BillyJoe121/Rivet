import 'dart:io';

/// Permite resolución confiable de hosts en entornos de emulador o redes con VPN
/// donde el proxy DNS virtual QEMU (10.0.2.3) no responde adecuadamente.
///
/// Solo reemplaza la resolución DNS: las conexiones HTTPS se cifran con TLS
/// usando el nombre real del host (SNI y validación del certificado). Sin
/// esto, la petición sale en texto plano al puerto 443 y el servidor responde
/// con una página HTML de error en lugar de JSON.
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
          final ip = _dnsMap[host];
          // Con proxy, el cliente abre el túnel y aplica TLS por su cuenta.
          final secure = uri.isScheme('https') && proxyHost == null;

          if (!secure) return Socket.startConnect(ip ?? host, port);
          if (ip == null) {
            return SecureSocket.startConnect(host, port, context: context);
          }
          final task = await Socket.startConnect(ip, port);
          return ConnectionTask.fromSocket(
            task.socket.then(
              (raw) => SecureSocket.secure(raw, host: host, context: context),
            ),
            task.cancel,
          );
        };
    return client;
  }
}

/// Configura los overrides globales de red para plataformas IO.
void setupHttpOverrides() {
  HttpOverrides.global = RivetHttpOverrides();
}
