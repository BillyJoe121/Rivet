import '../home/widgets/kit/kit.dart';

/// Conversación de la bandeja de mensajes.
class MsgConversation {
  const MsgConversation({
    required this.name,
    required this.avatar,
    required this.time,
    required this.text,
  });

  final String name;
  final String avatar;
  final String time;
  final String text;
}

/// Notificación reciente con ícono y texto en dos líneas.
class MsgNotice {
  const MsgNotice({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final LucideIcon icon;
  final String title;
  final String subtitle;
}

/// Bandeja de mensajes (22:146347).
const List<MsgConversation> messageConversations = [
  MsgConversation(
    name: 'Carlos Ramírez',
    avatar: ProAssets.avatarCarlos,
    time: 'Hace 10 min',
    text: 'Te envié la propuesta ajustada.',
  ),
  MsgConversation(
    name: 'Pinturas del Valle',
    avatar: ProAssets.avatarCarlos,
    time: 'Hace 1 h',
    text: 'Tu pedido #279 fue confirmado.',
  ),
  MsgConversation(
    name: 'Ana Torres',
    avatar: ProAssets.avatarPainter,
    time: 'Ayer',
    text: '¿Confirmas visita para mañana?',
  ),
];

const List<MsgNotice> messageNotices = [
  MsgNotice(
    icon: LucideIcon.bell,
    title: 'Nueva propuesta recibida',
    subtitle: 'Pintar sala                                       Hace 30 min',
  ),
  MsgNotice(
    icon: LucideIcon.package,
    title: 'Cambio de estado del pedido',
    subtitle: 'Pedido #275 en despacho                         Hace 2 h',
  ),
  MsgNotice(
    icon: LucideIcon.calendar,
    title: 'Recordatorio de fecha',
    subtitle: 'Inicio del trabajo mañana                              Ayer',
  ),
];
