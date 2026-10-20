import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../home/widgets/kit/kit.dart';
import 'messaging_mock.dart';
import 'widgets/msg_bubbles.dart';
import 'widgets/msg_outline_button.dart';

/// Negociación y conversación del proyecto con el contratista (22:145219):
/// resumen del proyecto, hilo de mensajes, propuesta revisada y acciones.
class NegotiationChatScreen extends StatelessWidget {
  const NegotiationChatScreen({
    super.key,
    required this.contractor,
    required this.projectTitle,
  });

  final Contractor contractor;
  final String projectTitle;

  @override
  Widget build(BuildContext context) {
    final contractorName = contractor.name;
    return ProScreen(
      backgroundAsset: ProAssets.headerRenovation,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProBackHeader(
            title: 'Negociación y conversación',
            lucideChevron: true,
            height: 198,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProjectCard(contractorName),
                const SizedBox(height: 6),
                for (final entry in negotiationBeforeOffer) ...[
                  MsgThreadRow(
                    entry: entry,
                    name: entry.isMe ? 'Juan Pérez' : contractorName,
                  ),
                  const SizedBox(height: 6),
                ],
                const MsgOfferCard(),
                const SizedBox(height: 6),
                for (final entry in negotiationAfterOffer) ...[
                  MsgThreadRow(
                    entry: entry,
                    name: entry.isMe ? 'Juan Pérez' : contractorName,
                    compact: true,
                  ),
                  const SizedBox(height: 6),
                ],
                _buildComposerField(),
                const SizedBox(height: 6),
                MsgOutlineButton(label: 'Adjuntar fotos'),
                const SizedBox(height: 7),
                ProPrimaryButton.large('Ver acuerdo de trabajo'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String contractorName) {
    return ProCard(
      padding: const EdgeInsets.all(7),
      radius: ProRadii.card,
      borderWidth: ProStroke.hairline,
      child: Row(
        children: [
          ProImage(
            ProAssets.livingRoomTall,
            width: 71,
            height: 71,
            radius: ProRadii.sm,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectTitle,
                  style: ProText.r(
                    12,
                    weight: FontWeight.w600,
                    lineHeight: 14.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$contractorName\n',
                        style: ProText.r(
                          11,
                          color: ProColors.ink500,
                          lineHeight: 12.65,
                        ),
                      ),
                      TextSpan(
                        text: '$negotiationAmount        ▦ $negotiationDays',
                        style: ProText.r(
                          11,
                          color: ProColors.ink900,
                          lineHeight: 12.65,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const ProIcon(LucideIcon.chevronRight, size: 14),
        ],
      ),
    );
  }

  Widget _buildComposerField() {
    return ProCard(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      radius: ProRadii.md,
      borderWidth: ProStroke.divider,
      child: SizedBox(
        height: 36,
        child: Row(
          children: [
            const ProIcon(LucideIcon.paperclip, size: 19),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Escribe un mensaje...',
                style: ProText.r(
                  13,
                  color: ProColors.ink500,
                  lineHeight: 17.55,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
