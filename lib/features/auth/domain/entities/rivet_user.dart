import '../../../../core/models/models.dart';

/// Entidad que representa al usuario autenticado y su perfil en Rivet.
class RivetUser {
  const RivetUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phone = '',
    this.avatarUrl,
    this.createdAt,
    this.isVerified = false,
  });

  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String phone;
  final String? avatarUrl;
  final DateTime? createdAt;

  /// Contratista verificado por Rivet; solo ellos ven los precios de contratista.
  final bool isVerified;

  /// Crea una instancia a partir de un registro de base de datos (`profiles`).
  factory RivetUser.fromJson(Map<String, dynamic> json) {
    final roleStr = (json['role'] as String? ?? 'client').toLowerCase();
    final role = roleStr == 'contractor' ? UserRole.contractor : UserRole.client;

    return RivetUser(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      role: role,
      phone: json['phone'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  /// Convierte a JSON para inserciones parametrizadas en Supabase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role == UserRole.contractor ? 'contractor' : 'client',
      'phone': phone,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    };
  }

  RivetUser copyWith({
    String? id,
    String? email,
    String? fullName,
    UserRole? role,
    String? phone,
    String? avatarUrl,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return RivetUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
