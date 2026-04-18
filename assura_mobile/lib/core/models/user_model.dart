class UserModel {
  final String id;
  final String userName;
  final String name;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.userName,
    required this.name,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      name: json['name'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'name': name,
      'roles': roles,
    };
  }

  bool get isAdmin => roles.contains('Admin');
}

class AuthResponseModel {
  final String token;
  final UserModel user;

  AuthResponseModel({
    required this.token,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}
