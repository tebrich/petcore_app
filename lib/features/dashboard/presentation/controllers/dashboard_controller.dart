import 'package:get/get.dart';
import 'package:peticare/core/utils/pet_avatars_list.dart';
import 'package:flutter/material.dart';
import 'package:peticare/services/user_service.dart';
import 'package:peticare/features/dashboard/data/services/follow_ups_service.dart';
import 'package:peticare/services/auth_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';

class DashboardController extends GetxController {
  final GetConnect _api = GetConnect();

  var userName = "".obs;
  var userId = 0.obs; // 🔥 NUEVO
  var petsList = [].obs;
  var remindersList = [].obs;
  var isLoading = false.obs;
  var reminderTypes = [].obs;
  var followUps = [].obs;
  var pendingReviews = [].obs;
  var pendingGroomReviews = [].obs;

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
            "id": pet["id"],
            "name": pet["name"] ?? "",
            "age": age,
            "gender": pet["gender"] ?? "",
            "energy": pet["energy_level_id"] ?? 1,

            "avatar": avatarFn,

            "avatar_code": pet["avatar_code"],

            "photo_url": pet["photo_url"],

            "species": pet["species_name"] ?? "",
            "breed": pet["breed_name"] ?? "",
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

      await loadFollowUps(); // 🔥 AQUÍ SÍ

      await loadPendingReviews();

      await loadPendingGroomReviews();

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

  Future<void> loadFollowUps() async {
    try {
      if (userId.value == 0) {
        print("No userId yet for followUps");
        return;
      }

      final data = await FollowUpsService().getMyFollowUps(userId.value);

      followUps.value = data.where((f) {
        final dt = DateTime.tryParse(f['scheduled_at'] ?? '');
        return dt != null &&
            dt.isAfter(DateTime.now()) &&
            f['status'] == 'proposed';
      }).toList();

      print("FOLLOW UPS LOADED: ${followUps.length}");
    } catch (e) {
      print("ERROR loadFollowUps: $e");
    }
  }

