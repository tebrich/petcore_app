import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peticare/features/vet_appointments/data/services/vet_appointments_service.dart';
import 'package:peticare/features/shopping/presentation/pages/shopping_page.dart';

class AddNewVetAppointmentPageController extends GetxController {

  final storage = const FlutterSecureStorage();

  late PageController pageController;

  int currentPage = 0;

  int? selectedPetId;
  String? selectedPetName;

  int? selectedAppointmentTypeId;
  String? appointmentType;

  String? selectedVetName;
  int? selectedVetID;

  DateTime? appointmentDateTime;

  bool addToCalendar = false;
  bool addReminder = false;

  bool useMobileLocation = false;

  List<dynamic> petsList = [];
  

  /// 🔥 PRICING REAL
  var servicePrice = 0.obs;
  var currency = "PYG".obs;
  var vetsList = <dynamic>[].obs;

  /// TIPOS
  List<Map<String, dynamic>> appointmentTypes = [
    {"id": 1, "label_es": "Chequeo General", "icon": "Check"},
    {"id": 2, "label_es": "Vacunación", "icon": "Vaccine"},
    {"id": 3, "label_es": "Emergencia", "icon": "Emergency"},
  ];

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  /// =========================
  /// CONTROL DE FLUJO
  /// =========================
  Future<void> updatePage(int index) async {
    currentPage = index;

    /// 🔥 GARANTIZAR QUE VETS EXISTAN
    if ((index == 4 || index == 5) && vetsList.isEmpty) {
      print("📡 Cargando vets porque lista está vacía...");
      await loadVets();
    }

    /// 🔥 CARGAR PRECIO EN REVIEW
    if (index == 5) {
      await fetchPrice();
    }

    update();
  }

  /// =========================
  /// SELECCIONES
  /// =========================
  void updateSelectedPet(dynamic pet) {
    selectedPetId = pet["id"];
    selectedPetName = pet["name"];
    update();
  }

  void selectAppointmentType(int id, String label) {
    selectedAppointmentTypeId = id;
    appointmentType = label;

    /// reset precio
    servicePrice.value = 0;

    update();
  }

  void updateAppointmentType(String type) {
    appointmentType = type;

    /// reset precio
    servicePrice.value = 0;

    update();
  }

  void updateAppointmentDateTime(DateTime dateTime) {
    appointmentDateTime = dateTime;
    update();
  }

  /// 🔥 NUEVO (compatible con UI nueva)
  void updateSelectedVet(dynamic vet) {
    selectedVetID = vet["id"];
    selectedVetName = vet["name"];
    update();
  }

  /// 🔥 COMPATIBILIDAD (NO ROMPE TU UI ACTUAL)
  void updateSelectedVetID(int vetId) {
    selectedVetID = vetId;

    final vet = vetsList.firstWhere(
      (v) => v["id"] == vetId,
      orElse: () => null,
    );

    if (vet != null) {
      selectedVetName = vet["name"];
    }

    update();
  }

  void toggleLocationMode(bool value) {
    useMobileLocation = value;
    update();
  }

  void toggleCalendar(bool value) {
    addToCalendar = value;
    update();
  }

  void toggleReminder(bool value) {
    addReminder = value;
    update();
  }

  /// =========================
  /// MAPEO SERVICE TYPE
  /// =========================
  String mapServiceType(String? appointmentType) {
    if (appointmentType == null) return "vet";

    switch (appointmentType) {
      case "Chequeo General":
      case "Vacunación":
      case "Emergencia":
        return "vet";

      default:
        return "vet";
    }
  }

  /// =========================
  /// FETCH PRECIO REAL
  /// =========================
  Future<void> fetchPrice() async {
    try {
      if (appointmentType == null) {
        print("⚠️ appointmentType NULL → no se consulta precio");
        return;
      }

      print("💰 FETCH PRICE...");

      final serviceType = mapServiceType(appointmentType);

      final response = await VetAppointmentsService.getBasePrice(
        serviceType: serviceType,
        isMobile: false,
      );

      print("💰 PRICE RESPONSE >>> $response");

      if (response != null) {
        servicePrice.value = response["price"];
        currency.value = response["currency"];
      }

    } catch (e) {
      print("❌ ERROR PRICE >>> $e");
    }
  }

  /// =========================
  /// LOAD VETS
  /// =========================
  Future<void> loadVets() async {
    try {
      print("📡 CARGANDO VETERINARIAS...");

      final data = await VetAppointmentsService.getNearbyVets(
        lat: -25.490075,
        lng: -57.386725,
      );

      print("📡 RESPONSE VETS >>> $data");

      if (data.isNotEmpty) {
        vetsList.assignAll(data);
        update();
      } else {
        print("⚠️ No hay veterinarias");
      }

    } catch (e) {
      print("❌ ERROR LOAD VETS >>> $e");
    }
  }

  /// =========================
  /// CREATE APPOINTMENT
  /// =========================
  Future<bool> createAppointment(BuildContext context) async {
    print("========== DEBUG CITA ==========");
    print("PET: $selectedPetId");
    print("VET: $selectedVetID");
    print("TYPE: $appointmentType");
    print("DATE: $appointmentDateTime");
    print("================================");

    try {
      if (selectedPetId == null ||
          selectedVetID == null ||
          appointmentType == null ||
          appointmentDateTime == null) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Completa todos los campos")),
        );
        return false;
      }

      final userIdStr = await storage.read(key: 'user_id');
      final userId = int.tryParse(userIdStr ?? '');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario no autenticado")),
        );
        return false;
      }

      final response = await VetAppointmentsService.createAppointment(
        userId: userId,
        petId: selectedPetId!,
        vetId: selectedVetID!,
        appointmentType: appointmentType!,
        appointmentDateTime: appointmentDateTime!,
        addToCalendar: addToCalendar,
        addReminder: addReminder,
      );

      if (response != null) {

        Get.defaultDialog(
          title: "✅ Cita enviada",
          middleText:
              "Tu solicitud fue enviada correctamente.\n\n"
              "Podrás ver el estado en:\n"
              "🔔 Alertas o 📅 Mis citas.\n\n"
              "Te notificaremos cuando sea confirmada.",

          textConfirm: "Ir a Shopping",
          confirmTextColor: Colors.white,

          onConfirm: () {
            Get.back();
            Get.to(() => const ShoppingPage());
          },
        );

        return true;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo crear la cita")),
      );

      return false;

    } catch (e) {
      print("ERROR CREATE APPOINTMENT >>> $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error inesperado")),
      );

      return false;
    }
  }
}