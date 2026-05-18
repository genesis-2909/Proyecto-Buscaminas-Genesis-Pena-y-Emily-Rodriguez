import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'menu_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MenuScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: ZoomIn(
          duration: const Duration(seconds: 2),
          child: Text(
            'BUSCAMINAS FLUTTER',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: 'PixelFont',
              letterSpacing: 3,
              shadows: [
                Shadow(offset: const Offset(-2, -2), color: Colors.black),
                Shadow(offset: const Offset(2, -2), color: Colors.black),
                Shadow(offset: const Offset(2, 2), color: Colors.black),
                Shadow(offset: const Offset(-2, 2), color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
