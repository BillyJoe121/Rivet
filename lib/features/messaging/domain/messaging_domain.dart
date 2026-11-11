// Entidades, contrato del repositorio y casos de uso de mensajería.
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
