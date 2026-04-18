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
      assetsByDivision: (json['assetsByDivision'] as List?)
              ?.map((i) => StatItemModel.fromJson(i))
              .toList() ??
          [],
      assetsByStatus: (json['assetsByStatus'] as List?)
              ?.map((i) => StatItemModel.fromJson(i))
              .toList() ??
          [],
      assetsByCategory: (json['assetsByCategory'] as List?)
              ?.map((i) => StatItemModel.fromJson(i))
              .toList() ??
          [],
    );
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

  StatItemModel({
    required this.label,
    required this.count,
  });

  factory StatItemModel.fromJson(Map<String, dynamic> json) {
    return StatItemModel(
      label: json['label']?.toString() ?? '',
      count: json['count'] is int
          ? json['count']
          : int.tryParse(json['count']?.toString() ?? '0') ?? 0,
    );
  }
}
