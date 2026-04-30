import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peticare/features/vet_appointments/data/services/vet_appointments_service.dart';
import 'package:peticare/features/shopping/presentation/pages/shopping_page.dart';
import 'package:peticare/features/dashboard/presentation/controllers/dashboard_controller.dart';

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

  /// 🔥 TIPO DE SERVICIO (lo que entiende el backend)
  /// Para este MVP: siempre "vet"
  String serviceType = "vet";

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

    /// 🔥 CARGAR PRECIO EN REVIEW (ÚNICO LUGAR DONDE SE HACE)
    if (index == 5) {
      await loadPrice();
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

    /// 🔥 CLAVE: para este MVP, siempre "vet"
    serviceType = "vet";

    /// reset precio (la carga real se hace en review)
    servicePrice.value = 0;

    update();
  }

  void updateAppointmentType(String type) {
    appointmentType = type;

    /// 🔥 CLAVE: siempre "vet"
    serviceType = "vet";

    /// reset precio (la carga real se hace en review)
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

  // ======= Compatibilidad notifications =======
  int? appointmentId;
  var isReadOnly = false.obs;

  /// Inicializa campos del controller desde un mapa de notificación (fullItem)
  void setFromNotificationItem(Map<String, dynamic> fullItem) {
    try {
      appointmentId = fullItem['appointment_id'] ?? fullItem['id'];
      selectedPetId = fullItem['pet_id'] ?? selectedPetId;
      selectedPetName = fullItem['pet_name'] ?? selectedPetName;
      selectedVetID = fullItem['vet_id'] ?? selectedVetID;
      appointmentType = fullItem['appointment_type'] ?? appointmentType;
      final rawDt = fullItem['appointment_datetime'];
      appointmentDateTime = rawDt != null ? DateTime.tryParse(rawDt.toString()) : appointmentDateTime;
      final paid = (fullItem['paid'] == true) || (fullItem['paid']?.toString().toLowerCase() == 'true');
      isReadOnly.value = paid;
      update();
    } catch (e) {
      print("ERROR setFromNotificationItem (vet) >>> $e");
    }
  }


  /// =========================
  /// PRECIO REAL (usa service_pricing_config)
  /// =========================
  Future<void> loadPrice() async {
    try {
      print("💰 BUSCANDO PRECIO: $serviceType");

      final response = await VetAppointmentsService.getBasePrice(
        serviceType: serviceType,        // siempre "vet" en este MVP
        isMobile: useMobileLocation,     // respeta el toggle de ubicación
      );

      print("💰 PRICE RESPONSE >>> $response");

      if (response != null) {
        servicePrice.value = response["price"] ?? 0;
        currency.value = response["currency"] ?? "PYG";

        print("💰 PRECIO OK >>> ${servicePrice.value} ${currency.value}");
      } else {
        print("❌ NO SE ENCONTRÓ PRECIO");
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
  /// CREATE APPOINTMENT (y PAY si appointmentId ya existe)
  /// =========================
  Future<bool> createAppointment(BuildContext context) async {
    // Si abrimos desde una notificación y ya tenemos appointmentId,
    // NO creamos otra cita: intentamos marcar la existente como pagada.
    if (appointmentId != null) {
      try {
        final paid = await VetAppointmentsService.markAppointmentPaid(appointmentId!);
        if (paid) {
          isReadOnly.value = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pago registrado correctamente")),
          );
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No se pudo registrar el pago")),
          );
          return false;
        }
      } catch (e) {
        print("ERROR paying existing appointment >>> $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error procesando el pago")),
        );
        return false;
      }
    }

    // Autocomplete pet id si solo tenemos el nombre (caso venido desde notificaciones)
    if (selectedPetId == null && selectedPetName != null) {
      final match = petsList.firstWhere(
        (p) => (p["name"] ?? "").toString().toLowerCase() == selectedPetName!.toLowerCase(),
        orElse: () => null,
      );
      if (match != null) {
        selectedPetId = match["id"];
        print("DBG auto-fill selectedPetId from petsList -> $selectedPetId");
      } else {
        try {
          final dash = Get.find<DashboardController>();
          final dashMatch = dash.petsList.firstWhere(
            (p) => (p["name"] ?? "").toString().toLowerCase() == selectedPetName!.toLowerCase(),
            orElse: () => null,
          );
          if (dashMatch != null) {
            selectedPetId = dashMatch["id"];
            print("DBG auto-fill selectedPetId from DashboardController -> $selectedPetId");
          }
        } catch (e) {
          // ignore if DashboardController not available
        }
      }
    }

    print("========== DEBUG CITA ==========");
    print("PET: $selectedPetId");
    print("VET: $selectedVetID");
    print("TYPE (UI): $appointmentType");
    print("SERVICE_TYPE (backend): $serviceType");
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
        // guardar id para uso posterior
        appointmentId = response["id"] ?? appointmentId;

        Get.defaultDialog(
          title: "✅ Cita enviada",
          middleText: "Tu solicitud fue enviada correctamente.\n\n"
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