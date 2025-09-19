import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class AppLocalizations {
  final String languageCode;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.languageCode) {
    _loadLanguage();
  }

  void _loadLanguage() {
    switch (languageCode) {
      case 'en':
        _localizedStrings = {
          "welcome_title": "Welcome to Chat Mate",
          "welcome_subtitle": "The perfect app for loving couples",
          "welcome_description":
              "Discover a new world of communication and love with your life partner",
          "chat_title": "Romantic Conversations",
          "chat_subtitle": "Communicate in a special way",
          "chat_description":
              "Enjoy private conversations and interactive games that bring hearts closer",
          "games_title": "Love Games",
          "games_subtitle": "Play and enjoy together",
          "games_description":
              "A collection of romantic games that increase understanding and intimacy",
          "skip": "Skip",
          "previous": "Previous",
          "next": "Next",
          "start": "Start",
          "app_version": "Chat Mate",

          "welcome_back": "Welcome Back",
          "login_subtitle": "Please login to your account",
          "email": "Email",
          "phone": "Phone",
          "phone_number": "Phone Number",
          "password": "Password",
          "forgot_password": "Forgot Password?",
          "login": "Login",
          "or": "OR",
          "dont_have_account": "Don't have an account?",
          "sign_up": "Sign Up",
          "email_required": "Email is required",
          "email_invalid": "Please enter a valid email",
          "phone_required": "Phone number is required",
          "phone_invalid": "Please enter a valid phone number",
          "password_required": "Password is required",
          "password_too_short": "Password must be at least 6 characters",
        };
        break;
      case 'fr':
        _localizedStrings = {
          "welcome_title": "Bienvenue dans Chat Mate",
          "welcome_subtitle":
              "L'application parfaite pour les couples amoureux",
          "welcome_description":
              "Découvrez un nouveau monde de communication et d'amour avec votre partenaire de vie",
          "chat_title": "Conversations Romantiques",
          "chat_subtitle": "Communiquez d'une manière spéciale",
          "chat_description":
              "Profitez de conversations privées et de jeux interactifs qui rapprochent les cœurs",
          "games_title": "Jeux d'Amour",
          "games_subtitle": "Jouez et amusez-vous ensemble",
          "games_description":
              "Une collection de jeux romantiques qui augmentent la compréhension et l'intimité",
          "skip": "Passer",
          "previous": "Précédent",
          "next": "Suivant",
          "start": "Commencer",
          "app_version": "Chat Mate",

          "welcome_back": "Bon retour",
          "login_subtitle": "Veuillez vous connecter à votre compte",
          "email": "Email",
          "phone": "Téléphone",
          "phone_number": "Numéro de téléphone",
          "password": "Mot de passe",
          "forgot_password": "Mot de passe oublié ?",
          "login": "Se connecter",
          "or": "OU",
          "dont_have_account": "Vous n'avez pas de compte ?",
          "sign_up": "S'inscrire",
          "email_required": "L'email est requis",
          "email_invalid": "Veuillez entrer un email valide",
          "phone_required": "Le numéro de téléphone est requis",
          "phone_invalid": "Veuillez entrer un numéro de téléphone valide",
          "password_required": "Le mot de passe est requis",
          "password_too_short": "Le mot de passe doit contenir au moins 6 caractères",
        };
        
        break;
      case 'ar':
        _localizedStrings = {
          "welcome_title": "مرحباً بك في Chat Mate",
          "welcome_subtitle": "التطبيق المثالي للأزواج المحبين",
          "welcome_description":
              "اكتشف عالماً جديداً من التواصل والحب مع شريك حياتك",
          "chat_title": "محادثات رومانسية",
          "chat_subtitle": "تواصل بطريقة مميزة",
          "chat_description":
              "استمتع بالمحادثات الخاصة والألعاب التفاعلية التي تقرب القلوب",
          "games_title": "ألعاب الحب",
          "games_subtitle": "العب واستمتع معاً",
          "games_description":
              "مجموعة من الألعاب الرومانسية التي تزيد من التفاهم والحميمية",
          "skip": "تخطي",
          "previous": "السابق",
          "next": "التالي",
          "start": "البدء",
          "app_version": "Chat Mate",

          "welcome_back": "مرحبا بعودتك",
          "login_subtitle": "يرجى تسجيل الدخول إلى حسابك",
          "email": "البريد الإلكتروني",
          "phone": "الهاتف",
          "phone_number": "رقم الهاتف",
          "password": "كلمة المرور",
          "forgot_password": "هل نسيت كلمة المرور؟",
          "login": "تسجيل الدخول",
          "or": "أو",
          "dont_have_account": "ليس لديك حساب؟",
          "sign_up": "سجل الآن",
          "email_required": "البريد الإلكتروني مطلوب",
          "email_invalid": "الرجاء إدخال بريد إلكتروني صالح",
          "phone_required": "رقم الهاتف مطلوب",
          "phone_invalid": "الرجاء إدخال رقم هاتف صالح",
          "password_required": "كلمة المرور مطلوبة",
          "password_too_short": "يجب أن تكون كلمة المرور 6 أحرف على الأقل",
        };
        break;
      default: // neutral
        _localizedStrings = {
          "welcome_title": "Chat Mate",
          "welcome_subtitle": "Connect & Love",
          "welcome_description":
              "Communication app for couples to connect and share love",
          "chat_title": "Chat",
          "chat_subtitle": "Talk together",
          "chat_description":
              "Private conversations and interactive games for couples",
          "games_title": "Games",
          "games_subtitle": "Play together",
          "games_description":
              "Fun romantic games to strengthen your relationship",
          "skip": "Skip",
          "previous": "Back",
          "next": "Next",
          "start": "Start",
          "app_version": "Chat Mate",

          "welcome_back": "Welcome Back",
          "login_subtitle": "Please login to your account",
          "email": "Email",
          "phone": "Phone",
          "phone_number": "Phone Number",
          "password": "Password",
          "forgot_password": "Forgot Password?",
          "login": "Login",
          "or": "OR",
          "dont_have_account": "Don't have an account?",
          "sign_up": "Sign Up",
          "email_required": "Email is required",
          "email_invalid": "Please enter a valid email",
          "phone_required": "Phone number is required",
          "phone_invalid": "Please enter a valid phone number",
          "password_required": "Password is required",
          "password_too_short": "Password must be at least 6 characters",
        };
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
