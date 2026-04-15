import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/exercise.dart';
import '../../data/models/training.dart';
import '../../data/models/exercise_types.dart';
import '../../data/firebase/training_service.dart';

class CreateTrainingPage extends StatefulWidget {
  @override
  _CreateTrainingPageState createState() => _CreateTrainingPageState();
}

class _CreateTrainingPageState extends State<CreateTrainingPage> {
  final titleController = TextEditingController();
  final levelController = TextEditingController();

  List<Exercise> exercises = [];

  // -------------------------
  // AÑADIR EJERCICIO
  // -------------------------
  void addExercise() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    String? selectedExerciseType;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Añadir ejercicio"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: "Nombre"),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: InputDecoration(labelText: "Descripción"),
                ),
                TextField(
                  controller: durationCtrl,
                  decoration: InputDecoration(labelText: "Duración (segundos)"),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),

                // SELECTOR DE TIPO
                DropdownButtonFormField<String>(
                  initialValue: selectedExerciseType,
                  decoration: InputDecoration(labelText: "Tipo de ejercicio"),
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
                if (nameCtrl.text.isEmpty ||
                    descCtrl.text.isEmpty ||
                    durationCtrl.text.isEmpty ||
                    selectedExerciseType == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Completa todos los campos")),
                  );
                  return;
                }

                setState(() {
                  exercises.add(
                    Exercise(
                      name: nameCtrl.text,
                      description: descCtrl.text,
                      duration: int.parse(durationCtrl.text),
                      type: selectedExerciseType!,
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: Text("Guardar"),
            )
          ],
        );
      },
    );
  }

  // -------------------------
  // GUARDAR ENTRENAMIENTO
  // -------------------------
  void saveTraining() async {
    if (titleController.text.isEmpty ||
        levelController.text.isEmpty ||
        exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    final training = Training(
      id: const Uuid().v4(),
      title: titleController.text,
      level: levelController.text,
      type: "Personalizado", // Puedes cambiarlo si quieres
      exercises: exercises,
    );

    await TrainingService().saveTraining(training);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Entrenamiento guardado")),
    );

    Navigator.pop(context);
  }

  // -------------------------
  // UI PRINCIPAL
  // -------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear entrenamiento")),
      floatingActionButton: FloatingActionButton(
        onPressed: addExercise,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: levelController,
              decoration: InputDecoration(labelText: "Nivel"),
            ),
            SizedBox(height: 20),
            Text("Ejercicios añadidos: ${exercises.length}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveTraining,
              child: Text("Guardar entrenamiento"),
            ),
          ],
        ),
      ),
    );
  }
}

