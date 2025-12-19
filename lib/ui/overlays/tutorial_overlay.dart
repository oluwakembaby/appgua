import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class TutorialOverlay extends StatefulWidget {
  const TutorialOverlay({super.key});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return GestureDetector(
      onTap: dismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: AppTheme.deepBlue,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.teal, width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "How to Play",
                          style: AppTheme.titleStyle.copyWith(color: AppTheme.teal),
                        ),
                        const SizedBox(height: 16),
                        _buildLegendItem(
                          'assets/images/icon_cloud_red.png',
                          "Lonely / Unhappy\n(Needs a friend!)",
                        ),
                        const SizedBox(height: 12),
                        _buildLegendItem(
                          'assets/images/icon_heart_green.png',
                          "Happy!\n(Good job!)",
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Goal: Place all items and make everyone happy!",
                          textAlign: TextAlign.center,
                          style: AppTheme.bodyStyle.copyWith(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Tap to Start",
                          style: AppTheme.bodyStyle.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ).animate(onPlay: (c) => c.repeat()).fade(duration: 1000.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String assetPath, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(assetPath, width: 40, height: 40),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            text,
            style: AppTheme.bodyStyle.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void dismiss() {
    if (mounted) {
      setState(() {
        _visible = false;
      });
    }
  }
}
