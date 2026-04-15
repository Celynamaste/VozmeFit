import 'package:flutter/material.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/agenda/agenda_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/agenda':
        return MaterialPageRoute(builder: (_) => const AgendaScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
