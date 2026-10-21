/// Reglas de validación estrictas para Rivet (Sprint 1).
///
/// Implementa RFC 5322 simplificado para email, contraseña segura y formato móvil Colombia.
abstract final class Validators {
  /// Expresión regular para email estándar RFC 5322.
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
  );

  /// Celular Colombia: 10 dígitos iniciando en 3 (ej. 3001234567, 310..., 320...).
  static final RegExp _colombiaPhoneRegExp = RegExp(r'^3\d{9}$');

  /// Validador de correo electrónico.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu correo electrónico';
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Ingresa un correo electrónico válido (ej. usuario@dominio.com)';
    }
    return null;
  }

  /// Validador de contraseña segura:
  /// - Mínimo 8 caracteres
  /// - Al menos 1 letra mayúscula
  /// - Al menos 1 número
  /// - Al menos 1 carácter especial (@, $, !, %, *, #, ?, &, etc.)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu contraseña';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Debe incluir al menos una letra mayúscula';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Debe incluir al menos un número';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-=+/\\]'))) {
      return 'Debe incluir al menos un carácter especial (!@#%&*...)';
    }
    return null;
  }

  /// Validador de confirmación de contraseña.
  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != originalPassword) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  /// Validador de teléfono celular nacional (Colombia).
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu número de celular';
    }
    // Normalizar quitando espacios, guiones y prefijo +57
    var sanitized = value.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (sanitized.startsWith('+57')) {
      sanitized = sanitized.substring(3);
    } else if (sanitized.startsWith('57') && sanitized.length == 12) {
      sanitized = sanitized.substring(2);
    }

    if (!_colombiaPhoneRegExp.hasMatch(sanitized)) {
      return 'Ingresa un número de celular colombiano válido (10 dígitos iniciando en 3)';
    }
    return null;
  }

  /// Normaliza el teléfono al formato nacional de 10 dígitos.
  static String sanitizePhone(String value) {
    var sanitized = value.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (sanitized.startsWith('+57')) {
      sanitized = sanitized.substring(3);
    } else if (sanitized.startsWith('57') && sanitized.length == 12) {
      sanitized = sanitized.substring(2);
    }
    return sanitized;
  }

  /// Validador de nombre completo.
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu nombre completo';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    return null;
  }
}
