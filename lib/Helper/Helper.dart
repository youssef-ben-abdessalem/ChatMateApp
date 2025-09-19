import 'package:flutter/cupertino.dart';

class LanguageOption {
  final String code;
  final String name;
  final String flag;
  final String nativeName;

  LanguageOption({
    required this.code,
    required this.name,
    required this.flag,
    required this.nativeName,
  });
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}