import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/models/usuario.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/user_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final UserService _userService = UserService();

  bool isLoading = false;
  String? errorMessage;
  Usuario? currentUser;

  bool get isTrainer => currentUser?.role == 'trainer';

  Future<void> _loadCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    currentUser = await _userService.getUser(uid);
  }

  Future<void> reloadCurrentUser() async {
    await _loadCurrentUser();
    notifyListeners();
  }

  // LOGIN
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authRepository.login(email, password);

    if (result == null) {
      await _loadCurrentUser();
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      errorMessage = result;
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // LOGIN CON GOOGLE
  Future<bool> loginWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authRepository.loginWithGoogle();

    if (result == null) {
      await _loadCurrentUser();
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      errorMessage = result;
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // REGISTRO
  Future<bool> register(String email, String password, String role) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authRepository.register(email, password, role);

    if (result == null) {
      await _loadCurrentUser();
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      errorMessage = result;
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _authRepository.logout();
    currentUser = null;
    notifyListeners();
  }
}
