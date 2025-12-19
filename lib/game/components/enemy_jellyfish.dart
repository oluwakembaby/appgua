import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class EnemyJellyfish extends PositionComponent with HasGameReference {
  final double speed;
  final double scareRadius;
  Vector2 _velocity = Vector2.zero();
  final Random _random = Random();
  double _changeDirectionTimer = 0;
  
  // Visual components
  late CircleComponent _body;
  late CircleComponent _glow;
  final List<_Tentacle> _tentacles = [];

  EnemyJellyfish({
    required Vector2 position,
    required this.speed,
    required this.scareRadius,
  }) : super(position: position, size: Vector2(50, 60), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Outer glow
    _glow = CircleComponent(
      radius: 28,
      position: Vector2(25, 20),
      anchor: Anchor.center,
      paint: Paint()
        ..color = const Color(0x40FF6B9D)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );
    add(_glow);
    
    // Main body - semi-transparent pink/purple jellyfish
    _body = CircleComponent(
      radius: 22,
      position: Vector2(25, 20),
      anchor: Anchor.center,
      paint: Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xCCFF6B9D),
            const Color(0x99D946EF),
          ],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: 22)),
    );
    add(_body);
    
    // Inner highlight
    add(CircleComponent(
      radius: 10,
      position: Vector2(25, 16),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0x66FFFFFF),
    ));
    
    // Add tentacles
    for (int i = 0; i < 5; i++) {
      final tentacle = _Tentacle(
        startX: 15 + i * 5.0,
        delay: i * 0.2,
      );
      _tentacles.add(tentacle);
      add(tentacle);
    }
    
    // Pulsing animation on body
    _body.add(
      ScaleEffect.by(
        Vector2.all(1.1),
        EffectController(
          duration: 1.5,
          reverseDuration: 1.5,
          infinite: true,
          curve: Curves.easeInOut,
        ),
      ),
    );
    
    // Start with random direction
    _setRandomDirection();
  }

  void _setRandomDirection() {
    final angle = _random.nextDouble() * 2 * pi;
    _velocity = Vector2(cos(angle), sin(angle)) * speed;
    _changeDirectionTimer = 2.0 + _random.nextDouble() * 3.0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move
    position += _velocity * dt;
    
    // Bounce off walls
    if (position.x < 40 || position.x > 320) {
      _velocity.x = -_velocity.x;
      position.x = position.x.clamp(40, 320);
    }
    if (position.y < 100 || position.y > 550) {
      _velocity.y = -_velocity.y;
      position.y = position.y.clamp(100, 550);
    }
    
    // Periodically change direction
    _changeDirectionTimer -= dt;
    if (_changeDirectionTimer <= 0) {
      _setRandomDirection();
    }
  }
}

class _Tentacle extends PositionComponent {
  final double startX;
  final double delay;
  double _time = 0;
  
  _Tentacle({required this.startX, required this.delay}) 
      : super(position: Vector2(startX, 35), size: Vector2(4, 25));

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0x99D946EF)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    path.moveTo(0, 0);
    
    // Wavy tentacle
    final wave = sin(_time * 3 + delay * 2) * 6;
    path.quadraticBezierTo(wave, 12, wave * 0.5, 25);
    
    canvas.drawPath(path, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }
}

