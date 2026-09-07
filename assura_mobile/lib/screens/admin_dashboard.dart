import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../widgets/app_drawer.dart';
import '../services/dashboard_service.dart';
import '../services/asset_service.dart';
import '../services/auth_service.dart';
import '../services/qr_service.dart';
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
    final String? rawCode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (rawCode != null && mounted) {
      final code = QrParserService.extractAssetCode(rawCode);
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
    
    final isPendingUser = authService.isPendingUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate 900 background
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(AppConstants.logoPath), // Consider using a lighter logo if available
        ),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu,
                  color: Color(0xFFF8FAFC), size: 30),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
            ],
          ),
        ),
        child: isPendingUser 
        ? Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF94A3B8).withOpacity(0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF818CF8), // Indigo
                          size: 64,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Account Under Review',
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF8FAFC),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Your account is under review, wait for HR review.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontSize: 16,
                            color: Color(0xFFE2E8F0),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                  'Assura Dashboard',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF8FAFC),
                    letterSpacing: 0.5,
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
                  _buildLargeCard(
                      context, 
                      'Total Assets', 
                      '${stats.totalAssets}',
                      const Color(0xFF818CF8).withOpacity(0.15), // Tinted glass
                      const Color(0xFF818CF8), // Icon color
                  ),
                  const SizedBox(height: 30),
                  
                  // Track Assets Card (Glassmorphic Scan)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: const Color(0xFF94A3B8).withOpacity(0.15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                          child: Column(
                            children: [
                              const Text(
                                'Scan the QR code on the asset',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  color: Color(0xFFE2E8F0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 25),
                              ElevatedButton.icon(
                                onPressed: _startScan,
                                icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 22),
                                label: const Text(
                                  'Scan Now',
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F46E5), // Indigo solid
                                  elevation: 4,
                                  shadowColor: const Color(0xFF4F46E5).withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ] else if (!isLoading)
                  const Text('No data found.', style: TextStyle(color: Color(0xFF94A3B8))),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildLargeCard(
      BuildContext context, String title, String value, Color bgColor, Color iconColor) {
    return Container(
      width: double.infinity,
      height: 180, 
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.6), // Glass background
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF94A3B8).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Padding(
            padding: const EdgeInsets.all(30),
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
                          color: Color(0xFF94A3B8), // Slate 400
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                    Icon(
                      Icons.account_balance_wallet, // Changed from archive for aesthetics
                      color: iconColor,
                      size: 28,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Jost',
                      color: Color(0xFFF8FAFC), // Slate 50
                      fontSize: 64, 
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
