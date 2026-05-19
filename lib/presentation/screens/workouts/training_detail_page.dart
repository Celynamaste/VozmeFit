import 'package:flutter/material.dart';
import '../../../data/models/training.dart';
import '../../../data/services/workout_log_service.dart';

const _exerciseColors = {
  'Fuerza':       [Color(0xFF1565C0), Color(0xFF42A5F5)],
  'Cardio':       [Color(0xFFB71C1C), Color(0xFFEF9A9A)],
  'Core':         [Color(0xFF4A148C), Color(0xFFCE93D8)],
  'Movilidad':    [Color(0xFF1B5E20), Color(0xFF81C784)],
  'Flexibilidad': [Color(0xFF006064), Color(0xFF80DEEA)],
  'Equilibrio':   [Color(0xFFE65100), Color(0xFFFFCC80)],
  'Descanso':     [Color(0xFF37474F), Color(0xFF90A4AE)],
};

const _exerciseIcons = {
  'Fuerza':       Icons.fitness_center,
  'Cardio':       Icons.directions_run,
  'Core':         Icons.sports_gymnastics,
  'Movilidad':    Icons.self_improvement,
  'Flexibilidad': Icons.accessibility_new,
  'Equilibrio':   Icons.balance,
  'Descanso':     Icons.hotel,
};

// Imágenes por nombre de ejercicio (Unsplash, sin CORS)
const _exerciseImagesByName = {
  // Fullbody principiante
  'Sentadillas':             'https://images.unsplash.com/photo-1567598508481-65985588e295?w=600&q=80',
  'Flexiones de rodillas':   'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=600&q=80',
  'Plancha':                 'https://images.unsplash.com/photo-1566241142559-40e1dab266c6?w=600&q=80',
  'Puente de glúteos':       'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600&q=80',
  'Marcha en el sitio':      'https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=600&q=80',
  // HIIT
  'Burpees':                 'https://images.unsplash.com/photo-1739283180407-21e27d5c0735?w=600&q=80',
  'Mountain Climbers':       'https://images.unsplash.com/photo-1598136490941-30d885318abd?w=600&q=80',
  'Saltos de tijera':        'https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=600&q=80',
  'Sprint estático':         'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=600&q=80',
  'Descanso activo':         'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600&q=80',
  // Fuerza
  'Flexiones estándar':      'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=600&q=80',
  'Remo con mancuerna':      'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=600&q=80',
  'Press de hombros':        'https://images.unsplash.com/photo-1532029837206-abbe2b7620e3?w=600&q=80',
  'Curl de bíceps':          'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=600&q=80',
  'Tríceps en banco':        'https://images.unsplash.com/photo-1597452485669-2c7bb5fef90d?w=600&q=80',
  // Yoga / movilidad
  'Postura del gato-vaca':   'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=600&q=80',
  'Perro boca abajo':        'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600&q=80',
  'Guerrero I':              'https://images.unsplash.com/photo-1552196563-55cd4e45efb3?w=600&q=80',
  'Torsión sentado':         'https://images.unsplash.com/photo-1575052814086-f385e2e2ad1b?w=600&q=80',
  'Postura del niño':        'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=600&q=80',
  // Avanzado
  'Sentadilla con salto':    'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?w=600&q=80',
  'Flexiones con palmada':   'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=600&q=80',
  'Pistol squat asistida':   'https://images.unsplash.com/photo-1567598508481-65985588e295?w=600&q=80',
  'Dominadas excéntricas':   'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?w=600&q=80',
  'L-sit en sillas':         'https://images.unsplash.com/photo-1531326044450-7448d47f0b2c?w=600&q=80',
};

String? _imageForExerciseName(String name) => _exerciseImagesByName[name];

class TrainingDetailPage extends StatefulWidget {
  final Training training;

  const TrainingDetailPage({super.key, required this.training});

  @override
  State<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends State<TrainingDetailPage> {
  Training get training => widget.training;

  Widget _gradientBannerSmall(String type) {
    final colors = _exerciseColors[type] ??
        [const Color(0xFF263238), const Color(0xFF546E7A)];
    final icon = _exerciseIcons[type] ?? Icons.fitness_center;
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(icon, color: Colors.white30, size: 32),
    );
  }

  List<Widget> _buildExerciseCards(Color primary) {
    return training.exercises.asMap().entries.map((entry) {
      final i = entry.key;
      final e = entry.value;
      final imageUrl = e.imageUrl.isNotEmpty
          ? e.imageUrl
          : _imageForExerciseName(e.name);
      return Card(
        margin: const EdgeInsets.only(bottom: 10),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _gradientBannerSmall(e.type),
                    )
                  : _gradientBannerSmall(e.type),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: primary.withOpacity(0.15),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          if (e.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                e.description,
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            '${e.type} · ${e.duration}s',
                            style: TextStyle(
                                color: primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _openLogDialog() {
    final notesCtrl = TextEditingController();
    final weightCtrl = TextEditingController();
    final repsCtrl = TextEditingController();
    String sensation = 'normal';
    final service = WorkoutLogService();

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
                try {
                  await service.logWorkout(
                    trainingId: training.id,
                    notes: notesCtrl.text.trim(),
                    weight: double.tryParse(weightCtrl.text),
                    reps: int.tryParse(repsCtrl.text),
                    sensation: sensation,
                  );
                  if (dialogCtx.mounted) Navigator.pop(dialogCtx);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('¡Entrenamiento registrado!')),
                    );
                  }
                } catch (e, st) {
                  debugPrint('logWorkout error: $e\n$st');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al guardar. Comprueba tu conexión.')),
                    );
                  }
                }
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
        onPressed: _openLogDialog,
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
              if (training.duration > 0) ...[
                const SizedBox(width: 10),
                _InfoChip(label: '${training.duration} min', icon: Icons.timer_outlined),
              ],
            ],
          ),
          if (training.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              training.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ),
          ],
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
          ..._buildExerciseCards(primary),

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
