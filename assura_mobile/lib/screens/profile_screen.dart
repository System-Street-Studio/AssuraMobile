import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../widgets/app_drawer.dart';
import '../services/auth_service.dart';
import '../core/models/user_profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEditMode = false;
  bool isLoading = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final profile = await authService.fetchUserProfile();
    if (profile != null && mounted) {
      setState(() {
        _usernameController.text = profile.username;
        _firstNameController.text = profile.firstName;
        _lastNameController.text = profile.lastName;
        _phoneController.text = profile.phoneNumber ?? '';
        isLoading = false;
      });
    } else if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    final currentProfile = authService.profile;
    if (currentProfile == null) return;

    setState(() {
      isLoading = true;
    });

    final updatedProfile = UserProfileModel(
      id: currentProfile.id,
      username: _usernameController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: currentProfile.email,
      role: currentProfile.role,
      divisionId: currentProfile.divisionId,
      divisionName: currentProfile.divisionName,
      phoneNumber: _phoneController.text,
    );

    final success = await authService.updateUserProfile(
      updatedProfile,
      password:
          _passwordController.text.isNotEmpty ? _passwordController.text : null,
    );

    if (mounted) {
      setState(() {
        isLoading = false;
        if (success) {
          isEditMode = false;
          _passwordController.clear();
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Profile updated successfully!'
              : 'Failed to update profile. Please try again.'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final profile = authService.profile;

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppColors.primaryBlue,
                                  child: Icon(Icons.person,
                                      size: 50, color: Colors.white),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${profile?.firstName ?? 'Assura'} ${profile?.lastName ?? 'Admin'}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryOrange,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          profile?.role ?? 'Admin',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (isEditMode) {
                                        _loadProfile();
                                        _passwordController.clear();
                                      }
                                      isEditMode = !isEditMode;
                                    });
                                  },
                                  icon: Icon(
                                    isEditMode ? Icons.close : Icons.edit,
                                    color: AppColors.primaryBlue,
                                    size: 28,
                                  ),
                                  tooltip:
                                      isEditMode ? 'Cancel' : 'Edit Profile',
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            _buildField('Username', _usernameController,
                                validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username is required';
                              }
                              if (value.length < 3) {
                                return 'Too short';
                              }
                              return null;
                            }),
                            const SizedBox(height: 15),
                            if (isEditMode) ...[
                              _buildField('First Name', _firstNameController,
                                  validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First name is required';
                                }
                                return null;
                              }),
                              const SizedBox(height: 15),
                              _buildField('Last Name', _lastNameController,
                                  validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Last name is required';
                                }
                                return null;
                              }),
                            ] else ...[
                              _buildStaticField('Full Name',
                                  '${profile?.firstName} ${profile?.lastName}'),
                            ],
                            const SizedBox(height: 15),
                            if (isEditMode)
                              _buildField('New Password (Optional)',
                                  _passwordController, isPassword: true,
                                  validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    value.length < 6) {
                                  return 'Min 6 characters';
                                }
                                return null;
                              }),
                            const SizedBox(height: 15),
                            _buildStaticField(
                                'Email Address', profile?.email ?? 'N/A'),
                            const SizedBox(height: 15),
                            _buildStaticField(
                                'User Role', profile?.role ?? 'Admin'),
                            const SizedBox(height: 15),
                            _buildStaticField('Working Division',
                                profile?.divisionName ?? 'N/A'),
                            const SizedBox(height: 15),
                            _buildField('Telephone Number', _phoneController,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is required';
                              }
                              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                return 'Enter a valid 10-digit number';
                              }
                              return null;
                            }),
                            const SizedBox(height: 40),
                            if (isEditMode)
                              ElevatedButton(
                                onPressed: isLoading ? null : _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text('Save Changes',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      {bool isPassword = false,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 6),
        if (isEditMode)
          TextFormField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0F0F0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.5),
              ),
              errorStyle: const TextStyle(height: 0.8),
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
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
