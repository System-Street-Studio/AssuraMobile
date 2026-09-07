import 'package:flutter_test/flutter_test.dart';
import 'package:assura_mobile/core/constants/app_constants.dart';
import 'package:assura_mobile/services/api_service.dart';

// Covers the BUGS.md finding: apiBaseUrl was hardcoded to the
// Android-emulator-only loopback alias (10.0.2.2), so any non-Android target
// (this test's own VM included, plus Flutter web/desktop/iOS simulator)
// could never reach a locally-run backend.
void main() {
  group('AppConstants.apiBaseUrl', () {
    test('resolves to localhost on non-Android platforms', () {
      // flutter test itself runs on the host VM, not an Android emulator, so
      // this reproduces the exact environment the original bug broke.
      expect(AppConstants.apiBaseUrl, 'http://localhost:5000');
    });

    test('ApiService picks up the resolved default when no baseUrl is given',
        () {
      final service = ApiService();
      expect(service.baseUrl, AppConstants.apiBaseUrl);
    });

    test('ApiService still accepts an explicit baseUrl override', () {
      final service = ApiService(baseUrl: 'https://example.test');
      expect(service.baseUrl, 'https://example.test');
    });
  });
}
