import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/messaging/messaging_module.dart';
import 'package:rivet/features/messaging/project_chat_screen.dart';

import 'helpers/repositories_test_harness.dart';

class _PaginatedMessagingRepository extends LocalMessagingRepository {
  _PaginatedMessagingRepository({
    required this.olderBatch,
  });

  final List<ChatMessage> olderBatch;
  final StreamController<ChatMessage> controller =
      StreamController<ChatMessage>.broadcast();

  @override
  Future<List<ChatConversation>> getConversations() async {
    return [
      ChatConversation(
        id: 'conv-1',
        projectId: 'proj-1',
        projectTitle: 'Remodelación sala',
        contractorId: 'c-1',
        contractorName: 'Carlos Méndez',
        contractorSpecialty: 'Pintura y acabados',
        messages: [
          ChatMessage(
            id: 'm-3',
            senderName: 'Carlos',
            fromClient: false,
            text: 'Mensaje reciente 3',
            sentAt: DateTime(2026, 11, 17, 10, 30),
          ),
          ChatMessage(
            id: 'm-4',
            senderName: 'Tú',
            fromClient: true,
            text: 'Mensaje reciente 4',
            sentAt: DateTime(2026, 11, 17, 10, 35),
          ),
        ],
      ),
    ];
  }

  @override
  Future<List<ChatMessage>> fetchMessagesBefore({
    required String conversationId,
    required DateTime before,
    int limit = 20,
  }) async {
    return olderBatch.where((m) => m.sentAt.isBefore(before)).toList();
  }

  @override
  Stream<ChatMessage> watchMessages(String conversationId) => controller.stream;
}

void main() {
  test(
    'MessagingBloc carga mensajes anteriores y los fusiona por id sin perderlos en tiempo real',
    () async {
      final repo = _PaginatedMessagingRepository(
        olderBatch: [
          ChatMessage(
            id: 'm-1',
            senderName: 'Tú',
            fromClient: true,
            text: 'Mensaje antiguo 1',
            sentAt: DateTime(2026, 11, 17, 10, 0),
          ),
          ChatMessage(
            id: 'm-2',
            senderName: 'Carlos',
            fromClient: false,
            text: 'Mensaje antiguo 2',
            sentAt: DateTime(2026, 11, 17, 10, 15),
          ),
        ],
      );

      final bloc = MessagingBloc.fromRepository(repo);
      bloc.add(const LoadMessagingData());
      await Future<void>.delayed(const Duration(milliseconds: 30));

      bloc.add(const SubscribeConversationRealtime('conv-1'));
      bloc.add(const LoadOlderMessagesRequested('conv-1', limit: 2));
      await Future<void>.delayed(const Duration(milliseconds: 30));

      var conv = bloc.state.conversationById('conv-1')!;
      expect(conv.messages.map((m) => m.id).toList(), ['m-1', 'm-2', 'm-3', 'm-4']);
      expect(bloc.state.hasMoreMessages('conv-1'), isTrue);

      // Llega un mensaje en tiempo real y no se pierde el historial paginado
      repo.controller.add(
        ChatMessage(
          id: 'm-5',
          senderName: 'Carlos',
          fromClient: false,
          text: 'Mensaje en vivo 5',
          sentAt: DateTime(2026, 11, 17, 10, 40),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 30));

      conv = bloc.state.conversationById('conv-1')!;
      expect(
        conv.messages.map((m) => m.id).toList(),
        ['m-1', 'm-2', 'm-3', 'm-4', 'm-5'],
      );

      // Si pide más pero ya no hay más antiguos, hasMoreMessages pasa a false
      bloc.add(const LoadOlderMessagesRequested('conv-1', limit: 2));
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(bloc.state.hasMoreMessages('conv-1'), isFalse);

      await bloc.close();
      await repo.controller.close();
    },
  );

  testWidgets(
    'ProjectChatScreen muestra el botón de mensajes anteriores y carga el historial',
    (tester) async {
      final repo = _PaginatedMessagingRepository(
        olderBatch: [
          ChatMessage(
            id: 'm-1',
            senderName: 'Tú',
            fromClient: true,
            text: 'Mensaje histórico en pantalla',
            sentAt: DateTime(2026, 11, 17, 10, 0),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: withRepositories(
            ProjectChatScreen.withBloc(conversationId: 'conv-1'),
            messaging: repo,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mensaje reciente 3'), findsOneWidget);
      expect(find.text('Mensaje histórico en pantalla'), findsNothing);
      final loadOlderButton = find.text('Cargar mensajes anteriores');
      expect(loadOlderButton, findsOneWidget);

      await tester.tap(loadOlderButton);
      await tester.pumpAndSettle();

      expect(find.text('Mensaje histórico en pantalla'), findsOneWidget);
      expect(find.text('Cargar mensajes anteriores'), findsNothing);

      await repo.controller.close();
    },
  );
}
