import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const MesNotesApp());
}

class MesNotesApp extends StatelessWidget {
  const MesNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2585E8),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
