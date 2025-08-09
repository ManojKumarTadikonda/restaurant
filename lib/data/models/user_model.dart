class UserModel {
  final bool status;
  final String message;
  final String userId;
  final String role;
  final String accesstoken;

  UserModel({
    required this.status,
    required this.message,
    required this.userId,
    required this.role,
    required this.accesstoken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],
      message: json['message'],
      userId: json['userid'],
      role: json['role'],
      accesstoken: json['accesstoken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'userid': userId,
      'role': role,
      'accesstoken': accesstoken,
    };
  }
}
