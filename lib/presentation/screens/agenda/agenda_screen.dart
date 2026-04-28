import 'package:flutter/material.dart';
import 'package:vozmefit/data/firebase/training_service.dart';
import 'package:vozmefit/data/models/training.dart';
import 'package:vozmefit/data/services/agenda_service.dart';
import 'package:vozmefit/presentation/screens/workouts/training_detail_page.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final _service = AgendaService();
  final _trainingService = TrainingService();

  int _selectedDay = DateTime.now().weekday;

  static const _dayLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  // ─── DIÁLOGO: añadir sesión de entrenamiento al día ─────────────────────
  void _openAddDialog() async {
    // Cargar entrenamientos disponibles para poder elegir uno
    final trainings = await _trainingService.getTrainings();
    if (!mounted) return;

    final textCtrl = TextEditingController();
    Training? selectedTraining;
    DateTime pickedDate = _dateForWeekday(_selectedDay);

    final messenger = ScaffoldMessenger.of(context);

    await showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialog) => AlertDialog(
          title: const Text('Añadir a la agenda'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vincular a un entrenamiento (opcional)
                DropdownButtonFormField<Training>(
                  decoration: const InputDecoration(
                      labelText: 'Entrenamiento (opcional)'),
                  value: selectedTraining,
                  items: [
                    const DropdownMenuItem(
                        value: null, child: Text('Sin entrenamiento')),
                    ...trainings.map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.title,
                              overflow: TextOverflow.ellipsis),
                        )),
                  ],
                  onChanged: (t) {
                    setDialog(() {
                      selectedTraining = t;
                      if (t != null) textCtrl.text = t.title;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: textCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Nota / descripción'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                      '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}'),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: dialogCtx,
                      initialDate: pickedDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setDialog(() => pickedDate = picked);
                  },
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
                final text = textCtrl.text.trim();
                if (text.isEmpty) {
                  messenger.showSnackBar(
                      const SnackBar(content: Text('Escribe una descripción')));
                  return;
                }
                _service.addItem(
                  text,
                  pickedDate,
                  trainingId: selectedTraining?.id,
                );
                Navigator.pop(dialogCtx);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
    textCtrl.dispose();
  }

  /// Devuelve la próxima fecha que cae en [weekday] (1=lunes…7=domingo)
  DateTime _dateForWeekday(int weekday) {
    final now = DateTime.now();
    final diff = (weekday - now.weekday + 7) % 7;
    return now.add(Duration(days: diff));
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Agenda'), centerTitle: true),

      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // ─── SELECTOR DE DÍA ─────────────────────────────
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (i) {
                final dayNum = i + 1;
                final isSelected = _selectedDay == dayNum;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDay = dayNum),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? primary
                          : Colors.transparent,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: primary.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        _dayLabels[i],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isSelected ? Colors.black : Colors.white54,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const Divider(height: 1),

          // ─── LISTA DE ENTRADAS DEL DÍA ──────────────────
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _service.getItems(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final dayItems = snapshot.data!.where((item) {
                  final date = DateTime.parse(item['date'] as String);
                  return date.weekday == _selectedDay;
                }).toList();

                if (dayItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_available,
                            size: 56,
                            color: primary.withOpacity(0.3)),
                        const SizedBox(height: 12),
                        const Text(
                          'Sin entrenamientos este día.\nPulsa + para añadir.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                  itemCount: dayItems.length,
                  itemBuilder: (context, index) {
                    final item = dayItems[index];
                    final completed = item['completed'] as bool;
                    final hasTraining = item['trainingId'] != null;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: Checkbox(
                          value: completed,
                          onChanged: (v) =>
                              _service.toggleCompleted(item['id'], v!),
                        ),
                        title: Text(
                          item['text'] as String,
                          style: TextStyle(
                            decoration: completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color:
                                completed ? Colors.white38 : Colors.white,
                          ),
                        ),
                        subtitle: hasTraining
                            ? Row(
                                children: [
                                  Icon(Icons.fitness_center,
                                      size: 13, color: primary),
                                  const SizedBox(width: 4),
                                  Text('Entrenamiento vinculado',
                                      style: TextStyle(
                                          color: primary, fontSize: 12)),
                                ],
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasTraining)
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios,
                                    color: primary, size: 16),
                                tooltip: 'Ver entrenamiento',
                                onPressed: () async {
                                  final t = await _trainingService
                                      .getTrainingById(
                                          item['trainingId'] as String);
                                  if (t != null && context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            TrainingDetailPage(training: t),
                                      ),
                                    );
                                  }
                                },
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red, size: 20),
                              onPressed: () =>
                                  _service.deleteItem(item['id']),
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
