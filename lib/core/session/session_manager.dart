import 'package:get/get.dart';

class SessionManager extends GetxService {
  String? token;
  Map<String, dynamic>? user;

  bool get isLoggedIn => token != null;
}
