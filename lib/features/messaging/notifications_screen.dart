import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'messaging_mock.dart';
import 'widgets/msg_list_rows.dart';
import 'widgets/msg_outline_button.dart';

/// Mensajes y notificaciones (22:146347): pestañas, conversaciones recientes,
/// notificaciones y acción principal. Se abre dentro de la navegación inferior
/// en la pestaña "Mensajes".
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      backgroundAsset: ProAssets.headerChat,
      navWhenPushed: ProNavDestination.messages,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProBackHeader(
            title: 'Mensajes y notificaciones',
            lucideChevron: true,
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 8),
            gap: 6,
            height: 120,
            titleWidth: 242,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTabs(),
                const SizedBox(height: 6),
                _buildConversationsCard(),
                const SizedBox(height: 6),
                const ProSectionHeader(
                  'Notificaciones recientes',
                  linkLabel: 'Ver todas',
                ),
                const SizedBox(height: 6),
                _buildNoticesCard(),
                const SizedBox(height: 75),
                ProPrimaryButton.large('Ver todas las conversaciones'),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return const Row(
      children: [
        Expanded(child: MsgTab(label: 'Mensajes', selected: true)),
        SizedBox(width: 4),
        Expanded(child: MsgTab(label: 'Notificaciones', selected: false)),
      ],
    );
  }

  Widget _buildConversationsCard() {
    return ProCard(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          for (var i = 0; i < messageConversations.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            MsgConversationRow(conversation: messageConversations[i]),
          ],
          const SizedBox(height: 16),
          MsgOutlineButton(label: 'Ver todas las conversaciones'),
        ],
      ),
    );
  }

  Widget _buildNoticesCard() {
    return ProCard(
      padding: const EdgeInsets.all(7),
      child: Column(
        children: [
          for (final notice in messageNotices)
            ProOptionRow(
              icon: notice.icon,
              title: notice.title,
              subtitle: notice.subtitle,
              lineHeight: 15,
            ),
        ],
      ),
    );
  }
}
