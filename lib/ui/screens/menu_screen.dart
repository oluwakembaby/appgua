import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../game/audio_manager.dart';
import '../theme/app_theme.dart';
import 'level_select_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    AudioManager().playBgm();
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.deepBlue.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.teal, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTheme.titleStyle.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                child: Text(
                  content,
                  style: AppTheme.bodyStyle.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.teal,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Close', style: AppTheme.buttonStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / Title
              Column(
                children: [
                  Image.asset(
                    'assets/images/app_icon_512.png',
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.water, size: 80, color: AppTheme.teal),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aqua Harmony',
                    style: AppTheme.titleStyle.copyWith(fontSize: 42),
                  ),
                  Text(
                    'Zen Puzzle',
                    style: AppTheme.bodyStyle.copyWith(fontSize: 20, color: AppTheme.aqua),
                  ),
                ],
              ).animate().fadeIn(duration: 800.ms).moveY(begin: 20, end: 0),
              
              const SizedBox(height: 64),

              // Menu Buttons
              _MenuButton(
                label: 'Play Game',
                isPrimary: true,
                onTap: () {
                  AudioManager().playBgm(); // Ensure music plays on interaction
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LevelSelectScreen()),
                  );
                },
              ).animate(delay: 200.ms).fadeIn().moveX(begin: -20, end: 0),
              
              const SizedBox(height: 16),
              
              _MenuButton(
                label: 'How to Play',
                onTap: () {
                  AudioManager().playBgm(); // Ensure music plays on interaction
                  _showDialog(
                    'How to Play',
                    '1. Select a level to start.\n'
                    '2. Drag fish and decorations from the inventory into the tank.\n'
                    '3. Pay attention to the "Social Rules" of each fish.\n'
                    '   • Some fish like company (Green Heart).\n'
                    '   • Some fish want space (Red Cloud).\n'
                    '4. Place ALL items correctly to restore harmony and win!',
                  );
                },
              ).animate(delay: 300.ms).fadeIn().moveX(begin: -20, end: 0),

              const SizedBox(height: 16),

              _MenuButton(
                label: 'Instructions',
                onTap: () {
                  AudioManager().playBgm();
                  _showDialog(
                    'Instructions',
                    '• Drag & Drop: Touch and hold an item to move it.\n'
                    '• Placement: Items must be placed within the tank boundaries.\n'
                    '• Hints: If a fish is unhappy, try moving it closer to its friends or further from its enemies.\n'
                    '• Mute: You can toggle sound in the Level Select screen.',
                  );
                },
              ).animate(delay: 400.ms).fadeIn().moveX(begin: -20, end: 0),

              const SizedBox(height: 16),

              _MenuButton(
                label: 'Privacy Policy',
                onTap: () {
                  AudioManager().playBgm();
                  _showDialog(
                    'Privacy Policy',
                    'Aqua Harmony respects your privacy.\n\n'
                    '• We do not collect any personal data.\n'
                    '• Game progress is stored locally on your device.\n'
                    '• No internet connection is required to play.',
                  );
                },
              ).animate(delay: 500.ms).fadeIn().moveX(begin: -20, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _MenuButton({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppTheme.teal : Colors.white.withValues(alpha: 0.1),
          foregroundColor: isPrimary ? Colors.white : AppTheme.aqua,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: isPrimary ? BorderSide.none : const BorderSide(color: AppTheme.teal, width: 2),
          ),
          elevation: isPrimary ? 4 : 0,
        ),
        child: Text(
          label,
          style: AppTheme.buttonStyle.copyWith(
            color: isPrimary ? Colors.white : AppTheme.aqua,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

