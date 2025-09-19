import 'package:chat_mate/Screens/Auth/Otp.dart';
import 'package:chat_mate/Translation/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  final String languageCode;

  const SignUpScreen({Key? key, required this.languageCode}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedGender = 'male';
  DateTime? _selectedDate;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isEmailValid = false;
  bool _isCheckingEmail = false;
  late AppLocalizations localizations;

  @override
  void initState() {
    super.initState();
    localizations = AppLocalizations(widget.languageCode);

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();

    // Add email validation listener
    _emailController.addListener(_checkEmailValidity);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkEmailValidity() async {
    final email = _emailController.text;
    if (email.isNotEmpty && _isValidEmailFormat(email)) {
      setState(() => _isCheckingEmail = true);

      // Simulate email validation API call
      await Future.delayed(Duration(seconds: 1));

      // Mock validation - in real app, you'd call an API
      final isValid = !email.contains('fake') && email.contains('@');

      setState(() {
        _isCheckingEmail = false;
        _isEmailValid = isValid;
      });
    } else {
      setState(() {
        _isEmailValid = false;
        _isCheckingEmail = false;
      });
    }
  }

  bool _isValidEmailFormat(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
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
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),

                      // Back button
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 30),

                      // Title
                      Text(
                        localizations.translate('create_account'),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 8),

                      Text(
                        localizations.translate('signup_subtitle'),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 30),

                      // Name fields
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              controller: _firstNameController,
                              label: localizations.translate('first_name'),
                              icon: Icons.person,
                              validator: (value) => value?.isEmpty == true
                                  ? localizations.translate(
                                      'first_name_required',
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: _buildInputField(
                              controller: _lastNameController,
                              label: localizations.translate('last_name'),
                              icon: Icons.person_outline,
                              validator: (value) => value?.isEmpty == true
                                  ? localizations.translate(
                                      'last_name_required',
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Gender selection
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.translate('gender'),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(
                                        () => _selectedGender = 'male',
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _selectedGender == 'male'
                                              ? Colors.white.withOpacity(0.3)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.male,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              localizations.translate('male'),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(
                                        () => _selectedGender = 'female',
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _selectedGender == 'female'
                                              ? Colors.white.withOpacity(0.3)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.female,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              localizations.translate('female'),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Birthdate
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              SizedBox(width: 15),
                              Text(
                                _selectedDate == null
                                    ? localizations.translate('birth_date')
                                    : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Email input with validation indicator
                      _buildEmailField(),

                      SizedBox(height: 20),

                      // Phone input
                      _buildInputField(
                        controller: _phoneController,
                        label: localizations.translate('phone_number'),
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                      ),

                      SizedBox(height: 20),

                      // Password input
                      _buildInputField(
                        controller: _passwordController,
                        label: localizations.translate('password'),
                        icon: Icons.lock,
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        validator: _validatePassword,
                      ),

                      SizedBox(height: 20),

                      // Confirm password input
                      _buildInputField(
                        controller: _confirmPasswordController,
                        label: localizations.translate('confirm_password'),
                        icon: Icons.lock_outline,
                        obscureText: !_isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        validator: _validateConfirmPassword,
                      ),

                      SizedBox(height: 30),

                      // Sign up button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignUp,
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
                                      Color(0xFFE91E63),
                                    ),
                                  ),
                                )
                              : Text(
                                  localizations.translate('sign_up'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            localizations.translate('already_have_account'),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              localizations.translate('login'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: _validateEmail,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: localizations.translate('email'),
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
          prefixIcon: Icon(Icons.email, color: Colors.white.withOpacity(0.7)),
          suffixIcon: _buildEmailValidationIcon(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildEmailValidationIcon() {
    if (_isCheckingEmail) {
      return Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    if (_emailController.text.isNotEmpty &&
        _isValidEmailFormat(_emailController.text)) {
      return Icon(
        _isEmailValid ? Icons.check_circle : Icons.cancel,
        color: _isEmailValid ? Colors.green : Colors.red,
      );
    }

    return SizedBox.shrink();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFE91E63),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return localizations.translate('email_required');
    }
    if (!_isValidEmailFormat(value)) {
      return localizations.translate('email_invalid');
    }
    if (!_isEmailValid && _isValidEmailFormat(value)) {
      return localizations.translate('email_not_exist');
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return localizations.translate('phone_required');
    }
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value)) {
      return localizations.translate('phone_invalid');
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return localizations.translate('password_required');
    }
    if (value.length < 8) {
      return localizations.translate('password_too_short');
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return localizations.translate('password_weak');
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return localizations.translate('confirm_password_required');
    }
    if (value != _passwordController.text) {
      return localizations.translate('passwords_not_match');
    }
    return null;
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _isEmailValid) {
      setState(() => _isLoading = true);

      // Simulate registration process
      await Future.delayed(Duration(seconds: 2));

      setState(() => _isLoading = false);

      // Navigate to OTP verification
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            languageCode: widget.languageCode,
            contactInfo: _emailController.text,
            isEmail: true,
          ),
        ),
      );
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate('birth_date_required')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
