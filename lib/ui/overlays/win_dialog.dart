import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class WinDialog extends StatelessWidget {
  final int levelId;
  final VoidCallback onNextLevel;

  const WinDialog({
    super.key,
    required this.levelId,
    required this.onNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.deepBlue,
              AppTheme.deepBlue.withBlue(60),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.success, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppTheme.success.withValues(alpha: 0.4),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trophy icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 56,
              ),
            )
            .animate()
            .scale(begin: const Offset(0, 0), duration: 500.ms, curve: Curves.elasticOut)
            .then()
            .shake(duration: 300.ms, hz: 2),
            
            const SizedBox(height: 20),
            
            Text(
              '🎉 Harmony Restored! 🎉',
              style: AppTheme.titleStyle.copyWith(
                color: AppTheme.success,
                fontSize: 26,
              ),
              textAlign: TextAlign.center,
            )
            .animate(delay: 200.ms)
            .fadeIn()
            .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 8),
            
            Text(
              'Level $levelId Complete',
              style: AppTheme.bodyStyle.copyWith(
                color: Colors.white70,
                fontSize: 16,
              ),
            )
            .animate(delay: 300.ms)
            .fadeIn(),
            
            const SizedBox(height: 24),
            
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                    size: index == 1 ? 56 : 44,
                  )
                  .animate(delay: Duration(milliseconds: 400 + (index * 150)))
                  .scale(begin: const Offset(0, 0), curve: Curves.elasticOut, duration: 600.ms)
                  .then()
                  .shimmer(duration: 1000.ms, color: Colors.white.withValues(alpha: 0.3)),
                );
              }),
            ),
            
            const SizedBox(height: 32),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home_rounded, color: AppTheme.teal),
                  label: Text(
                    'Menu',
                    style: AppTheme.buttonStyle.copyWith(color: AppTheme.teal),
                  ),
                )
                .animate(delay: 700.ms)
                .fadeIn(),
                
                ElevatedButton.icon(
                  onPressed: onNextLevel,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text('Next Level', style: AppTheme.buttonStyle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    elevation: 8,
                    shadowColor: AppTheme.success.withValues(alpha: 0.5),
                  ),
                )
                .animate(delay: 800.ms)
                .fadeIn()
                .scale(begin: const Offset(0.9, 0.9)),
              ],
            ),
          ],
        ),
      )
      .animate()
      .fadeIn(duration: 300.ms)
      .scale(begin: const Offset(0.8, 0.8), duration: 400.ms, curve: Curves.easeOutBack),
    );
  }
}
