import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class BubbleParticle extends Particle {
  final Vector2 position;
  final Vector2 velocity;
  final double lifeSpan;
  double _timer = 0;

  BubbleParticle({
    required this.position,
    required this.velocity,
    this.lifeSpan = 2.0,
  });

  @override
  void update(double dt) {
    _timer += dt;
    position.add(velocity * dt);
    // Add some wobble
    position.x += sin(_timer * 10) * 0.5;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: (1 - _timer / lifeSpan).clamp(0.0, 0.5))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position.toOffset(), 4, paint);
    
    // Shine
    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: (1 - _timer / lifeSpan).clamp(0.0, 0.8))
      ..style = PaintingStyle.fill;
      
    canvas.drawCircle((position + Vector2(-1, -1)).toOffset(), 1, shinePaint);
  }
}

