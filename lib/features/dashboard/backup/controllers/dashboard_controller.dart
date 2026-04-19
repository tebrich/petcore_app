import 'package:get/get.dart';
import 'package:peticare/core/utils/pet_avatars_list.dart';
import 'package:flutter/material.dart';
import 'package:peticare/services/user_service.dart';

class DashboardController extends GetxController {
  final GetConnect _api = GetConnect();

  var userName = "".obs;
  var petsList = [].obs;
  var remindersList = [].obs; // 🔥 NUEVO
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
    loadReminders(); // 🔥 NUEVO
  }

  // =========================
  // LOAD DASHBOARD (USER + PETS)
  // =========================
  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;

      /// =========================
      /// USER
      /// =========================
      final user = await UserService.getMe();
      userName.value = user["full_name"] ?? "";

      /// =========================
      /// PETS
      /// =========================
      final petsRes =
          await _api.get('http://192.168.40.54:8000/api/v1/pets/user/1');

      if (petsRes.statusCode == 200 && petsRes.body != null) {
        final raw = List<Map<String, dynamic>>.from(petsRes.body);

        petsList.value = raw.map((pet) {
          final birthDate = DateTime.tryParse(pet["birth_date"] ?? "");
          int age = 0;

          if (birthDate != null) {
            final today = DateTime.now();
            age = today.year - birthDate.year;

            if (today.month < birthDate.month ||
                (today.month == birthDate.month &&
                    today.day < birthDate.day)) {
              age--;
            }
          }

          final isDog = pet["species_id"] == 1;

          final avatarFn =
              petAvatars(Get.context ?? Get.overlayContext!)
                  [isDog ? "Dog" : "Cat"]?[pet["avatar_code"]];

          return {
            "name": pet["name"] ?? "",
            "age": age,
            "gender": pet["gender"] ?? "",
            "energy": pet["energy_level_id"] ?? 1,
            "avatar": avatarFn,
          };
        }).toList();
      }
    } catch (e) {
      print("ERROR DASHBOARD: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // 🔥 NUEVO: LOAD REMINDERS
  // =========================
  Future<void> loadReminders() async {
    try {
      final res = await _api.get(
        'http://192.168.40.54:8000/api/v1/reminders/user/4/formatted',
      );

      if (res.statusCode == 200 && res.body != null) {
        remindersList.value = List<Map<String, dynamic>>.from(res.body);
      }
    } catch (e) {
      print("ERROR REMINDERS: $e");
    }
  }
}