import 'dart:convert'; // ✅ NECESARIO
import 'package:peticare/core/network/api_client.dart';

class VetAppointmentsService {

  /// =========================
  /// CREATE APPOINTMENT (CORREGIDO)
  /// =========================
  static Future<Map<String, dynamic>?> createAppointment({
    required int userId, // 🔥 NUEVO
    required int petId,
    required int vetId,
    required String appointmentType,
    required DateTime appointmentDateTime,
    required bool addToCalendar,
    required bool addReminder,
  }) async {

    final payload = {
      "user_id": userId, // 🔥 CLAVE
      "pet_id": petId,
      "vet_id": vetId,
      "appointment_type": appointmentType,
      "appointment_datetime": appointmentDateTime.toIso8601String(),
      "add_to_calendar": addToCalendar,
      "add_reminder": addReminder,
      "notes": "Cita desde app"
    };

    print("PAYLOAD >>> $payload");

    final response = await ApiClient.post(
      "/api/v1/vet-appointments/",
      payload,
      auth: true,
    );

    print("CREATE STATUS >>> ${response.statusCode}");
    print("CREATE BODY >>> ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error creating appointment: ${response.body}");
    }
  }

  /// =========================
  /// GET APPOINTMENT TYPES
  /// =========================
  static Future<List<dynamic>> getAppointmentTypes() async {
    final response = await ApiClient.get(
      "/api/v1/vet-appointments/vet-appointment-types",
      auth: true,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error getting appointment types");
    }
  }

  /// =========================
  /// GET NEARBY VETS
  /// =========================
  static Future<List<dynamic>> getNearbyVets({
    double? lat,
    double? lng,
  }) async {

    String url = "/api/v1/vets/nearby";

    if (lat != null && lng != null) {
      url += "?lat=$lat&lng=$lng";
    }

    final response = await ApiClient.get(
      url,
      auth: true,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["results"] ?? [];
    } else {
      throw Exception("Error getting nearby vets");
    }
  }

  static Future<Map<String, dynamic>?> getBasePrice({
    required String serviceType,
    required bool isMobile,
  }) async {
    try {
      final response = await ApiClient.get(
        "/api/v1/pricing/base?service_type=$serviceType&is_mobile=$isMobile",
        auth: true,
      );

      print("PRICE STATUS >>> ${response.statusCode}");
      print("PRICE BODY >>> ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;

    } catch (e) {
      print("ERROR GET BASE PRICE >>> $e");
      return null;
    }
  }
}