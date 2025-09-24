// Lokasi: lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Skema Warna Baru untuk "Perpus"
  final Color _primaryColor = const Color(0xFF2C3E50); // Biru Gelap
  final Color _accentColor = const Color(0xFFE74C3C); // Merah Bata
  final Color _backgroundColor = const Color(0xFFECF0F1); // Abu-abu Terang

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Memulai animasi
    _animationController.forward();

    // Timer untuk navigasi ke halaman login
    Timer(const Duration(seconds: 30), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Aplikasi "Perpus"
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/icon.png', // Menggunakan icon.png dari assets
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Nama Brand "Perpus"
            Text(
              'Perpus',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),

            // Tagline
            Text(
              'Jendela Duniamu',
              style: TextStyle(
                fontSize: 16,
                color: _primaryColor.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 60),

            // Indikator Loading
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: _primaryColor.withOpacity(0.1),
                color: _accentColor,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}