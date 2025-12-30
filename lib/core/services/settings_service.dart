import 'package:hive/hive.dart';

class SettingsService {
  static const String _boxName = 'settings';
  static const String _soundEffectsKey = 'soundEffects';
  static const String _vibrationsKey = 'vibrations';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  bool get soundEffectsEnabled => _box.get(_soundEffectsKey, defaultValue: true);
  
  bool get vibrationsEnabled => _box.get(_vibrationsKey, defaultValue: true);

  Future<void> setSoundEffects(bool enabled) async {
    await _box.put(_soundEffectsKey, enabled);
  }

  Future<void> setVibrations(bool enabled) async {
    await _box.put(_vibrationsKey, enabled);
  }
}
