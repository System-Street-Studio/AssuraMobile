import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assura_mobile/main.dart';
import 'package:assura_mobile/services/auth_service.dart';
import 'package:assura_mobile/services/dashboard_service.dart';
import 'package:assura_mobile/services/asset_service.dart';
import 'package:assura_mobile/screens/splash_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App starts with SplashScreen smoke test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We wrap MyApp in Providers just like in main.dart to avoid ProviderNotFoundException
    await tester.pumpWidget(
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

    // Verify that the SplashScreen is present.
    expect(find.byType(SplashScreen), findsOneWidget);

    // SplashScreen has a 3-second timer. We need to wait for it to finish
    // or use pumpAndSettle to avoid "timers pending" error.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
