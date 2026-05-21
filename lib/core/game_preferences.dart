import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class GamePreferences {
  // Guarda la dificultad seleccionada
  static Future<void> saveDifficulty(
    String name,
    int rows,
    int cols,
    int mines,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diff_name', name);
    await prefs.setInt('diff_rows', rows);
    await prefs.setInt('diff_cols', cols);
    await prefs.setInt('diff_mines', mines);
  }

  // Lee la dificultad seleccionada
  static Future<Map<String, dynamic>> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('diff_name') ?? 'Principiante',
      'rows': prefs.getInt('diff_rows') ?? 6,
      'cols': prefs.getInt('diff_cols') ?? 6,
      'mines': prefs.getInt('diff_mines') ?? 5,
    };
  }

  // Guarda si el Modo Oscuro está activo o no
  static Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDarkMode);
  }

  // Lee si el Modo Oscuro está activo (por defecto true)
  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_dark_mode') ?? true;
  }

  static Future<void> saveSound(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', enabled);
  }

  // Lee si el sonido está activo (por defecto true si no existe)
  static Future<bool> getSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('sound_enabled') ?? true;
  }

  // Método centralizado para reproducir el click.
  // CUALQUIER pantalla puede llamarlo y él decidirá si suena o no.
  static Future<void> playClickSound() async {
    final bool soundEnabled = await getSound();
    if (soundEnabled) {
      final player = AudioPlayer();
      await player
          .play(AssetSource('audio/click.mp3'))
          .catchError((e) => print("Error de audio: $e"));
    }
  }
}
