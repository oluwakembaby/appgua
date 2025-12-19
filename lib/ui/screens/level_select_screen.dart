import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/game_progress_provider.dart';
import '../../game/audio_manager.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  @override
  void initState() {
    super.initState();
    // BGM is now started in MenuScreen, but ensuring it plays here is safe if coming back.
    // Actually, MenuScreen -> Play -> LevelSelect.
    // AudioManager handles state, calling play again is fine (idempotent usually or restarts).
    // Let's leave it or remove it if it restarts track annoying.
    // AudioManager checks `_bgmPlayer.state`? No, my implementation just calls play.
    // `audioplayers` usually restarts if you call play. 
    // Let's remove it here to avoid restarting the loop when navigating from Menu.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepBlue,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   // Add Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    'Select Level',
                    style: AppTheme.titleStyle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.music_note, color: AppTheme.teal),
                    onPressed: () {
                      AudioManager().toggleMute();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<GameProgressProvider>(
                builder: (context, progress, child) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 12, // 12 levels total
                    itemBuilder: (context, index) {
                      final level = index + 1;
                      final isUnlocked = level <= progress.highestLevelUnlocked;

                      return _LevelButton(
                        level: level,
                        isUnlocked: isUnlocked,
                        onTap: isUnlocked
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameScreen(levelId: level),
                                  ),
                                );
                              }
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  final int level;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const _LevelButton({
    required this.level,
    required this.isUnlocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? AppTheme.teal : Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: isUnlocked
              ? Text(
                  '$level',
                  style: AppTheme.buttonStyle,
                )
              : Icon(
                  Icons.lock,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
        ),
      ),
    );
  }
}

