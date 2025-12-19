import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  AudioManager._internal();

  bool _isMuted = false;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      // Preload BGM (mp3 for web compatibility)
      await FlameAudio.audioCache.load('sound/calm-background-sound.mp3');
      
      // Preload SFX
      await FlameAudio.audioCache.loadAll([
        'sound/waterbloop.ogg',
        'sound/success.ogg',
        'sound/error.ogg',
      ]);
      
      _isInitialized = true;
    } catch (e) {
      debugPrint("Error preloading audio: $e");
    }
  }

  Future<void> playBgm() async {
    if (_isMuted) return; 
    try {
      if (!FlameAudio.bgm.isPlaying) {
        await FlameAudio.bgm.play('sound/calm-background-sound.mp3', volume: 0.3);
      }
    } catch (e) {
      debugPrint("Error playing BGM: $e");
    }
  }

  void pauseBgm() {
    try {
      if (FlameAudio.bgm.isPlaying) {
        FlameAudio.bgm.pause();
      }
    } catch (e) {
      debugPrint("Error pausing BGM: $e");
    }
  }

  void resumeBgm() {
    if (_isMuted) return;
    try {
      FlameAudio.bgm.resume();
    } catch (e) {
      debugPrint("Error resuming BGM: $e");
    }
  }

  void stopBgm() {
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      debugPrint("Error stopping BGM: $e");
    }
  }

  Future<void> playSfx(String sfxName) async {
    if (_isMuted) return;
    try {
      await FlameAudio.play('sound/$sfxName.ogg');
    } catch (e) {
      debugPrint("Error playing SFX: $e");
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    try {
      if (_isMuted) {
        FlameAudio.bgm.pause();
      } else {
        FlameAudio.bgm.resume();
      }
    } catch (e) {
      debugPrint("Error toggling mute: $e");
    }
  }
}
