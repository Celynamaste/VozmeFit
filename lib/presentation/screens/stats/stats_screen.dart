import 'package:flutter/material.dart';
import 'package:vozmefit/data/services/workout_log_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late final Stream<List<Map<String, dynamic>>> _logsStream;

  // Convierte 'facil' / 'normal' / 'duro' a emoji + color
  static (String, Color) _sensationDisplay(String sensation) {
    switch (sensation) {
      case 'facil':
        return (' Fácil', const Color(0xFF4CAF50));
      case 'duro':
        return (' Duro', const Color(0xFFFF5722));
      default:
        return ('Normal', const Color(0xFF00B4D8));
    }
  }

  @override
  void initState() {
    super.initState();
    _logsStream = WorkoutLogService().getLogs();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Estadísticas'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _logsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final logs = snapshot.data ?? [];

          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bar_chart,
                      size: 72, color: primary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text(
                    'Aún no tienes registros.\nCompleta tu primer entrenamiento.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            );
          }

          // ─── MÉTRICAS RESUMEN ──────────────────────────────
          final totalSessions = logs.length;
          final weights = logs
              .where((l) => l['weight'] != null)
              .map((l) => (l['weight'] as num).toDouble())
              .toList();
          final maxWeight =
              weights.isNotEmpty ? weights.reduce((a, b) => a > b ? a : b) : 0.0;
          final sensationCounts = <String, int>{
            'facil': 0,
            'normal': 0,
            'duro': 0
          };
          for (final l in logs) {
            final s = l['sensation'] as String? ?? 'normal';
            sensationCounts[s] = (sensationCounts[s] ?? 0) + 1;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── TARJETAS RESUMEN ────────────────────────
              Row(
                children: [
                  _StatCard(
                    label: 'Sesiones',
                    value: '$totalSessions',
                    icon: Icons.fitness_center,
                    color: primary,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'Peso máx.',
                    value: maxWeight > 0 ? '${maxWeight.toStringAsFixed(1)} kg' : '—',
                    icon: Icons.monitor_weight_outlined,
                    color: primary,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ─── SENSACIONES ─────────────────────────────
              Row(
                children: [
                  _StatCard(
                    label: 'Fáciles',
                    value: '${sensationCounts['facil']}',
                    icon: Icons.sentiment_satisfied_alt,
                    color: const Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 8),
                  _StatCard(
                    label: 'Normales',
                    value: '${sensationCounts['normal']}',
                    icon: Icons.sentiment_neutral,
                    color: primary,
                  ),
                  const SizedBox(width: 8),
                  _StatCard(
                    label: 'Duras',
                    value: '${sensationCounts['duro']}',
                    icon: Icons.local_fire_department,
                    color: const Color(0xFFFF5722),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ─── BARRA VISUAL SENSACIONES ─────────────────
              if (totalSessions > 0) ...[
                const Text(
                  'Distribución de esfuerzo',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                _SensationBar(counts: sensationCounts, total: totalSessions),
                const SizedBox(height: 24),
              ],

              // ─── HISTORIAL ────────────────────────────────
              const Text(
                'Historial',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              ...logs.map((log) {
                final date = DateTime.parse(log['date'] as String);
                final (sensLabel, sensColor) =
                    _sensationDisplay(log['sensation'] as String? ?? 'normal');
                final weight = log['weight'] != null
                    ? '${(log['weight'] as num).toStringAsFixed(1)} kg'
                    : null;
                final reps = log['reps'] != null
                    ? '${log['reps']} reps'
                    : null;
                final notes = log['notes'] as String? ?? '';

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${date.day}/${date.month}/${date.year}',
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: sensColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: sensColor.withOpacity(0.4)),
                              ),
                              child: Text(sensLabel,
                                  style: TextStyle(
                                      color: sensColor, fontSize: 12)),
                            ),
                          ],
                        ),
                        if (weight != null || reps != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (weight != null) ...[
                                Icon(Icons.monitor_weight_outlined,
                                    size: 14, color: Colors.white54),
                                const SizedBox(width: 4),
                                Text(weight,
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13)),
                                const SizedBox(width: 16),
                              ],
                              if (reps != null) ...[
                                Icon(Icons.repeat,
                                    size: 14, color: Colors.white54),
                                const SizedBox(width: 4),
                                Text(reps,
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13)),
                              ],
                            ],
                          ),
                        ],
                        if (notes.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            notes,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 13),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

// ─── WIDGETS AUXILIARES ────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _SensationBar extends StatelessWidget {
  final Map<String, int> counts;
  final int total;

  const _SensationBar({required this.counts, required this.total});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          _segment(counts['facil']! / total, const Color(0xFF4CAF50)),
          _segment(counts['normal']! / total, const Color(0xFF00B4D8)),
          _segment(counts['duro']! / total, const Color(0xFFFF5722)),
        ],
      ),
    );
  }

  Widget _segment(double ratio, Color color) {
    if (ratio == 0) return const SizedBox.shrink();
    return Expanded(
      flex: (ratio * 100).round(),
      child: Container(height: 16, color: color),
    );
  }
}
