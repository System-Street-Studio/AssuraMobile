import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../widgets/app_drawer.dart';
import '../core/models/asset_model.dart';
import '../services/asset_service.dart';
import 'package:intl/intl.dart';

class AssetDetailsScreen extends StatefulWidget {
  final AssetModel asset;
  const AssetDetailsScreen({super.key, required this.asset});

  @override
  State<AssetDetailsScreen> createState() => _AssetDetailsScreenState();
}

class _AssetDetailsScreenState extends State<AssetDetailsScreen> {
  late String selectedStatus;
  final List<String> statuses = [
    'InUse',
    'InStore',
    'UnderMaintenance',
    'Discarded',
    'Transferred',
    'Lost'
  ];
  bool isUpdating = false;
  bool isVerifying = false;
  bool? justVerified;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.asset.statusText;
  }

  Future<void> _confirmVerified() async {
    setState(() {
      isVerifying = true;
    });

    final success = await Provider.of<AssetService>(context, listen: false)
        .verifyAsset(widget.asset.id);

    if (mounted) {
      setState(() {
        isVerifying = false;
        if (success) justVerified = true;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asset confirmed verified.')),
        );
      } else {
        final error = Provider.of<AssetService>(context, listen: false).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to confirm verification: $error')),
        );
      }
    }
  }

  Future<void> _updateStatus() async {
    if (selectedStatus == widget.asset.statusText) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      isUpdating = true;
    });

    final success = await Provider.of<AssetService>(context, listen: false)
        .updateAssetStatus(widget.asset, selectedStatus);

    if (mounted) {
      setState(() {
        isUpdating = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asset status updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        final error = Provider.of<AssetService>(context, listen: false).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.asset.productName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _buildDetailField('Asset Code', widget.asset.assetCode),
                  const SizedBox(height: 15),
                  _buildDetailField('Category', widget.asset.categoryName),
                  const SizedBox(height: 15),
                  _buildDetailField('Current User',
                      widget.asset.assignedUserName ?? 'Unassigned'),
                  const SizedBox(height: 15),
                  _buildDetailField('Division', widget.asset.divisionName),
                  const SizedBox(height: 15),
                  _buildDetailField(
                      'Purchase Value',
                      NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 2)
                          .format(widget.asset.purchaseValue)),
                  const SizedBox(height: 25),
                  _buildVerificationSection(),
                  const SizedBox(height: 25),
                  const Text(
                    "Doesn't match what you see? Update the status below.",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  _buildStatusDropdown(),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: isUpdating ? null : _updateStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAC0000), // Dark red
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isUpdating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Update',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9).withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationSection() {
    final verifiedAt = widget.asset.lastVerifiedAt;
    final verifiedBy = widget.asset.lastVerifiedByName;
    final showAsVerified = justVerified == true || verifiedAt != null;

    final statusLine = justVerified == true
        ? 'Verified just now'
        : verifiedAt != null
            ? 'Last verified ${DateFormat('MMM d, yyyy').format(verifiedAt)}'
                '${verifiedBy != null ? ' by $verifiedBy' : ''}'
            : 'Never verified';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verification',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9).withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                showAsVerified ? Icons.check_circle : Icons.help_outline,
                color: showAsVerified ? Colors.green : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  statusLine,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isVerifying ? null : _confirmVerified,
            icon: isVerifying
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(isVerifying ? 'Confirming...' : 'Confirm Verified'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green.shade700,
              side: BorderSide(color: Colors.green.shade700),
              minimumSize: const Size(120, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Status',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9).withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: statuses.contains(selectedStatus) ? selectedStatus : null,
              hint: const Text('Select Status'),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              onChanged: isUpdating
                  ? null
                  : (String? newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                      });
                    },
              items: statuses.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: const TextStyle(color: Colors.black87)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
