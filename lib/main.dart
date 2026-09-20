import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/notes_screen.dart';
import 'services/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isRemembered = await SessionService.isRemembered();

  runApp(
    MesNotesApp(
      isRemembered: isRemembered,
    ),
  );
}

class MesNotesApp extends StatelessWidget {
  final bool isRemembered;

  const MesNotesApp({
    super.key,
    required this.isRemembered,
  });

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
      home: isRemembered
          ? const NotesScreen()
          : const LoginScreen(),
    );
  }
}
