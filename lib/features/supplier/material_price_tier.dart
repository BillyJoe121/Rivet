import '../../core/models/models.dart';

/// Precio que la Bodega muestra a quien la consulta.
enum MaterialPriceTier {
  /// Cliente: ve solo el precio de cliente.
  client,

  /// Contratista verificado: ve el precio de contratista.
  verifiedPro,

  /// Contratista sin verificar: ve el precio de cliente y un aviso.
  unverifiedPro;

  /// Precio que corresponde a este nivel.
  int priceOf(MaterialProduct product) =>
      this == verifiedPro ? product.proPriceCop : product.clientPriceCop;

  bool get isVerifiedPro => this == verifiedPro;
  bool get isUnverifiedPro => this == unverifiedPro;
}

/// Formatea pesos colombianos con punto de miles: 87000 → "87.000".
String formatCop(int amount) {
  return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
}
