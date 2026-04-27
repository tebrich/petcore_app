// C:\peticare\peticare_app\lib\features\auth\presentation\controllers\login_controller.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get_connect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peticare/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:peticare/features/vet/presentation/pages/vet_appointments_page.dart';
import 'package:peticare/features/vet/presentation/pages/groom_vet_appointments_page.dart';
import 'package:peticare/features/notifications/controllers/notifications_controller.dart';

class LoginController extends GetxController {
  final storage = GetStorage();
  final secure = const FlutterSecureStorage();

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

        // save in GetStorage (app state) and in secure storage (used by NotificationsController)
        await storage.write("token", token);
        await storage.write("user", user);
        await secure.write(key: 'access_token', value: token);

        final savedUser = storage.read("user");

        print("TOKEN GUARDADO (GetStorage) >>> ${storage.read("token")}");
        print("TOKEN GUARDADO (Secure) >>> ${await secure.read(key: 'access_token')}");
        print("USER ROLE >>> ${user["role"]}");
        print("USER GUARDADO >>> $savedUser");
        print("ROLE FINAL >>> ${savedUser["role"]}");
        print("🔥 LOGIN CONTROLLER EJECUTADO");

        // Ensure notifications controller reloads with new token
        if (Get.isRegistered<NotificationsController>()) {
          await Get.delete<NotificationsController>();
        }
        final notifsCtrl = Get.put(NotificationsController());
        await notifsCtrl.loadAll();

        /// 🔥 REDIRECCIÓN DIRECTA
        if (savedUser["role"] == "vet") {
          print("🚀 NAV → VET (GROOM)");
          Get.offAllNamed('/GroomVetAppointments');
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
