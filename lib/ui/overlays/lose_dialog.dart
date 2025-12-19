import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class LoseDialog extends StatelessWidget {
  final int levelId;
  final VoidCallback onRetry;
  final VoidCallback onQuit;

  const LoseDialog({
    super.key,
    required this.levelId,
    required this.onRetry,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2d1b3d),
                Color(0xFF1a1a2e),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.red.shade400,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Failure icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.timer_off_rounded,
                  size: 56,
                  color: Colors.red.shade300,
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .shake(delay: 200.ms, duration: 500.ms),
              
              const SizedBox(height: 20),
              
              // Title
              Text(
                "Time's Up!",
                style: AppTheme.titleStyle.copyWith(
                  fontSize: 32,
                  color: Colors.red.shade300,
                ),
              )
              .animate()
              .fadeIn(delay: 200.ms),
              
              const SizedBox(height: 12),
              
              // Message
              Text(
                "The fish couldn't find harmony in time.",
                textAlign: TextAlign.center,
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms),
              
              const SizedBox(height: 8),
              
              Text(
                "Level $levelId",
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              )
              .animate()
              .fadeIn(delay: 350.ms),
              
              const SizedBox(height: 28),
              
              // Retry Button
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  shadowColor: Colors.amber.withValues(alpha: 0.5),
                ),
              )
              .animate(delay: 400.ms)
              .fadeIn()
              .scale(begin: const Offset(0.9, 0.9)),
              
              const SizedBox(height: 12),
              
              // Quit Button
              TextButton(
                onPressed: onQuit,
                child: Text(
                  "Back to Levels",
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              )
              .animate(delay: 500.ms)
              .fadeIn(),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.9, 0.9), duration: 300.ms),
      ),
    );
  }
}

