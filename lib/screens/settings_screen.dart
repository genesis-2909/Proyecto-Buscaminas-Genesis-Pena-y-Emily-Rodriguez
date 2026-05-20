import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import '../core/game_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentDificulty = 'Principiante';
  String _themeMode = 'dark';
  bool _isDarkModeVisual = true;
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final data = await GamePreferences.getDifficulty();

    String savedThemeMode = prefs.getString('theme_mode_extended') ?? '';
    if (savedThemeMode.isEmpty) {
      final bool oldTheme = await GamePreferences.getTheme();
      savedThemeMode = oldTheme ? 'dark' : 'light';
    }

    final bool savedSound = prefs.getBool('sound_enabled') ?? true;

    setState(() {
      _currentDificulty = data['name'];
      _themeMode = savedThemeMode;
      _soundEnabled = savedSound;
      _updateVisualTheme();
    });
  }

  void _updateVisualTheme() {
    if (_themeMode == 'auto') {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkModeVisual = brightness == Brightness.dark;
    } else {
      _isDarkModeVisual = _themeMode == 'dark';
    }
  }

  void _playSound() {
    if (_soundEnabled) {
      final player = AudioPlayer();
      player.play(AssetSource('audio/click.mp3')).catchError((e) => print(e));
    }
  }

  void _selectDifficulty(String name, int rows, int cols, int mines) async {
    _playSound();
    await GamePreferences.saveDifficulty(name, rows, cols, mines);
    setState(() {
      _currentDificulty = name;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Dificultad guardada: $name',
          style: const TextStyle(fontFamily: 'PixelFont'),
        ),
        duration: const Duration(milliseconds: 600),
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _cycleTheme() async {
    _playSound();
    String nextMode;
    if (_themeMode == 'dark') {
      nextMode = 'light';
    } else if (_themeMode == 'light') {
      nextMode = 'auto';
    } else {
      nextMode = 'dark';
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode_extended', nextMode);
    await GamePreferences.saveTheme(
      nextMode == 'dark' ||
          (nextMode == 'auto' &&
              WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                  Brightness.dark),
    );

    setState(() {
      _themeMode = nextMode;
      _updateVisualTheme();
    });
  }

  void _toggleSound() async {
    final prefs = await SharedPreferences.getInstance();
    final newSoundState = !_soundEnabled;
    await prefs.setBool('sound_enabled', newSoundState);

    setState(() {
      _soundEnabled = newSoundState;
    });

    if (newSoundState) {
      final player = AudioPlayer();
      player.play(AssetSource('audio/click.mp3')).catchError((e) => print(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _isDarkModeVisual
        ? Colors.blueGrey[900]!
        : Colors.grey[200]!;
    final Color textColor = _isDarkModeVisual ? Colors.white : Colors.black;
    final Color sectionTitleColor = _isDarkModeVisual
        ? Colors.white60
        : Colors.black54;

    Color themeButtonColor = Colors.purple[700]!;
    IconData themeIcon = Icons.dark_mode;
    String themeText = 'MODO OSCURO';

    if (_themeMode == 'light') {
      themeButtonColor = Colors.amber[700]!;
      themeIcon = Icons.light_mode;
      themeText = 'MODO CLARO';
    } else if (_themeMode == 'auto') {
      themeButtonColor = Colors.teal[700]!;
      themeIcon = Icons.brightness_auto;
      themeText = 'MODO AUTOMÁTICO';
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'CONFIGURACIÓN',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'PixelFont',
                ),
              ),
              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'TEMA DEL JUEGO',
                  style: TextStyle(
                    fontFamily: 'PixelFont',
                    fontSize: 14,
                    color: sectionTitleColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeButtonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  onPressed: _cycleTheme,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(themeIcon, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        themeText,
                        style: const TextStyle(
                          fontFamily: 'PixelFont',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _soundEnabled
                        ? Colors.blue[700]
                        : Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  onPressed: _toggleSound,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _soundEnabled ? Icons.volume_up : Icons.volume_off,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _soundEnabled ? 'SONIDO: ACTIVADO' : 'SONIDO: MUTEADO',
                        style: const TextStyle(
                          fontFamily: 'PixelFont',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'DIFICULTAD',
                  style: TextStyle(
                    fontFamily: 'PixelFont',
                    fontSize: 14,
                    color: sectionTitleColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    _buildDiffButton(
                      'FACIL (6x6)',
                      'Principiante',
                      6,
                      6,
                      5,
                      Colors.green,
                    ),
                    _buildDiffButton(
                      'MEDIO (8x8)',
                      'Intermedio',
                      8,
                      8,
                      10,
                      Colors.orange,
                    ),
                    _buildDiffButton(
                      'DIFICIL (10x10)',
                      'Avanzado',
                      10,
                      10,
                      15,
                      Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  onPressed: () {
                    _playSound();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'VOLVER',
                    style: TextStyle(fontFamily: 'PixelFont', fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiffButton(
    String label,
    String name,
    int rows,
    int cols,
    int mines,
    Color baseColor,
  ) {
    final bool isSelected = _currentDificulty == name;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? baseColor
              : (_isDarkModeVisual ? Colors.blueGrey[800] : Colors.grey[400]),
          foregroundColor: _isDarkModeVisual ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(
              color: isSelected
                  ? Colors.yellow
                  : (_isDarkModeVisual ? Colors.white24 : Colors.black26),
              width: isSelected ? 4 : 2,
            ),
          ),
        ),
        onPressed: () => _selectDifficulty(name, rows, cols, mines),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'PixelFont',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.white
                : (_isDarkModeVisual ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }
}
