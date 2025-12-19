import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GameOverlay extends StatelessWidget {
  final VoidCallback onPause;
  final VoidCallback onRestart;
  final VoidCallback? onHint;
  final ValueNotifier<String>? statusMessage;
  final ValueNotifier<String>? levelDescription;
  final ValueNotifier<double>? timeRemaining;
  final int levelId;

  const GameOverlay({
    super.key,
    required this.onPause,
    required this.onRestart,
    this.onHint,
    this.statusMessage,
    this.levelDescription,
    this.timeRemaining,
    this.levelId = 1,
  });

  bool get _isHardMode => levelId >= 4;

  @override
  Widget build(BuildContext context) {
    final accentColor = _isHardMode ? Colors.amber : AppTheme.teal;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                // Back Button
                _buildIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.of(context).pop(),
                  accentColor: accentColor,
                ),
                
                const SizedBox(width: 8),
                
                // Level indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.deepBlue.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isHardMode) ...[
                        Icon(Icons.local_fire_department, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        "Level $levelId",
                        style: AppTheme.bodyStyle.copyWith(
                          color: _isHardMode ? Colors.amber : AppTheme.aqua,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),

                // Pause Button
                _buildIconButton(
                  icon: Icons.pause,
                  onPressed: onPause,
                  accentColor: accentColor,
                ),
                
                const SizedBox(width: 8),
                
                // Timer display
                if (timeRemaining != null)
                  ValueListenableBuilder<double>(
                    valueListenable: timeRemaining!,
                    builder: (context, time, child) {
                      if (time <= 0) return const SizedBox.shrink();
                      
                      final seconds = time.ceil();
                      final isLowTime = seconds <= 10;
                      final isCriticalTime = seconds <= 5;
                      
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isCriticalTime 
                              ? Colors.red.withValues(alpha: 0.9)
                              : isLowTime 
                                  ? Colors.orange.withValues(alpha: 0.9)
                                  : AppTheme.deepBlue.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCriticalTime 
                                ? Colors.red 
                                : isLowTime 
                                    ? Colors.orange 
                                    : accentColor.withValues(alpha: 0.5),
                            width: isCriticalTime ? 2 : 1,
                          ),
                          boxShadow: isCriticalTime ? [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ] : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              color: isCriticalTime || isLowTime ? Colors.white : AppTheme.aqua,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatTime(seconds),
                              style: AppTheme.bodyStyle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                
                if (timeRemaining != null) const SizedBox(width: 8),
                
                // Hint Button - only for non-hard mode
                if (onHint != null)
                  _buildIconButton(
                    icon: Icons.lightbulb_outline,
                    onPressed: onHint!,
                    color: Colors.amber,
                    accentColor: accentColor,
                  ),
                
                if (onHint != null) const SizedBox(width: 8),
                
                // Restart Button
                _buildIconButton(
                  icon: Icons.refresh,
                  onPressed: onRestart,
                  accentColor: accentColor,
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Status Message
            if (statusMessage != null)
              ValueListenableBuilder<String>(
                valueListenable: statusMessage!,
                builder: (context, value, child) {
                  if (value.isEmpty) return const SizedBox.shrink();
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(value),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.deepBlue.withValues(alpha: 0.95),
                            AppTheme.deepBlue.withValues(alpha: 0.85),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: value.contains('🎉') 
                              ? AppTheme.success 
                              : accentColor.withValues(alpha: 0.5),
                          width: value.contains('🎉') ? 2 : 1,
                        ),
                        boxShadow: value.contains('🎉') ? [
                          BoxShadow(
                            color: AppTheme.success.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ] : null,
                      ),
                      child: Text(
                        value,
                        style: AppTheme.bodyStyle.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color color = Colors.white,
    required Color accentColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.deepBlue.withValues(alpha: 0.8),
            shape: BoxShape.circle,
            border: Border.all(color: accentColor.withValues(alpha: 0.4)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
  
  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    if (mins > 0) {
      return '$mins:${secs.toString().padLeft(2, '0')}';
    }
    return '$secs';
  }
}
