class AssetModel {
  final int id;
  final String assetCode;
  final String? assetTag;
  final DateTime assetDate;
  final int
      status; // AssetStatus enum from backend (0: Active, 1: Repair, etc.)
  final String? serialNumber;
  final double purchaseValue;
  final String? warranty;
  final String? notes;
  final String? qrCode;
  final int categoryId;
  final String categoryName;
  final int divisionId;
  final String divisionName;
  final int productId;
  final String productName;
  final int supplierId;
  final String supplierName;
  final int? assignedUserId;
  final String? assignedUserName;

  AssetModel({
    required this.id,
    required this.assetCode,
    this.assetTag,
    required this.assetDate,
    required this.status,
    this.serialNumber,
    required this.purchaseValue,
    this.warranty,
    this.notes,
    this.qrCode,
    required this.categoryId,
    required this.categoryName,
    required this.divisionId,
    required this.divisionName,
    required this.productId,
    required this.productName,
    required this.supplierId,
    required this.supplierName,
    this.assignedUserId,
    this.assignedUserName,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] ?? 0,
      assetCode: json['assetCode'] ?? '',
      assetTag: json['assetTag'],
      assetDate:
          DateTime.parse(json['assetDate'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 0,
      serialNumber: json['serialNumber'],
      purchaseValue: (json['purchaseValue'] ?? 0).toDouble(),
      warranty: json['warranty'],
      notes: json['notes'],
      qrCode: json['qrCode'],
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName'] ?? 'N/A',
      divisionId: json['divisionId'] ?? 0,
      divisionName: json['divisionName'] ?? 'N/A',
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? 'N/A',
      supplierId: json['supplierId'] ?? 0,
      supplierName: json['supplierName'] ?? 'N/A',
      assignedUserId: json['assignedUserId'],
      assignedUserName: json['assignedUserName'],
    );
  }

  String get statusText {
    switch (status) {
      case 0:
        return 'Active';
      case 1:
        return 'Repair';
      case 2:
        return 'Discarded';
      case 3:
        return 'Transferred';
      case 4:
        return 'Missing';
      default:
        return 'Unknown';
    }
  }
}
