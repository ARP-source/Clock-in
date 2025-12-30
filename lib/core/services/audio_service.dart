import 'package:audioplayers/audioplayers.dart';
import 'package:focustrophy/core/services/settings_service.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final SettingsService _settingsService;

  AudioService(this._settingsService);

  Future<void> playButtonClick() async {
    if (!_settingsService.soundEffectsEnabled) return;
    
    try {
      await _player.play(AssetSource('sounds/button_click.mp3'), volume: 0.5);
    } catch (e) {
      // Silently fail if sound file doesn't exist
    }
  }

  Future<void> playTimerComplete() async {
    if (!_settingsService.soundEffectsEnabled) return;
    
    try {
      await _player.play(AssetSource('sounds/timer_complete.mp3'), volume: 0.7);
    } catch (e) {
      // Silently fail if sound file doesn't exist
    }
  }

  Future<void> playBreakStart() async {
    if (!_settingsService.soundEffectsEnabled) return;
    
    try {
      await _player.play(AssetSource('sounds/break_start.mp3'), volume: 0.6);
    } catch (e) {
      // Silently fail if sound file doesn't exist
    }
  }

  void dispose() {
    _player.dispose();
  }
}
