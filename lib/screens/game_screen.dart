import 'dart:async';
import 'package:flutter/material.dart';
import '../core/game_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:proyecto_buscaminas/models/board_model.dart';
import 'package:proyecto_buscaminas/models/cell_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  BoardModel? _board;
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isFirstClick = true;
  String _difficultyName = 'Principiante';

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Carga la dificultad guardada dinámicamente y crea el tablero lógico
  void _setupGame() async {
    final prefs = await GamePreferences.getDifficulty();

    setState(() {
      _difficultyName = prefs['name'];
      _board = BoardModel(
        rows: prefs['rows'],
        cols: prefs['cols'],
        numberOfMines: prefs['mines'],
      );
      _secondsElapsed = 0;
      _isFirstClick = true;
    });
    _timer?.cancel();
  }

  // Inicia el cronómetro en el primer toque del jugador
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_board != null && !_board!.isGameOver && !_board!.isGameWon) {
        setState(() {
          _secondsElapsed++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  // Maneja el clic normal en una casilla
  void _handleCellTap(int r, int c) {
    if (_board == null || _board!.isGameOver || _board!.isGameWon) return;

    if (_isFirstClick) {
      _isFirstClick = false;
      _startTimer();
    }

    setState(() {
      _board!.revealCell(r, c);
    });

    if (_board!.isGameOver) {
      _showEndDialog(
        title: '¡BOOM!',
        message: 'Pisaste una mina. Inténtalo de nuevo.',
        color: Colors.red,
      );
    } else {
      bool hasWon = true;
      for (var row in _board!.cells) {
        for (var cell in row) {
          if (!cell.isMine && !cell.isRevealed) {
            hasWon = false;
            break;
          }
        }
      }

      if (hasWon) {
        setState(() {
          _board!.isGameWon = true;
        });

        // Ejecuta el guardado
        _saveCurrentGameScore();

        _showEndDialog(
          title: '¡VICTORIA!',
          message: '¡Ganaste en $_secondsElapsed segundos!',
          color: Colors.green,
        );
      }
    }
  }

  // Maneja el clic largo para colocar banderas
  void _handleCellLongPress(int r, int c) {
    if (_board == null || _board!.isGameOver || _board!.isGameWon) return;

    setState(() {
      _board!.toggleFlag(r, c);
    });
  }

  // Alerta de fin de partida (Ganar o Perder)
  void _showEndDialog({
    required String title,
    required String message,
    required Color color,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 3),
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'PixelFont',
            color: color,
            fontSize: 26,
            letterSpacing: 2,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'PixelFont',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              //  Sonido para Reintentar
              final player = AudioPlayer();
              player.play(AssetSource('audio/click.mp3'));
              Navigator.pop(context);
              _setupGame(); // Reinicia el juego
            },
            child: const Text(
              'REINTENTAR',
              style: TextStyle(color: Colors.yellow, fontFamily: 'PixelFont'),
            ),
          ),
          TextButton(
            onPressed: () {
              // Sonido para ir al Menú
              final player = AudioPlayer();
              player.play(AssetSource('audio/click.mp3'));
              Navigator.pop(context); // Cierra el diálogo
              Navigator.pop(context); // Vuelve al menú
            },
            child: const Text(
              'MENU',
              style: TextStyle(color: Colors.white, fontFamily: 'PixelFont'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_board == null) {
      return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: const Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _difficultyName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'PixelFont',
                      letterSpacing: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.red, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          _secondsElapsed.toString().padLeft(3, '0'),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PixelFont',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _board!.rows * _board!.cols,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _board!.cols,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                      ),
                      itemBuilder: (context, index) {
                        int r = index ~/ _board!.cols;
                        int c = index % _board!.cols;
                        CellModel cell = _board!.cells[r][c];

                        return GestureDetector(
                          onTap: () => _handleCellTap(r, c),
                          onLongPress: () => _handleCellLongPress(r, c),
                          child: _buildCellWidget(cell),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.white, width: 3),
                    ),
                  ),
                  onPressed: () {
                    // Sonido de clic al abandonar la partida
                    final player = AudioPlayer();
                    player.play(AssetSource('audio/click.mp3'));
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'ABANDONAR PARTIDA',
                    style: TextStyle(
                      fontFamily: 'PixelFont',
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCellWidget(CellModel cell) {
    if (!cell.isRevealed) {
      return Container(
        color: Colors.blueGrey[700],
        child: cell.isFlagged
            ? const Icon(Icons.flag, color: Colors.orange, size: 20)
            : const SizedBox(),
      );
    }

    if (cell.isMine) {
      return Container(
        color: Colors.red[900],
        child: const Icon(Icons.brightness_7, color: Colors.white, size: 20),
      );
    }

    return Container(
      color: Colors.blueGrey[300],
      alignment: Alignment.center,
      child: cell.adjacentMines > 0
          ? Text(
              '${cell.adjacentMines}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'PixelFont',
                color: _getMineNumberColor(cell.adjacentMines),
              ),
            )
          : const SizedBox(),
    );
  }

  Color _getMineNumberColor(int number) {
    switch (number) {
      case 1:
        return Colors.blue[900]!;
      case 2:
        return Colors.green[900]!;
      case 3:
        return Colors.red[900]!;
      case 4:
        return Colors.purple[900]!;
      default:
        return Colors.black;
    }
  }

  void _saveCurrentGameScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String? scoresRaw = prefs.getString('high_scores');
      List<dynamic> scoresList = [];
      if (scoresRaw != null) {
        scoresList = jsonDecode(scoresRaw);
      }

      DateTime now = DateTime.now();
      String formattedDate =
          "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";

      String diffName = _difficultyName;
      if (diffName == 'Principiante') diffName = 'Fácil';
      if (diffName == 'Intermedio') diffName = 'Medio';
      if (diffName == 'Avanzado') diffName = 'Difícil';

      Map<String, dynamic> newRecord = {
        'difficulty': diffName,
        'time': _secondsElapsed,
        'attempts': 1,
        'date': formattedDate,
      };

      scoresList.add(newRecord);
      await prefs.setString('high_scores', jsonEncode(scoresList));
      print("¡Récord guardado con éxito localmente!");
    } catch (e) {
      print("Error guardando el puntaje: $e");
    }
  }
}
