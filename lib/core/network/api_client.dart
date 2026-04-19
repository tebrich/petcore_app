import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = "http://192.168.40.54:8000";
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // =====================
  // HEADERS
  // =====================
  static Future<Map<String, String>> _buildHeaders({bool auth = false}) async {
    final headers = <String, String>{
      "Content-Type": "application/json",
    };

    if (auth) {
      final token = await _storage.read(key: "access_token");
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return headers;
  }

  // =====================
  // GET
  // =====================
  static Future<http.Response> get(
    String path, {
    bool auth = false,
  }) async {
    final url = Uri.parse("$baseUrl$path");
    final headers = await _buildHeaders(auth: auth);

    return await http.get(url, headers: headers);
  }

  // =====================
  // POST
  // =====================
  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final url = Uri.parse("$baseUrl$path");
    final headers = await _buildHeaders(auth: auth);

    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // =====================
  // PUT
  // =====================
  static Future<http.Response> put(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final url = Uri.parse("$baseUrl$path");
    final headers = await _buildHeaders(auth: auth);

    return await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // =====================
  // MULTIPART HEADERS
  // =====================
  static Future<Map<String, String>> authHeadersMultipart() async {
    final token = await _storage.read(key: "access_token");

    if (token != null && token.isNotEmpty) {
      return {
        "Authorization": "Bearer $token",
      };
    }

    return {};
  }
}