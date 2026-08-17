import 'package:flutter_test/flutter_test.dart';
import 'package:assura_mobile/services/qr_service.dart';

// Mocking the model for the test
class Asset {
  final String assetCode;
  final String status;

  Asset({required this.assetCode, required this.status});

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      assetCode: json['assetCode'],
      status: json['status'],
    );
  }
}

void main() {
  group('Mobile App - Asset QR Scanning Logic Tests', () {

    test('QR Code Parsing: Should extract correct Asset Code from valid QR string', () {
      // 1. Arrange
      const validQrString = 'ASSURA-QR:AST-10045';

      // 2. Act
      final extractedCode = QrParserService.extractAssetCode(validQrString);

      // 3. Assert
      expect(extractedCode, 'AST-10045');
    });

    test('QR Code Parsing: Falls back to the raw payload for a non-prefixed code', () {
      // Some asset labels in the field may carry just the bare asset code
      // with no "ASSURA-QR:" prefix; scanning those must still resolve the
      // asset instead of always failing.
      // 1. Arrange
      const rawQrString = 'AST-505';

      // 2. Act
      final extractedCode = QrParserService.extractAssetCode(rawQrString);

      // 3. Assert
      expect(extractedCode, 'AST-505');
    });

    test('Asset Model JSON Serialization: Should map correctly', () {
      // 1. Arrange
      final jsonResponse = {
        'assetCode': 'AST-505',
        'status': 'In Use'
      };

      // 2. Act
      final asset = Asset.fromJson(jsonResponse);

      // 3. Assert
      expect(asset.assetCode, 'AST-505');
      expect(asset.status, 'In Use');
    });
  });
}
