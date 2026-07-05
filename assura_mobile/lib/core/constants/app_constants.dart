class AppConstants {
  // App Strings
  static const String appName = 'Assura';
  static const String loginSubtitle = 'log into the system';
  static const String usernameHint = 'Username';
  static const String passwordHint = 'Password';
  static const String loginButtonText = 'Login';
  static const String forgotPasswordText = 'Forgot Password';

  // API Endpoints (Placeholders)
  static const String apiBaseUrl =
      'http://10.217.189.91:5000'; // Physical device hotspot IP
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
