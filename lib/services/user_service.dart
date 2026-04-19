import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:peticare/core/network/api_client.dart';

class UserService {
  // =====================
  // GET /users/me
  // =====================
  static Future<Map<String, dynamic>> getMe() async {
    final response = await ApiClient.get(
      "/api/v1/users/me",
      auth: true,
    );

    print("GET /users/me STATUS >>> ${response.statusCode}");
    print("GET /users/me BODY >>> ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Error real: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  // =====================
  // PUT /users/me
  // =====================
  static Future<Map<String, dynamic>> updateMe(
    Map<String, dynamic> payload,
  ) async {
    final response = await ApiClient.put(
      "/api/v1/users/me",
      payload,
      auth: true,
    );

    if (response.statusCode != 200) {
      throw Exception("Error actualizando usuario");
    }

    return jsonDecode(response.body);
  }

  // =====================
  // POST /users/me/avatar  ✅ NUEVO
  // =====================
  static Future<String> uploadAvatar(File imageFile) async {
    final uri = Uri.parse(
      "${ApiClient.baseUrl}/api/v1/users/me/avatar",
    );

    final request = http.MultipartRequest("POST", uri);

    // 🔐 AUTH HEADER (NO Content-Type)
    request.headers.addAll(
      await ApiClient.authHeadersMultipart(),
    );

    // 📎 FILE (el nombre DEBE ser "file")
    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    );

    final response = await request.send();

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw Exception("Avatar upload failed: $body");
    }

    final responseBody = await response.stream.bytesToString();
    final decoded = jsonDecode(responseBody);

    return decoded["avatar_url"];
  }
}

