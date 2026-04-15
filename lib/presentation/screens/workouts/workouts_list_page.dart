import 'package:flutter/material.dart';
import '../../../data/firebase/training_service.dart';
import '../../../data/models/training.dart';

class WorkoutsListPage extends StatefulWidget {
  @override
  _WorkoutsListPageState createState() => _WorkoutsListPageState();
}

class _WorkoutsListPageState extends State<WorkoutsListPage> {
  final TrainingService _trainingService = TrainingService();
  late Future<List<Training>> _trainingsFuture;

  @override
  void initState() {
    super.initState();
    _trainingsFuture = _trainingService.getTrainings();
  }

  void refreshList() {
    setState(() {
      _trainingsFuture = _trainingService.getTrainings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis entrenamientos"),
      ),
      body: FutureBuilder<List<Training>>(
        future: _trainingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No tienes entrenamientos aún",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final trainings = snapshot.data!;

          return ListView.builder(
            itemCount: trainings.length,
            itemBuilder: (context, index) {
              final training = trainings[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(training.title),
                  subtitle: Text(
                    "${training.level} • ${training.exercises.length} ejercicios",
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _trainingService.deleteTraining(training.id);
                      refreshList();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrainingDetailPage(training: training),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TrainingDetailPage extends StatelessWidget {
  final Training training;

  const TrainingDetailPage({required this.training});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(training.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nivel: ${training.level}", style: TextStyle(fontSize: 18)),
            Text("Tipo: ${training.type}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Ejercicios:", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
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
