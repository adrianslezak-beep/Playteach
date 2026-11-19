import 'package:flutter/material.dart';

import 'screens/profiles_screen.dart';
import 'state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  runApp(PlayteachApp(state: state));
}

class PlayteachApp extends StatelessWidget {
  final AppState state;
  const PlayteachApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playteach',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6C5CE7),
      ),
      home: ProfilesScreen(state: state),
    );
  }
}
