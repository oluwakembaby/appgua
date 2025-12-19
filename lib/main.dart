import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/game_progress_provider.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/menu_screen.dart';
import 'game/audio_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Don't await audio init to prevent app hang on startup
  AudioManager().init(); 
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProgressProvider()),
      ],
      child: const AquaHarmonyApp(),
    ),
  );
}

class AquaHarmonyApp extends StatelessWidget {
  const AquaHarmonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aqua Harmony',
      theme: AppTheme.themeData,
      home: const MenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
