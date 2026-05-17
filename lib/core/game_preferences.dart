import 'package:shared_preferences/shared_preferences.dart';

class GamePreferences {
  static const String _keyRows = 'board_rows';
  static const String _keyCols = 'board_cols';
  static const String _keyMines = 'board_mines';
  static const String _keyLevelName = 'level_name';

  // Guardar la configuración seleccionada
  static Future<void> saveDifficulty(
    String name,
    int rows,
    int cols,
    int mines,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLevelName, name);
    await prefs.setInt(_keyRows, rows);
    await prefs.setInt(_keyCols, cols);
    await prefs.setInt(_keyMines, mines);
  }

  // Cargar los datos guardados (si no hay nada, devuelve Principiante por defecto)
  static Future<Map<String, dynamic>> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyLevelName) ?? 'Principiante',
      'rows': prefs.getInt(_keyRows) ?? 6,
      'cols': prefs.getInt(_keyCols) ?? 6,
      'mines':
          prefs.getInt(_keyMines) ??
          4, // 4 minas para un tablero de 6x6 está perfecto
    };
  }
}
