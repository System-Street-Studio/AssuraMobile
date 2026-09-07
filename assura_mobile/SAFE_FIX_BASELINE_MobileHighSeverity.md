# SAFE_FIX_BASELINE_MobileHighSeverity

Baseline captured before fixing the two High-severity bugs found by `/test-mobile-app`
(2026-08-17): the QR-scan format mismatch and the Android-only `apiBaseUrl`.

## Blast radius identified

- Bug 1 (QR parsing): `lib/services/qr_service.dart` (empty), `lib/screens/scanner_screen.dart`,
  `lib/screens/admin_dashboard.dart` (`_startScan`, sole caller of `AssetService.getAssetByCode`
  and sole user of `ScannerScreen`), `test/asset_qr_logic_test.dart` (mocked the intended
  parser instead of testing production code).
- Bug 2 (`apiBaseUrl`): `lib/core/constants/app_constants.dart`, and every reader of the
  constant — `lib/services/api_service.dart` (used it as a **compile-time-const default
  parameter**, which breaks once the constant becomes platform-aware), `auth_service.dart`
  (x2), `asset_service.dart` (x2), `dashboard_service.dart`. Also `start_ngrok.ps1`, an
  existing dev script that text-replaces the constant for ngrok/real-device testing.

## Before (baseline)

- `flutter analyze`: 7 issues — 4 unused-import warnings (`admin_dashboard.dart`,
  `forgot_password_screen.dart`, `login_screen.dart`, `reset_password_screen.dart`), 3
  `prefer_const_*` info hints in `admin_dashboard.dart`. All pre-existing, unrelated to
  either bug.
- `flutter test`: 9/9 passing (`asset_qr_logic_test.dart` x3, `mobile_login_role_gate_test.dart`
  x5, `widget_test.dart` x1).
- Live: `AppConstants.apiBaseUrl` == `http://10.0.2.2:5000` unconditionally — verified via
  `dart:io Platform`/`kIsWeb` code trace that this only resolves on the Android emulator.
- Live: QR scan matched the raw scanned barcode string directly against `AssetModel.assetCode`
  with no parsing step — `test/asset_qr_logic_test.dart`'s `QrParserService` (expecting an
  `ASSURA-QR:<code>` prefix) existed only inside the test file, never in `lib/`.

## After (post-fix)

- `flutter analyze`: still 7 issues, same 4 categories, same files — no new issues introduced.
- `flutter test`: 12/12 passing (9 baseline + 3 new: 1 replaced QR-fallback test, 2 new
  `AppConstants.apiBaseUrl`/`ApiService` tests).
- Live: started the real backend (`dotnet run --project src/Assura.API`, seeded `admin` /
  `Password@123`) and ran a one-off `flutter test` script (removed after use) confirming
  `AppConstants.apiBaseUrl` now resolves to `http://localhost:5000` on this (non-Android)
  platform and a real `POST /api/Auth/login` through it returns `200`.

## Comparison

| Check | Before | After | Result |
|---|---|---|---|
| `flutter analyze` issue count/kind | 7 (cosmetic, pre-existing) | 7 (same) | Unaffected |
| `flutter test` suite | 9/9 pass | 12/12 pass | Fixed (3 new), no regressions |
| `apiBaseUrl` reachable from non-Android test process | No (`10.0.2.2` unreachable) | Yes (`localhost:5000`, live `200`) | Fixed |
| QR scan handles `ASSURA-QR:<code>` labels | No (matched raw string) | Yes (parsed, tested) | Fixed |
| QR scan still handles bare-code labels (no prefix) | Yes (was the only case it handled) | Yes (explicit fallback, tested) | Unaffected |
| `ApiService()` default-baseUrl construction compiles | Yes (required const) | Yes (now via `??` at runtime) | Unaffected |
| `start_ngrok.ps1` override mechanism | Rewrites `apiBaseUrl` literal | Rewrites `apiBaseUrlOverride` literal | Preserved, updated in step |

No Pass → Fail regressions found.
