import 'package:flutter_bloc/flutter_bloc.dart';

enum CounterOfferStatus { pending, accepted, rejected }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.fromClient,
    required this.text,
    required this.sentAt,
    this.isCounterOffer = false,
    this.counterOfferAmountCop,
    this.counterOfferDays,
    this.counterOfferStatus = CounterOfferStatus.pending,
  });

  final String id;
  final String senderName;
  final bool fromClient;
  final String text;
  final DateTime sentAt;
  final bool isCounterOffer;
  final int? counterOfferAmountCop;
  final int? counterOfferDays;
  final CounterOfferStatus counterOfferStatus;

  ChatMessage copyWith({CounterOfferStatus? counterOfferStatus}) {
    return ChatMessage(
      id: id,
      senderName: senderName,
      fromClient: fromClient,
      text: text,
      sentAt: sentAt,
      isCounterOffer: isCounterOffer,
      counterOfferAmountCop: counterOfferAmountCop,
      counterOfferDays: counterOfferDays,
      counterOfferStatus: counterOfferStatus ?? this.counterOfferStatus,
    );
  }
}

class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.projectId,
    required this.projectTitle,
    required this.contractorId,
    required this.contractorName,
    required this.contractorSpecialty,
    required this.messages,
    this.unreadCount = 0,
  });

  final String id;
  final String projectId;
  final String projectTitle;
  final String contractorId;
  final String contractorName;
  final String contractorSpecialty;
  final List<ChatMessage> messages;
  final int unreadCount;

  String get lastMessagePreview =>
      messages.isEmpty ? 'Sin mensajes aún' : messages.last.text;

  ChatConversation copyWith({
    List<ChatMessage>? messages,
    int? unreadCount,
  }) {
    return ChatConversation(
      id: id,
      projectId: projectId,
      projectTitle: projectTitle,
      contractorId: contractorId,
      contractorName: contractorName,
      contractorSpecialty: contractorSpecialty,
      messages: messages ?? this.messages,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

enum ClientNotificationType {
  proposalReceived,
  counterOfferUpdate,
  visitScheduled,
  projectMilestone,
}

class ClientNotificationItem {
  const ClientNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.type,
    this.isRead = false,
    this.projectId,
    this.conversationId,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final ClientNotificationType type;
  final bool isRead;
  final String? projectId;
  final String? conversationId;

  ClientNotificationItem copyWith({bool? isRead}) {
    return ClientNotificationItem(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      type: type,
      isRead: isRead ?? this.isRead,
      projectId: projectId,
      conversationId: conversationId,
    );
  }
}

class MessagingFailure implements Exception {
  const MessagingFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

abstract class MessagingRepository {
  Future<List<ChatConversation>> getConversations();

  Future<ChatConversation> sendMessage({
    required String conversationId,
    required String text,
  });

  Future<ChatConversation> sendCounterOffer({
    required String conversationId,
    required int amountCop,
    required int estimatedDays,
    required String note,
  });

  Future<ChatConversation> respondCounterOffer({
    required String conversationId,
    required String messageId,
    required bool accepted,
  });

  Future<List<ClientNotificationItem>> getNotifications();

  Future<List<ClientNotificationItem>> markNotificationRead(
    String notificationId,
  );
}

class GetConversationsUseCase {
  const GetConversationsUseCase(this._repository);
  final MessagingRepository _repository;

  Future<List<ChatConversation>> call() => _repository.getConversations();
}

class SendChatMessageUseCase {
  const SendChatMessageUseCase(this._repository);
  final MessagingRepository _repository;

  Future<ChatConversation> call({
    required String conversationId,
    required String text,
  }) async {
    final clean = text.trim();
    if (clean.isEmpty) {
      throw const MessagingFailure('Escribe un mensaje antes de enviarlo.');
    }
    return _repository.sendMessage(conversationId: conversationId, text: clean);
  }
}

class SendCounterOfferUseCase {
  const SendCounterOfferUseCase(this._repository);
  final MessagingRepository _repository;

  Future<ChatConversation> call({
    required String conversationId,
    required int amountCop,
    required int estimatedDays,
    required String note,
  }) async {
    if (amountCop <= 0) {
      throw const MessagingFailure(
        'Ingresa un monto válido en COP para la contraoferta.',
      );
    }
    if (estimatedDays <= 0) {
      throw const MessagingFailure(
        'Ingresa un plazo estimado válido en días.',
      );
    }
    return _repository.sendCounterOffer(
      conversationId: conversationId,
      amountCop: amountCop,
      estimatedDays: estimatedDays,
      note: note.trim(),
    );
  }
}

class RespondCounterOfferUseCase {
  const RespondCounterOfferUseCase(this._repository);
  final MessagingRepository _repository;

  Future<ChatConversation> call({
    required String conversationId,
    required String messageId,
    required bool accepted,
  }) {
    return _repository.respondCounterOffer(
      conversationId: conversationId,
      messageId: messageId,
      accepted: accepted,
    );
  }
}

class GetClientNotificationsUseCase {
  const GetClientNotificationsUseCase(this._repository);
  final MessagingRepository _repository;

  Future<List<ClientNotificationItem>> call() => _repository.getNotifications();
}

class MarkNotificationReadUseCase {
  const MarkNotificationReadUseCase(this._repository);
  final MessagingRepository _repository;

  Future<List<ClientNotificationItem>> call(String notificationId) =>
      _repository.markNotificationRead(notificationId);
}

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

sealed class MessagingEvent {
  const MessagingEvent();
}

final class LoadMessagingData extends MessagingEvent {
  const LoadMessagingData();
}

final class SendChatMessageRequested extends MessagingEvent {
  const SendChatMessageRequested({
    required this.conversationId,
    required this.text,
  });
  final String conversationId;
  final String text;
}

final class SendCounterOfferRequested extends MessagingEvent {
  const SendCounterOfferRequested({
    required this.conversationId,
    required this.amountCop,
    required this.estimatedDays,
    required this.note,
  });
  final String conversationId;
  final int amountCop;
  final int estimatedDays;
  final String note;
}

final class RespondCounterOfferRequested extends MessagingEvent {
  const RespondCounterOfferRequested({
    required this.conversationId,
    required this.messageId,
    required this.accepted,
  });
  final String conversationId;
  final String messageId;
  final bool accepted;
}

final class MarkNotificationAsRead extends MessagingEvent {
  const MarkNotificationAsRead(this.notificationId);
  final String notificationId;
}

enum MessagingStatus { initial, loading, success, failure }

class MessagingState {
  const MessagingState({
    this.status = MessagingStatus.initial,
    this.conversations = const [],
    this.notifications = const [],
    this.errorMessage,
  });

  final MessagingStatus status;
  final List<ChatConversation> conversations;
  final List<ClientNotificationItem> notifications;
  final String? errorMessage;

  bool get isLoading => status == MessagingStatus.loading;
  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  ChatConversation? conversationById(String id) {
    for (final c in conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  MessagingState copyWith({
    MessagingStatus? status,
    List<ChatConversation>? conversations,
    List<ClientNotificationItem>? notifications,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MessagingState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      notifications: notifications ?? this.notifications,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingBloc(
    this._getConversationsUseCase,
    this._sendChatMessageUseCase,
    this._sendCounterOfferUseCase,
    this._respondCounterOfferUseCase,
    this._getClientNotificationsUseCase,
    this._markNotificationReadUseCase,
  ) : super(const MessagingState()) {
    on<LoadMessagingData>(_onLoad);
    on<SendChatMessageRequested>(_onSendMessage);
    on<SendCounterOfferRequested>(_onSendCounterOffer);
    on<RespondCounterOfferRequested>(_onRespondCounterOffer);
    on<MarkNotificationAsRead>(_onMarkNotificationRead);
  }

  final GetConversationsUseCase _getConversationsUseCase;
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final SendCounterOfferUseCase _sendCounterOfferUseCase;
  final RespondCounterOfferUseCase _respondCounterOfferUseCase;
  final GetClientNotificationsUseCase _getClientNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;

  Future<void> _onLoad(
    LoadMessagingData event,
    Emitter<MessagingState> emit,
  ) async {
    emit(state.copyWith(status: MessagingStatus.loading, clearError: true));
    try {
      final convs = await _getConversationsUseCase();
      final notifs = await _getClientNotificationsUseCase();
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          conversations: convs,
          notifications: notifs,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: MessagingStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  Future<void> _onSendMessage(
    SendChatMessageRequested event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      final updated = await _sendChatMessageUseCase(
        conversationId: event.conversationId,
        text: event.text,
      );
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          conversations: _replaceConv(state.conversations, updated),
          clearError: true,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: MessagingStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  Future<void> _onSendCounterOffer(
    SendCounterOfferRequested event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      final updated = await _sendCounterOfferUseCase(
        conversationId: event.conversationId,
        amountCop: event.amountCop,
        estimatedDays: event.estimatedDays,
        note: event.note,
      );
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          conversations: _replaceConv(state.conversations, updated),
          clearError: true,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: MessagingStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  Future<void> _onRespondCounterOffer(
    RespondCounterOfferRequested event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      final updated = await _respondCounterOfferUseCase(
        conversationId: event.conversationId,
        messageId: event.messageId,
        accepted: event.accepted,
      );
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          conversations: _replaceConv(state.conversations, updated),
          clearError: true,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: MessagingStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  Future<void> _onMarkNotificationRead(
    MarkNotificationAsRead event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      final updated = await _markNotificationReadUseCase(event.notificationId);
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          notifications: updated,
          clearError: true,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: MessagingStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  List<ChatConversation> _replaceConv(
    List<ChatConversation> current,
    ChatConversation updated,
  ) {
    final exists = current.any((c) => c.id == updated.id);
    if (!exists) return [updated, ...current];
    return [for (final c in current) c.id == updated.id ? updated : c];
  }
}

class MessagingService {
  MessagingService._();
  static final MessagingService instance = MessagingService._();

  MessagingRepository _repository = LocalMessagingRepository();

  void setRepositoryForTesting(MessagingRepository repository) {
    _repository = repository;
  }

  GetConversationsUseCase get getConversationsUseCase =>
      GetConversationsUseCase(_repository);
  SendChatMessageUseCase get sendChatMessageUseCase =>
      SendChatMessageUseCase(_repository);
  SendCounterOfferUseCase get sendCounterOfferUseCase =>
      SendCounterOfferUseCase(_repository);
  RespondCounterOfferUseCase get respondCounterOfferUseCase =>
      RespondCounterOfferUseCase(_repository);
  GetClientNotificationsUseCase get getClientNotificationsUseCase =>
      GetClientNotificationsUseCase(_repository);
  MarkNotificationReadUseCase get markNotificationReadUseCase =>
      MarkNotificationReadUseCase(_repository);
}
