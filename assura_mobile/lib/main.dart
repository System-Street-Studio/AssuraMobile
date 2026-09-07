import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/dashboard_service.dart';
import 'services/asset_service.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'screens/splash_screen.dart';
import 'widgets/network_connectivity_wrapper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, DashboardService>(
          create: (context) => DashboardService(
            Provider.of<AuthService>(context, listen: false),
          ),
          update: (context, auth, previous) =>
              previous ?? DashboardService(auth),
        ),
        ChangeNotifierProxyProvider<AuthService, AssetService>(
          create: (context) => AssetService(
            Provider.of<AuthService>(context, listen: false),
          ),
          update: (context, auth, previous) => previous ?? AssetService(auth),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return NetworkConnectivityWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const SplashScreen(),
    );
  }
}
