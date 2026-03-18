import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              left: -95,
              top: -144,
              child: Container(
                width: 300,
                height: 300,
                decoration: const ShapeDecoration(
                  color: AppColors.primaryBlue,
                  shape: OvalBorder(),
                ),
              ),
            ),
            Positioned(
              right: -76,
              bottom: -122,
              child: Container(
                width: 300,
                height: 300,
                decoration: const ShapeDecoration(
                  color: AppColors.primaryOrange,
                  shape: OvalBorder(),
                ),
              ),
            ),

            // Login Card
            Center(
              child: Container(
                width: 304,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      AppConstants.appName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      AppConstants.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Username Field
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline,
                            size: 20, color: AppColors.textGrey),
                        hintText: AppConstants.usernameHint,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline,
                            size: 20, color: AppColors.textGrey),
                        hintText: AppConstants.passwordHint,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text(
                          AppConstants.forgotPasswordText,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement Login Logic
                        },
                        child: const Text(AppConstants.loginButtonText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
