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
      totalAssets: json['totalAssets'] ?? 0,
      totalUsers: json['totalUsers'] ?? 0,
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
      label: json['label'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
