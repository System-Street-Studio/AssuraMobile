class DashboardStatsModel {
  final int totalAssets;
  final int totalUsers;
  final List<StatItemModel> assetsByDivision;
  final List<StatItemModel> assetsByStatus;
  final List<StatItemModel> assetsByCategory;

  DashboardStatsModel({
    required this.totalAssets,
    required this.totalUsers,
    required this.assetsByDivision,
    required this.assetsByStatus,
    required this.assetsByCategory,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalAssets: _toInt(json['totalAssets']),
      totalUsers: _toInt(json['totalUsers']),
      assetsByDivision: _toList(json['assetsByDivision']),
      assetsByStatus: _toList(json['assetsByStatus']),
      assetsByCategory: _toList(json['assetsByCategory']),
    );
  }

  static List<StatItemModel> _toList(dynamic list) {
    if (list is List) {
      return list.map((i) => StatItemModel.fromJson(i)).toList();
    }
    return [];
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value == null) return 0;
    return int.tryParse(value.toString()) ?? 0;
  }
}

class StatItemModel {
  final String label;
  final int count;
  final double value;

  StatItemModel({
    required this.label,
    required this.count,
    required this.value,
  });

  factory StatItemModel.fromJson(Map<String, dynamic> json) {
    return StatItemModel(
      label: json['label']?.toString() ?? '',
      count: _toInt(json['count']),
      value: _toDouble(json['value']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value == null) return 0;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
