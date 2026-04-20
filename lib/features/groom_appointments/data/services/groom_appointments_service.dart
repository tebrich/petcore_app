import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GroomAppointmentsService {
  static final _api = GetConnect()
    ..timeout = const Duration(seconds: 15);

  static final _storage = const FlutterSecureStorage();

  static Future<Map<String, dynamic>?> createAppointment({
    required int userId,
    required int petId,
    required int groomerId,
    required String appointmentType,
    required DateTime appointmentDateTime,
    required bool addToCalendar,
    required bool addReminder,
  }) async {
    final token = await _storage.read(key: 'access_token');

    final response = await _api.post(
      "http://192.168.40.54:8000/api/v1/groom-appointments/",
      {
        "pet_id": petId,
        "groomer_id": groomerId,
        "appointment_type": appointmentType,
        "appointment_datetime": appointmentDateTime.toIso8601String(),
        "add_to_calendar": addToCalendar,
        "add_reminder": addReminder,
      },
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("GROOM CREATE STATUS >>> ${response.statusCode}");
    print("GROOM CREATE BODY >>> ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.body);
    }

    return null;
  }
}
