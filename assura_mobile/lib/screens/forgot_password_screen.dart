import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';

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
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryBlue,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            if (!_isLoading) ...[
              Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      width: 304,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      decoration: ShapeDecoration(
                        color: AppColors.cardBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(-4, 4),
                            spreadRadius: 0,
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
                              color: AppColors.primaryBlue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Enter your email address and we\'ll send you a link to reset your password.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
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
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined,
                                  size: 20, color: AppColors.textGrey),
                              hintText: 'Email Address',
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
                            height: 45,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleReset,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Send Reset Link',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
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
