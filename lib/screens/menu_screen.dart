import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'instrucciones_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      fontFamily: 'Impact',
                      letterSpacing: 4,
                      shadows: [
                        Shadow(offset: const Offset(-3, -3), color: Colors.black),
                        Shadow(offset: const Offset(3, -3), color: Colors.black),
                        Shadow(offset: const Offset(3, 3), color: Colors.black),
                        Shadow(offset: const Offset(-3, 3), color: Colors.black),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                _buildMenuButton(context, 'JUGAR', Colors.green, () {}),
                _buildMenuButton(context, 'MARCADORES', Colors.blue, () {}),
                _buildMenuButton(context, 'CONFIGURACION', Colors.orange, () {}),
                _buildMenuButton(context, 'INSTRUCCIONES', Colors.purple, () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InstructionsScreen()),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
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
              side: const BorderSide(color: Colors.white, width: 4),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'Impact',
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}