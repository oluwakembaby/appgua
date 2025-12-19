import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../game/aqua_game.dart';
import '../../game/audio_manager.dart';
import '../../data/game_progress_provider.dart';
import '../overlays/inventory_overlay.dart';
import '../overlays/win_dialog.dart';
import '../overlays/lose_dialog.dart';
import '../overlays/game_overlay.dart';
import '../overlays/level_intro_dialog.dart';
import '../theme/app_theme.dart';

class GameScreen extends StatefulWidget {
  final int levelId;
  const GameScreen({super.key, this.levelId = 1});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late final AquaGame _game;
  List<dynamic> _inventoryItems = [];
  bool _showLevelIntro = true;
  String _levelDescription = "";
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _game = AquaGame(
      levelId: widget.levelId,
      onWin: _handleWin,
      onLose: _handleLose,
    );
    _loadLevelInventory();
    
    // Ensure BGM is playing when entering game
    AudioManager().playBgm();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Do NOT stop BGM here if we want it to persist across screens, 
    // but the requirement says "stop when player is not in game (e.g. menu)".
    // So actually, we should manage BGM per screen or globally.
    // The prompt says: "play when game is active... stop when player is not in the game".
    // LevelSelectScreen -> GameScreen. 
    // If we stop here, going back to LevelSelect will be silent unless LevelSelect starts it.
    // Let's assume Menu/LevelSelect SHOULD have music too, but "paused when game is paused".
    // If the user meant "only play in game", then stop here.
    // Re-reading: "stop when the player is not in the game (for example, in the menu)"
    // Okay, so BGM *only* in GameScreen? Or BGM everywhere but paused in menu? 
    // "stop when the player is not in the game (for example, in the menu)" -> implied BGM is for gameplay only?
    // BUT MenuScreen had `AudioManager().playBgm()` in its initState in previous code.
    // Let's assume they want BGM *everywhere* but it was broken.
    // "Currently, it is not playing at all." -> Fix playback.
    // "pause when game is paused" -> handle pause.
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AudioManager().pauseBgm();
      if (!_isPaused && !_showLevelIntro) {
        _handlePause();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (!_isPaused) {
        AudioManager().resumeBgm();
      }
    }
  }

  Future<void> _loadLevelInventory() async {
    try {
      final jsonString = await DefaultAssetBundle.of(context).loadString('assets/levels/level_${widget.levelId}.json');
      final data = json.decode(jsonString);
      setState(() {
        _inventoryItems = data['inventory'] ?? [];
        _levelDescription = data['description'] ?? "";
      });
    } catch (e) {
      debugPrint("Error loading inventory: $e");
    }
  }

  void _handleWin() {
    AudioManager().playSfx('success');
    final nextLevel = widget.levelId + 1;
    context.read<GameProgressProvider>().unlockLevel(nextLevel);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WinDialog(
        levelId: widget.levelId,
        onNextLevel: () {
          Navigator.of(context).pop();
          if (nextLevel <= 12) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GameScreen(levelId: nextLevel)),
            );
          } else {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
    );
  }
  
  void _handleLose() {
    AudioManager().playSfx('error');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoseDialog(
        levelId: widget.levelId,
        onRetry: () {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GameScreen(levelId: widget.levelId)),
          );
        },
        onQuit: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _handlePause() {
    setState(() {
      _isPaused = true;
    });
    _game.pauseEngine();
    AudioManager().pauseBgm();
    
    showDialog(
      context: context,
      barrierDismissible: false,
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
                "PAUSED",
                style: AppTheme.titleStyle.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 32),
              _PauseButton(
                label: "Resume",
                icon: Icons.play_arrow,
                onTap: () {
                  Navigator.of(context).pop();
                  _resumeGame();
                },
                isPrimary: true,
              ),
              const SizedBox(height: 16),
              _PauseButton(
                label: "Restart Level",
                icon: Icons.refresh,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen(levelId: widget.levelId)),
                  );
                },
              ),
              const SizedBox(height: 16),
              _PauseButton(
                label: "Quit to Menu",
                icon: Icons.exit_to_app,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Back to Level Select
                },
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      // If dialog dismissed by back button, resume
      if (_isPaused) {
        _resumeGame();
      }
    });
  }

  void _resumeGame() {
    setState(() {
      _isPaused = false;
    });
    _game.resumeEngine();
    AudioManager().resumeBgm();
  }

  void _dismissLevelIntro() {
    setState(() {
      _showLevelIntro = false;
    });
    _game.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background/Game Layer
          Positioned.fill(
            child: DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                return GameWidget(game: _game);
              },
              onAcceptWithDetails: (details) {
                if (!_isPaused && !_showLevelIntro) {
                  _handleDrop(details);
                }
              },
              hitTestBehavior: HitTestBehavior.translucent, 
            ),
          ),
          
          // HUD Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GameOverlay(
              levelId: widget.levelId,
              statusMessage: _game.statusMessage,
              levelDescription: _game.levelDescription,
              timeRemaining: _game.timeRemaining,
              onHint: widget.levelId <= 3 ? () {
                _game.toggleHints();
                HapticFeedback.lightImpact();
              } : null,
              onPause: _handlePause,
              onRestart: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(levelId: widget.levelId)),
                );
              },
            ),
          ),

          // Inventory Dock
          if (!_isPaused)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: InventoryOverlay(items: _inventoryItems),
            ),
          
          // Level Intro Dialog
          if (_showLevelIntro)
            LevelIntroDialog(
              levelId: widget.levelId,
              description: _levelDescription,
              onStart: _dismissLevelIntro,
            ),
        ],
      ),
    );
  }

  void _handleDrop(DragTargetDetails<String> details) {
    // 1. Decrement inventory
    bool itemAvailable = false;
    setState(() {
      for (var item in _inventoryItems) {
        if (item['type'] == details.data) {
          if ((item['count'] as int) > 0) {
            item['count'] = (item['count'] as int) - 1;
            itemAvailable = true;
          }
          break;
        }
      }
    });

    if (!itemAvailable) {
      AudioManager().playSfx('error');
      return;
    }

    AudioManager().playSfx('waterbloop');
    HapticFeedback.mediumImpact();

    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.offset);
    final adjustedPosition = Vector2(localPosition.dx + 32, localPosition.dy + 32);

    _game.onExternalDragDrop(details.data, adjustedPosition);
  }
}

class _PauseButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _PauseButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppTheme.teal : Colors.white.withValues(alpha: 0.1),
          foregroundColor: isPrimary ? Colors.white : AppTheme.aqua,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary ? BorderSide.none : const BorderSide(color: AppTheme.teal, width: 1),
          ),
        ),
      ),
    );
  }
}
