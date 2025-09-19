import 'package:chat_mate/Helper/Helper.dart';
import 'package:chat_mate/Screens/Iniators/Onboarding.dart';
import 'package:chat_mate/Translation/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<LanguageOption> _languages = [
    LanguageOption(
      code: 'en',
      name: 'English',
      flag: '🇺🇸',
      nativeName: 'English',
    ),
    LanguageOption(
      code: 'fr',
      name: 'French',
      flag: '🇫🇷',
      nativeName: 'Français',
    ),
    LanguageOption(
      code: 'ar',
      name: 'Arabic',
      flag: '🇸🇦',
      nativeName: 'العربية',
    ),
    LanguageOption(
      code: 'neutral',
      name: 'Neutral',
      flag: '🌍',
      nativeName: 'Simple',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  SizedBox(height: 60),

                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFF8FAB),
                          Color(0xFFFF6B9D),
                          Color(0xFFE91E63),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF6B9D).withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 40),

                  // Title
                  Text(
                    'Choose Your Language',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 10),

                  Text(
                    'اختر لغتك المفضلة',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 50),

                  // Language options
                  Expanded(
                    child: ListView.builder(
                      itemCount: _languages.length,
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 800 + (index * 200)),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.translate(
                              offset: Offset(50 * (1 - value), 0),
                              child: Opacity(
                                opacity: value,
                                child: _buildLanguageCard(_languages[index], index),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(LanguageOption language, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectLanguage(language),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Flag
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      language.flag,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),

                SizedBox(width: 20),

                // Language info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        language.nativeName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.7),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectLanguage(LanguageOption language) {
    // Navigate to onboarding with selected language
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingScreen(languageCode: language.code),
      ),
    );
  }
}