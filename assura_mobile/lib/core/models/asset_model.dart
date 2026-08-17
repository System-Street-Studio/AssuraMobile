class AssetModel {
  final int id;
  final String assetCode;
  final String? assetTag;
  final DateTime assetDate;
  final String status; // Status is sent as a String from backend
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
  final DateTime? lastVerifiedAt;
  final String? lastVerifiedByName;

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
    this.lastVerifiedAt,
    this.lastVerifiedByName,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      assetCode: json['assetCode'] ?? '',
      assetTag: json['assetTag'],
      assetDate:
          DateTime.parse(json['assetDate'] ?? DateTime.now().toIso8601String()),
      status: json['status']?.toString() ?? 'Active',
      serialNumber: json['serialNumber'],
      purchaseValue: json['purchaseValue'] is num
          ? (json['purchaseValue'] as num).toDouble()
          : double.tryParse(json['purchaseValue']?.toString() ?? '0') ?? 0.0,
      warranty: json['warranty'],
      notes: json['notes'],
      qrCode: json['qrCode'],
      categoryId: json['categoryId'] is int
          ? json['categoryId']
          : int.tryParse(json['categoryId']?.toString() ?? '0') ?? 0,
      categoryName: json['categoryName'] ?? 'N/A',
      divisionId: json['divisionId'] is int
          ? json['divisionId']
          : int.tryParse(json['divisionId']?.toString() ?? '0') ?? 0,
      divisionName: json['divisionName'] ?? 'N/A',
      productId: json['productId'] is int
          ? json['productId']
          : int.tryParse(json['productId']?.toString() ?? '0') ?? 0,
      productName: json['productName'] ?? 'N/A',
      supplierId: json['supplierId'] is int
          ? json['supplierId']
          : int.tryParse(json['supplierId']?.toString() ?? '0') ?? 0,
      supplierName: json['supplierName'] ?? 'N/A',
      assignedUserId: json['assignedUserId'] is int
          ? json['assignedUserId']
          : int.tryParse(json['assignedUserId']?.toString() ?? ''),
      assignedUserName: json['assignedUserName'],
      lastVerifiedAt: json['lastVerifiedAt'] != null
          ? DateTime.tryParse(json['lastVerifiedAt'].toString())
          : null,
      lastVerifiedByName: json['lastVerifiedByName'],
    );
  }

  String get statusText => status;
}
