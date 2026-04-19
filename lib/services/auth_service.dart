import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peticare/core/network/api_client.dart';

class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // =====================
  // TOKEN
  // =====================

  static Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'user');      // 🔥 limpiar user
    await _storage.delete(key: 'user_id');   // 🔥 limpiar user_id
  }

  // =====================
  // SESSION VALIDATION (CRÍTICO)
  // =====================

  static Future<bool> hasValidSession() async {
    try {
      final response = await ApiClient.get(
        "/api/v1/users/me",
        auth: true,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (_) {
      await logout();
      return false;
    }
  }

  // =====================
  // REGISTER
  // =====================

  static Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneCountryCode,
    required String phoneNumber,
    required String countryCode,
    String? city,
    double? latitude,
    double? longitude,
  }) async {
    final payload = {
      "email": email,
      "password": password,
      "full_name": fullName,
      "phone_country_code": phoneCountryCode,
      "phone_number": phoneNumber,
      "country_code": countryCode,
      "city": city,
      "latitude": latitude,
      "longitude": longitude,
    };

    final response = await ApiClient.post(
      "/api/v1/auth/register",
      payload,
    );

    if (response.statusCode != 201) {
      throw Exception("Error al registrar usuario");
    }
  }

  // =====================
  // LOGIN
  // =====================

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final payload = {
      "email": email,
      "password": password,
    };

    final response = await ApiClient.post(
      "/api/v1/auth/login",
      payload,
    );

    print("LOGIN STATUS >>> ${response.statusCode}");
    print("LOGIN BODY >>> ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Credenciales inválidas");
    }

    final data = jsonDecode(response.body);

    final token = data['access_token'];
    final user = data['user'];
    final userId = user['id'];

    // 🔐 Guardar token
    await saveToken(token);

    // 🔥 GUARDAR USER COMPLETO (CLAVE DEL FIX)
    await _storage.write(
      key: 'user',
      value: jsonEncode(user),
    );

    // 🔥 GUARDAR USER ID
    await _storage.write(
      key: 'user_id',
      value: userId.toString(),
    );

    print("USER GUARDADO >>> $user");
    print("USER ID GUARDADO >>> $userId");
  }
}