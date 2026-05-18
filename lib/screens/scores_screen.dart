import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _scores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadScores();
  }

  // Carga los marcadores desde la persistencia local exigida
  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final String? scoresString = prefs.getString('high_scores');

    if (scoresString != null) {
      final List<dynamic> decoded = jsonDecode(scoresString);
      setState(() {
        _scores = decoded
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _scores = [];
        _isLoading = false;
      });
    }
  }

  // Borra el historial con la persistencia local
  Future<void> _clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('high_scores');
    setState(() {
      _scores = [];
    });
  }

  // Muestra ventana flotante de confirmación exigida
  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          shape: const Border(),
          title: const Text(
            '¿BORRAR TODO?',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'PixelFont',
              fontSize: 18,
            ),
          ),
          content: const Text(
            'Se eliminaran todos los records guardados permanentemente.',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'PixelFont',
              fontSize: 12,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Sonido para el botón Cancelar
                final player = AudioPlayer();
                player.play(AssetSource('audio/click.mp3'));
                Navigator.pop(context);
              },
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.grey, fontFamily: 'PixelFont'),
              ),
            ),
            TextButton(
              onPressed: () {
                // Sonido para el botón Borrar definitivo
                final player = AudioPlayer();
                player.play(AssetSource('audio/click.mp3'));
                _clearScores();
                Navigator.pop(context);
              },
              child: const Text(
                'BORRAR',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PixelFont',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredScores(String difficulty) {
    return _scores.where((score) => score['difficulty'] == difficulty).toList()
      ..sort(
        (a, b) => (a['time'] as int).compareTo(b['time'] as int),
      ); // Ordena por mejor tiempo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'MARCADORES',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: 'PixelFont',
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 15),

              // Controlador de pestañas por dificultad (Fácil, Medio, Difícil)
              TabBar(
                controller: _tabController,
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Colors.white60,
                indicatorColor: Colors.blueAccent,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'PixelFont',
                ),
                tabs: const [
                  Tab(text: 'FACIL'),
                  Tab(text: 'MEDIO'),
                  Tab(text: 'DIFICIL'),
                ],
              ),
              const SizedBox(height: 15),

              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildScoresList('Fácil'),
                          _buildScoresList('Medio'),
                          _buildScoresList('Difícil'),
                        ],
                      ),
              ),
              const SizedBox(height: 10),

              // Botón obligatorio para borrar records
              if (_scores.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    //  Sonido para el botón de abrir diálogo de borrar historial
                    final player = AudioPlayer();
                    player.play(AssetSource('audio/click.mp3'));
                    _showClearDialog();
                  },
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  label: const Text(
                    'BORRAR HISTORIAL',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PixelFont',
                    ),
                  ),
                ),
              const SizedBox(height: 10),

              // Botón obligatorio para volver
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.white, width: 3),
                    ),
                  ),
                  onPressed: () {
                    // Sonido para el botón Volver
                    final player = AudioPlayer();
                    player.play(AssetSource('audio/click.mp3'));
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'VOLVER',
                    style: TextStyle(
                      fontSize: 18,
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

  Widget _buildScoresList(String difficulty) {
    final filtered = _getFilteredScores(difficulty);

    // Mensaje amigable exigido por el profe si la lista está vacía
    if (filtered.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Aun no tienes registros.\n¡Juega tu primera partida!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 16,
              height: 1.5,
              fontFamily: 'PixelFont',
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final score = filtered[index];

        // Colores especiales de medallas retro para los primeros puestos
        Color rankColor = Colors.white30;
        if (index == 0) rankColor = Colors.amber; // Oro
        if (index == 1) rankColor = Colors.grey; // Plata
        if (index == 2) rankColor = Colors.brown; // Bronce

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blueGrey[800],
            border: Border(left: BorderSide(color: rankColor, width: 5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${index + 1} - ${score['date'] ?? 'Sin fecha'}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: 'PixelFont',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Intentos: ${score['attempts'] ?? 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PixelFont',
                    ),
                  ),
                ],
              ),
              Text(
                '${score['time']}s',
                style: TextStyle(
                  color: rankColor == Colors.white30
                      ? Colors.greenAccent
                      : rankColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'PixelFont',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
