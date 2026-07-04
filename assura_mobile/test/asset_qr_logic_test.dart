import 'package:flutter_test/flutter_test.dart';

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

// Mocking the QR Parsing logic that would normally be in your service
class QrParserService {
  static String extractAssetCode(String qrData) {
    // Assuming the QR code is formatted as a URL or JSON string
    // e.g., "ASSURA-QR:AST-001"
    if (qrData.startsWith('ASSURA-QR:')) {
      return qrData.split(':')[1];
    }
    return '';
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

    test('QR Code Parsing: Should return empty string for invalid QR format', () {
      // 1. Arrange
      const invalidQrString = 'RANDOM_TEXT_NOT_ASSURA';

      // 2. Act
      final extractedCode = QrParserService.extractAssetCode(invalidQrString);

      // 3. Assert
      expect(extractedCode, '');
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
