import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A [GetxController] to manage the global state of the application.
///
/// This controller is responsible for handling the state of the main navigation,
/// such as the selected index of a bottom navigation bar and controlling the
/// corresponding [PageView].
///
///> 💡 **Note**:  This project uses GetX for state management, but you can easily
/// swap it out for your preferred solution like Provider, BLoC, or Riverpod.
class GlobalController extends GetxController {
  /// Controls the [PageView] for the main app navigation.
  late PageController pageController;

  /// The currently selected index of the main menu/navigation.
  late int menuSelectedIndex;

  /// Updates the selected menu index and animates the [PageView] to the new page.
  ///
  /// [nextSelectedIndex] is the index of the page to navigate to.
  void updateMenuSelectedIndex(int nextSelectedIndex) {
    menuSelectedIndex = nextSelectedIndex;
    update();
    pageController.animateToPage(
      nextSelectedIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  /// Initializes the controller.
  void onInit() async {
    super.onInit();
    pageController = PageController(initialPage: 0);
    menuSelectedIndex = 0;
  }

  @override
  /// Disposes the controller and cleans up resources.
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}

/// A [Bindings] class for the [GlobalController].
///
/// This binding ensures that the [GlobalController] is properly initialized
/// and injected as a permanent dependency using `Get.put()`.
class GlobalControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController(), permanent: true);
  }
}
