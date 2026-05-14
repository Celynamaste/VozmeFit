import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LOGIN CON GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      // En web se usa signInWithPopup directamente con Firebase
      final provider = GoogleAuthProvider();
      provider.addScope('email');
      provider.addScope('https://www.googleapis.com/auth/userinfo.profile');
      return await _auth.signInWithPopup(provider);
    }

    // Flujo móvil (Android / iOS)
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null; // El usuario canceló el login

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    if (googleAuth.idToken == null) {
      throw Exception(
        'No se pudo obtener el token de Google. Asegúrate de que el SHA-1 esté registrado en Firebase Console.',
      );
    }

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  // LOGIN CON EMAIL
  Future<UserCredential> loginWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // REGISTRO CON EMAIL
  Future<UserCredential> registerWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
