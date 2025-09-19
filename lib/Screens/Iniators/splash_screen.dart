import 'package:chat_mate/Screens/Iniators/LanguageSelectionScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimations();

    // Navigate to language selection after 2 seconds
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
      );
    });
  }

  void _startAnimations() {
    _scaleController.forward();
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B4BBF),
              Color(0xFF8B5FBF),
              Color(0xFFDB4A9C),
              Color(0xFFFF6B9D),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating particles
            ...List.generate(30, (index) => _buildFloatingParticle(index)),

            // Main animated logo
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_scaleAnimation, _rotationAnimation, _pulseAnimation]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value * _pulseAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 0.1,
                      child: _buildAnimatedLogo(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF8FAB),
            Color(0xFFFF6B9D),
            Color(0xFFE91E63),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF6B9D).withOpacity(0.6),
            blurRadius: 30,
            offset: Offset(0, 10),
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Icon(
                  Icons.favorite,
                  size: 35,
                  color: Color(0xFFFF1744),
                ),
              );
            },
          ),
          Transform.translate(
            offset: Offset(0, -5),
            child: Icon(
              Icons.favorite,
              size: 25,
              color: Color(0xFFFF4569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = index * 123;
    final x = (random % 100) / 100.0;
    final y = ((random * 7) % 100) / 100.0;
    final size = 2.0 + (random % 3);

    return Positioned(
      left: MediaQuery.of(context).size.width * x,
      top: MediaQuery.of(context).size.height * y,
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              10 * (index % 2 == 0 ? 1 : -1) * _rotationAnimation.value,
              5 * _rotationAnimation.value,
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}