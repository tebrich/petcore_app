import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class PetFormController extends GetxController {
  /// ID devuelto por backend al crear la mascota
  int? petId;

  /// Datos básicos
  int? speciesId;       // 1 = Dog, 2 = Cat
  int? breedId;         // FK pet_breeds
  String? customBreed;  // si es "Other"
  String? name;
  String? gender;       // Male / Female

  /// Datos físicos
  double? weightKg;
  DateTime? birthDate;

  /// Energía
  /// 1 = LOW, 2 = MODERATE, 3 = HIGH
  int? energyLevelId;

  /// Avatar / imagen
  /// avatar | photo
  String? avatarType;
  String? photoUrl; // URL Cloudinary

  /// =========================
  /// HELPERS
  /// =========================

  int get userId => Get.find<UserController>().user.id;

  bool get isBasicInfoComplete =>
      name != null &&
      speciesId != null &&
      breedId != null &&
      gender != null;

  bool get isPhysicalInfoComplete =>
      weightKg != null &&
      birthDate != null &&
      energyLevelId != null;

  bool get isReadyToCreate =>
      isBasicInfoComplete && isPhysicalInfoComplete;

  /// =========================
  /// SERIALIZACIÓN BACKEND
  /// =========================
  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "name": name,
      "species_id": speciesId,
      "breed_id": breedId,
      "custom_breed": customBreed,
      "gender": gender,
      "weight_kg": weightKg,
      "birth_date": birthDate?.toIso8601String(),
      "energy_level_id": energyLevelId,
      "avatar_type": avatarType ?? "avatar",
      "photo_url": photoUrl,
    };
  }

  /// =========================
  /// RESET (por si cancela flujo)
  /// =========================
  void resetForm() {
    petId = null;
    speciesId = null;
    breedId = null;
    customBreed = null;
    name = null;
    gender = null;
    weightKg = null;
    birthDate = null;
    energyLevelId = null;
    avatarType = null;
    photoUrl = null;
  }
}

