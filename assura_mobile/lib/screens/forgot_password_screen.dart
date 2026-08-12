import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late AnimationController _controller;
  bool _isLoading = false;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _successMessage = null;
    });
    _controller.repeat();

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.forgotPassword(_emailController.text);

      if (success && mounted) {
        setState(() {
          _successMessage =
              'If an account exists, a reset link has been sent to your email.';
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Something went wrong. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _controller.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Forgot Password', style: TextStyle(color: Color(0xFFF8FAFC), fontFamily: 'Jost')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFF8FAFC)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A), // Slate 900
              Color(0xFF1E293B), // Slate 800
            ],
          ),
        ),
        child: Stack(
          children: [
            if (!_isLoading) ...[
              // Abstract glowing orbs in background
              Positioned(
                left: -100,
                top: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF818CF8).withOpacity(0.15),
                        blurRadius: 50,
                        spreadRadius: 50,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: -100,
                bottom: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withOpacity(0.15),
                        blurRadius: 50,
                        spreadRadius: 50,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          width: 320,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 36),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B).withOpacity(0.6), // Glass background
                            border: Border.all(color: const Color(0xFF94A3B8).withOpacity(0.15)),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AppConstants.logoPath,
                                width: 80,
                                height: 80,
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Reset Password',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFF8FAFC), // Slate 50
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Jost',
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Enter your email address and we\'ll send you a link to reset your password.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF94A3B8), // Slate 400
                                  fontSize: 14,
                                  fontFamily: 'Jost',
                                ),
                              ),
                              const SizedBox(height: 32),
                          if (_successMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Text(
                                _successMessage!,
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Color(0xFFF8FAFC)), // Slate 50
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email_outlined,
                                  size: 20, color: Color(0xFF94A3B8)),
                              hintText: 'Email Address',
                              hintStyle: const TextStyle(color: Color(0xFF64748B)), // Slate 500
                              filled: true,
                              fillColor: const Color(0xFF0F172A).withOpacity(0.5), // Slate 900
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: const Color(0xFF94A3B8).withOpacity(0.2)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: const Color(0xFF94A3B8).withOpacity(0.2)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF818CF8)), // Indigo
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red, width: 1.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleReset,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4F46E5), // Solid indigo
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: const Color(0xFF4F46E5).withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Send Reset Link',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Jost')),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResetPasswordScreen(
                                    initialEmail: _emailController.text,
                                  ),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF818CF8)), // Indigo
                            child: const Text('Already have a token?', style: TextStyle(fontFamily: 'Jost')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
            if (_isLoading)
              Center(
                child: RotationTransition(
                  turns: _controller,
                  child: Image.asset(
                    AppConstants.logoPath,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
