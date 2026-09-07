import 'package:flutter_test/flutter_test.dart';
import 'package:assura_mobile/services/auth_service.dart';

// Covers the BUGS.md Admin finding: the mobile app is Admin-only — its entire
// duty is scanning an asset's QR code and verifying/updating that asset's
// status. A previous change had also allowed Storekeeper into the app; that
// was reverted per explicit product clarification that only Admin accounts
// should be able to log in here.
void main() {
  group('Mobile App - Login role gate', () {
    test('allows Admin role', () {
      expect(isRoleAuthorized(['Admin']), isTrue);
    });

    test('rejects Storekeeper role', () {
      expect(isRoleAuthorized(['Storekeeper']), isFalse);
    });

    test('rejects SystemAdmin role', () {
      expect(isRoleAuthorized(['SystemAdmin']), isFalse);
    });

    test('rejects other roles such as Employee', () {
      expect(isRoleAuthorized(['Employee']), isFalse);
    });

    test('rejects empty role list', () {
      expect(isRoleAuthorized([]), isFalse);
    });
  });
}
