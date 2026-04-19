import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationsController extends GetxController {

  var notificationsList = [].obs;
  var isLoading = false.obs;

  final storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;

      final token = await storage.read(key: 'access_token');

      final api = GetConnect();

      final response = await api.get(
        "http://192.168.40.54:8000/api/v1/notifications",
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("NOTIFICATIONS STATUS >>> ${response.statusCode}");
      print("NOTIFICATIONS BODY >>> ${response.body}");

      if (response.statusCode == 200) {
        notificationsList.value = response.body;
      } else {
        notificationsList.value = [];
      }

    } catch (e) {
      print("ERROR NOTIFICATIONS >>> $e");
      notificationsList.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}