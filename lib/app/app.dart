import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';

class VozmeFitApp extends StatelessWidget {
  const VozmeFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VozmeFit',
      debugShowCheckedModeBanner: false,

      // Aquí usamos tu tema real
      theme: appTheme,

      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
