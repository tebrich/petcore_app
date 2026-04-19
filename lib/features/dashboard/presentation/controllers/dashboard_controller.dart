import 'package:get/get.dart';
import 'package:peticare/core/utils/pet_avatars_list.dart';
import 'package:flutter/material.dart';
import 'package:peticare/services/user_service.dart';

class DashboardController extends GetxController {
  final GetConnect _api = GetConnect();

  var userName = "".obs;
  var userId = 0.obs; // 🔥 NUEVO
  var petsList = [].obs;
  var remindersList = [].obs;
  var isLoading = false.obs;
  var reminderTypes = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  // =========================
  // LOAD DASHBOARD (USER + PETS + REMINDERS)
  // =========================
  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;

      /// =========================
      /// USER
      /// =========================
      final user = await UserService.getMe();
      userName.value = user["full_name"] ?? "";
      userId.value = user["id"];

      print("USER ID >>> ${userId.value}");

      /// =========================
      /// PETS (DINÁMICO)
      /// =========================
      final petsRes = await _api.get(
        'http://192.168.40.54:8000/api/v1/pets/user/${userId.value}',
      );

      print("PETS RESPONSE >>> ${petsRes.body}");

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
            "id": pet["id"], // 🔥 IMPORTANTE
            "name": pet["name"] ?? "",
            "age": age,
            "gender": pet["gender"] ?? "",
            "energy": pet["energy_level_id"] ?? 1,
            "avatar": avatarFn,
          };
        }).toList();
      }

      /// =========================
      /// REMINDERS (DINÁMICO)
      /// =========================
      await loadReminders();

      /// =========================
      /// REMINDER TYPES
      /// =========================
      await loadReminderTypes();

    } catch (e) {
      print("ERROR DASHBOARD: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // LOAD REMINDERS
  // =========================
  Future<void> loadReminders() async {
    try {
      final res = await _api.get(
        'http://192.168.40.54:8000/api/v1/reminders/today/${userId.value}',
      );

      print("REMINDERS >>> ${res.body}");

      if (res.statusCode == 200 && res.body != null) {
        remindersList.value = List<Map<String, dynamic>>.from(res.body);
      }
    } catch (e) {
      print("ERROR REMINDERS: $e");
    }
  }

  // =========================
  // LOAD REMINDER TYPES
  // =========================
  Future<void> loadReminderTypes() async {
    try {
      final res = await _api.get(
        'http://192.168.40.54:8000/api/v1/reminders/reminder-types',
      );

      if (res.statusCode == 200 && res.body != null) {
        reminderTypes.value = List<Map<String, dynamic>>.from(res.body);
      }
    } catch (e) {
      print("ERROR REMINDER TYPES: $e");
    }
  }
}