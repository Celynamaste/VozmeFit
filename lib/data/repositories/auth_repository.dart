import 'package:vozmefit/data/firebase/auth_service.dart';
import 'package:vozmefit/data/models/usuario.dart';
import 'package:vozmefit/data/services/user_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  Future<String?> login(String email, String password) async {
    try {
      await _authService.loginWithEmail(email, password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> register(
      String email, String password, String role) async {
    try {
      final cred = await _authService.registerWithEmail(email, password);
      final user = Usuario(
        uid: cred.user!.uid,
        email: email,
        displayName: '',
        role: role,
      );
      await _userService.saveUser(user);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginWithGoogle() async {
    try {
      final cred = await _authService.signInWithGoogle();
      if (cred == null) return 'Inicio de sesión cancelado';

      // Si es la primera vez, crear perfil con rol "user"
      final existing = await _userService.getUser(cred.user!.uid);
      if (existing == null) {
        final newUser = Usuario(
          uid: cred.user!.uid,
          email: cred.user!.email ?? '',
          displayName: cred.user!.displayName ?? '',
          role: 'user',
        );
        await _userService.saveUser(newUser);
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
