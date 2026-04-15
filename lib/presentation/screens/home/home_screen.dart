import 'package:flutter/material.dart';
import 'package:vozmefit/data/services/workout_service.dart';
import 'package:vozmefit/presentation/screens/workouts/workouts_list_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _workoutService = WorkoutService();

  @override
  Widget build(BuildContext context) {
    const corporateBlue = Color(0xFF4DA3FF);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("VozMeFit"),
        centerTitle: true,
        backgroundColor: corporateBlue,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // -------------------------
              // TARJETA: VER ENTRENAMIENTOS
              // -------------------------
              _HomeCard(
                title: "Ver entrenamientos",
                icon: Icons.fitness_center,
                color: corporateBlue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WorkoutsListPage()),
                  );
                },
              ),

              const SizedBox(height: 20),

              // -------------------------
              // TARJETA: MIS ENTRENAMIENTOS
              // -------------------------
              _HomeCard(
                title: "Mis entrenamientos",
                icon: Icons.list_alt,
                color: corporateBlue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WorkoutsListPage()),
                  );
                },
              ),

              const SizedBox(height: 30),

              const Text(
                "Entrenamientos destacados",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 200,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _workoutService.getWorkouts(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final workouts = snapshot.data!;
                    if (workouts.isEmpty) {
                      return const Center(
                        child: Text(
                          "No hay entrenamientos aún",
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        final workout = workouts[index];

                        return GestureDetector(
                          onTap: () {
                            // Aquí irá WorkoutDetailScreen cuando la creemos
                          },
                          child: Container(
                            width: 220,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: corporateBlue.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: corporateBlue.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  child: workout['imageUrl'] != null
                                      ? Image.network(
                                          workout['imageUrl'],
                                          height: 110,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 110,
                                          color: Colors.white12,
                                          child: const Icon(
                                            Icons.image,
                                            color: Colors.white54,
                                          ),
                                        ),
                                ),

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          workout['name'] ?? "Entrenamiento",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: corporateBlue,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          workout['description'] ??
                                              "Sin descripción",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
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
              padding: const EdgeInsets.all(16),
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
            Icon(Icons.arrow_forward_ios, color: color),
          ],
        ),
      ),
    );
  }
}
