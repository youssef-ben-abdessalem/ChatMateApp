import 'package:chat_mate/Helper/Helper.dart';
import 'package:chat_mate/Screens/Auth/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Translation/AppLocalizations.dart';

class OnboardingScreen extends StatefulWidget {
  final String languageCode;

  const OnboardingScreen({Key? key, required this.languageCode}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late AppLocalizations localizations;

  @override
  void initState() {
    super.initState();
    localizations = AppLocalizations(widget.languageCode);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Navigation function to login screen
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(languageCode: widget.languageCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<OnboardingData> _onboardingData = [
      OnboardingData(
        icon: Icons.favorite_rounded,
        title: localizations.translate('welcome_title'),
        subtitle: localizations.translate('welcome_subtitle'),
        description: localizations.translate('welcome_description'),
      ),
      OnboardingData(
        icon: Icons.chat_bubble_rounded,
        title: localizations.translate('chat_title'),
        subtitle: localizations.translate('chat_subtitle'),
        description: localizations.translate('chat_description'),
      ),
      OnboardingData(
        icon: Icons.games_rounded,
        title: localizations.translate('games_title'),
        subtitle: localizations.translate('games_subtitle'),
        description: localizations.translate('games_description'),
      ),
    ];

    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations.translate('app_version'),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToLogin, // Navigate to login on skip
                      child: Text(
                        localizations.translate('skip'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(_onboardingData[index]);
                  },
                ),
              ),

              // Navigation
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingData.length,
                            (index) => _buildIndicator(index == _currentPage),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _currentPage > 0
                            ? TextButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            localizations.translate('previous'),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        )
                            : SizedBox(width: 60),

                        ElevatedButton(
                          onPressed: () {
                            if (_currentPage == _onboardingData.length - 1) {
                              // Navigate to login on last page
                              _navigateToLogin();
                            } else {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFFE91E63),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            _currentPage == _onboardingData.length - 1
                                ? localizations.translate('get_started') // Changed from 'start'
                                : localizations.translate('next'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: Icon(
                    data.icon,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 50),

          Text(
            data.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 15),

          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 25),

          Text(
            data.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

