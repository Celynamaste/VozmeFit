import 'package:vozmefit/data/firebase/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<String?> login(String email, String password) async {
    try {
      await _authService.loginWithEmail(email, password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      await _authService.registerWithEmail(email, password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
