import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

class AddNewGroomAppointmentPageController extends GetxController {

  // ================================
  // PAGE CONTROL
  // ================================
  late PageController pageController;
  int currentPage = 0;

  // ================================
  // DATA PRINCIPAL
  // ================================

  Map<String, dynamic>? selectedPet;
  int? selectedPetId;

  String get selectedPetName {
    if (selectedPet == null) return "";
    return selectedPet!["name"] ?? "";
  }

  String? appointmentType;

  late DateTime appointmentDateTime;

  bool? isMobileGrooming;

  String? selectedGroomerID;

  bool addToCalendar = true;
  bool addReminder = true;

  // ================================
  // GROOMERS DATA
  // ================================

  List<dynamic> groomersList = [];
  bool isLoadingGroomers = false;

  // ================================
  // LOCATION MODE (🔥 IGUAL QUE VET)
  // ================================

  bool useMobileLocation = false;

  // ================================
  // STORAGE
  // ================================

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // ================================
  // UPDATE METHODS
  // ================================

  void updateSelectedPet(Map pet) {
    selectedPet = Map<String, dynamic>.from(pet);
    selectedPetId = pet['id'];
    update();
  }

  void updateAppointmentType(String? type) {
    appointmentType = type;
    update();
  }

  void updateAppointmentDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      appointmentDateTime = dateTime;
      update();
    }
  }

  void updateGroomingServiceMobility(bool value) {
    isMobileGrooming = value;
    update();
  }

  void updateSelectedGroomerID(String? id) {
    selectedGroomerID = id;

    // 🔥 LLAMAR PRECIO AUTOMÁTICO
    if (id != null) {
      fetchGroomingPrice(
        clinicId: int.parse(id),
        serviceName: "bath", // luego dinámico
        petSize: "medium",   // luego automático desde pet
        isMobile: isMobileGrooming ?? false,
      );
    }

    update();
  }

  void updateAddToCalendar(bool value) {
    addToCalendar = value;
    update();
  }

  void updateAddReminder(bool value) {
    addReminder = value;
    update();
  }

  // ================================
  // 🔥 TOGGLE LOCATION (CLAVE)
  // ================================

  void toggleLocationMode(bool value) {
    useMobileLocation = value;
    fetchGroomers();
    update();
  }

  // ================================
  // FETCH GROOMERS (PRODUCCIÓN)
  // ================================

  Future<void> fetchGroomers() async {

    if (isMobileGrooming == null) {
      print("❌ isMobileGrooming NULL");
      return;
    }

    isLoadingGroomers = true;
    update();

    try {
      final token = await storage.read(key: 'access_token');

      final api = GetConnect();

      String url =
          "http://192.168.40.54:8000/api/v1/groomers?is_mobile=$isMobileGrooming";

      // 🔥 SI USA GPS (IGUAL QUE VET)
      if (useMobileLocation) {

        LocationPermission permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever) {

          Position position = await Geolocator.getCurrentPosition();

          url += "&lat=${position.latitude}&lng=${position.longitude}";
        }
      }

      final response = await api.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("GROOMERS STATUS: ${response.statusCode}");
      print("GROOMERS BODY: ${response.body}");

      if (response.statusCode == 200) {
        groomersList = response.body["results"];
      } else {
        groomersList = [];
      }

    } catch (e) {
      print("ERROR GROOMERS: $e");
      groomersList = [];
    }

    isLoadingGroomers = false;
    update();
  }

  // ================================
  // VALIDACIONES
  // ================================

  bool canContinue() {
    switch (currentPage) {

      case 0:
        return true;

      case 1:
        return selectedPetId != null;

      case 2:
        return appointmentType != null;

      case 3:
        return true;

      case 4:
        return isMobileGrooming != null;

      case 5:
        return selectedGroomerID != null;

      case 6:
        return true;

      default:
        return false;
    }
  }

  // ================================
  // NAVEGACIÓN
  // ================================

  void nextPage() {
    if (!canContinue()) return;

    pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  // ================================
  // INIT
  // ================================

  @override
  void onInit() {
    super.onInit();

    pageController = PageController()
      ..addListener(() {
        final page = (pageController.page ?? 0).round();
        if (page != currentPage) {
          currentPage = page;
          update();
        }
      });

    appointmentDateTime = DateTime.now()
        .add(const Duration(days: 3))
        .copyWith(
          hour: 9,
          minute: 30,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
  }

  double? groomingPrice;
  bool isLoadingPrice = false;

  Future<void> fetchGroomingPrice({
    required int clinicId,
    required String serviceName,
    required String petSize,
    required bool isMobile,
  }) async {

    isLoadingPrice = true;
    update();

    try {
      final token = await storage.read(key: 'access_token');

      final response = await GetConnect().get(
        "http://192.168.40.54:8000/api/v1/grooming/price"
        "?clinic_id=$clinicId"
        "&service_name=$serviceName"
        "&pet_size=$petSize"
        "&is_mobile=$isMobile",
        headers: {
            'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        groomingPrice = response.body["price"];
      } else {
        groomingPrice = null;
      }

    } catch (e) {
      groomingPrice = null;
    }

    isLoadingPrice = false;
    update();
  }
}