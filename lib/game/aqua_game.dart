import 'dart:convert';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/aquarium_item.dart';
import 'components/bubble_particle.dart';
import 'components/enemy_jellyfish.dart';

class AquaGame extends FlameGame with HasCollisionDetection {
  final int levelId;
  Map<String, dynamic>? levelData;
  final VoidCallback onWin;
  final VoidCallback? onLose;
  final ValueNotifier<String> statusMessage = ValueNotifier("");
  final ValueNotifier<String> levelDescription = ValueNotifier("");
  final ValueNotifier<bool> showHints = ValueNotifier(false);
  
  // Timer
  final ValueNotifier<double> timeRemaining = ValueNotifier(0);
  double _timeLimit = 0;
  bool _timerStarted = false;

  int totalItemsToPlace = 0;
  int itemsPlaced = 0;
  bool isLevelCompleted = false;
  bool isLevelFailed = false;
  
  // Hint zone components
  final List<CircleComponent> _hintZones = [];
  
  // Enemy tracking
  final List<EnemyJellyfish> _enemies = [];

  AquaGame({required this.levelId, required this.onWin, this.onLose});

  @override
  Color backgroundColor() => const Color(0xFF001F3F);

  @override
  Future<void> onLoad() async {
    // Set up fixed resolution camera
    camera = CameraComponent.withFixedResolution(width: 360, height: 640);
    camera.viewfinder.anchor = Anchor.topLeft;

    await loadLevelData();
    
    // Set initial status
    statusMessage.value = "Drag items to the tank";
  }

  Future<void> loadLevelData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/levels/level_$levelId.json');
      levelData = json.decode(jsonString);

      // Calculate total items
      final inventory = levelData?['inventory'] as List<dynamic>?;
      if (inventory != null) {
        totalItemsToPlace = inventory.fold<int>(0, (sum, item) => sum + (item['count'] as int));
      }
      
      // Set level description
      levelDescription.value = levelData?['description'] ?? '';

      // Load background
      final bgName = levelData?['background'] ?? 'bg_deep.png';
      final bgSprite = await loadSprite(bgName);
      final background = SpriteComponent(
        sprite: bgSprite,
        size: Vector2(360, 640),
        priority: -10,
      );
      world.add(background);
      
      // Spawn enemies if defined
      final enemyData = levelData?['enemy'] as Map<String, dynamic>?;
      if (enemyData != null) {
        final count = enemyData['count'] as int? ?? 1;
        final speed = (enemyData['speed'] as num?)?.toDouble() ?? 40.0;
        final scareRadius = (enemyData['scareRadius'] as num?)?.toDouble() ?? 80.0;
        
        final random = Random();
        for (int i = 0; i < count; i++) {
          final enemy = EnemyJellyfish(
            position: Vector2(
              80 + random.nextDouble() * 200,
              150 + random.nextDouble() * 300,
            ),
            speed: speed,
            scareRadius: scareRadius,
          );
          _enemies.add(enemy);
          world.add(enemy);
        }
      }
      
