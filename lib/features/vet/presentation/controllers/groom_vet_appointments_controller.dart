import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peticare/features/vet/presentation/pages/attend_pet_page.dart';

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

  //////////////////////////////////////////////////////////////
  /// 🔥 ATTEND GROOM (AGREGAR AQUÍ)
  //////////////////////////////////////////////////////////////
  Future<bool> attendAndOpen(int appointmentId, int? petId) async {
    try {
      print("GROOM ATTEND $appointmentId");

      final response = await http.post(
        "/groom-appointments/$appointmentId/attend",
        {},
        headers: await _getHeaders(),
      );

      print("GROOM ATTEND STATUS: ${response.statusCode}");
      print("GROOM ATTEND BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchAppointments();

        if (petId != null) {
          Get.to(() => AttendPetPage(
                petId: petId,
                appointmentId: appointmentId,
              ));
        }

        return true;
      } else {
        print("GROOM Error attend: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("GROOM Exception attend: $e");
      return false;
    }
  }

  //////////////////////////////////////////////////////////////
  // 🔥 CREATE FOLLOW-UP GROOM
  //////////////////////////////////////////////////////////////
  Future<bool> createFollowUp({
    required int petId,
    required DateTime scheduledAt,
    String? note,
  }) async {
    try {
      final response = await http.post(
        "/follow-ups/",
        {
          "pet_id": petId,
          "scheduled_at": scheduledAt.toIso8601String(),
          "note": note,
          "service_type": "grooming", // 🔥 CLAVE
        },
        headers: await _getHeaders(),
      );

      print("GROOM FOLLOW UP STATUS: ${response.statusCode}");
      print("GROOM FOLLOW UP BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("GROOM FOLLOW UP ERROR: $e");
      return false;
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

  //////////////////////////////////////////////////////////////
  /// 🔥 ATTEND GROOM APPOINTMENT
  //////////////////////////////////////////////////////////////
  Future<bool> attendAppointment(int? appointmentId) async {

    if (appointmentId == null) return false;

    try {

      final response = await http.post(
        "/groom-appointments/$appointmentId/attend",
        {},
        headers: await _getHeaders(),
      );

      print("GROOM ATTEND STATUS: ${response.statusCode}");
      print("GROOM ATTEND BODY: ${response.body}");

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        await fetchAppointments();

        return true;
      }

      return false;

    } catch (e) {

      print("GROOM ATTEND ERROR: $e");

      return false;
    }
  }
}
