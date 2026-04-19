import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserAvatarService {
  static const String baseUrl = "http://192.168.40.54:8000";
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> uploadAvatar(File imageFile) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) {
      throw Exception("No token available");
    }

    final uri = Uri.parse("$baseUrl/api/v1/users/me/avatar");
    final request = http.MultipartRequest("POST", uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Error uploading avatar");
    }
  }
}

