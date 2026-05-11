import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vozmefit/app/router.dart';
import 'package:vozmefit/data/models/usuario.dart';
import 'package:vozmefit/data/services/user_service.dart';
import 'package:vozmefit/presentation/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _userService = UserService();

  String _selectedLevel = 'Principiante';
  bool _saving = false;

  static const _levels = ['Principiante', 'Intermedio', 'Avanzado'];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _nameCtrl.text = user.displayName;
      if (user.level.isNotEmpty) _selectedLevel = user.level;
    }
    // Forzar recarga desde Firestore por si no se cargó al hacer login
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = context.read<AuthProvider>();
      await auth.reloadCurrentUser();
      final reloaded = auth.currentUser;
      if (reloaded != null && mounted) {
        setState(() {
          _nameCtrl.text = reloaded.displayName;
          if (reloaded.level.isNotEmpty) _selectedLevel = reloaded.level;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final auth = context.read<AuthProvider>();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    setState(() => _saving = true);

    // Usa currentUser si existe, sino construye uno nuevo desde FirebaseAuth
    final current = auth.currentUser;
    final updated = Usuario(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: _nameCtrl.text.trim(),
      role: current?.role ?? 'user',
      level: _selectedLevel,
    );

    await _userService.saveUser(updated);
    await auth.reloadCurrentUser();

    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRouter.login);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ─── AVATAR ────────────────────────────────────────
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: primary.withOpacity(0.15),
              child: Icon(Icons.person, size: 52, color: primary),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              user?.email ?? '',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 6),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primary.withOpacity(0.4)),
              ),
              child: Text(
                user?.role == 'trainer' ? 'Entrenador' : 'Usuario',
                style: TextStyle(
                    color: primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ─── NOMBRE ────────────────────────────────────────
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),

          if (user?.role != 'trainer') ...[
            const SizedBox(height: 28),

            // ─── NIVEL FÍSICO ───────────────────────────────
            const Text(
              'Nivel físico',
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tu rutina mostrará los entrenamientos de este nivel.',
              style: TextStyle(color: Colors.white30, fontSize: 12),
            ),
            const SizedBox(height: 12),

            Row(
              children: _levels.map((lvl) {
                final sel = _selectedLevel == lvl;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedLevel = lvl),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: sel
                              ? primary.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel ? primary : Colors.white24,
                            width: sel ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              sel
                                  ? Icons.bar_chart
                                  : Icons.bar_chart_outlined,
                              color: sel ? primary : Colors.white30,
                              size: 20,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              lvl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: sel ? primary : Colors.white38,
                                fontWeight: sel
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 36),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('Guardar cambios'),
            ),
          ),

          if (user?.role == 'trainer') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.admin_panel_settings_outlined),
                label: const Text('Panel de Entrenador'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: BorderSide(color: primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.trainerHome),
              ),
            ),
          ],

        ],
      ),
    );
  }
}
