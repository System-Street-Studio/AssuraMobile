import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? initialEmail;
  const ResetPasswordScreen({super.key, this.initialEmail});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _controller;
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail ?? '';
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    _controller.repeat();

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.resetPassword(
        _emailController.text,
        _tokenController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        setState(() {
          _isSuccess = true;
        });
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Failed to reset password. Please check your token.')),
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
        title: const Text('New Password'),
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
                      child: _isSuccess
                          ? const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_outline,
                                    color: Colors.green, size: 60),
                                SizedBox(height: 24),
                                Text(
                                  'Success!',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Your password has been reset successfully. Redirecting to login...',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Set New Password',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Enter the token received in your email and choose a new password.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined,
                                        size: 20, color: AppColors.textGrey),
                                    hintText: 'Email Address',
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Required'
                                          : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _tokenController,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.vpn_key_outlined,
                                        size: 20, color: AppColors.textGrey),
                                    hintText: 'Reset Token',
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Required'
                                          : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.lock_outline,
                                        size: 20, color: AppColors.textGrey),
                                    hintText: 'New Password',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (value.length < 6) {
                                      return 'Password too short';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.lock_reset,
                                        size: 20, color: AppColors.textGrey),
                                    hintText: 'Confirm Password',
                                  ),
                                  validator: (value) {
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: _handleReset,
                                    child: const Text('Update Password',
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
                  child: Image.asset(AppConstants.logoPath,
                      width: 100, height: 100),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
