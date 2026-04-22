import 'package:get/get.dart';
import 'package/get_storage/get_storage.dart';
import 'package:peticare/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:peticare/features/vet/presentation/pages/vet_appointments_page.dart';
import 'package:peticare/features/vet/presentation/pages/groom_vet_appointments_page.dart';

class LoginController extends GetxController {
  final storage = GetStorage();

  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final api = GetConnect();

      final response = await api.post(
        "http://192.168.40.54:8000/api/v1/login",
        {
          "username": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.body["access_token"];
        final user = response.body["user"];

        await storage.write("token", token);
        await storage.write("user", user);

        final savedUser = storage.read("user");

        print("TOKEN GUARDADO >>> ${storage.read("token")}");
        print("USER ROLE >>> ${user["role"]}");
        print("USER GUARDADO >>> $savedUser");
        print("ROLE FINAL >>> ${savedUser["role"]}");
        print("🔥 LOGIN CONTROLLER EJECUTADO");

        /// 🔥 REDIRECCIÓN DIRECTA
        if (savedUser["role"] == "vet") {
          print("🚀 NAV → VET (GROOM)");
          // Opciones:
          // 1) Usar la ruta que definimos en main.dart:
          Get.offAllNamed('/GroomVetAppointments');

          // 2) O navegar directo al widget (equivalente):
          // Get.offAll(() => const GroomVetAppointmentsPage());

        } else {
          print("🚀 NAV → USER");
          Get.offAllNamed('/HomePage');
        }
      } else {
        Get.snackbar("Error", "Login inválido");
      }
    } catch (e) {
      print("LOGIN ERROR >>> $e");
    } finally {
      isLoading.value = false;
    }
  }
}
