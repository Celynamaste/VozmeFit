import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vozmefit/presentation/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "VozmeFit",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              if (auth.errorMessage != null)
                Text(
                  auth.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 20),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          final ok = await auth.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );

                          if (ok && mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                  child: auth.isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text("Iniciar sesión"),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF7FEFE3)),
                    foregroundColor: const Color(0xFF7FEFE3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          final ok = await auth.loginWithGoogle();

                          if (ok && mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                  child: const Text("Continuar con Google"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
