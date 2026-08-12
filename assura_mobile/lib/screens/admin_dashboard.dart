import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../widgets/app_drawer.dart';
import '../services/dashboard_service.dart';
import '../services/asset_service.dart';
import '../services/auth_service.dart';
import 'scanner_screen.dart';
import 'asset_details_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardService>(context, listen: false)
          .fetchDashboardStats();
      Provider.of<AssetService>(context, listen: false).fetchAssets();
    });
  }

  void _startScan() async {
    final String? code = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (code != null && mounted) {
      final assetService = Provider.of<AssetService>(context, listen: false);
      final asset = assetService.getAssetByCode(code);

      if (asset != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssetDetailsScreen(asset: asset),
          ),
        ).then((_) {
          // Refresh data after returning
          if (!mounted) return;
          Provider.of<DashboardService>(context, listen: false).fetchDashboardStats();
          assetService.fetchAssets();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Asset with code "$code" not found'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardService = Provider.of<DashboardService>(context);
    final authService = Provider.of<AuthService>(context);
    
    final stats = dashboardService.stats;
    final isLoading = dashboardService.isLoading;
    final error = dashboardService.error;
    
    final isPendingUser = authService.profile?.divisionId == null;

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
      body: isPendingUser 
        ? Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 64,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Account Under Review',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your account is under review, wait for HR review.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          )
        : RefreshIndicator(
        onRefresh: () async {
          dashboardService.fetchDashboardStats();
          Provider.of<AssetService>(context, listen: false).fetchAssets();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            // Use the remaining screen height to center the content
            height: MediaQuery.of(context).size.height - kToolbarHeight - 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Assura Mobile',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                if (isLoading && stats == null)
                  const CircularProgressIndicator()
                else if (error != null && stats == null)
                  Column(
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
                  )
                else if (stats != null) ...[
                  _buildLargeCard(context, 'Total Assets', '${stats.totalAssets}',
                      AppColors.primaryOrange),
                  const SizedBox(height: 30),
                  
                  // Track Assets Card (Replaces the separate screen)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryRed.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Scan the QR code on the asset',
                          style: TextStyle(
                            fontFamily: 'Jost',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton.icon(
                          onPressed: _startScan,
                          icon: const Icon(Icons.qr_code_scanner, color: Colors.black, size: 22),
                          label: const Text(
                            'Scan Now',
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBeige,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                ] else if (!isLoading)
                  const Text('No data found.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeCard(
      BuildContext context, String title, String value, Color color) {
    return Container(
      width: double.infinity,
      height: 180, 
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Jost',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              const Icon(
                Icons.archive, 
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Jost',
                color: Colors.white,
                fontSize: 64, 
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
