/// Parses the payload scanned off an asset's QR label.
///
/// Asset QR labels are generated as "ASSURA-QR:<assetCode>". If a scanned
/// payload doesn't carry that prefix, it's treated as a bare asset code
/// instead of rejected outright — some labels in the field may have been
/// printed as just the raw code, and failing those unconditionally would be
/// worse than accepting them.
class QrParserService {
  static const String _prefix = 'ASSURA-QR:';

  static String extractAssetCode(String qrData) {
    final trimmed = qrData.trim();
    if (trimmed.startsWith(_prefix)) {
      return trimmed.substring(_prefix.length);
    }
    return trimmed;
  }
}
