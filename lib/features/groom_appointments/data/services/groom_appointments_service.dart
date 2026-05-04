import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GroomAppointmentsService {
  static final _api = GetConnect()..timeout = const Duration(seconds: 15);
  static final _storage = const FlutterSecureStorage();

  /// CREATE GROOM APPOINTMENT
  static Future<Map<String, dynamic>?> createAppointment({
    required int userId,
    required int petId,
    required int groomerId,
    required String appointmentType,
    required DateTime appointmentDateTime,
    required bool addToCalendar,
    required bool addReminder,
  }) async {
    try {
      final token = await _storage.read(key: 'access_token');
      final payload = {
        "user_id": userId,
        "pet_id": petId,
        "groomer_id": groomerId,
        "appointment_type": appointmentType,
        "appointment_datetime": appointmentDateTime.toIso8601String(),
        "add_to_calendar": addToCalendar,
        "add_reminder": addReminder,
      };

      final response = await _api.post(
        "http://192.168.40.54:8000/api/v1/groom-appointments/",
        payload,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final body = response.body is String
          ? (response.body.isNotEmpty ? jsonDecode(response.body) : null)
          : response.body;

      print("GROOM CREATE STATUS >>> ${response.statusCode}");
      print("GROOM CREATE BODY >>> $body");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body != null ? Map<String, dynamic>.from(body) : null;
      }

      return null;
    } catch (e) {
      print("ERROR CREATE GROOM APPOINTMENT >>> $e");
      return null;
    }
  }

  /// MARK GROOM APPOINTMENT AS PAID
  static Future<bool> markAppointmentPaid(dynamic appointmentId) async {
    try {
      final token = await _storage.read(key: 'access_token');
      final url = "http://192.168.40.54:8000/api/v1/groom-appointments/$appointmentId/mark-paid";
      final response = await _api.put(
        url,
        {},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final body = response.body is String
          ? (response.body.isNotEmpty ? jsonDecode(response.body) : null)
          : response.body;

      print("GROOM MARK PAID STATUS >>> ${response.statusCode}");
      print("GROOM MARK PAID BODY >>> $body");

      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e) {
      print("ERROR GROOM MARK PAID >>> $e");
      return false;
    }
  }

  /// GET MY GROOM APPOINTMENTS
  static Future<List<Map<String, dynamic>>> getMyAppointments() async {
    try {
      final token = await _storage.read(key: 'access_token');
      final response = await _api.get(
        "http://192.168.40.54:8000/api/v1/groom-appointments/my",
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final body = response.body is String
          ? (response.body.isNotEmpty ? jsonDecode(response.body) : null)
          : response.body;

      print("GET MY GROOM APPTS STATUS >>> ${response.statusCode}");
      print("GET MY GROOM APPTS BODY >>> $body");

      if (response.statusCode == 200 && body != null) {
        return List<Map<String, dynamic>>.from(body);
      }

      return [];
    } catch (e) {
      print("ERROR GET MY GROOM APPOINTMENTS >>> $e");
      return [];
    }
  }
}
