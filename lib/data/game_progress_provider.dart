import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameProgressProvider extends ChangeNotifier {
  int _highestLevelUnlocked = 1;
  int get highestLevelUnlocked => _highestLevelUnlocked;

  GameProgressProvider() {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _highestLevelUnlocked = prefs.getInt('highestLevelUnlocked') ?? 1;
    notifyListeners();
  }

  Future<void> unlockLevel(int level) async {
    if (level > _highestLevelUnlocked) {
      _highestLevelUnlocked = level;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highestLevelUnlocked', _highestLevelUnlocked);
      notifyListeners();
    }
  }
}

