import 'package:flutter/material.dart';
import '../../../data/firebase/training_service.dart';
import '../../../data/models/training.dart';
import 'training_detail_page.dart';

class WorkoutsListPage extends StatefulWidget {
  const WorkoutsListPage({super.key});

  @override
  State<WorkoutsListPage> createState() => _WorkoutsListPageState();
}

class _WorkoutsListPageState extends State<WorkoutsListPage> {
  final TrainingService _trainingService = TrainingService();
  late Future<List<Training>> _trainingsFuture;
  String _filterLevel = 'Todos';

  static const _levels = ['Todos', 'Principiante', 'Intermedio', 'Avanzado'];

  @override
  void initState() {
    super.initState();
    _trainingsFuture = _trainingService.getTrainings();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrenamientos'),
      ),
      body: Column(
        children: [
          // ─── FILTRO POR NIVEL ─────────────────────────────
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          color: selected ? primary : Colors.white24),
                      onSelected: (_) =>
                          setState(() => _filterLevel = level),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ─── LISTA ────────────────────────────────────────
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
                  return const Center(
                    child: Text(
                      'No hay entrenamientos para este nivel',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  itemCount: trainings.length,
                  itemBuilder: (context, index) {
                    final training = trainings[index];
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor:
                              primary.withOpacity(0.15),
                          child: Icon(Icons.fitness_center,
                              color: primary, size: 22),
                        ),
                        title: Text(
                          training.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${training.level} · ${training.type} · ${training.exercises.length} ejercicios',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 13),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: primary, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TrainingDetailPage(
                                  training: training),
                            ),
                          );
                        },
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

            },
          );
        },
      ),
    );
  }
}

class TrainingDetailPage extends StatelessWidget {
  final Training training;

  const TrainingDetailPage({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(training.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nivel: ${training.level}", style: const TextStyle(fontSize: 18)),
            Text("Tipo: ${training.type}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text("Ejercicios:", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: training.exercises.length,
                itemBuilder: (context, index) {
                  final e = training.exercises[index];
                  return ListTile(
                    title: Text(e.name),
                    subtitle: Text("${e.type} • ${e.duration}s"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

