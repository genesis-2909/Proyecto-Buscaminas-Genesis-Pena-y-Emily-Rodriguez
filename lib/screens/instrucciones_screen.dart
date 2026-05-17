import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                'COMO JUGAR',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: 'Arial Black',
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: const [
                    _InstructionTile(
                      number: '1',
                      text: 'El juego consiste en descubrir todas las casillas del tablero sin tocar las minas ocultas.',
                    ),
                    _InstructionTile(
                      number: '2',
                      text: 'Haz clic en una casilla para revelar lo que hay debajo.',
                    ),
                    _InstructionTile(
                      number: '3',
                      text: 'Los numeros indican cuantas minas hay en las casillas adyacentes.',
                    ),
                    _InstructionTile(
                      number: '4',
                      text: 'Usa el clic largo para colocar banderas y marcar donde creas que hay minas.',
                    ),
                    _InstructionTile(
                      number: '5',
                      text: 'Ganas al revelar todas las casillas seguras. Puedes variar el tamaño del tablero en las dificultades.',
                    ),
                    SizedBox(height: 30),
                    Text(
                      'DESARROLLADORES:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.purpleAccent,
                        fontFamily: 'Arial Black',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Génesis Peña y Emily Rodríguez',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
                      side: BorderSide(color: Colors.white, width: 3),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'VOLVER',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Arial Black',
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

  const _InstructionTile({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontFamily: 'Arial Black',
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}