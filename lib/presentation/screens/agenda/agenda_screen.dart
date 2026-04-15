import 'package:flutter/material.dart';
import 'package:vozmefit/data/services/agenda_service.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final _service = AgendaService();

  int selectedDay = DateTime.now().weekday; // Día seleccionado (1-7)

  void _openAddDialog() {
    final textController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nueva tarea"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );

                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
                child: const Text("Seleccionar fecha"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final text = textController.text.trim();
                if (text.isNotEmpty) {
                  _service.addItem(text, selectedDate);
                }
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> days = ["L", "M", "X", "J", "V", "S", "D"];

    return Scaffold(
      appBar: AppBar(title: const Text("Mi Agenda"), centerTitle: true),

      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // ---------------------------------------------------
          // CALENDARIO SEMANAL REDONDO Y AZUL CORPORATIVO
          // ---------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final dayNumber = index + 1;
                final isSelected = selectedDay == dayNumber;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = dayNumber;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? const Color(0xFF4DA3FF) // Azul claro corporativo
                          : Colors.transparent,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF4DA3FF).withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      days[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const Divider(),

          // ---------------------------------------------------
          // LISTA DE TAREAS AGRUPADAS POR DÍA
          // ---------------------------------------------------
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _service.getItems(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = snapshot.data!;

                if (items.isEmpty) {
                  return const Center(child: Text("No tienes tareas todavía"));
                }

                // Filtrar tareas del día seleccionado
                final dayTasks = items.where((item) {
                  final date = DateTime.parse(item['date']);
                  return date.weekday == selectedDay;
                }).toList();

                if (dayTasks.isEmpty) {
                  return const Center(
                    child: Text("No hay tareas para este día"),
                  );
                }

                return ListView.builder(
                  itemCount: dayTasks.length,
                  itemBuilder: (context, index) {
                    final item = dayTasks[index];
                    final date = DateTime.parse(item['date']);

                    return Card(
                      color: Colors.white10,
                      child: ListTile(
                        leading: Checkbox(
                          value: item['completed'],
                          onChanged: (value) {
                            _service.toggleCompleted(item['id'], value!);
                          },
                        ),
                        title: Text(
                          item['text'],
                          style: TextStyle(
                            decoration: item['completed']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          "${date.day}/${date.month}/${date.year}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _service.deleteItem(item['id']),
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
