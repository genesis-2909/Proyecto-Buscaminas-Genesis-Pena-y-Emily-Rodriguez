import 'package:flutter/material.dart';
import '../core/game_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentDificulty = 'Principiante';
  bool _isDarkMode = true; // Estado local controlado de manera persistente

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Cargar dificultad y tema guardados
  void _loadPreferences() async {
    final data = await GamePreferences.getDifficulty();
    final savedTheme = await GamePreferences.getTheme();
    setState(() {
      _currentDificulty = data['name'];
      _isDarkMode = savedTheme;
    });
  }

  // Cambiar dificultad de forma persistente
  void _selectDifficulty(String name, int rows, int cols, int mines) async {
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

  // Cambiar y guardar el tema de forma persistente
  void _toggleTheme() async {
    final newTheme = !_isDarkMode;
    await GamePreferences.saveTheme(newTheme);
    setState(() {
      _isDarkMode = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _isDarkMode ? Colors.blueGrey[900]! : Colors.grey[200]!;
    final Color textColor = _isDarkMode ? Colors.white : Colors.black;
    final Color sectionTitleColor = _isDarkMode ? Colors.white60 : Colors.black54;

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
              const SizedBox(height: 30),
              
              // --- SECCIÓN DE TEMA ---
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
                    backgroundColor: _isDarkMode ? Colors.purple[700] : Colors.amber[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  onPressed: _toggleTheme,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _isDarkMode ? 'MODO OSCURO ACTIVADO' : 'MODO CLARO ACTIVADO',
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
              
              const SizedBox(height: 30),

              // --- SECCIÓN DE DIFICULTAD ---
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
                    _buildDiffButton('FACIL (6x6)', 'Principiante', 6, 6, 5, Colors.green),
                    _buildDiffButton('MEDIO (8x8)', 'Intermedio', 8, 8, 10, Colors.orange),
                    _buildDiffButton('DIFICIL (10x10)', 'Avanzado', 10, 10, 15, Colors.red),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // --- BOTÓN VOLVER ---
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
          backgroundColor: isSelected ? baseColor : (_isDarkMode ? Colors.blueGrey[800] : Colors.grey[400]),
          foregroundColor: _isDarkMode ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(
              color: isSelected ? Colors.yellow : (_isDarkMode ? Colors.white24 : Colors.black26),
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
            color: isSelected ? Colors.white : (_isDarkMode ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }
}