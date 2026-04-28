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
  final _searchCtrl = TextEditingController();
  String _filterLevel = 'Todos';
  String _searchQuery = '';

  static const _levels = ['Todos', 'Principiante', 'Intermedio', 'Avanzado'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
          // ─── BUSCADOR ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Buscar entrenamiento...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // ─── FILTRO POR NIVEL ─────────────────────────────
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            child: StreamBuilder<List<Training>>(
              stream: _trainingService.streamTrainings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red)),
                  );
                }

                final all = snapshot.data ?? [];
                final trainings = all.where((t) {
                  final matchLevel = _filterLevel == 'Todos' || t.level == _filterLevel;
                  final matchSearch = _searchQuery.isEmpty ||
                      t.title.toLowerCase().contains(_searchQuery);
                  return matchLevel && matchSearch;
                }).toList();

                if (trainings.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay entrenamientos disponibles',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  itemCount: trainings.length,
                  itemBuilder: (context, index) {
                    final training = trainings[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TrainingDetailPage(training: training),
                        ),
                      ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (training.imageUrl.isNotEmpty)
                              Image.network(
                                training.imageUrl,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 160,
                                  color: primary.withOpacity(0.1),
                                  child: Icon(Icons.fitness_center,
                                      color: primary, size: 40),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    training.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${training.level} · ${training.type}',
                                    style: TextStyle(
                                        color: primary, fontSize: 13),
                                  ),
                                  if (training.description.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      training.description,
                                      style: const TextStyle(
                                          color: Colors.white54, fontSize: 13),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
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

