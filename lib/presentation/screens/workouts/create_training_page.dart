import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/exercise.dart';
import '../../../data/models/training.dart';
import '../../../data/models/exercise_types.dart';
import '../../../data/firebase/training_service.dart';

class CreateTrainingPage extends StatefulWidget {
  const CreateTrainingPage({super.key});

  @override
  State<CreateTrainingPage> createState() => _CreateTrainingPageState();
}

class _CreateTrainingPageState extends State<CreateTrainingPage> {
  final titleController = TextEditingController();
  final levelController = TextEditingController();

  List<Exercise> exercises = [];

  @override
  void dispose() {
    titleController.dispose();
    levelController.dispose();
    super.dispose();
  }

  // -------------------------
  // AÑADIR EJERCICIO
  // -------------------------
  void addExercise() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    String? selectedExerciseType;

    // Capturamos el ScaffoldMessenger antes de abrir el diálogo
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Añadir ejercicio"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Nombre"),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: "Descripción"),
                ),
                TextField(
                  controller: durationCtrl,
                  decoration: const InputDecoration(labelText: "Duración (segundos)"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),

                // SELECTOR DE TIPO
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Tipo de ejercicio"),
                  items: ExerciseTypes.types.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedExerciseType = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final duration = int.tryParse(durationCtrl.text);
                if (nameCtrl.text.isEmpty ||
                    descCtrl.text.isEmpty ||
                    durationCtrl.text.isEmpty ||
                    duration == null ||
                    selectedExerciseType == null) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text("Completa todos los campos")),
                  );
                  return;
                }

                setState(() {
                  exercises.add(
                    Exercise(
                      name: nameCtrl.text,
                      description: descCtrl.text,
                      duration: duration,
                      type: selectedExerciseType!,
                    ),
                  );
                });

                Navigator.pop(dialogContext);
              },
              child: const Text("Guardar"),
            )
          ],
        );
      },
    ).then((_) {
      nameCtrl.dispose();
      descCtrl.dispose();
      durationCtrl.dispose();
    });
  }

  // -------------------------
  // GUARDAR ENTRENAMIENTO
  // -------------------------
  void saveTraining() async {
    if (titleController.text.isEmpty ||
        levelController.text.isEmpty ||
        exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    final training = Training(
      id: const Uuid().v4(),
      title: titleController.text,
      level: levelController.text,
      type: "Personalizado",
      exercises: exercises,
    );

    await TrainingService().saveTraining(training);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Entrenamiento guardado")),
      );
      Navigator.pop(context);
    }
  }

  // -------------------------
  // UI PRINCIPAL
  // -------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear entrenamiento")),
      floatingActionButton: FloatingActionButton(
        onPressed: addExercise,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: levelController,
              decoration: const InputDecoration(labelText: "Nivel"),
            ),
            const SizedBox(height: 20),
            Text("Ejercicios añadidos: ${exercises.length}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveTraining,
              child: const Text("Guardar entrenamiento"),
            ),
          ],
        ),
      ),
    );
  }
}

