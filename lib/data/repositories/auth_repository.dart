import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/data/models/user_model.dart';
class AuthRepository {
  final String baseUrl = 'http://34.226.249.86:3000/api/auth';

  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        return UserModel.fromJson(data);
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Login failed with status ${response.statusCode}');
    }
  }
}
