class UserModel {
  final bool status;
  final String message;
  final String userId;
  final String role;
  final String accessToken;

  UserModel({
    required this.status,
    required this.message,
    required this.userId,
    required this.role,
    required this.accessToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],
      message: json['message'],
      userId: json['userid'],
      role: json['role'],
      accessToken: json['accesstoken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'userid': userId,
      'role': role,
      'accesstoken': accessToken,
    };
  }
}
