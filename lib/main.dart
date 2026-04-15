import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Firebase options
import 'package:vozmefit/data/utils/firebase_options.dart';

// Providers
import 'package:vozmefit/presentation/providers/auth_provider.dart';

// Screens
import 'package:vozmefit/presentation/screens/login/login_screen.dart';
import 'package:vozmefit/presentation/screens/home/home_screen.dart';
import 'package:vozmefit/presentation/screens/agenda/agenda_screen.dart';

// Theme
import 'package:vozmefit/app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VozmeFit',

        // Aquí aplicamos tu tema oscuro + turquesa pastel
        theme: appTheme,

        initialRoute: '/login',

        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/agenda': (context) => const AgendaScreen(),
        },
      ),
    );
  }
}
