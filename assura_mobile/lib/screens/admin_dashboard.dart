import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../widgets/app_drawer.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevents default drawer icon
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(AppConstants.logoPath), // logo
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
      body: SingleChildScrollView(
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

            // Overview Cards
            _buildLargeCard('Total Users', '100', AppColors.primaryTeal),
            const SizedBox(height: 15),
            _buildLargeCard('Total Assets', '1000', AppColors.primaryOrange),

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

            // Division List
            _buildDivisionCard('Information Technology', '100', '100'),
            _buildDivisionCard('Admin', '100', '100'),
            _buildDivisionCard('Procurement', '100', '100'),
            _buildDivisionCard('HR', '100', '100'),
            _buildDivisionCard('Stores', '100', '100'),
            _buildDivisionCard(
                'Electronics and Microelectronics', '100', '100'),
            _buildDivisionCard('Industrial Services', '100', '100'),
            _buildDivisionCard('Communication Engineering', '100', '100'),
            _buildDivisionCard('Astronomy', '100', '100'),
            _buildDivisionCard('Space Applications', '100', '100'),
            _buildDivisionCard('Finance', '100', '100'),
            _buildDivisionCard('Procurement', '100', '100'),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // colored cards (Total Users, Total Assets)
  Widget _buildLargeCard(String title, String value, Color color) {
    return Container(
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
    );
  }

  // Division cards
  Widget _buildDivisionCard(String name, String assets, String value) {
    return Container(
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
