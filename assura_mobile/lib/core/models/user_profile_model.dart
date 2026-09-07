class UserProfileModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final int? divisionId;
  final String? divisionName;
  final String? phoneNumber;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.divisionId,
    this.divisionName,
    this.phoneNumber,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'User',
      divisionId: json['divisionId'] is int
          ? json['divisionId']
          : int.tryParse(json['divisionId']?.toString() ?? ''),
      divisionName: json['divisionName'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson({String? password, String? currentPassword}) {
    final Map<String, dynamic> data = {
      'userId': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
    if (password != null && password.isNotEmpty) {
      data['password'] = password;
      if (currentPassword != null && currentPassword.isNotEmpty) {
        data['currentPassword'] = currentPassword;
      }
    }
    return data;
  }
}
