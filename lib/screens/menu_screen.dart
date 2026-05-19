import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import '../core/game_preferences.dart';
import 'instrucciones_screen.dart';
import 'settings_screen.dart';
import 'game_screen.dart';
import 'scores_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _updateTheme();
  }

  // Carga el tema activo de SharedPreferences de forma segura
  void _updateTheme() async {
    final savedTheme = await GamePreferences.getTheme();
    setState(() {
      _isDarkMode = savedTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioPlayer();
    final Color backgroundColor = _isDarkMode ? Colors.blueGrey[900]! : Colors.grey[200]!;
    final Color textColor = _isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    'BUSCAMINAS',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      fontFamily: 'PixelFont',
                      letterSpacing: 4,
                      shadows: [
                        Shadow(offset: const Offset(-3, -3), color: _isDarkMode ? Colors.black : Colors.white24),
                        Shadow(offset: const Offset(3, -3), color: _isDarkMode ? Colors.black : Colors.white24),
                        Shadow(offset: const Offset(3, 3), color: _isDarkMode ? Colors.black : Colors.white24),
                        Shadow(offset: const Offset(-3, 3), color: _isDarkMode ? Colors.black : Colors.white24),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                _buildMenuButton(
                  audioPlayer,
                  context,
                  'JUGAR',
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GameScreen()),
                    ).then((_) => _updateTheme()); // Sincroniza el tema al regresar de la partida
                  },
                ),
                _buildMenuButton(
                  audioPlayer,
                  context,
                  'MARCADORES', // Nombre original intacto
                  Colors.orange,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScoresScreen()),
                    ).then((_) => _updateTheme());
                  },
                ),
                _buildMenuButton(
                  audioPlayer,
                  context,
                  'CONFIGURACION',
                  Colors.purple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    ).then((_) => _updateTheme()); // Cambia el color del menú al volver de ajustes
                  },
                ),
                _buildMenuButton(
                  audioPlayer,
                  context,
                  'INSTRUCCIONES', // Cambiado a INSTRUCCIONES tal como lo pediste
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InstructionsScreen()),
                    ).then((_) => _updateTheme());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    AudioPlayer player,
    BuildContext context,
    String text,
    Color color,
    VoidCallback onPressed,
  ) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Container(
        width: 280,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: _isDarkMode ? Colors.white : Colors.black87, width: 4),
            ),
          ),
          onPressed: () {
            player.play(AssetSource('audio/click.mp3')).catchError((e) {
              print("Error de audio: $e");
            });
            onPressed();
          },
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'PixelFont',
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}