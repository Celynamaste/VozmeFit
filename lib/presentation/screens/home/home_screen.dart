import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vozmefit/app/router.dart';
import 'package:vozmefit/data/firebase/training_service.dart';
import 'package:vozmefit/data/models/training.dart';
import 'package:vozmefit/presentation/providers/auth_provider.dart';
import 'package:vozmefit/presentation/screens/workouts/training_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _trainingService = TrainingService();
  late Future<List<Training>> _trainingsFuture;

  @override
  void initState() {
    super.initState();
    _trainingsFuture = _trainingService.getTrainings();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final auth = context.watch<AuthProvider>();
    final userName = auth.currentUser?.displayName;
    final greeting = userName != null && userName.isNotEmpty
        ? '¡Hola, $userName!'
        : '¡Bienvenido!';

    return Scaffold(
      appBar: AppBar(
        title: const Text("VozMeFit"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: "Mi perfil",
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.profile),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRouter.login);
              }
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ─── SALUDO ────────────────────────────────────
              Text(
                greeting,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                auth.currentUser?.level != null
                    ? 'Nivel: ${auth.currentUser!.level}'
                    : 'Configura tu nivel en el perfil',
                style: TextStyle(
                  color: auth.currentUser?.level != null
                      ? primaryColor
                      : Colors.white38,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),

              // ─── VER TODOS LOS ENTRENAMIENTOS ──────────────
              _HomeCard(
                title: "Ver entrenamientos",
                icon: Icons.fitness_center,
                color: primaryColor,
                onTap: () =>
                    Navigator.pushNamed(context, AppRouter.workouts),
              ),

              const SizedBox(height: 16),

              // ─── AGENDA ────────────────────────────────────
              _HomeCard(
                title: "Mi Agenda",
                icon: Icons.calendar_today_outlined,
                color: primaryColor,
                onTap: () =>
                    Navigator.pushNamed(context, AppRouter.agenda),
              ),

              const SizedBox(height: 16),

              // ─── ESTADÍSTICAS ───────────────────────────────
              _HomeCard(
                title: "Mis Estadísticas",
                icon: Icons.bar_chart,
                color: primaryColor,
                onTap: () =>
                    Navigator.pushNamed(context, AppRouter.stats),
              ),

              const SizedBox(height: 30),

              const Text(
                "Entrenamientos recientes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 160,
                child: FutureBuilder<List<Training>>(
                  future: _trainingsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final trainings = snapshot.data ?? [];
                    final recent = trainings.take(5).toList();

                    if (trainings.isEmpty) {
                      return const Center(
                        child: Text(
                          "No hay entrenamientos todavía.",
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recent.length,
                      itemBuilder: (context, index) {
                        final training = recent[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TrainingDetailPage(training: training),
                              ),
                            );
                          },
                          child: Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: 15),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.fitness_center,
                                    color: primaryColor, size: 28),
                                const SizedBox(height: 10),
                                Text(
                                  training.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${training.level} · ${training.exercises.length} ej.",
                                  style: const TextStyle(
                                      color: Colors.white60, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// WIDGET REUTILIZABLE PARA LAS TARJETAS DEL HOME
// ---------------------------------------------------------
class _HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}
