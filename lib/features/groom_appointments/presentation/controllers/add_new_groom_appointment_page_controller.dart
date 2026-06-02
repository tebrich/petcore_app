import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

import 'package:peticare/features/groom_appointments/data/services/groom_appointments_service.dart';
import 'package:peticare/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:peticare/features/notifications/controllers/notifications_controller.dart';
import 'package:peticare/core/commn/presentation/controllers/global_controller.dart';

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

  String? selectedGroomerName;

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

    // 🔥 NUEVO: GUARDAR NOMBRE DEL GROOMER
    if (id != null) {
      final groomer = groomersList.firstWhereOrNull(
        (g) => g['id'].toString() == id,
      );

      if (groomer != null) {
        selectedGroomerName = groomer['name'];

        print("✅ GROOMER NAME SET: $selectedGroomerName");
      } else {
        print("⚠️ Groomer no encontrado en lista");
      }

      // 🔥 PRECIO (YA LO TENÍAS)
      fetchGroomingPrice(
        clinicId: int.parse(id),
        serviceName: "bath",
        petSize: "medium",
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

  // ======= Compatibilidad notifications =======
  int? appointmentId;
  var isReadOnly = false.obs;

  /// Inicializa campos del controller desde un mapa de notificación (fullItem)
  void setFromNotificationItem(Map<String, dynamic> fullItem) {
    try {
      if (fullItem == null || fullItem.isEmpty) {
        print("WARN setFromNotificationItem: fullItem vacío, skip");
        return;
      }

      // appointment id puede venir en varios campos
      appointmentId = fullItem['appointment_id'] ??
          fullItem['groom_appointment_id'] ??
          fullItem['vet_appointment_id'] ??
          fullItem['id'];

      // mascota (si viene)
      if (fullItem.containsKey('pet_id') || fullItem.containsKey('pet_name')) {
        selectedPet = {
          "id": fullItem["pet_id"],
          "name": fullItem["pet_name"] ?? "",
        };
        selectedPetId = fullItem['pet_id'] ?? selectedPetId;
      }

      // tipo de servicio
      appointmentType = fullItem['appointment_type'] ?? appointmentType;

      // groomer/vet id (si viene)
      selectedGroomerID = (fullItem['groomer_id'] ?? fullItem['clinic_id'])?.toString();

      // fecha/horario seguro (puede ser nullable)
      final rawDt =
          fullItem['proposed_datetime'] ??
              fullItem['appointment_datetime'] ??
              fullItem['appointment_datetime_raw'] ??
              fullItem['date'] ??
              fullItem['created_at'];

      // default seguro
      final DateTime defaultDt = DateTime.now().add(const Duration(days: 3)).copyWith(
        hour: 9,
        minute: 30,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

      if (rawDt != null) {
        final parsed = DateTime.tryParse(rawDt.toString());
        appointmentDateTime = parsed ?? defaultDt;
      } else {
        // asignar siempre un valor por defecto (no usar appointmentDateTime antes de inicializar)
        appointmentDateTime = defaultDt;
      }

      // paid -> readOnly
      final paid = (fullItem['paid'] == true) ||
          (fullItem['paid']?.toString().toLowerCase() == 'true');
      isReadOnly.value = paid;

      update();
    } catch (e, s) {
      print("ERROR setFromNotificationItem (groom) >>> $e");
      print(s);
    }
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

    if (pageController.hasClients) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      // fallback: actualizar índice sin animación
      updatePage(currentPage + 1);
    }
  }

  void previousPage() {
    if (pageController.hasClients) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      // fallback: actualizar índice sin animación (evita negativos)
      final newIndex = currentPage > 0 ? currentPage - 1 : 0;
      updatePage(newIndex);
    }
  }

  Future<void> updatePage(int index) async {
    currentPage = index;
    update();
  }

  // ================================
  // INIT
  // ================================
  @override
  void onInit() {
    super.onInit();

    pageController = PageController()
      ..addListener(() {
        // protección: sólo leer page si el PageController tiene clients
        if (!pageController.hasClients) return;
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
        "http://192.168.40.54:8000/api/v1/pricing/base"
        "?service_type=grooming"
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

  Future<bool> createGroomAppointment(BuildContext context) async {
    // Si venimos desde notificación y ya tenemos appointmentId -> intentar pagar esa cita
    if (appointmentId != null) {
      try {
        final paid = await GroomAppointmentsService.markAppointmentPaid(appointmentId!);
        if (paid) {
          isReadOnly.value = true;
          try {
            final notifsCtrl = Get.find<NotificationsController>();
            await notifsCtrl.loadNotifications(); // recargar notificaciones
          } catch (e) {
            print("WARN: reload notifs failed -> $e");
          }
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
        print("ERROR paying existing groom appointment >>> $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error procesando el pago")),
        );
        return false;
      }
    }
    
    // Autocomplete pet id si solo tenemos el nombre (desde notificación)
    if (selectedPetId == null && selectedPet != null && selectedPet!['name'] != null) {
      final name = (selectedPet!['name'] ?? '').toString().toLowerCase();
      final match = groomersList; // not used; try pets from controller/dashboard
      try {
        final dash = Get.find<DashboardController>();
        final dashMatch = dash.petsList.firstWhere(
          (p) => (p["name"] ?? "").toString().toLowerCase() == name,
          orElse: () => null,
        );
        if (dashMatch != null) {
          selectedPetId = dashMatch["id"];
          print("DBG auto-fill selectedPetId from DashboardController -> $selectedPetId");
        }
      } catch (e) {
        // no dashboard available, ignore
      }
    }

    print("========== DEBUG CITA GROOM ==========");
    print("PET: $selectedPetId");
    print("GROOMER: $selectedGroomerID");
    print("TYPE: $appointmentType");
    print("DATE: $appointmentDateTime");
    print("MOBILE: $isMobileGrooming");
    print("======================================");

    try {
      if (selectedPetId == null ||
          selectedGroomerID == null ||
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

      final response = await GroomAppointmentsService.createAppointment(
        userId: userId,
        petId: selectedPetId!,
        groomerId: int.parse(selectedGroomerID!),
        appointmentType: appointmentType!,
        appointmentDateTime: appointmentDateTime!,
        addToCalendar: addToCalendar,
        addReminder: addReminder,
      );

      if (response != null) {
        // guardar id para uso posterior (notificación / pago)
        appointmentId = response["id"] ?? appointmentId;

        Get.defaultDialog(
          title: "✅ Cita enviada",
          middleText: "Tu solicitud de grooming fue enviada correctamente.\n\n"
              "Podrás ver el estado en:\n"
              " Alertas o Mis citas.\n\n"
              "Te notificaremos cuando sea confirmada.",
          textConfirm: "Ir a Shopping",
          confirmTextColor: Colors.white,
          onConfirm: () {

            Get.back();

            final globalController =
            Get.find<GlobalController>();

            globalController.updateMenuSelectedIndex(2);

            Get.until((route) => route.isFirst);
          },
        );

        return true;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo crear la cita de grooming")),
      );
      return false;
    } catch (e) {
      print("ERROR CREATE GROOM APPOINTMENT >>> $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error inesperado")),
      );
      return false;
    }
  }
}
