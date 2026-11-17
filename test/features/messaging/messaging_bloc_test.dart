import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/messaging/messaging_module.dart';

class _RealtimeFakeMessagingRepo extends LocalMessagingRepository {
  final msgController = StreamController<ChatMessage>.broadcast();
  final notifController = StreamController<ClientNotificationItem>.broadcast();

  @override
  Stream<ChatMessage> watchMessages(String conversationId) =>
      msgController.stream;

  @override
  Stream<ClientNotificationItem> watchNotifications() =>
      notifController.stream;
}

void main() {
  test('MessagingBloc carga datos y recibe mensajes y notificaciones Realtime', () async {
    final repo = _RealtimeFakeMessagingRepo();
    final bloc = MessagingBloc.fromRepository(repo);

    bloc.add(const LoadMessagingData());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, MessagingStatus.success);
    final convId = bloc.state.conversations.first.id;
    final initialMsgCount = bloc.state.conversations.first.messages.length;
    final initialNotifCount = bloc.state.notifications.length;

    bloc.add(SubscribeConversationRealtime(convId));
    bloc.add(const SubscribeNotificationsRealtime());
    await Future<void>.delayed(Duration.zero);

    repo.msgController.add(
      ChatMessage(
        id: 'rt-msg-1',
        senderName: 'Andrés',
        fromClient: false,
        text: 'Mensaje en vivo',
        sentAt: DateTime.now(),
      ),
    );
    repo.notifController.add(
      ClientNotificationItem(
        id: 'rt-notif-1',
        title: 'Nuevo aviso',
        body: 'Actualización en vivo',
        createdAt: DateTime.now(),
        type: ClientNotificationType.projectMilestone,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(
      bloc.state.conversationById(convId)?.messages.length,
      initialMsgCount + 1,
    );
    expect(bloc.state.notifications.length, initialNotifCount + 1);

    await bloc.close();
    await repo.msgController.close();
    await repo.notifController.close();
  });
}