  Future<void> loadPendingReviews() async {
    try {
      final token = await AuthService.getToken();

      final res = await _api.get(
        'http://192.168.40.54:8000/api/v1/vet-reviews/pending',
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("PENDING REVIEWS >>> ${res.body}");

      if (res.statusCode == 200 && res.body != null) {
        pendingReviews.value =
        List<Map<String, dynamic>>.from(res.body);

        // 🔥 MOSTRAR POPUP SI EXISTE REVIEW PENDIENTE
        if (pendingReviews.isNotEmpty) {
          Future.delayed(
            const Duration(milliseconds: 800),
                () {
              showPendingReviewPopup(
                pendingReviews.first,
                isGrooming: false,
              );
            },
          );
        }
      }
    } catch (e) {
      print("ERROR PENDING REVIEWS: $e");
    }
  }

  void showPendingReviewPopup(
      Map<String, dynamic> review, {
        required bool isGrooming,
      }) {

    double selectedRating = 5;
    final commentController = TextEditingController();

    Get.dialog(

      AlertDialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        title: const Text(
          "🐾 ¿Cómo fue la atención?",
          textAlign: TextAlign.center,
        ),

        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  "${review['pet_name']} fue atendido en:",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  review['clinic_name'] ??
                  review['groomer_name'] ??
                      '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 35,

                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),

                  onRatingUpdate: (rating) {
                    selectedRating = rating;
                  },
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: commentController,
                  maxLines: 3,

                  decoration: InputDecoration(
                    hintText: "Comentario opcional...",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        actions: [

          /// 🔥 AHORA NO
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Ahora no"),
          ),

          /// 🔥 ENVIAR
          ElevatedButton(

            onPressed: () async {

              bool success = false;

              if (isGrooming) {

                success = await submitGroomReview(
                  groomerId: review['groomer_id'],
                  appointmentId: review['appointment_id'],
                  rating: selectedRating.toInt(),
                  comment: commentController.text,
                );

              } else {

                success = await submitReview(
                  clinicId: review['clinic_id'],
                  appointmentId: review['appointment_id'],
                  rating: selectedRating.toInt(),
                  comment: commentController.text,
                );
              }

              if (success) {

                Navigator.of(Get.context!).pop();
              }
            },

            child: const Text("Enviar"),
          ),
        ],
      ),

      barrierDismissible: false,
    );
  }

  /// ======================================================
  /// VET REVIEW
  /// ======================================================

  Future<bool> submitReview({
    required int clinicId,
    required int appointmentId,
    required int rating,
    required String comment,
  }) async {

    try {

      final token = await AuthService.getToken();

      final body = {
        "clinic_id": clinicId,
        "appointment_id": appointmentId,
        "rating": rating,
        "review_text": comment,
      };

      final res = await _api.post(
        'http://192.168.40.54:8000/api/v1/vet-reviews/',
        body,

        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("SUBMIT REVIEW STATUS >>> ${res.statusCode}");
      print("SUBMIT REVIEW BODY >>> ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {

        Get.showSnackbar(
          const GetSnackBar(
            message: "Tu review fue enviada correctamente 🐾",
            duration: Duration(seconds: 2),
          ),
        );

        pendingReviews.removeWhere(
              (r) => r['appointment_id'] == appointmentId,
        );

        return true;

      } else {

        Get.showSnackbar(
          GetSnackBar(
            message:
            res.body?['detail'] ??
                "No se pudo enviar la review",
            duration: const Duration(seconds: 2),
          ),
        );

        return false;
      }

    } catch (e) {

      print("ERROR SUBMIT REVIEW: $e");

      Get.showSnackbar(
        const GetSnackBar(
          message:
          "Ocurrió un problema enviando la review",
          duration: Duration(seconds: 2),
        ),
      );

      return false;
    }
  }

  /// ======================================================
  /// GROOM REVIEW
  /// ======================================================

  Future<bool> submitGroomReview({
    required int groomerId,
    required int appointmentId,
    required int rating,
    required String comment,
  }) async {

    try {

      final token = await AuthService.getToken();

      final body = {
        "groomer_id": groomerId,
        "appointment_id": appointmentId,
        "rating": rating,
        "review_text": comment,
      };

      final res = await _api.post(
        'http://192.168.40.54:8000/api/v1/groom-reviews/',
        body,

        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("SUBMIT GROOM REVIEW STATUS >>> ${res.statusCode}");
      print("SUBMIT GROOM REVIEW BODY >>> ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {

        Get.showSnackbar(
          const GetSnackBar(
            message: "Tu review Groom fue enviada correctamente 🐾",
            duration: Duration(seconds: 2),
          ),
        );

        pendingGroomReviews.removeWhere(
              (r) => r['appointment_id'] == appointmentId,
        );

        return true;

      } else {

        Get.showSnackbar(
          GetSnackBar(
            message:
            res.body?['detail'] ??
                "No se pudo enviar la review Groom",
            duration: const Duration(seconds: 2),
          ),
        );

        return false;
      }

    } catch (e) {

      print("ERROR SUBMIT GROOM REVIEW: $e");

      Get.showSnackbar(
        const GetSnackBar(
          message:
          "Ocurrió un problema enviando la review Groom",
          duration: Duration(seconds: 2),
        ),
      );

      return false;
    }
  }


  Future<void> loadPendingGroomReviews() async {
    try {

      final token = await AuthService.getToken();

      final res = await _api.get(
        'http://192.168.40.54:8000/api/v1/groom-reviews/pending',
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("PENDING GROOM REVIEWS >>> ${res.body}");

      if (res.statusCode == 200 && res.body != null) {

        pendingGroomReviews.value =
        List<Map<String, dynamic>>.from(res.body);

        if (pendingGroomReviews.isNotEmpty) {

          Future.delayed(
            const Duration(milliseconds: 1200),
                () {

              showPendingReviewPopup(
                pendingGroomReviews.first,
                isGrooming: true,
              );

            },
          );
        }
      }

    } catch (e) {

      print("ERROR PENDING GROOM REVIEWS: $e");
    }
  }
}