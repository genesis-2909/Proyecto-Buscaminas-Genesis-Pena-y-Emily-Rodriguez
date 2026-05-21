import 'package:flutter/material.dart';
import '../core/game_preferences.dart';

class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({super.key});

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final savedTheme = await GamePreferences.getTheme();
    setState(() {
      _isDarkMode = savedTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _isDarkMode
        ? Colors.blueGrey[900]!
        : Colors.grey[200]!;
    final Color textColor = _isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'COMO JUGAR',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'PixelFont',
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _InstructionTile(
                      number: '1',
                      text:
                          'El juego consiste en descubrir todas las casillas del tablero sin tocar las minas ocultas.',
                      isDarkMode: _isDarkMode,
                    ),
                    _InstructionTile(
                      number: '2',
                      text:
                          'Haz clic en una casilla para revelar lo que hay debajo.',
                      isDarkMode: _isDarkMode,
                    ),
                    _InstructionTile(
                      number: '3',
                      text:
                          'Los numeros indican cuantas minas hay en las casillas de alrededor.',
                      isDarkMode: _isDarkMode,
                    ),
                    _InstructionTile(
                      number: '4',
                      text:
                          'Usa un clic largo para colocar una bandera donde sospeches que hay una mina.',
                      isDarkMode: _isDarkMode,
                    ),
                    _InstructionTile(
                      number: '5',
                      text:
                          '¡Ganas si logras descubrir todas las casillas que no tienen minas!',
                      isDarkMode: _isDarkMode,
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
                  onPressed: () async {
                    await GamePreferences.playClickSound();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'VOLVER',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'PixelFont',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstructionTile extends StatelessWidget {
  final String number;
  final String text;
  final bool isDarkMode;

  const _InstructionTile({
    required this.number,
    required this.text,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final Color itemTextColor = isDarkMode ? Colors.white : Colors.black87;
    final Color boxBorderColor = isDarkMode ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple,
              border: Border.all(color: boxBorderColor, width: 2),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontFamily: 'PixelFont',
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: itemTextColor,
                fontSize: 16,
                height: 1.4,
                fontFamily: 'PixelFont',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
