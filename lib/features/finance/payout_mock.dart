/// Datos simulados de la cuenta de cobro y del pago liberado del contratista.
/// Son cifras de prototipo: no se realiza ninguna transferencia real.
abstract final class PayoutMock {
  static const String holder = 'Carlos Ramírez';
  static const String bank = 'Bancolombia';
  static const String accountType = 'Ahorros';
  static const String maskedAccount = '•••• •••• 5678';
  static const String shortAccount = 'Cuenta •••• 5678';
  static const String role = 'Contratista · Carlos Ramírez';
  static const String pendingStatus = 'Pendiente de verificar';

  static const String paidProject = 'Pintar sala y comedor';
  static const String netAmount = '\$ 1.150.000 COP';
  static const String laborAmount = '\$ 1.200.000 COP';
  static const String paymentDate = '18 de mayo de 2024';
}
