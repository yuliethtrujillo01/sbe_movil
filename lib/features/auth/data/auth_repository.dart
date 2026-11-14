
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Stream<User?> get authChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  bool correoInstitucional(String correo) {
    return correo.trim().toLowerCase().endsWith('@uceva.edu.co');
  }

  Future<void> registrar({
    required String correo,
    required String contrasena,
  }) async {
    final email = correo.trim().toLowerCase();

    if (!correoInstitucional(email)) {
      throw Exception('Utiliza tu correo institucional @uceva.edu.co.');
    }

    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: contrasena,
    );

    try {
      await credencial.user!.sendEmailVerification();
    } finally {
      await _auth.signOut();
    }
  }

  Future<void> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    final email = correo.trim().toLowerCase();

    if (!correoInstitucional(email)) {
      throw Exception('Utiliza tu correo institucional @uceva.edu.co.');
    }

    final credencial = await _auth.signInWithEmailAndPassword(
      email: email,
      password: contrasena,
    );

    final usuario = credencial.user!;

    await usuario.reload();
    final actualizado = _auth.currentUser;

    if (actualizado == null || !actualizado.emailVerified) {
      await _auth.signOut();
      throw Exception(
        'Debes verificar tu correo institucional antes de ingresar.',
      );
    }
  }

  Future<void> recuperarContrasena(String correo) async {
    final email = correo.trim().toLowerCase();

    if (!correoInstitucional(email)) {
      throw Exception('Introduce un correo institucional válido.');
    }

    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> cerrarSesion() => _auth.signOut();

  String mensajeError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Ya existe una cuenta con este correo.';
        case 'invalid-email':
          return 'El correo electrónico no es válido.';
        case 'weak-password':
          return 'La contraseña es demasiado débil.';
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'Correo o contraseña incorrectos.';
        case 'too-many-requests':
          return 'Demasiados intentos. Inténtalo más tarde.';
        case 'network-request-failed':
          return 'Revisa tu conexión a Internet.';
        default:
          return 'No fue posible completar la operación. '
              'Inténtalo nuevamente.';
      }
    }

    return error.toString().replaceFirst('Exception: ', '');
  }
}
