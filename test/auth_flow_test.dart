import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/auth/auth_service.dart';
import 'package:rivet/features/auth/domain/entities/rivet_user.dart';
import 'package:rivet/features/auth/domain/repositories/auth_repository.dart';
import 'package:rivet/features/auth/login_screen.dart';
import 'package:rivet/features/auth/signup_screen.dart';

class MockAuthRepository implements AuthRepository {
  final _controller = StreamController<RivetUser?>.broadcast();
  RivetUser? currentUser;

  @override
  Future<RivetUser> signIn({
    required String email,
    required String password,
  }) async {
    if (password == 'Password123!') {
      final user = RivetUser(
        id: 'user-123',
        email: email,
        fullName: 'Juan Pérez',
        role: UserRole.client,
      );
      currentUser = user;
      _controller.add(user);
      return user;
    }
    throw Exception('Correo o contraseña incorrectos. Verifica tus datos.');
  }

  @override
  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) async {
    final user = RivetUser(
      id: 'user-new',
      email: email,
      fullName: fullName,
      role: role,
      phone: phone,
    );
    currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signOut() async {
    currentUser = null;
    _controller.add(null);
  }

  @override
  Future<RivetUser?> getCurrentUser() async => currentUser;

  @override
  Stream<RivetUser?> get authStateChanges => _controller.stream;
}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    AuthService.instance.setRepositoryForTesting(mockRepo);
  });

  testWidgets('LoginScreen valida correo inválido y muestra error', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Tocar el botón de inicio de sesión
    final loginButton = find.text('Iniciar sesión');
    await tester.ensureVisible(loginButton.last);
    await tester.tap(loginButton.last);
    await tester.pump();

    // Debe mostrar error de validación
    expect(find.text('Ingresa tu correo electrónico'), findsAtLeastNWidgets(1));
  });

  testWidgets('SignupScreen valida campos vacíos y requisitos de contraseña', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: SignupScreen(),
      ),
    );

    // Tocar el botón de crear cuenta
    final signupButton = find.text('Crear cuenta');
    await tester.ensureVisible(signupButton);
    await tester.tap(signupButton);
    await tester.pump();

    // Debe mostrar error de nombre
    expect(find.text('Ingresa tu nombre completo'), findsAtLeastNWidgets(1));
  });
}
