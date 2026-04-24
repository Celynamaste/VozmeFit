import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vozmefit/data/firebase/training_service.dart';
import 'package:vozmefit/data/models/training.dart';
import 'package:vozmefit/data/services/workout_log_service.dart';
import 'package:vozmefit/presentation/providers/auth_provider.dart';

class MyRoutineScreen extends StatefulWidget {
  const MyRoutineScreen({super.key});

  @override
  State<MyRoutineScreen> createState() => _MyRoutineScreenState();
}

class _MyRoutineScreenState extends State<MyRoutineScreen> {
  final _trainingService = TrainingService();
  late Future<List<Training>> _routineFuture;
  String? _userLevel;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _userLevel = auth.currentUser?.level;
    _routineFuture = _loadRoutine();
  }

  Future<List<Training>> _loadRoutine() async {
    final all = await _trainingService.getTrainings();
    if (_userLevel == null || _userLevel!.isEmpty) return all;
    return all.where((t) => t.level == _userLevel).toList();
  }

  void _openLogDialog(Training training) {
    final notesCtrl = TextEditingController();
    final weightCtrl = TextEditingController();
    final repsCtrl = TextEditingController();
    String sensation = 'normal';
    final service = WorkoutLogService();
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          title: Text('Registrar: ${training.title}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: notesCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Notas / sensaciones'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: weightCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Peso (kg)'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: repsCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Repeticiones'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('¿Cómo te ha resultado?',
                    style: TextStyle(color: Colors.white54, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SensationChip(
                      emoji: '😊',
                      label: 'Fácil',
                      value: 'facil',
                      selected: sensation == 'facil',
                      onTap: () =>
                          setDialogState(() => sensation = 'facil'),
                    ),
                    _SensationChip(
                      emoji: '💪',
                      label: 'Normal',
                      value: 'normal',
                      selected: sensation == 'normal',
                      onTap: () =>
                          setDialogState(() => sensation = 'normal'),
                    ),
                    _SensationChip(
                      emoji: '🔥',
                      label: 'Duro',
                      value: 'duro',
                      selected: sensation == 'duro',
                      onTap: () =>
                          setDialogState(() => sensation = 'duro'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.logWorkout(
                  trainingId: training.id,
                  notes: notesCtrl.text.trim(),
                  weight: double.tryParse(weightCtrl.text),
                  reps: int.tryParse(repsCtrl.text),
                  sensation: sensation,
                );
                Navigator.pop(dialogCtx);
                messenger.showSnackBar(
                  const SnackBar(content: Text('¡Entrenamiento registrado!')),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    ).then((_) {
      notesCtrl.dispose();
      weightCtrl.dispose();
      repsCtrl.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Rutina'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Training>>(
        future: _routineFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final trainings = snapshot.data ?? [];

          if (trainings.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.fitness_center,
                      size: 64, color: primary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay rutinas para tu nivel todavía',
                    style: TextStyle(color: Colors.white54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trainings.length,
            itemBuilder: (context, index) {
              final t = trainings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: primary.withOpacity(0.15),
                    child:
                        Icon(Icons.fitness_center, color: primary, size: 22),
                  ),
                  title: Text(
                    t.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${t.level} · ${t.type} · ${t.exercises.length} ejercicios',
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    // Lista de ejercicios
                    ...t.exercises.map((e) => ListTile(
                          dense: true,
                          leading: const Icon(Icons.radio_button_unchecked,
                              color: Colors.white30, size: 18),
                          title: Text(e.name,
                              style: const TextStyle(fontSize: 14)),
                          subtitle: Text(
                            '${e.type} · ${e.duration}s',
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 12),
                          ),
                        )),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openLogDialog(t),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Registrar entrenamiento'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SensationChip extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _SensationChip({
    required this.emoji,
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              selected ? primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? primary : Colors.white24,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? primary : Colors.white38,
                fontSize: 12,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
