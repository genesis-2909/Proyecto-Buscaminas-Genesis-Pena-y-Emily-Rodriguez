import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import '../core/game_preferences.dart';

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
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadScoresAndTheme();
  }

  Future<void> _loadScoresAndTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final String? scoresString = prefs.getString('high_scores');
    final savedTheme = await GamePreferences.getTheme();

    if (scoresString != null) {
      final List<dynamic> decoded = jsonDecode(scoresString);
      setState(() {
        _scores = decoded
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        _isDarkMode = savedTheme;
        _isLoading = false;
      });
    } else {
      setState(() {
        _scores = [];
        _isDarkMode = savedTheme;
        _isLoading = false;
      });
    }
  }

  void _playSound() {
    SharedPreferences.getInstance()
        .then((prefs) {
          final bool soundEnabled = prefs.getBool('sound_enabled') ?? true;
          if (soundEnabled) {
            final player = AudioPlayer();
            player.play(AssetSource('audio/click.mp3')).catchError((e) {
              print('Audio no pudo reproducirse en este navegador: $e');
            });
          }
        })
        .catchError((e) {
          print('Error al leer preferencias de audio: $e');
        });
  }

  void _showConfirmationDialog() {
    _playSound();

    print("¡Botón presionado!");
    print("¿Tiene historial?: ${_scores.isNotEmpty}");
    print("Cantidad de records: ${_scores.length}");

    final Color dialogBackground = _isDarkMode
        ? const Color(0xFF263238)
        : Colors.white;
    final Color dialogTextColor = _isDarkMode ? Colors.white : Colors.black;

    // >>> ESTO SE AGREGÓ: Validamos si hay elementos en el historial <<<
    final bool hasHistory = _scores.isNotEmpty;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: dialogBackground,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.orange, width: 3),
          ),
          // >>> ESTO SE MODIFICÓ: Título dinámico con tu texto exacto <<<
          title: Text(
            hasHistory
                ? '¿ESTÁS SEGURO DE BORRAR EL HISTORIAL?'
                : 'SIN REGISTROS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PixelFont',
              color: hasHistory ? Colors.red[600] : Colors.orange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // >>> ESTO SE MODIFICÓ: Contenido dinámico con tu texto exacto <<<
          content: Text(
            hasHistory
                ? 'ESTA ACCIÓN NO SE PUEDE DESHACER.'
                : 'AÚN NO HAY REGISTROS DE PARTIDAS.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PixelFont',
              color: dialogTextColor,
              fontSize: 12,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          // >>> ESTO SE MODIFICÓ: Botones según si hay o no historial <<<
          actions: hasHistory
              ? [
                  // CASO SÍ HAY HISTORIAL: Botones "VOLVER" y "SÍ, SEGURO"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      _playSound();
                      Navigator.pop(dialogContext);
                    },
                    child: const Text(
                      'VOLVER',
                      style: TextStyle(fontFamily: 'PixelFont', fontSize: 12),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      await _clearScores();
                    },
                    child: const Text(
                      'SÍ, SEGURO',
                      style: TextStyle(fontFamily: 'PixelFont', fontSize: 12),
                    ),
                  ),
                ]
              : [
                  // CASO NO HAY HISTORIAL: Solo botón "VOLVER"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      _playSound();
                      Navigator.pop(dialogContext);
                    },
                    child: const Text(
                      'VOLVER',
                      style: TextStyle(fontFamily: 'PixelFont', fontSize: 12),
                    ),
                  ),
                ],
        );
      },
    );
  }

  Future<void> _clearScores() async {
    _playSound();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('high_scores');
    setState(() {
      _scores = [];
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Historial borrado',
            style: TextStyle(fontFamily: 'PixelFont'),
          ),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: _isDarkMode ? Colors.blueGrey[900] : Colors.grey[200],
        body: const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    final Color backgroundColor = _isDarkMode
        ? Colors.blueGrey[900]!
        : Colors.grey[200]!;
    final Color textColor = _isDarkMode ? Colors.white : Colors.black;
    final Color labelColor = _isDarkMode
        ? Colors.orange
        : Colors.deepOrange[700]!;
    final Color unselectedLabelColor = _isDarkMode
        ? Colors.white54
        : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'MEJORES TIEMPOS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'PixelFont',
                ),
              ),
              const SizedBox(height: 15),
              TabBar(
                controller: _tabController,
                indicatorColor: labelColor,
                labelColor: labelColor,
                unselectedLabelColor: unselectedLabelColor,
                labelStyle: const TextStyle(
                  fontFamily: 'PixelFont',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: 'FÁCIL'),
                  Tab(text: 'MEDIO'),
                  Tab(text: 'DIFÍCIL'),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildScoreList('Fácil'),
                    _buildScoreList('Medio'),
                    _buildScoreList('Difícil'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      onPressed: _showConfirmationDialog,
                      child: const Text(
                        'BORRAR TODO',
                        style: TextStyle(fontFamily: 'PixelFont', fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                        style: TextStyle(fontFamily: 'PixelFont', fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreList(String difficulty) {
    List<Map<String, dynamic>> filtered = _scores
        .where((s) => s['difficulty'] == difficulty)
        .toList();

    filtered.sort((a, b) => (a['time'] as int).compareTo(b['time'] as int));

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'No hay records aún, ¡Juega tu primera partida!',
          style: TextStyle(
            color: _isDarkMode ? Colors.white30 : Colors.black38,
            fontFamily: 'PixelFont',
            fontSize: 16,
          ),
        ),
      );
    }

    final Color cardBackground = _isDarkMode
        ? Colors.blueGrey[800]!
        : Colors.grey[400]!;
    final Color itemTextColor = _isDarkMode ? Colors.white : Colors.black87;
    final Color subTextColor = _isDarkMode ? Colors.white70 : Colors.black54;
    final Color cardBorderColor = _isDarkMode ? Colors.white24 : Colors.black26;

    return ListView.builder(
      itemCount: filtered.length > 5 ? 5 : filtered.length,
      itemBuilder: (context, index) {
        final score = filtered[index];
        Color rankColor;
        if (index == 0)
          rankColor = Colors.yellow;
        else if (index == 1)
          rankColor = Colors.grey[300]!;
        else if (index == 2)
          rankColor = Colors.brown[300]!;
        else
          rankColor = _isDarkMode ? Colors.white30 : Colors.black26;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBackground,
            border: Border(
              left: BorderSide(color: rankColor, width: 5),
              top: BorderSide(color: cardBorderColor),
              right: BorderSide(color: cardBorderColor),
              bottom: BorderSide(color: cardBorderColor),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${index + 1} - ${score['date'] ?? 'Sin fecha'}',
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 12,
                      fontFamily: 'PixelFont',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Intentos: ${score['attempts'] ?? 1}',
                    style: TextStyle(
                      color: itemTextColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PixelFont',
                    ),
                  ),
                ],
              ),
              Text(
                '${score['time']}s',
                style: TextStyle(
                  color:
                      (rankColor == Colors.white30 ||
                          rankColor == Colors.black26)
                      ? (_isDarkMode ? Colors.greenAccent : Colors.green[800])
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
