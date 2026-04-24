import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vozmefit/data/firebase/training_service.dart';
import 'package:vozmefit/data/models/exercise.dart';
import 'package:vozmefit/data/models/training.dart';
import 'package:vozmefit/presentation/screens/trainer/trainer_training_form.dart';

class TrainerHomeScreen extends StatefulWidget {
  const TrainerHomeScreen({super.key});

  @override
  State<TrainerHomeScreen> createState() => _TrainerHomeScreenState();
}

class _TrainerHomeScreenState extends State<TrainerHomeScreen> {
  final _service = TrainingService();
  late Future<List<Training>> _trainingsFuture;
  String _filterLevel = 'Todos';

  static const _levels = ['Todos', 'Principiante', 'Intermedio', 'Avanzado'];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _trainingsFuture = _service.getTrainings();
    });
  }

  Future<void> _delete(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar rutina'),
        content: const Text('¿Seguro que quieres eliminar esta rutina?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _service.deleteTraining(id);
      _reload();
    }
  }

  void _goToForm({Training? training}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrainerTrainingForm(training: training),
      ),
    );
    _reload();
  }

  /// Crea 3 entrenamientos de ejemplo en Firestore (solo en modo debug)
  Future<void> _seedData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cargar datos de ejemplo'),
        content: const Text(
            '¿Crear 3 entrenamientos de muestra (Principiante, Intermedio, Avanzado)?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Crear')),
        ],
      ),
    );
    if (confirm != true) return;

    final seedTrainings = [
      Training(
        id: 'seed-principiante',
        title: 'Inicio Total - Cuerpo Completo',
        level: 'Principiante',
        type: 'Cuerpo completo',
        exercises: [
          Exercise(name: 'Marcha en el sitio', description: 'Levanta las rodillas al caminar en el sitio', duration: 60, type: 'Cardio'),
          Exercise(name: 'Sentadilla con peso corporal', description: 'Baja hasta paralelo, espalda recta', duration: 45, type: 'Piernas'),
          Exercise(name: 'Flexiones en rodillas', description: 'Cuerpo recto desde rodillas hasta hombros', duration: 40, type: 'Pecho'),
          Exercise(name: 'Plancha', description: 'Aguanta en posición de plancha manteniendo el core firme', duration: 30, type: 'Abdominales'),
          Exercise(name: 'Estiramiento de piernas', description: 'Tira del talón al glúteo alternando piernas', duration: 60, type: 'Estiramientos'),
        ],
      ),
      Training(
        id: 'seed-intermedio',
        title: 'Fuerza y Cardio Combinado',
        level: 'Intermedio',
        type: 'HIIT',
        exercises: [
          Exercise(name: 'Jumping Jacks', description: 'Saltos abriendo y cerrando piernas y brazos', duration: 60, type: 'Cardio'),
          Exercise(name: 'Sentadilla búlgara', description: 'Pie trasero elevado, baja el cuerpo hacia el suelo', duration: 45, type: 'Piernas'),
          Exercise(name: 'Flexiones con pausa', description: 'Baja 2 s, aguanta 1 s abajo, sube explosivo', duration: 40, type: 'Pecho'),
          Exercise(name: 'Remo invertido', description: 'Usa una barra o anillas, cuerpo recto, tira hasta el pecho', duration: 45, type: 'Espalda'),
          Exercise(name: 'Abdominales bicicleta', description: 'Alterna codo con rodilla contraria controlando', duration: 40, type: 'Abdominales'),
          Exercise(name: 'Vuelta a la calma - movilidad', description: 'Círculos de cadera, hombros y muñecas', duration: 60, type: 'Movilidad'),
        ],
      ),
      Training(
        id: 'seed-avanzado',
        title: 'HIIT Avanzado - Sin Descanso',
        level: 'Avanzado',
        type: 'HIIT',
        exercises: [
          Exercise(name: 'Burpees', description: '4 tiempos: flexión, plancha, salto, palmada arriba', duration: 60, type: 'HIIT'),
          Exercise(name: 'Pistol squat', description: 'Sentadilla a una pierna, alterna lados', duration: 50, type: 'Piernas'),
          Exercise(name: 'Flexiones en pica', description: 'Cuerpo en V invertida, baja la cabeza entre manos', duration: 45, type: 'Hombros'),
          Exercise(name: 'L-sit en silla', description: 'Apoya en sillas, eleva las caderas y extiende piernas', duration: 30, type: 'Abdominales'),
          Exercise(name: 'Mountain Climbers', description: 'Lleva las rodillas al pecho alternando a máxima velocidad', duration: 60, type: 'Cardio'),
          Exercise(name: 'Fondos de tríceps', description: 'Usa una silla, codos atrás, baja hasta 90°', duration: 45, type: 'Brazos'),
          Exercise(name: 'Estiramiento completo', description: 'Cadena posterior, cuádriceps e isquiotibiales', duration: 90, type: 'Estiramientos'),
        ],
      ),
    ];

    for (final t in seedTrainings) {
      await _service.saveTraining(t);
    }

    _reload();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('3 entrenamientos de ejemplo creados')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Entrenador'),
        centerTitle: true,
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.science_outlined),
              tooltip: 'Cargar datos de ejemplo',
              onPressed: _seedData,
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goToForm(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva rutina'),
      ),

      body: Column(
        children: [
          // ─── FILTRO POR NIVEL ───────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _levels.map((level) {
                  final selected = _filterLevel == level;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(level),
                      selected: selected,
                      selectedColor: primary.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: selected ? primary : Colors.white54,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: selected ? primary : Colors.white24,
                      ),
                      onSelected: (_) =>
                          setState(() => _filterLevel = level),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ─── LISTA DE RUTINAS ───────────────────────────────
          Expanded(
            child: FutureBuilder<List<Training>>(
              future: _trainingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final all = snapshot.data ?? [];
                final trainings = _filterLevel == 'Todos'
                    ? all
                    : all
                        .where((t) => t.level == _filterLevel)
                        .toList();

                if (trainings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fitness_center,
                            size: 64, color: primary.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        const Text('No hay rutinas todavía',
                            style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                  itemCount: trainings.length,
                  itemBuilder: (context, index) {
                    final t = trainings[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: primary.withOpacity(0.15),
                          child: Icon(Icons.fitness_center,
                              color: primary, size: 22),
                        ),
                        title: Text(
                          t.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${t.level} · ${t.type} · ${t.exercises.length} ejercicios',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 13),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit_outlined, color: primary),
                              tooltip: 'Editar',
                              onPressed: () => _goToForm(training: t),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              tooltip: 'Eliminar',
                              onPressed: () => _delete(t.id),
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
    );
  }
}
