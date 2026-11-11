import '../domain/messaging_domain.dart';

class LocalMessagingRepository implements MessagingRepository {
  LocalMessagingRepository()
    : _conversations = _buildSeedConversations(),
      _notifications = _buildSeedNotifications();

  final List<ChatConversation> _conversations;
  final List<ClientNotificationItem> _notifications;

  static List<ChatConversation> _buildSeedConversations() {
    final now = DateTime(2026, 5, 10, 14, 30);
    return [
      ChatConversation(
        id: 'conv-001',
        projectId: 'proj-cali-001',
        projectTitle: 'Pintura sala y comedor en Ciudad Jardín',
        contractorId: 'con-001',
        contractorName: 'Andrés Felipe Montoya',
        contractorSpecialty: 'Pintura arquitectónica y estuco',
        unreadCount: 1,
        messages: [
          ChatMessage(
            id: 'msg-1',
            senderName: 'Andrés Felipe Montoya',
            fromClient: false,
            text:
                '¡Hola! Revisé el metraje de tu sala en Ciudad Jardín. Puedo incluir resane con estuco plástico y dos manos de Koraza/Vinilo Tipo 1.',
            sentAt: now.subtract(const Duration(hours: 3)),
          ),
          ChatMessage(
            id: 'msg-2',
            senderName: 'Andrés Felipe Montoya',
            fromClient: false,
            text:
                'Te propongo cerrar mano de obra y preparación de superficies en \$ 2.150.000 COP terminando en 5 días.',
            sentAt: now.subtract(const Duration(hours: 2)),
            isCounterOffer: true,
            counterOfferAmountCop: 2150000,
            counterOfferDays: 5,
          ),
        ],
      ),
      ChatConversation(
        id: 'conv-002',
        projectId: 'proj-cali-001',
        projectTitle: 'Pintura sala y comedor en Ciudad Jardín',
        contractorId: 'con-002',
        contractorName: 'Carolina Rivas & Equipo',
        contractorSpecialty: 'Acabados interiores y drywall',
        unreadCount: 0,
        messages: [
          ChatMessage(
            id: 'msg-3',
            senderName: 'Carolina Rivas & Equipo',
            fromClient: false,
            text:
                'Buenas tardes, tenemos disponibilidad desde el lunes con plástico protector para pisos y muebles.',
            sentAt: now.subtract(const Duration(days: 1)),
          ),
        ],
      ),
    ];
  }

  static List<ClientNotificationItem> _buildSeedNotifications() {
    final now = DateTime(2026, 5, 10, 15, 0);
    return [
      ClientNotificationItem(
        id: 'not-001',
        title: 'Nueva propuesta recibida',
        body:
            'Andrés Felipe Montoya envió una cotización para tu proyecto en Ciudad Jardín.',
        createdAt: now.subtract(const Duration(hours: 1)),
        type: ClientNotificationType.proposalReceived,
        projectId: 'proj-cali-001',
      ),
      ClientNotificationItem(
        id: 'not-002',
        title: 'Contraoferta activa en el chat',
        body:
            'Revisa la propuesta ajustada de \$ 2.150.000 COP en tu conversación con Andrés Felipe.',
        createdAt: now.subtract(const Duration(hours: 2)),
        type: ClientNotificationType.counterOfferUpdate,
        conversationId: 'conv-001',
        projectId: 'proj-cali-001',
      ),
      ClientNotificationItem(
        id: 'not-003',
        title: 'Dossier listo para comparar',
        body:
            'Ya cuentas con múltiples cotizaciones para comparar alcance, días y presupuesto.',
        createdAt: now.subtract(const Duration(days: 1)),
        type: ClientNotificationType.projectMilestone,
        isRead: true,
        projectId: 'proj-cali-001',
      ),
    ];
  }

  @override
  Future<List<ChatConversation>> getConversations() async =>
      List<ChatConversation>.unmodifiable(_conversations);

  @override
  Future<ChatConversation> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    final targetIndex = index >= 0 ? index : 0;
    final conv = _conversations[targetIndex];
    final now = DateTime.now();

    final clientMsg = ChatMessage(
      id: 'msg-${now.microsecondsSinceEpoch}-c',
      senderName: 'Tú',
      fromClient: true,
      text: text,
      sentAt: now,
    );
    final autoReply = ChatMessage(
      id: 'msg-${now.microsecondsSinceEpoch}-r',
      senderName: conv.contractorName,
      fromClient: false,
      text:
          '¡Perfecto! Recibí tu mensaje. Quedo atento para coordinar los detalles en obra y confirmar el cronograma.',
      sentAt: now.add(const Duration(seconds: 1)),
    );

    final updated = conv.copyWith(
      messages: [...conv.messages, clientMsg, autoReply],
      unreadCount: 0,
    );
    _conversations[targetIndex] = updated;
    return updated;
  }

  @override
  Future<ChatConversation> sendCounterOffer({
    required String conversationId,
    required int amountCop,
    required int estimatedDays,
    required String note,
  }) async {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    final targetIndex = index >= 0 ? index : 0;
    final conv = _conversations[targetIndex];
    final now = DateTime.now();

    final offerMsg = ChatMessage(
      id: 'msg-${now.microsecondsSinceEpoch}-co',
      senderName: 'Tú',
      fromClient: true,
      text: note.isEmpty
          ? 'Contraoferta enviada por \$ $amountCop COP ($estimatedDays días).'
          : note,
      sentAt: now,
      isCounterOffer: true,
      counterOfferAmountCop: amountCop,
      counterOfferDays: estimatedDays,
    );
    final replyMsg = ChatMessage(
      id: 'msg-${now.microsecondsSinceEpoch}-cor',
      senderName: conv.contractorName,
      fromClient: false,
      text:
          'Recibí tu contraoferta. Estoy revisando las cantidades de material para confirmarte enseguida.',
      sentAt: now.add(const Duration(seconds: 1)),
    );

    final updated = conv.copyWith(
      messages: [...conv.messages, offerMsg, replyMsg],
      unreadCount: 0,
    );
    _conversations[targetIndex] = updated;
    return updated;
  }

  @override
  Future<ChatConversation> respondCounterOffer({
    required String conversationId,
    required String messageId,
    required bool accepted,
  }) async {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    final targetIndex = index >= 0 ? index : 0;
    final conv = _conversations[targetIndex];
    final nextStatus = accepted
        ? CounterOfferStatus.accepted
        : CounterOfferStatus.rejected;

    final updatedMessages = [
      for (final m in conv.messages)
        m.id == messageId ? m.copyWith(counterOfferStatus: nextStatus) : m,
      ChatMessage(
        id: 'msg-${DateTime.now().microsecondsSinceEpoch}-sys',
        senderName: conv.contractorName,
        fromClient: false,
        text: accepted
            ? '¡Excelente! Dejamos acordado ese valor para avanzar al resumen del acuerdo.'
            : 'Entendido, sigamos conversando para ajustar el alcance.',
        sentAt: DateTime.now(),
      ),
    ];

    final updated = conv.copyWith(messages: updatedMessages, unreadCount: 0);
    _conversations[targetIndex] = updated;
    return updated;
  }

  @override
  Future<List<ClientNotificationItem>> getNotifications() async =>
      List<ClientNotificationItem>.unmodifiable(_notifications);

  @override
  Future<List<ClientNotificationItem>> markNotificationRead(
    String notificationId,
  ) async {
    for (var i = 0; i < _notifications.length; i++) {
      if (_notifications[i].id == notificationId) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    return List<ClientNotificationItem>.unmodifiable(_notifications);
  }
}
