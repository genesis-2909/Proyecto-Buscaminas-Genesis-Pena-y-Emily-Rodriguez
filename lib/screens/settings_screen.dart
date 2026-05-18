import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import '../core/game_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentDificulty = 'Principiante';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Cargar lo que esté guardado para mostrar qué opción está activa
  void _loadPreferences() async {
    final data = await GamePreferences.getDifficulty();
    setState(() {
      _currentDificulty = data['name'];
    });
  }

  // Cambiar dificultad y guardarla de forma persistente
  void _selectDifficulty(String name, int rows, int cols, int mines) async {
    final player = AudioPlayer();
    player.play(AssetSource('audio/click.mp3'));
    await GamePreferences.saveDifficulty(name, rows, cols, mines);
    setState(() {
      _currentDificulty = name;
    });

    // Ventana emergente opcional confirmando el guardado
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Configuración guardada: $name ($rows x $cols)',
          style: const TextStyle(fontFamily: 'PixelFont'),
        ),

        duration: const Duration(milliseconds: 800),
        backgroundColor: Colors.purple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              FadeInDown(
                child: const Text(
                  'DIFICULTAD',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontFamily: 'PixelFont',
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Seleccionado actual: $_currentDificulty',
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontFamily: 'PixelFont',
                ),
              ),
              const SizedBox(height: 40),

              // OPCIÓN 1: PRINCIPIANTE
              _buildDiffButton(
                'PRINCIPIANTE (6x6)',
                'Principiante',
                6,
                6,
                4,
                Colors.green,
              ),

              // OPCIÓN 2: INTERMEDIO
              _buildDiffButton(
                'INTERMEDIO (8x8)',
                'Intermedio',
                8,
                8,
                10,
                Colors.orange,
              ),

              // OPCIÓN 3: AVANZADO
              _buildDiffButton(
                'AVANZADO (10x10)',
                'Avanzado',
                10,
                10,
                15,
                Colors.red,
              ),

              const Spacer(),

              // BOTÓN VOLVER
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.white, width: 3),
                    ),
                  ),
                  onPressed: () {
                    //  Reproduce el sonido antes de salir de la pantalla
                    final player = AudioPlayer();
                    player.play(AssetSource('audio/click.mp3'));
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
          backgroundColor: isSelected ? baseColor : Colors.blueGrey[800],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(
              color: isSelected ? Colors.yellow : Colors.white24,
              width: isSelected ? 4 : 2,
            ),
          ),
        ),
        onPressed: () => _selectDifficulty(name, rows, cols, mines),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'PixelFont',
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
