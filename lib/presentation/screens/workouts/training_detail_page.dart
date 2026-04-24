import 'package:flutter/material.dart';
import '../../../data/models/training.dart';
import '../../../data/services/workout_log_service.dart';

class TrainingDetailPage extends StatelessWidget {
  final Training training;

  const TrainingDetailPage({super.key, required this.training});

  void _openLogDialog(BuildContext context) {
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
                        selected: sensation == 'facil',
                        onTap: () =>
                            setDialogState(() => sensation = 'facil')),
                    _SensationChip(
                        emoji: '💪',
                        label: 'Normal',
                        selected: sensation == 'normal',
                        onTap: () =>
                            setDialogState(() => sensation = 'normal')),
                    _SensationChip(
                        emoji: '🔥',
                        label: 'Duro',
                        selected: sensation == 'duro',
                        onTap: () =>
                            setDialogState(() => sensation = 'duro')),
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
                  const SnackBar(
                      content: Text('¡Entrenamiento registrado!')),
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
        title: Text(training.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openLogDialog(context),
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Registrar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ─── INFO GENERAL ──────────────────────────────────
          Row(
            children: [
              _InfoChip(label: training.level, icon: Icons.bar_chart),
              const SizedBox(width: 10),
              _InfoChip(label: training.type, icon: Icons.category_outlined),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            'Ejercicios (${training.exercises.length})',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 12),

          // ─── LISTA DE EJERCICIOS ───────────────────────────
          ...training.exercises.asMap().entries.map((entry) {
            final i = entry.key;
            final e = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: primary.withOpacity(0.15),
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                        color: primary, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(e.name,
                    style:
                        const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  e.description.isNotEmpty
                      ? e.description
                      : '${e.type} · ${e.duration}s',
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 13),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: primary.withOpacity(0.3)),
                  ),
                  child: Text(
                    '${e.duration}s',
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 80), // espacio para el FAB
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primary, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SensationChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SensationChip({
    required this.emoji,
    required this.label,
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
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            Text(label,
                style: TextStyle(
                  color: selected ? primary : Colors.white38,
                  fontSize: 12,
                  fontWeight: selected
                      ? FontWeight.bold
                      : FontWeight.normal,
                )),
          ],
        ),
      ),
    );
  }
}
