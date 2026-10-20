import '../home/widgets/kit/kit.dart';

/// Mensaje de la conversación de propuesta (22 px de margen, burbuja de 310 px).
class MsgBubble {
  const MsgBubble({
    required this.text,
    required this.time,
    this.mine = false,
    this.read = false,
  });

  final String text;
  final String time;
  final bool mine;

  /// Muestra el doble check de lectura en mensajes propios.
  final bool read;
}

/// Mensaje de la negociación: el usuario (tarjeta tintada) o el contratista.
class MsgThreadEntry {
  const MsgThreadEntry({
    required this.time,
    required this.text,
    required this.avatar,
    this.isMe = false,
  });

  final String time;
  final String text;
  final String avatar;
  final bool isMe;
}

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

/// Chat de propuesta (55:105).
const String proposalContractorName = 'Pinturas del Valle';
const String proposalContractorTrade = 'Pintor y estucador';
const String proposalContractorZone = 'Medellín y alrededores';
const String proposalTitle = 'Propuesta de pintura y estuco';
const String proposalSummary = '\$ 3.200.000 · 12 días';

const List<MsgBubble> proposalChatMessages = [
  MsgBubble(
    mine: true,
    read: true,
    time: '9:32',
    text:
        'Hola, ¿los \$ 3.200.000 incluyen la preparación de paredes y la pintura Pintuco de la propuesta?',
  ),
  MsgBubble(
    time: '9:35',
    text:
        'Hola, Juan. Sí, el total incluye resanes, estuco y pintura vinilo premium Pintuco, además de la mano de obra. El plazo es de 12 días.',
  ),
  MsgBubble(
    mine: true,
    read: true,
    time: '9:36',
    text: '¡Gracias por la aclaración!',
  ),
];

/// Negociación y conversación (22:145219).
const String negotiationAmount = '\$ 3.200.000 COP';
const String negotiationDays = '6 días';

const List<MsgThreadEntry> negotiationBeforeOffer = [
  MsgThreadEntry(
    isMe: true,
    time: '10:15 a.m.',
    avatar: ProAssets.avatarContractor,
    text:
        'Hola Carlos, me gustaría confirmar que usaremos pintura vinílica lavable y estuco plástico como lo hablamos.',
  ),
  MsgThreadEntry(
    time: '10:28 a.m.',
    avatar: ProAssets.avatarCarlos,
    text:
        '¡Hola Juan! Sí, usaremos pintura vinílica lavable y estuco plástico. Podemos iniciar el 12 de mayo.',
  ),
];

const List<MsgThreadEntry> negotiationAfterOffer = [
  MsgThreadEntry(
    isMe: true,
    time: '10:40 a.m.',
    avatar: ProAssets.avatarContractor,
    text:
        'Perfecto. ¿Podemos hacer una visita previa el viernes para revisar las paredes?',
  ),
  MsgThreadEntry(
    time: '10:45 a.m.',
    avatar: ProAssets.avatarCarlos,
    text: 'Claro, el viernes a las 10 a.m. nos vemos en el apartamento.',
  ),
];

/// Tarjeta de propuesta revisada dentro de la negociación.
const String offerTitleLine =
    'Propuesta revisada                            10:32 a.m.';
const String offerDetail =
    'Ajuste en materiales y precio\n• Pintura vinílica premium\n• Incluye sellador';
const String offerAmount = '\$ 3.200.000 COP\n(antes \$ 3.400.000)';

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
