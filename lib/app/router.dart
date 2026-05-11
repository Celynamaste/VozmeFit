import 'package:flutter/material.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/agenda/agenda_screen.dart';
import '../presentation/screens/workouts/workouts_list_page.dart';
import '../presentation/screens/trainer/trainer_home_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/stats/stats_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String home = '/home';
  static const String trainerHome = '/trainer-home';
  static const String agenda = '/agenda';
  static const String workouts = '/workouts';
  static const String profile = '/profile';
  static const String stats = '/stats';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginScreen(),
        home: (_) => const HomeScreen(),
        trainerHome: (_) => const TrainerHomeScreen(),
        agenda: (_) => const AgendaScreen(),
        workouts: (_) => const WorkoutsListPage(),
        profile: (_) => const ProfileScreen(),
        stats: (_) => const StatsScreen(),
      };

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Página no encontrada')),
      ),
    );
  }
}