      // Load time limit
      final timeLimitData = levelData?['timeLimit'] as num?;
      if (timeLimitData != null) {
        _timeLimit = timeLimitData.toDouble();
        timeRemaining.value = _timeLimit;
      }
    } catch (e) {
      debugPrint('Error loading level $levelId: $e');
    }
  }
  
  void startTimer() {
    if (_timeLimit > 0 && !_timerStarted) {
      _timerStarted = true;
    }
  }

  void addGameItem(String type, Vector2 position) async {
    try {
      // Determine sprite
      String spriteName = 'fish_neon.png'; // Default
      if (type == 'plant_fern') spriteName = 'decor_plant_fern.png';
      if (type == 'plant_anemone') spriteName = 'decor_plant_anemone.png';
      if (type == 'rock_clean') spriteName = 'decor_rock_clean.png';
      if (type == 'rock_mossy') spriteName = 'decor_rock_mossy.png';
      if (type == 'clown_fish') spriteName = 'fish_clown.png';
      if (type == 'betta_fish') spriteName = 'fish_betta.png';
      if (type == 'goldfish') spriteName = 'fish_gold.png';
      if (type == 'neon_tetra') spriteName = 'fish_neon.png';
      if (type == 'catfish') spriteName = 'fish_catfish.png';
      if (type == 'castle') spriteName = 'decor_castle.png';
      
      final sprite = await loadSprite(spriteName);
      
      final component = AquariumItem(
        type: type,
        position: position,
        sprite: sprite,
        onMoved: checkHarmony, // Callback when item is dragged
      );
      
      world.add(component);
      itemsPlaced++;
      debugPrint('Added item $type at $position (total: $itemsPlaced/$totalItemsToPlace)');
      
      // Check rules after adding
      checkHarmony();
    } catch (e) {
      debugPrint('Error adding item: $e');
    }
  }

  void checkHarmony() {
    if (levelData == null) return;
    
    final rules = levelData!['rules'] as Map<String, dynamic>?;
    if (rules == null) return;

    final items = world.children.whereType<AquariumItem>().toList();
    
    // Check for enemy scare radius
    final enemyData = levelData!['enemy'] as Map<String, dynamic>?;
    final scareRadius = (enemyData?['scareRadius'] as num?)?.toDouble() ?? 0;
    
    bool allHappy = true;

    for (final item in items) {
      // First check if scared by enemy (only affects fish, not decor)
      bool scaredByEnemy = false;
      if (_isFish(item.type)) {
        for (final enemy in _enemies) {
          final distance = item.position.distanceTo(enemy.position);
          if (distance <= scareRadius) {
            scaredByEnemy = true;
            break;
          }
        }
      }
      
      if (scaredByEnemy) {
        item.setMood(MoodState.sad);
        allHappy = false;
        continue;
      }
      
      if (!rules.containsKey(item.type)) {
        // No rules for this item type, it's just decor
        item.setMood(MoodState.neutral);
        continue;
      }

      final itemRule = rules[item.type];
      final targetType = itemRule['target'];
      final ruleType = itemRule['type'];
      final double radius = (itemRule['radius'] as num).toDouble();

      bool ruleMet = false;

      if (ruleType == 'attraction') {
        // Needs nearby target
        for (final other in items) {
          if (other == item) continue;
          if (other.type == targetType) {
            final distance = item.position.distanceTo(other.position);
            if (distance <= radius) {
              ruleMet = true;
              break;
            }
          }
        }
        item.setMood(ruleMet ? MoodState.happy : MoodState.sad);
      } else if (ruleType == 'repulsion') {
        // Needs to be AWAY from target
        bool safe = true;
        for (final other in items) {
          if (other == item) continue;
          if (other.type == targetType) {
            final distance = item.position.distanceTo(other.position);
            if (distance <= radius) {
              safe = false;
              break;
            }
          }
        }
        item.setMood(safe ? MoodState.happy : MoodState.sad);
        ruleMet = safe;
      }
      
      if (!ruleMet) {
        allHappy = false;
      }
    }
    
    // Update status message based on state
    if (items.isEmpty) {
      statusMessage.value = "Drag items to the tank";
    } else if (items.length < totalItemsToPlace) {
      int left = totalItemsToPlace - items.length;
      statusMessage.value = "$left more to place";
    } else if (!allHappy) {
      statusMessage.value = "Move fish to make them happy!";
    } else {
      statusMessage.value = "🎉 Perfect!";
    }

    // Win condition: all items placed AND all items with rules are happy
    if (items.length >= totalItemsToPlace && allHappy) {
      if (!isLevelCompleted && !isLevelFailed) {
        isLevelCompleted = true; // This flag stops the timer in update()
        debugPrint("WIN! Level Completed.");
        statusMessage.value = "🎉 Level Complete!";
        _spawnWinParticles();
        
        // Delay win callback slightly for visual effect
        Future.delayed(const Duration(milliseconds: 800), () {
          onWin();
        });
      }
    }
  }

  void toggleHints() {
    showHints.value = !showHints.value;
    if (showHints.value) {
      _showHintZones();
    } else {
      _hideHintZones();
    }
  }

  void _showHintZones() {
    if (levelData == null) return;
    final rules = levelData!['rules'] as Map<String, dynamic>?;
    if (rules == null) return;

    final items = world.children.whereType<AquariumItem>().toList();
    
    for (final item in items) {
      if (!rules.containsKey(item.type)) continue;
      
      final itemRule = rules[item.type];
      final ruleType = itemRule['type'];
      final double radius = (itemRule['radius'] as num).toDouble();
      
      final color = ruleType == 'attraction' 
          ? Colors.green.withValues(alpha: 0.2) 
          : Colors.red.withValues(alpha: 0.2);
      
      final zone = CircleComponent(
        radius: radius,
        position: item.position,
        anchor: Anchor.center,
        paint: Paint()..color = color,
        priority: -1,
      );
      
      _hintZones.add(zone);
      world.add(zone);
    }
  }

  void _hideHintZones() {
    for (final zone in _hintZones) {
      zone.removeFromParent();
    }
    _hintZones.clear();
  }

  void _spawnWinParticles() {
    final random = Random();
    for (int i = 0; i < 30; i++) {
      world.add(
        ParticleSystemComponent(
          particle: BubbleParticle(
            position: Vector2(
              random.nextDouble() * 360,
              640 + 10,
            ),
            velocity: Vector2(
              (random.nextDouble() - 0.5) * 30,
              -120 - random.nextDouble() * 60,
            ),
            lifeSpan: 4 + random.nextDouble() * 2,
          ),
          priority: 50,
        ),
      );
    }
  }

  void onExternalDragDrop(String itemType, Vector2 screenPosition) {
    // Convert screen position (from Flutter DragTarget) to World Position
    final worldPosition = camera.globalToLocal(screenPosition);
    addGameItem(itemType, worldPosition);
  }
  
  bool _isFish(String type) {
    return type.contains('fish') || 
           type == 'neon_tetra' || 
           type == 'goldfish' ||
           type == 'catfish';
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Continuously check harmony if enemies are present
    if (_enemies.isNotEmpty && !isLevelCompleted && !isLevelFailed) {
      checkHarmony();
    }
    
    // Timer countdown
    if (_timerStarted && !isLevelCompleted && !isLevelFailed && _timeLimit > 0) {
      timeRemaining.value -= dt;
      
      if (timeRemaining.value <= 0) {
        timeRemaining.value = 0;
        _handleTimeOut();
      }
    }
  }
  
  void _handleTimeOut() {
    if (isLevelFailed || isLevelCompleted) return;
    
    isLevelFailed = true;
    statusMessage.value = "⏰ Time's Up!";
    
    // Trigger lose callback
    Future.delayed(const Duration(milliseconds: 500), () {
      onLose?.call();
    });
  }
}
