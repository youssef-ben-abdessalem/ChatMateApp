import 'package:chat_mate/Helper/Helper.dart';
import 'package:chat_mate/Screens/Components/HomeScreen.dart';
import 'package:chat_mate/Translation/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class OTPVerificationScreen extends StatefulWidget {
  final String languageCode;
  final String contactInfo;
  final bool isEmail;

  const OTPVerificationScreen({
    Key? key,
    required this.languageCode,
    required this.contactInfo,
    required this.isEmail,
  }) : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  bool _isLoading = false;
  bool _isResending = false;
  int _countdown = 60;
  Timer? _timer;
  late AppLocalizations localizations;

  @override
  void initState() {
    super.initState();
    localizations = AppLocalizations(widget.languageCode);

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);
    _startCountdown();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _countdown = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
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
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value * 100),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    // Back button
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40),

                    // Animated icon
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
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
                              widget.isEmail ? Icons.email : Icons.sms,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 40),

                    // Title
                    Text(
                      localizations.translate('verify_code'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 15),

                    // Subtitle
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: widget.isEmail
                                ? localizations.translate('otp_sent_email')
                                : localizations.translate('otp_sent_phone'),
                          ),
                          TextSpan(
                            text: '\n${widget.contactInfo}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 50),

                    // OTP input fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) => _buildOTPField(index)),
                    ),

                    SizedBox(height: 30),

                    // Timer and resend
                    if (_countdown > 0)
                      Text(
                        '${localizations.translate('resend_in')} $_countdown ${localizations.translate('seconds')}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      )
                    else
                      TextButton(
                        onPressed: _isResending ? null : _resendOTP,
                        child: _isResending
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          localizations.translate('resend_code'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                    SizedBox(height: 40),

                    // Verify button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFFE91E63),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFE91E63)),
                          ),
                        )
                            : Text(
                          localizations.translate('verify'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Change contact info
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        widget.isEmail
                            ? localizations.translate('change_email')
                            : localizations.translate('change_phone'),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Help text
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: Colors.white.withOpacity(0.7),
                            size: 24,
                          ),
                          SizedBox(height: 10),
                          Text(
                            localizations.translate('otp_help'),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? Colors.white
              : Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 3) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              _focusNodes[index].unfocus();
              _verifyOTP();
            }
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
          setState(() {});
        },
      ),
    );
  }

  String _getOTPCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  bool _isOTPComplete() {
    return _getOTPCode().length == 4;
  }

  void _verifyOTP() async {
    if (!_isOTPComplete()) {
      _showErrorMessage(localizations.translate('enter_complete_otp'));
      return;
    }

    setState(() => _isLoading = true);

    // Simulate OTP verification
    await Future.delayed(Duration(seconds: 2));

    final otpCode = _getOTPCode();
    // Mock verification - in real app, you'd verify with backend
    final isValidOTP = otpCode == '1234'; // Demo OTP

    setState(() => _isLoading = false);

    if (isValidOTP) {
      _showSuccessMessage(localizations.translate('verification_successful'));

      // Navigate to home screen after a short delay
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(), /**languageCode: widget.languageCode**/
        ),
            (route) => false,
      );
    } else {
      _showErrorMessage(localizations.translate('invalid_otp'));
      _clearOTPFields();
    }
  }

  void _resendOTP() async {
    setState(() => _isResending = true);

    // Simulate resend request
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isResending = false);
    _startCountdown();
    _showSuccessMessage(localizations.translate('otp_resent'));
  }

  void _clearOTPFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}