import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostSignupPageController extends GetxController {
  /// =========================
  /// GENERAL
  /// =========================
  late PageController pageController;
  late int currentPage;

  /// =========================
  /// PET TYPE
  /// =========================
  String? petType;

  /// =========================
  /// PET BASIC INFO
  /// =========================
  late TextEditingController petNameController;
  late TextEditingController petBreedController;
  late TextEditingController petGenderController;
  late TextEditingController petWeightController;
  DateTime? petBirthdate;

  /// 🔥 YA NO usamos texto para energía
  /// lo dejamos por compatibilidad pero no se usa
  late TextEditingController petActivityLevelController;

  /// =========================
  /// BREEDS (BACKEND)
  /// =========================
  List<Map<String, dynamic>> breeds = [];

  /// 🔥 ID REAL DE RAZA
  int? selectedBreedId;

  /// =========================
  /// 🔥 ENERGY LEVEL (NUEVO)
  /// =========================
  int? selectedEnergyLevelId;

  /// =========================
  /// AVATAR
  /// =========================
  String? avatarName;

  /// =========================
  /// NETWORK
  /// =========================
  final GetConnect _api = GetConnect();

  /// =========================
  /// UPDATE METHODS
  /// =========================

  void updatePetType(String? newPetType) {
    petType = newPetType;

    int speciesId = getSpeciesId();
    loadBreeds(speciesId);

    update();
  }

  void updatePetBirthdate(DateTime? newPetBirthdate) {
    petBirthdate = newPetBirthdate;
    update();
  }

  void updatePetAvatar(String? newSelectedAvatar) {
    avatarName = newSelectedAvatar;
    update();
  }

  /// =========================
  /// 🔥 NUEVO: SET ENERGY LEVEL
  /// =========================
  void setEnergyLevel(int id) {
    selectedEnergyLevelId = id;

    print("⚡ ENERGY LEVEL ID: $selectedEnergyLevelId");

    update();
  }

  /// =========================
  /// SET BREED
  /// =========================
  void setBreed(Map<String, dynamic> breed) {
    selectedBreedId = breed["id"];
    petBreedController.text = breed["name"];

    print("🐶 BREED SELECTED ID: $selectedBreedId");

    update();
  }

  /// =========================
  /// LOAD BREEDS FROM BACKEND
  /// =========================
  Future<void> loadBreeds(int speciesId) async {
    try {
      final response = await _api.get(
        'http://192.168.40.54:8000/api/v1/pets/breeds/$speciesId',
      );

      if (response.statusCode == 200) {
        breeds = List<Map<String, dynamic>>.from(response.body);
        update();
      } else {
        print("ERROR BREEDS STATUS: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR LOAD BREEDS: $e");
    }
  }

  /// =========================
  /// SAVE PET (🔥 CORREGIDO)
  /// =========================
  Future<void> savePet() async {
    print("🚀 GUARDANDO MASCOTA...");

    try {
      /// VALIDACIONES CLAVE
      if (selectedBreedId == null) {
        print("❌ ERROR: breed_id es NULL");
        return;
      }

      if (selectedEnergyLevelId == null) {
        print("❌ ERROR: energy_level_id es NULL");
        Get.snackbar("Error", "Selecciona nivel de energía");
        return;
      }

      final response = await _api.post(
        'http://192.168.40.54:8000/api/v1/pets/',
        {
          "user_id": 1,
          "name": petNameController.text,
          "species_id": getSpeciesId(),
          "breed_id": selectedBreedId,
          "custom_breed": null,
          "gender": petGenderController.text,
          "weight_kg": double.tryParse(petWeightController.text),
          "birth_date": petBirthdate?.toIso8601String(),

          /// 🔥 FIX CRÍTICO
          "energy_level_id": selectedEnergyLevelId,

          "avatar_type": "avatar",
          "avatar_code": avatarName,
          "photo_url": null,
        },
      );

      print("🔥 SAVE PET STATUS: ${response.statusCode}");
      print("🔥 SAVE PET RESPONSE: ${response.body}");
    } catch (e) {
      print("❌ ERROR SAVE PET: $e");
    }
  }

  /// =========================
  /// MAP PET TYPE → SPECIES ID
  /// =========================
  int getSpeciesId() {
    if (petType == "Dog") return 1;
    if (petType == "Cat") return 2;
    return 1;
  }

  /// =========================
  /// INIT
  /// =========================
  @override
  void onInit() {
    super.onInit();

    currentPage = 0;

    pageController = PageController()
      ..addListener(() {
        if ((pageController.page ?? 0.0).round() != currentPage) {
          currentPage = (pageController.page ?? 0.0).round();
          update();
        }
      });

    petNameController = TextEditingController();
    petBreedController = TextEditingController();
    petGenderController = TextEditingController();
    petWeightController = TextEditingController();
    petActivityLevelController = TextEditingController();
  }
}