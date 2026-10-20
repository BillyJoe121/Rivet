import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'messaging_mock.dart';
import 'widgets/msg_bubbles.dart';

/// Chat sobre la propuesta con el contratista (55:105): cabecera con el
/// contratista, la propuesta vinculada, la conversación y la barra fija
/// "Escribe un mensaje…" para enviar.
class ProposalChatScreen extends StatefulWidget {
  const ProposalChatScreen({super.key});

  @override
  State<ProposalChatScreen> createState() => _ProposalChatScreenState();
}

class _ProposalChatScreenState extends State<ProposalChatScreen> {
  final _controller = TextEditingController();
  final List<MsgBubble> _messages = List.of(proposalChatMessages);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final now = DateTime.now();
    final time = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    setState(() {
      _messages.add(MsgBubble(text: text, time: time, mine: true));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      backgroundAsset: ProAssets.headerBotanical,
      footer: _buildComposer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ProImage(
                        ProAssets.avatarCarlos,
                        width: 60,
                        height: 60,
                        radius: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              proposalContractorName,
                              style: ProText.serif(
                                16,
                                color: ProColors.ink900,
                                lineHeight: 20.48,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              proposalContractorTrade,
                              style: ProText.r(
                                12,
                                color: ProColors.ink500,
                                lineHeight: 14.0625,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              proposalContractorZone,
                              style: ProText.r(
                                12,
                                color: ProColors.ink500,
                                lineHeight: 14.0625,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildLinkedProposal(),
                const SizedBox(height: 14),
                Text(
                  'Hoy',
                  textAlign: TextAlign.center,
                  style: ProText.r(
                    11,
                    color: ProColors.ink500,
                    lineHeight: 12.890625,
                  ),
                ),
                const SizedBox(height: 14),
                for (var i = 0; i < _messages.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  MsgChatBubble(message: _messages[i]),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 132,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProBackButton(onTap: () => Navigator.of(context).maybePop()),
            const SizedBox(height: 8),
            const ProPageTitle('Chat'),
            const SizedBox(height: 8),
            SizedBox(
              width: 245,
              child: Text(
                'Resuelve tus dudas sobre la propuesta con el contratista.',
                style: ProText.r(14, color: ProColors.ink500, lineHeight: 16.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedProposal() {
    return SizedBox(
      height: 64,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF3EF),
          borderRadius: BorderRadius.circular(ProRadii.lg),
        ),
        child: Row(
          children: [
            const ProIcon(LucideIcon.fileText, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proposalTitle,
                    style: ProText.r(
                      13,
                      weight: FontWeight.w600,
                      color: ProColors.ink900,
                      lineHeight: 15.234375,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    proposalSummary,
                    style: ProText.r(
                      12,
                      color: ProColors.ink500,
                      lineHeight: 14.0625,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const ProChevron(width: 5, height: 9),
          ],
        ),
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.only(bottom: bottom),
      decoration: const BoxDecoration(
        color: ProColors.paper100,
        border: Border(
          top: BorderSide(color: ProColors.line300, width: ProStroke.card),
        ),
      ),
      child: SizedBox(
        height: 88,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: ProColors.surface0,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: ProColors.line300,
                        width: ProStroke.divider,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onSubmitted: (_) => _send(),
                            style: ProText.r(
                              14,
                              color: ProColors.ink900,
                              lineHeight: 16.4,
                            ),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Escribe un mensaje…',
                              hintStyle: ProText.r(
                                14,
                                color: ProColors.ink500,
                                lineHeight: 16.4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const ProIcon(LucideIcon.paperclip, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: ProColors.brandGradient,
                    ),
                    child: const ProIcon(
                      LucideIcon.send,
                      size: 21,
                      color: ProColors.surface0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
