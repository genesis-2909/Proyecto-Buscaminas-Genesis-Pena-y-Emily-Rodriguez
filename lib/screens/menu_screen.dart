import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'instrucciones_screen.dart';
import 'settings_screen.dart';
import 'game_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioPlayer();
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
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
                      color: Colors.white,
                      fontFamily: 'PixelFont',
                      letterSpacing: 4,
                      shadows: [
                        Shadow(
                          offset: const Offset(-3, -3),
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: const Offset(3, -3),
                          color: Colors.black,
                        ),
                        Shadow(offset: const Offset(3, 3), color: Colors.black),
                        Shadow(
                          offset: const Offset(-3, 3),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                _buildMenuButton(
                  audioPlayer,
                  context,
                  'JUGAR',
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuButton(
                  audioPlayer,
                  context,
                  'MARCADORES',
                  Colors.blue,
                  () {},
                ),
                _buildMenuButton(
                  audioPlayer,
                  context,
                  'CONFIGURACION',
                  Colors.orange,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuButton(
                  audioPlayer,
                  context,
                  'INSTRUCCIONES',
                  Colors.purple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InstructionsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } //

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
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Colors.white, width: 4),
            ),
          ),
          onPressed: () {
            // CAMBIO 2: Cambiamos '_playClickSound()' por la reproducción real usando el 'player'
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
              fontFamily:
                  'PixelFont', // <-- CAMBIO 3: Cambiado 'Impact' por 'PixelFont'
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
