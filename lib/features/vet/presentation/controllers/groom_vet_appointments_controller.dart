import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GroomVetAppointmentsController extends GetxController {
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

  /// 🔹 GET GROOMING APPOINTMENTS (para la clínica)
  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        "/groom-appointments/vet",
        headers: await _getHeaders(),
      );

      print("GROOM GET STATUS: ${response.statusCode}");
      print("GROOM GET BODY: ${response.body}");

      if (response.statusCode == 200) {
        appointments.value = response.body;
      }
    } catch (e) {
      print("GROOM Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ ACEPTAR CITA GROOMING
  Future<void> acceptAppointment(int id) async {
    try {
      print("GROOM ACCEPT $id");

      final response = await http.put(
        "/groom-appointments/$id/accept",
        {},
        headers: await _getHeaders(),
      );

      print("GROOM ACCEPT STATUS: ${response.statusCode}");
      print("GROOM ACCEPT BODY: ${response.body}");

      if (response.statusCode == 200) {
        await fetchAppointments();

        Get.showSnackbar(
          const GetSnackBar(
            message: "Cita grooming aceptada",
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("GROOM Exception accept: $e");
    }
  }

  /// ❌ RECHAZAR CITA GROOMING
  Future<void> rejectAppointment(int id) async {
    try {
      print("GROOM REJECT $id");

      final response = await http.put(
        "/groom-appointments/$id/reject",
        {},
        headers: await _getHeaders(),
      );

      print("GROOM REJECT STATUS: ${response.statusCode}");
      print("GROOM REJECT BODY: ${response.body}");

      if (response.statusCode == 200) {
        await fetchAppointments();

        Get.showSnackbar(
          const GetSnackBar(
            message: "Cita grooming rechazada",
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("GROOM Exception reject: $e");
    }
  }

  /// 🔄 REPROGRAMAR CITA GROOMING
  Future<void> rescheduleAppointment(int id, DateTime newDateTime) async {
    try {
      final response = await http.put(
        "/groom-appointments/$id/reschedule",
        {
          "new_datetime": newDateTime.toIso8601String(),
        },
        headers: await _getHeaders(),
      );

      print("GROOM RESCHEDULE STATUS: ${response.statusCode}");
      print("GROOM RESCHEDULE BODY: ${response.body}");

      if (response.statusCode == 200) {
        await fetchAppointments();

        Get.showSnackbar(
          const GetSnackBar(
            message: "Cita grooming reprogramada",
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("GROOM Error reschedule: $e");
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token =
        await const FlutterSecureStorage().read(key: 'access_token');

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }
}
