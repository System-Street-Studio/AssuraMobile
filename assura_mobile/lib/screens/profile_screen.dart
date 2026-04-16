import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditMode = false;

  final TextEditingController _usernameController =
      TextEditingController(text: 'david_emmit');
  final TextEditingController _firstNameController =
      TextEditingController(text: 'David');
  final TextEditingController _lastNameController =
      TextEditingController(text: 'Emmit');
  final TextEditingController _passwordController =
      TextEditingController(text: 'password123');
  final TextEditingController _emailController =
      TextEditingController(text: 'david.emmit@systemstreet.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+94 77 123 4567');

  final String _role = 'Admin';
  final String _division = 'Information Technology';

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                'User Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),

              // Profile Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    // Avatar and Edit Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primaryBlue,
                          child:
                              Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isEditMode = !isEditMode;
                            });
                          },
                          icon: Icon(
                            isEditMode ? Icons.close : Icons.edit,
                            color: AppColors.primaryBlue,
                            size: 28,
                          ),
                          tooltip: isEditMode ? 'Cancel' : 'Edit Profile',
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    _buildField('Username', _usernameController,
                        editable: true),
                    const SizedBox(height: 15),

                    _buildField('First Name', _firstNameController,
                        editable: true),
                    const SizedBox(height: 15),

                    _buildField('Last Name', _lastNameController,
                        editable: true),
                    const SizedBox(height: 15),

                    _buildField('Password', _passwordController,
                        editable: true, isPassword: true),
                    const SizedBox(height: 15),

                    _buildField('Email Address', _emailController,
                        editable: true),
                    const SizedBox(height: 15),

                    _buildStaticField('User Role(s)', _role),
                    const SizedBox(height: 15),

                    _buildStaticField('Working Division', _division),
                    const SizedBox(height: 15),

                    _buildField('Telephone Number', _phoneController,
                        editable: true),
                    const SizedBox(height: 40),

                    if (isEditMode)
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement save logic
                          setState(() {
                            isEditMode = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Profile updated successfully!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Save Changes',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      {bool editable = false, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 6),
        if (isEditMode && editable)
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0F0F0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isPassword ? '••••••••' : controller.text,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
      ],
    );
  }

  Widget _buildStaticField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 15, color: Colors.black54), // Grey text for read-only
          ),
        ),
      ],
    );
  }
}
