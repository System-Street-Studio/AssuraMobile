import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../widgets/app_drawer.dart';
import '../services/asset_service.dart';
import '../core/models/asset_model.dart';
import 'scanner_screen.dart';
import 'asset_details_screen.dart';

class AssetManagementScreen extends StatefulWidget {
  const AssetManagementScreen({super.key});

  @override
  State<AssetManagementScreen> createState() => _AssetManagementScreenState();
}

class _AssetManagementScreenState extends State<AssetManagementScreen> {
  String selectedDivision = 'All';
  String selectedStatus = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetService>(context, listen: false).fetchAssets();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get divisions {
    final assetService = Provider.of<AssetService>(context, listen: false);
    final divs =
        assetService.assets.map((a) => a.divisionName).toSet().toList();
    divs.removeWhere((element) => element == 'N/A' || element.isEmpty);
    divs.sort();
    return ['All', ...divs];
  }

  List<String> get statuses {
    return [
      'All',
      'Active',
      'Repair',
      'Discarded',
      'Transferred',
      'Missing',
      'UnderMaintenance',
      'InUse'
    ];
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          final divs = divisions;
          // Ensure selectedDivision is still valid if divs list changed
          if (!divs.contains(selectedDivision)) {
            selectedDivision = 'All';
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Assets',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text('By Division',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                DropdownButton<String>(
                  value: selectedDivision,
                  isExpanded: true,
                  items: divs.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setModalState(() {
                      selectedDivision = newValue!;
                    });
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
                const Text('By Status',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                DropdownButton<String>(
                  value: selectedStatus,
                  isExpanded: true,
                  items: statuses.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setModalState(() {
                      selectedStatus = newValue!;
                    });
                    setState(() {});
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Apply Filters',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        });
      },
    );
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
          // Refresh list if status was updated
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
    final assetService = Provider.of<AssetService>(context);
    final assets = assetService.assets;
    final isLoading = assetService.isLoading;
    final error = assetService.error;

    final filteredAssets = assets.where((asset) {
      final matchDivision =
          selectedDivision == 'All' || asset.divisionName == selectedDivision;
      final matchStatus =
          selectedStatus == 'All' || asset.statusText == selectedStatus;
      final matchSearch = searchQuery.isEmpty ||
          asset.productName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          asset.assetCode.toLowerCase().contains(searchQuery.toLowerCase());
      return matchDivision && matchStatus && matchSearch;
    }).toList();

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
      body: RefreshIndicator(
        onRefresh: () => assetService.fetchAssets(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search by Name or Code',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon:
                                Icon(Icons.search, color: Colors.black54),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Filter Button
                      GestureDetector(
                        onTap: _showFilterBottomSheet,
                        child: Container(
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
                      if (isLoading && assets.isEmpty)
                        const Center(child: CircularProgressIndicator())
                      else if (error != null && assets.isEmpty)
                        Center(child: Text('Error: $error'))
                      else if (filteredAssets.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text('No assets found',
                              style: TextStyle(color: Colors.grey)),
                        )
                      else
                        ...filteredAssets.map((asset) {
                          return _buildAssetRow(
                            context,
                            asset,
                          );
                        }).toList(),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),

                // Pagination (Simplified for now)
                const SizedBox(height: 20),

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
                        onPressed: _startScan,
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
      ),
    );
  }

  Color _getBgColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFFE8F5E9);
      case 'Repair':
        return const Color(0xFFFFF3E0);
      case 'Discarded':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFE3F2FD);
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Repair':
        return Colors.orange;
      case 'Discarded':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildAssetRow(BuildContext context, AssetModel asset) {
    final name = asset.productName;
    final status = asset.statusText;
    final bgColor = _getBgColor(status);
    final textColor = _getTextColor(status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssetDetailsScreen(asset: asset),
                ),
              );
            },
            child: Text(
              name,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
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
