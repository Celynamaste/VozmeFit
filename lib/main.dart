import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Firebase options
import 'package:vozmefit/data/utils/firebase_options.dart';

// Router y tema
import 'package:vozmefit/app/router.dart';
import 'package:vozmefit/app/theme.dart';

// Providers
import 'package:vozmefit/presentation/providers/auth_provider.dart';

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
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VozmeFit',
        theme: appTheme,
        initialRoute: AppRouter.login,
        routes: AppRouter.routes,
        onUnknownRoute: AppRouter.onUnknownRoute,
      ),
    );
  }
}

