import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

/// Cabecera con botón de regreso y título a su derecha, en un ancho fijo que
/// permite el salto de línea (x = 64, título desde y = 46).
class OrderInlineHeader extends StatelessWidget {
  const OrderInlineHeader(this.title, {super.key, required this.width, this.height = 86});

  final String title;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProBackButton(),
            const SizedBox(width: 10),
            SizedBox(width: width, child: Text(title, style: ProText.pageTitle)),
          ],
        ),
      ),
    );
  }
}
