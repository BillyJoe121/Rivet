import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../home/widgets/kit/kit.dart';
import '../account/widgets/account_action_buttons.dart';
import '../account/widgets/account_proposal_form_widgets.dart';

/// Pantalla donde el contratista crea y envía su propuesta (Figma 22:145820).
class CreateProposalScreen extends StatefulWidget {
  const CreateProposalScreen({super.key, required this.project});

  final Project project;

  @override
  State<CreateProposalScreen> createState() => _CreateProposalScreenState();
}

class _CreateProposalScreenState extends State<CreateProposalScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    return ProScreen(
      backgroundAsset: ProAssets.headerRoller,
      bottomNav: const ProBottomNav(active: ProNavDestination.home),
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(22, 6, 22, 6),
        child: Row(
          children: [
            SizedBox(
              width: 181,
              child: AccountOutlineButton('Guardar borrador', onTap: () => Navigator.maybePop(context)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AccountGradientButton('Enviar propuesta', onTap: () => Navigator.maybePop(context)),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProBackHeader(
            title: 'Crear y enviar propuesta',
            lucideChevron: true,
            height: 126,
            titleWidth: 239,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 3,
              children: [
                _ProjectCard(title: project.title, city: project.city),
                const ProposalStepper(labels: ['Mano de obra', 'Materiales', 'Resumen'], active: 0),
                const ProSectionHeader('Información de la propuesta'),
                ProCard(
                  radius: ProRadii.lg,
                  borderWidth: 0.6,
                  padding: const EdgeInsets.all(4),
                  child: const Column(
                    children: [
                      ProposalSummaryRow(icon: LucideIcon.fileText, label: 'Mano de obra estimada', value: '\$ 1.200.000'),
                      ProposalSummaryRow(icon: LucideIcon.clock, label: 'Duración estimada', value: '12 días'),
                      ProposalSummaryRow(icon: LucideIcon.calendar, label: 'Fecha de inicio', value: '15 abr. 2024'),
                    ],
                  ),
                ),
                const ProSectionHeader('Buscar en Bodega'),
                _SearchField(controller: _search),
                const ProposalMaterialCard(
                  image: ProAssets.rivetPaint,
                  text: 'Pintura vinilo premium\nInterior lavable, 1 galón\nCosto contratista      Precio al cliente\n\$ 87.000              \$ 120.000',
                ),
                const ProposalMaterialCard(
                  image: ProAssets.coronaStucco,
                  text: 'Estuco plástico\nAcabado profesional, 5 galones\nCosto contratista      Precio al cliente\n\$ 45.000              \$ 70.000',
                ),
                const ProposalMaterialCard(
                  image: ProAssets.maskingTape,
                  text: 'Cinta y selladores\nCinta de enmascarar, 45 m\nCosto contratista      Precio al cliente\n\$ 12.000              \$ 18.000',
                ),
                const _TotalNotice(text: 'Valor total de la propuesta     \$ 3.200.000'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta del proyecto a cotizar con foto de 46 px.
class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.title, required this.city});

  final String title;
  final String city;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      height: 60,
      radius: ProRadii.card,
      borderWidth: ProStroke.hairline,
      padding: const EdgeInsets.all(7),
      child: Row(
        children: [
          const ProImage(ProAssets.greenWallTall, width: 46, height: 46, radius: 10),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                Text(title, style: ProText.labelStrong),
                Text(
                  '62 m² · 3 ambientes\n♧ $city',
                  style: ProText.r(11, color: ProColors.ink500, lineHeight: 12.65),
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          const ProIcon(LucideIcon.chevronRight, size: 14),
        ],
      ),
    );
  }
}

/// Campo de búsqueda de 36 px con borde de 1 px y lupa de marca.
class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ProColors.surface0,
        borderRadius: BorderRadius.circular(ProRadii.md),
        border: Border.all(color: ProColors.line300, width: 1),
      ),
      child: Row(
        children: [
          const ProIcon(LucideIcon.search, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: ProText.r(13, color: ProColors.ink900, lineHeight: 17.55),
              decoration: InputDecoration.collapsed(
                hintText: 'Buscar materiales, marcas o categorías...',
                hintStyle: ProText.r(13, color: ProColors.ink500, lineHeight: 17.55),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Aviso con el valor total de la propuesta en fondo verde suave.
class _TotalNotice extends StatelessWidget {
  const _TotalNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: ProColors.brandLight, borderRadius: BorderRadius.circular(ProRadii.md)),
      child: Row(
        children: [
          const ProIcon(LucideIcon.info, size: 23),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: ProText.r(12, color: ProColors.ink500, lineHeight: 14.4))),
        ],
      ),
    );
  }
}
