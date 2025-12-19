import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InventoryOverlay extends StatelessWidget {
  final List<dynamic> items;

  const InventoryOverlay({
    super.key,
    this.items = const [], // Default empty
  });

  // Helper to map type to asset path
  String _getAssetPath(String type) {
    // Ideally this map should be shared or central
    switch (type) {
      case 'neon_tetra': return 'assets/images/fish_neon.png';
      case 'plant_fern': return 'assets/images/decor_plant_fern.png';
      case 'clown_fish': return 'assets/images/fish_clown.png';
      case 'plant_anemone': return 'assets/images/decor_plant_anemone.png';
      case 'betta_fish': return 'assets/images/fish_betta.png';
      case 'rock_clean': return 'assets/images/decor_rock_clean.png';
      case 'rock_mossy': return 'assets/images/decor_rock_mossy.png';
      case 'goldfish': return 'assets/images/fish_gold.png';
      case 'catfish': return 'assets/images/fish_catfish.png';
      case 'castle': return 'assets/images/decor_castle.png';
      default: return 'assets/images/fish_neon.png'; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppTheme.deepBlue.withValues(alpha: 0.8),
        border: Border(top: BorderSide(color: AppTheme.teal.withValues(alpha: 0.5), width: 2)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = items[index];
          final count = item['count'] as int;
          
          // If count is 0, don't show or show disabled?
          // For now, let's just filter them out in parent, or return empty here.
          if (count <= 0) return const SizedBox.shrink();

          final type = item['type'];
          final assetPath = _getAssetPath(type);
          
          return Stack(
            clipBehavior: Clip.none,
            children: [
              _DraggableInventoryItem(
                type: type,
                assetPath: assetPath,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.deepBlue,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.teal),
                  ),
                  child: Text(
                    '$count',
                    style: AppTheme.bodyStyle.copyWith(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DraggableInventoryItem extends StatelessWidget {
  final String type;
  final String assetPath;

  const _DraggableInventoryItem({
    required this.type,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: type,
      feedback: Material(
        color: Colors.transparent,
        child: Image.asset(assetPath, width: 64, height: 64),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _InventorySlot(assetPath: assetPath),
      ),
      child: _InventorySlot(assetPath: assetPath),
    );
  }
}

class _InventorySlot extends StatelessWidget {
  final String assetPath;

  const _InventorySlot({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.teal.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(8),
      child: Image.asset(assetPath),
    );
  }
}
