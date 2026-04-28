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
  bool _isRegistering = false;
  String _selectedRole = 'user';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _routeForRole(AuthProvider auth) {
    return '/home';
  }

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
              const SizedBox(height: 8),
              Text(
                _isRegistering ? "Crea tu cuenta" : "Bienvenido de nuevo",
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              ),
              const SizedBox(height: 40),
              if (auth.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    auth.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
              ),
              if (_isRegistering) ...[
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "¿Cuál es tu rol?",
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _RoleChip(
                      label: "Usuario",
                      icon: Icons.person_outline,
                      selected: _selectedRole == 'user',
                      onTap: () => setState(() => _selectedRole = 'user'),
                    ),
                    const SizedBox(width: 12),
                    _RoleChip(
                      label: "Entrenador",
                      icon: Icons.fitness_center,
                      selected: _selectedRole == 'trainer',
                      onTap: () => setState(() => _selectedRole = 'trainer'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          final bool ok;
                          if (_isRegistering) {
                            ok = await auth.register(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              _selectedRole,
                            );
                          } else {
                            ok = await auth.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          }
                          if (ok && mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              _routeForRole(auth),
                            );
                          }
                        },
                  child: auth.isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(_isRegistering ? "Crear cuenta" : "Iniciar sesión"),
                ),
              ),
              if (!_isRegistering) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            final ok = await auth.loginWithGoogle();
                            if (ok && mounted) {
                              Navigator.pushReplacementNamed(
                                context,
                                _routeForRole(auth),
                              );
                            }
                          },
                    child: const Text("Continuar con Google"),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isRegistering = !_isRegistering;
                    _selectedRole = 'user';
                  });
                },
                child: Text(
                  _isRegistering
                      ? "¿Ya tienes cuenta? Inicia sesión"
                      : "¿No tienes cuenta? Regístrate",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? primary.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? primary : Colors.white24,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? primary : Colors.white38),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? primary : Colors.white38,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
