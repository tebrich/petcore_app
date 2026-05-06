import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FollowUpsService {
  final GetConnect http = GetConnect();

  FollowUpsService() {
    http.baseUrl = "http://192.168.40.54:8000/api/v1";
  }

  Future<List<dynamic>> getMyFollowUps(int userId) async {
    try {
      final res = await http.get(
        "/follow-ups/user/$userId",
        headers: await _getHeaders(),
      );

      print("FOLLOW UPS STATUS: ${res.statusCode}");
      print("FOLLOW UPS BODY: ${res.body}");

      if (res.statusCode == 200) {
        return res.body;
      } else {
        return [];
      }
    } catch (e) {
      print("FOLLOW UPS ERROR: $e");
      return [];
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await const FlutterSecureStorage().read(key: 'access_token');
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }
}
