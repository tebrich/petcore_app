// C:\peticare\peticare_app\lib\features\notifications\controllers\notifications_controller.dart

import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationsController extends GetxController {
  var notificationsList = <Map<String, dynamic>>[].obs;
  var followUpsList = <Map<String, dynamic>>[].obs;
  var myAppointmentsList = <Map<String, dynamic>>[].obs;
  var myGroomAppointmentsList = <Map<String, dynamic>>[].obs; // NEW
  var isLoading = false.obs;

  final storage = const FlutterSecureStorage();
  final String baseUrl = "http://192.168.40.54:8000/api/v1";
  final GetConnect api = GetConnect();

  @override
  void onInit() {
    super.onInit();
    api.baseUrl = baseUrl;
    loadAll();
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await storage.read(key: 'access_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<void> loadAll() async {
    // cargar en paralelo (mantengo loadAll como antes pero añado groom)
    await Future.wait([
      loadNotifications(),
      loadFollowUpsForCurrentUser(),
      loadMyAppointments(),
      loadMyGroomAppointments(), // NEW
    ]);
  }

  Future<void> loadNotifications() async {
    print(">> ENTER loadNotifications()");
    try {
      isLoading.value = true;
      final headers = await _getHeaders();
      print(">> headers prepared: $headers");
      final response = await api.get("/notifications", headers: headers);
      print("NOTIFICATIONS STATUS >>> ${response.statusCode}");
      print("NOTIFICATIONS BODY >>> ${response.body}");
      print("NOTIFICATIONS BODY TYPE >>> ${response.body.runtimeType}");
      if (response.statusCode == 200 && response.body != null) {
        notificationsList.value = List<Map<String, dynamic>>.from(response.body);
        // DEBUG para dashboard
        print("DASHBOARD DEBUG - ALL NOTIFS >>> ${notificationsList.length}");
        for (var n in notificationsList) {
          print("DASHBOARD DEBUG - NOTIF: $n");
        }
        print("ALL NOTIFS >>> ${notificationsList.length}");
        for (var n in notificationsList) {
          final st = (n['service_type'] ?? '').toString().toLowerCase();
          final dt = n['appointment_datetime'];
          print("NOTIF SERVICE_TYPE=$st appointment_datetime=$dt raw=$n");
        }
        for (var n in notificationsList) {
          final serviceType = (n['service_type'] ?? '').toString().toLowerCase();
          if (serviceType == 'vet') {
            print("VET NOTIF >>> $n");
          }
        }
      } else {
        print("NOTIFICATIONS: empty or not 200");
        notificationsList.value = [];
      }
    } catch (e, s) {
      print("ERROR NOTIFICATIONS >>> $e");
      print(s);
      notificationsList.value = [];
    } finally {
      isLoading.value = false;
      print("<< EXIT loadNotifications()");
    }
  }

  Future<void> loadFollowUpsForCurrentUser() async {
    try {
      isLoading.value = true;
      final headers = await _getHeaders();

      // Try to get current user id via /auth/me
      final meResp = await api.get("/auth/me", headers: headers);
      int? userId;
      if (meResp.statusCode == 200 && meResp.body != null) {
        userId = (meResp.body['id'] as int?) ?? (meResp.body['user_id'] as int?);
      }

      if (userId == null) {
        // fallback: try direct endpoint for token owner (if available)
        final respDirect = await api.get("/follow-ups/user", headers: headers);
        if (respDirect.statusCode == 200 && respDirect.body != null) {
          followUpsList.value = List<Map<String, dynamic>>.from(respDirect.body);
          print("FOLLOWUPS (direct) LOADED >>> ${followUpsList.length}");
          return;
        } else {
          followUpsList.value = [];
          return;
        }
      }

      final response = await api.get("/follow-ups/user/$userId", headers: headers);
      print("FOLLOWUPS STATUS >>> ${response.statusCode}");
      print("FOLLOWUPS BODY >>> ${response.body}");
      if (response.statusCode == 200 && response.body != null) {
        followUpsList.value = List<Map<String, dynamic>>.from(response.body);
        print("FOLLOWUPS LOADED >>> ${followUpsList.length}");
      } else {
        followUpsList.value = [];
      }
    } catch (e) {
      print("ERROR FOLLOWUPS >>> $e");
      followUpsList.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMyAppointments() async {
    try {
      isLoading.value = true;
      final headers = await _getHeaders();
      final response = await api.get("/vet-appointments/my", headers: headers);
      print("MY APPOINTMENTS STATUS >>> ${response.statusCode}");
      print("MY APPOINTMENTS BODY >>> ${response.body}");
      if (response.statusCode == 200 && response.body != null) {
        myAppointmentsList.value = List<Map<String, dynamic>>.from(response.body);
        print("MY APPOINTMENTS LOADED >>> ${myAppointmentsList.length}");
      } else {
        myAppointmentsList.value = [];
      }
    } catch (e) {
      print("ERROR myAppointments >>> $e");
      myAppointmentsList.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // NEW: load grooming appointments for current user (client)
  Future<void> loadMyGroomAppointments() async {
    try {
      isLoading.value = true;
      final headers = await _getHeaders();
      // intento endpoint paralelo al de vet; ajusta si tu backend usa otra ruta
      final response = await api.get("/groom-appointments/my", headers: headers);
      print("MY GROOM APPOINTMENTS STATUS >>> ${response.statusCode}");
      print("MY GROOM APPOINTMENTS BODY >>> ${response.body}");
      if (response.statusCode == 200 && response.body != null) {
        myGroomAppointmentsList.value =
            List<Map<String, dynamic>>.from(response.body);
        print("MY GROOM APPOINTMENTS LOADED >>> ${myGroomAppointmentsList.length}");
      } else {
        // fallback: try user endpoint if backend exposes it
        final fallback = await api.get("/groom-appointments/user", headers: headers);
        if (fallback.statusCode == 200 && fallback.body != null) {
          myGroomAppointmentsList.value =
              List<Map<String, dynamic>>.from(fallback.body);
          print("MY GROOM APPOINTMENTS (fallback) LOADED >>> ${myGroomAppointmentsList.length}");
        } else {
          myGroomAppointmentsList.value = [];
        }
      }
    } catch (e) {
      print("ERROR myGroomAppointments >>> $e");
      myGroomAppointmentsList.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Public helper: refresh everything (callable from UI)
  Future<void> refreshAll() async {
    await loadAll();
  }
}
