import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../widgets/app_drawer.dart';

class AssetManagementScreen extends StatelessWidget {
  const AssetManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
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
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Asset Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Search and Filter Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by Name',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: Colors.black54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Filter Button
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.filter_list, size: 20),
                          SizedBox(width: 5),
                          Text('Filter'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Table Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 40.0),
                          child: Text(
                            'Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 30.0),
                          child: Text(
                            'Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Asset Rows
                    _buildAssetRow('Dell XPS 15', 'Active',
                        const Color(0xFFD4F8D4), Colors.green),
                    _buildAssetRow('Macbook Air 14', 'Repair',
                        const Color(0xFFD4E3F8), Colors.blue),
                    _buildAssetRow('HP Printer', 'Discarded',
                        const Color(0xFFF8D4D4), Colors.red),

                    const SizedBox(
                        height: 120), // Height matching screenshot space
                  ],
                ),
              ),

              // Pagination
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('← Previous',
                        style: TextStyle(color: Colors.black54)),
                    const SizedBox(width: 20),
                    const Text('1',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 20),
                    const Text('2', style: TextStyle(color: Colors.black54)),
                    const SizedBox(width: 20),
                    const Text('3', style: TextStyle(color: Colors.black54)),
                    const SizedBox(width: 20),
                    const Text('Next →',
                        style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),

              const Text(
                'Track Assets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),

              // Track Assets Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Scan the QR code on the asset',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEBD192),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      child: const Text(
                        'Scan Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssetRow(
      String name, String status, Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: textColor, width: 0.5),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
