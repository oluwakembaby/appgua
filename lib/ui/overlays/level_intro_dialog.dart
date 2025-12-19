import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class LevelIntroDialog extends StatelessWidget {
  final int levelId;
  final String description;
  final VoidCallback onStart;

  const LevelIntroDialog({
    super.key,
    required this.levelId,
    required this.description,
    required this.onStart,
  });

  bool get _isHardMode => levelId >= 4;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isHardMode 
                ? [
                    const Color(0xFF1a0a2e),
                    const Color(0xFF16213e),
                  ]
                : [
                    AppTheme.deepBlue,
                    AppTheme.deepBlue.withBlue(80),
                  ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHardMode ? Colors.amber : AppTheme.teal, 
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: (_isHardMode ? Colors.amber : AppTheme.teal).withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hard mode badge
              if (_isHardMode)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "CHALLENGE MODE",
                        style: AppTheme.bodyStyle.copyWith(
                          color: Colors.amber,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn()
                .shimmer(duration: 1500.ms, color: Colors.amber.withValues(alpha: 0.3)),
              
              // Level badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: (_isHardMode ? Colors.amber : AppTheme.teal).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _isHardMode ? Colors.amber : AppTheme.teal),
                ),
                child: Text(
                  "Level $levelId",
                  style: AppTheme.titleStyle.copyWith(
                    fontSize: 28,
                    color: _isHardMode ? Colors.amber : AppTheme.aqua,
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.8, 0.8)),
              
              const SizedBox(height: 24),
              
              // Icon
              Icon(
                _isHardMode ? Icons.psychology : Icons.water,
                size: 48,
                color: _isHardMode ? Colors.amber : AppTheme.aqua,
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: -8, duration: 1500.ms),
              
              const SizedBox(height: 16),
              
              // Description - only show for non-hard mode levels
              if (!_isHardMode && description.isNotEmpty)
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.4,
                  ),
                )
                .animate(delay: 200.ms)
                .fadeIn(duration: 400.ms),
              
              if (!_isHardMode && description.isEmpty)
                Text(
                  "Create a happy aquarium!",
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.4,
                  ),
                )
                .animate(delay: 200.ms)
                .fadeIn(duration: 400.ms),
              
              // Hard mode - warning about enemies
              if (_isHardMode)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.amber.shade200,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Beware of jellyfish!",
                      style: AppTheme.bodyStyle.copyWith(
                        color: Colors.amber.shade200,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
                .animate(delay: 200.ms)
                .fadeIn(duration: 400.ms),
              
              const SizedBox(height: 8),
              
              // Tip - only show for levels 1-3
              if (!_isHardMode)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.touch_app, color: AppTheme.aqua, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "Tip: You can drag fish to reposition them!",
                          style: AppTheme.bodyStyle.copyWith(
                            color: AppTheme.aqua,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate(delay: 400.ms)
                .fadeIn(),
              
              
              const SizedBox(height: 28),
              
              // Start button
              ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isHardMode ? Colors.amber : AppTheme.teal,
                  foregroundColor: _isHardMode ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  shadowColor: (_isHardMode ? Colors.amber : AppTheme.teal).withValues(alpha: 0.5),
                ),
                child: Text(
                  _isHardMode ? "Bring It On!" : "Let's Go!",
                  style: AppTheme.buttonStyle.copyWith(
                    fontSize: 20,
                    color: _isHardMode ? Colors.black : Colors.white,
                  ),
                ),
              )
              .animate(delay: 500.ms)
              .fadeIn()
              .scale(begin: const Offset(0.9, 0.9)),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.95, 0.95), duration: 300.ms),
      ),
    );
  }
}
