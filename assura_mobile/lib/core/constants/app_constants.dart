import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  // App Strings
  static const String appName = 'Assura';
  static const String loginSubtitle = 'log into the system';
  static const String usernameHint = 'Username';
  static const String passwordHint = 'Password';
  static const String loginButtonText = 'Login';
  static const String forgotPasswordText = 'Forgot Password';

  // Manual override for real-device/tunnel testing (e.g. ngrok). Leave empty
  // to use the per-platform default below. start_ngrok.ps1 rewrites this
  // line directly, so keep the exact `= '...'` literal form.
  static const String apiBaseUrlOverride = '';

  // API Endpoints
  static String get apiBaseUrl {
    if (apiBaseUrlOverride.isNotEmpty) return apiBaseUrlOverride;
    // Only the Android emulator needs the special 10.0.2.2 alias to reach
    // the host's loopback; web, desktop, and iOS simulator targets share the
    // host's own localhost directly.
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:5000';
    return 'http://localhost:5000';
  }

  static const String healthEndpoint = '/health';
  static const String loginEndpoint = '/api/Auth/login';
  static const String profileEndpoint = '/api/User/profile';
  static const String dashboardStatsEndpoint = '/api/Admin/dashboard-stats';
  static const String forgotPasswordEndpoint = '/api/Auth/forgot-password';
  static const String resetPasswordEndpoint = '/api/Auth/reset-password';

  // Assets
  static const String logoPath = 'assets/images/LOGO2.png';
  static const String fontJost = 'Jost';
}
