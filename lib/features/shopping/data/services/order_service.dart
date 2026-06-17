import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class OrderService {

  static const String baseUrl =
      'https://api.pet-core.app/api/v1/shop';

  static final FlutterSecureStorage storage =
      FlutterSecureStorage();

  static Future<Map<String, dynamic>?> createOrder({

    required Map<String, dynamic> orderData,

  }) async {

    try {

      final token =
          await storage.read(key: 'access_token');

      final response = await http.post(

        Uri.parse('$baseUrl/orders'),

        headers: {

          'Content-Type': 'application/json',

          'Authorization': 'Bearer $token',
        },

        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {

        return jsonDecode(response.body);
      }

      return null;

    } catch (e) {

      print('CREATE ORDER ERROR: $e');

      return null;
    }
  }
}
