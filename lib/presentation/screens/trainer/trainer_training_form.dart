import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vozmefit/data/firebase/training_service.dart';
import 'package:vozmefit/data/models/exercise.dart';
import 'package:vozmefit/data/models/exercise_types.dart';
import 'package:vozmefit/data/models/training.dart';

class TrainerTrainingForm extends StatefulWidget {
  /// Si se pasa un [training] existente, el formulario funciona en modo edición.
  final Training? training;

  const TrainerTrainingForm({super.key, this.training});

  @override
  State<TrainerTrainingForm> createState() => _TrainerTrainingFormState();
}

class _TrainerTrainingFormState extends State<TrainerTrainingForm> {
  final _service = TrainingService();
  final _titleCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();

  String _selectedLevel = 'Principiante';
  List<Exercise> _exercises = [];
  bool _saving = false;

  static const _levels = ['Principiante', 'Intermedio', 'Avanzado'];

  bool get _isEditing => widget.training != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final t = widget.training!;
      _titleCtrl.text = t.title;
      _typeCtrl.text = t.type;
      _selectedLevel = t.level;
      _exercises = List.from(t.exercises);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _typeCtrl.dispose();
    super.dispose();
  }

  // ─── AÑADIR / EDITAR EJERCICIO ────────────────────────────────────────────
  void _openExerciseDialog({Exercise? existing, int? index}) {
    final nameCtrl =
        TextEditingController(text: existing?.name ?? '');
    final descCtrl =
        TextEditingController(text: existing?.description ?? '');
    final durationCtrl = TextEditingController(
        text: existing != null ? existing.duration.toString() : '');
    String? selectedType = existing?.type;
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(existing == null ? 'Añadir ejercicio' : 'Editar ejercicio'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationCtrl,
                decoration:
                    const InputDecoration(labelText: 'Duración (segundos)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration:
                    const InputDecoration(labelText: 'Tipo de ejercicio'),
                items: ExerciseTypes.types
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => selectedType = v,
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
            onPressed: () {
              final duration = int.tryParse(durationCtrl.text);
              if (nameCtrl.text.isEmpty ||
                  descCtrl.text.isEmpty ||
                  duration == null ||
                  selectedType == null) {
                messenger.showSnackBar(const SnackBar(
                    content: Text('Completa todos los campos')));
                return;
              }
              final exercise = Exercise(
                name: nameCtrl.text.trim(),
                description: descCtrl.text.trim(),
                duration: duration,
                type: selectedType!,
              );
              setState(() {
                if (index != null) {
                  _exercises[index] = exercise;
                } else {
                  _exercises.add(exercise);
                }
              });
              Navigator.pop(dialogCtx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    ).then((_) {
      nameCtrl.dispose();
      descCtrl.dispose();
      durationCtrl.dispose();
    });
  }

  // ─── GUARDAR RUTINA ────────────────────────────────────────────────────────
  Future<void> _save() async {
    if (_titleCtrl.text.isEmpty || _typeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Completa título y tipo')));
      return;
    }
    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Añade al menos un ejercicio')));
      return;
    }

    setState(() => _saving = true);

    final training = Training(
      id: _isEditing ? widget.training!.id : const Uuid().v4(),
      title: _titleCtrl.text.trim(),
      level: _selectedLevel,
      type: _typeCtrl.text.trim(),
      exercises: _exercises,
    );

    if (_isEditing) {
      await _service.updateTraining(training);
    } else {
      await _service.saveTraining(training);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(_isEditing ? 'Rutina actualizada' : 'Rutina creada')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar rutina' : 'Nueva rutina'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ─── DATOS GENERALES ───────────────────────────────
          TextField(
            controller: _titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Título de la rutina',
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _typeCtrl,
            decoration: const InputDecoration(
              labelText: 'Tipo (ej: Fuerza, Cardio…)',
              prefixIcon: Icon(Icons.category_outlined),
            ),
          ),
          const SizedBox(height: 20),

          // ─── SELECTOR NIVEL ────────────────────────────────
          const Text('Nivel físico',
              style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 10),
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: sel
                            ? primary.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: sel ? primary : Colors.white24,
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        lvl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: sel ? primary : Colors.white38,
                          fontWeight: sel
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // ─── LISTA DE EJERCICIOS ───────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ejercicios (${_exercises.length})',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () => _openExerciseDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Añadir'),
              ),
            ],
          ),

          if (_exercises.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Sin ejercicios todavía',
                  style:
                      TextStyle(color: primary.withOpacity(0.5)),
                ),
              ),
            ),

          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _exercises.length,
            onReorder: (oldIdx, newIdx) {
              setState(() {
                if (newIdx > oldIdx) newIdx--;
                final item = _exercises.removeAt(oldIdx);
                _exercises.insert(newIdx, item);
              });
            },
            itemBuilder: (context, i) {
              final e = _exercises[i];
              return Card(
                key: ValueKey(i),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primary.withOpacity(0.1),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(color: primary, fontSize: 13),
                    ),
                  ),
                  title: Text(e.name),
                  subtitle: Text(
                      '${e.type} · ${e.duration}s',
                      style:
                          const TextStyle(color: Colors.white54)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_outlined,
                            color: primary, size: 20),
                        onPressed: () =>
                            _openExerciseDialog(existing: e, index: i),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red, size: 20),
                        onPressed: () =>
                            setState(() => _exercises.removeAt(i)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const CircularProgressIndicator(color: Colors.black)
                  : Text(_isEditing
                      ? 'Guardar cambios'
                      : 'Crear rutina'),
            ),
          ),
        ],
      ),
    );
  }
}
