import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../widgets/app_drawer.dart';
import '../services/dashboard_service.dart';
import 'asset_management_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late NumberFormat _currencyFormat;

  @override
  void initState() {
    super.initState();
    _currencyFormat = NumberFormat.currency(
      symbol: 'Rs. ',
      decimalDigits: 0,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardService>(context, listen: false)
          .fetchDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardService = Provider.of<DashboardService>(context);
    final stats = dashboardService.stats;
    final isLoading = dashboardService.isLoading;
    final error = dashboardService.error;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(AppConstants.logoPath),
        ),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu,
                  color: AppColors.primaryBlue, size: 30),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => dashboardService.fetchDashboardStats(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (isLoading && stats == null)
                const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (error != null && stats == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      children: [
                        Text('Error: $error',
                            style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () =>
                              dashboardService.fetchDashboardStats(),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (stats != null) ...[
                _buildLargeCard(context, 'Total Users', '${stats.totalUsers}',
                    AppColors.primaryTeal),
                const SizedBox(height: 15),
                _buildLargeCard(context, 'Total Assets', '${stats.totalAssets}',
                    AppColors.primaryOrange),
                const SizedBox(height: 30),
                const Text(
                  'Division',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                if (stats.assetsByDivision.isEmpty)
                  const Center(child: Text('No division data available.'))
                else
                  ...stats.assetsByDivision.map((item) {
                    final formattedValue = _currencyFormat.format(item.value);
                    return _buildDivisionCard(
                      context,
                      item.label,
                      '${item.count}',
                      formattedValue,
                    );
                  }).toList(),
              ] else if (!isLoading)
                const Center(child: Text('No data found.')),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeCard(
      BuildContext context, String title, String value, Color color) {
    return GestureDetector(
      onTap: () {
        if (title == 'Total Assets') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AssetManagementScreen()),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivisionCard(
      BuildContext context, String name, String assets, String value) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AssetManagementScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.5), width: 1.5),
        ),
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Assets', assets),
                _buildStatItem('Total Value', value),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String val) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Text(
          val,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
