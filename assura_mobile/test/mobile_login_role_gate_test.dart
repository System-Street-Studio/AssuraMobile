import 'package:flutter_test/flutter_test.dart';
import 'package:assura_mobile/services/auth_service.dart';

// Covers the BUGS.md Storekeeper finding: "Mobile app locks Storekeeper out
// entirely." The login gate previously only allowed the `Admin` role (or a
// division literally named "admin"), rejecting every Storekeeper account.
void main() {
  group('Mobile App - Login role gate', () {
    test('allows Admin role', () {
      expect(isRoleAuthorized(['Admin']), isTrue);
    });

    test('allows Storekeeper role', () {
      expect(isRoleAuthorized(['Storekeeper']), isTrue);
    });

    test('rejects other roles such as Employee', () {
      expect(isRoleAuthorized(['Employee']), isFalse);
    });

    test('rejects empty role list', () {
      expect(isRoleAuthorized([]), isFalse);
    });
  });
}
