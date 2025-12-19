import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

enum MoodState { happy, sad, neutral }

class AquariumItem extends SpriteComponent with DragCallbacks {
  final String type;
  MoodState mood = MoodState.neutral;
  SpriteComponent? feedbackIcon;
  final VoidCallback? onMoved;
  
  // For drag visual feedback
  bool _isDragging = false;
  Vector2? _dragStartPosition;

  AquariumItem({
    required this.type,
    required Vector2 position,
    required Sprite sprite,
    this.onMoved,
  }) : super(sprite: sprite, position: position, size: Vector2(64, 64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Add idle animation (bobbing) - only when not dragging
    add(MoveEffect.by(
      Vector2(0, -5),
      EffectController(
        duration: 2,
        reverseDuration: 2,
        infinite: true,
        curve: Curves.easeInOut,
      ),
    ));
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _isDragging = true;
    _dragStartPosition = position.clone();
    
    // Visual feedback - scale up slightly
    add(ScaleEffect.to(
      Vector2.all(1.2),
      EffectController(duration: 0.1),
    ));
    
    // Bring to front
    priority = 100;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_isDragging) {
      position += event.localDelta;
      
      // Clamp to screen bounds (with some padding)
      position.x = position.x.clamp(30, 330);
      position.y = position.y.clamp(80, 560);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _isDragging = false;
    
    // Scale back to normal
    add(ScaleEffect.to(
      Vector2.all(1.0),
      EffectController(duration: 0.1),
    ));
    
    // Reset priority
    priority = 0;
    
    // Notify game to re-check harmony
    onMoved?.call();
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _isDragging = false;
    if (_dragStartPosition != null) {
      position = _dragStartPosition!;
    }
    
    add(ScaleEffect.to(
      Vector2.all(1.0),
      EffectController(duration: 0.1),
    ));
    priority = 0;
  }

  void setMood(MoodState newMood) async {
    if (mood == newMood) return;
    mood = newMood;

    // Remove old feedback
    if (feedbackIcon != null) {
      feedbackIcon!.removeFromParent();
      feedbackIcon = null;
    }

    // Add new feedback icon
    String? iconName;
    if (mood == MoodState.happy) iconName = 'icon_heart_green.png';
    if (mood == MoodState.sad) iconName = 'icon_cloud_red.png';

    if (iconName != null) {
      try {
        final iconSprite = await Sprite.load(iconName);
        feedbackIcon = SpriteComponent(
          sprite: iconSprite,
          size: Vector2(28, 28),
          position: Vector2(0, -45), // Above the item
          anchor: Anchor.center,
        );
        add(feedbackIcon!);
        
        // Pop animation for feedback
        feedbackIcon!.add(ScaleEffect.by(
          Vector2.all(1.3),
          EffectController(duration: 0.15, reverseDuration: 0.15),
        ));
      } catch (e) {
        debugPrint('Error loading feedback icon: $e');
      }
    }
  }
}
