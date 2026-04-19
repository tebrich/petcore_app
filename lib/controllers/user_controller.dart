import 'package:get/get.dart';

/// Modelo mínimo de usuario (solo lo que necesitamos ahora)
class AppUser {
  final int id;
  final String email;

  AppUser({
    required this.id,
    required this.email,
  });
}

class UserController extends GetxController {
  /// Usuario logueado
  late AppUser user;

  /// Inicializar usuario después del login
  void setUser({
    required int id,
    required String email,
  }) {
    user = AppUser(
      id: id,
      email: email,
    );
  }

  bool get isLoggedIn => user.id > 0;
}

