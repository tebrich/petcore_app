import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peticare/features/vet/presentation/pages/attend_pet_page.dart';

class VetAppointmentsController extends GetxController {
  var isLoading = true.obs;
  var appointments = [].obs;

  final String baseUrl = "http://192.168.40.54:8000/api/v1";
  final GetConnect http = GetConnect();

  @override
  void onInit() {
    super.onInit();
    http.baseUrl = baseUrl;
    fetchAppointments();
  }

  ////////////////////////////////////////////////////////////////
  /// 🔹 GET APPOINTMENTS
  ////////////////////////////////////////////////////////////////
  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        "/vet-appointments/vet",
        headers: await _getHeaders(),
      );

      print("GET STATUS: ${response.statusCode}");
      print("GET BODY: ${response.body}");

      if (response.statusCode == 200) {
        appointments.value = response.body;
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  ////////////////////////////////////////////////////////////////
  /// ✅ ACCEPT APPOINTMENT
  ////////////////////////////////////////////////////////////////
  Future<void> acceptAppointment(int id) async {
    try {
      print("ACCEPT $id");

      final response = await http.put(
        "/vet-appointments/$id/accept",
        {},
        headers: await _getHeaders(),
      );

      print("ACCEPT STATUS: ${response.statusCode}");
      print("ACCEPT BODY: ${response.body}");

      if (response.statusCode == 200) {
        await fetchAppointments();
        print("Cita aceptada");
      }
    } catch (e) {
      print("Exception accept: $e");
    }
  }

  ////////////////////////////////////////////////////////////////
  /// ❌ REJECT APPOINTMENT
  ////////////////////////////////////////////////////////////////
  Future<void> rejectAppointment(int id) async {
    try {
      print("REJECT $id");

      final response = await http.put(
        "/vet-appointments/$id/reject",
        {},
        headers: await _getHeaders(),
      );

      print("REJECT STATUS: ${response.statusCode}");
      print("REJECT BODY: ${response.body}");

      if (response.statusCode == 200) {
        await fetchAppointments();
        print("Cita rechazada");
      }
    } catch (e) {
      print("Exception reject: $e");
    }
  }

  ////////////////////////////////////////////////////////////////
  /// 🔄 RESCHEDULE
  ////////////////////////////////////////////////////////////////
  Future<void> rescheduleAppointment(int id, DateTime newDateTime) async {
    try {
      final response = await http.put(
        "/vet-appointments/$id/reschedule",
        {
          "new_datetime": newDateTime.toIso8601String(),
        },
        headers: await _getHeaders(),
      );

      print("RESCHEDULE STATUS: ${response.statusCode}");
      print("RESCHEDULE BODY: ${response.body}");

      if (response.statusCode == 200) {
        await fetchAppointments();
        print("Cita reprogramada");
      }
    } catch (e) {
      print("Error reschedule: $e");
    }
  }

  ////////////////////////////////////////////////////////////////
  /// 🔥 ATTEND + NAVIGATE TO FICHA (NEW)
  ////////////////////////////////////////////////////////////////
  Future<bool> attendAndOpen(int appointmentId, int? petId) async {
    try {
      print("ATTEND $appointmentId");

      final response = await http.post(
        "/vet-appointments/$appointmentId/attend",
        {},
        headers: await _getHeaders(),
      );

      print("ATTEND STATUS: ${response.statusCode}");
      print("ATTEND BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchAppointments();
        if (petId != null) {
          Get.to(() => AttendPetPage(petId: petId, appointmentId: appointmentId));
        }
        return true;
      } else {
        print("Error attend: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception attend: $e");
      return false;
    }
  }

  ////////////////////////////////////////////////////////////////
  /// Helpers
  ////////////////////////////////////////////////////////////////
  Future<Map<String, String>> _getHeaders() async {
    final token = await const FlutterSecureStorage().read(key: 'access_token');
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }
}
