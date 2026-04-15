import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  // LOGIN
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authRepository.login(email, password);

    isLoading = false;

    if (result == null) {
      notifyListeners();
      return true; // login correcto
    } else {
      errorMessage = result;
      notifyListeners();
      return false; // error
    }
  }

  // LOGIN CON GOOGLE
  Future<bool> loginWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authRepository.loginWithGoogle();

    isLoading = false;

    if (result == null) {
      notifyListeners();
      return true;
    } else {
      errorMessage = result;
      notifyListeners();
      return false;
    }
  }

  // REGISTRO
  Future<bool> register(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _authRepository.register(email, password);

    isLoading = false;

    if (result == null) {
      notifyListeners();
      return true;
    } else {
      errorMessage = result;
      notifyListeners();
      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _authRepository.logout();
    notifyListeners();
  }
}
