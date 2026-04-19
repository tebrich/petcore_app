import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/controllers/global_controller.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:peticare/features/pets/presentation/pages/pets_page.dart';
import 'package:peticare/features/post_signup/presentation/pages/post_signup_welcome_page.dart';
import 'package:peticare/features/settings/presentation/pages/main_settings_page.dart';
import 'package:peticare/features/shopping/presentation/pages/shopping_page.dart';

/// The main screen of the application that hosts the primary navigation structure.
///
/// This widget serves as the root for the app's main sections, using a [PageView]
/// to display the different pages and a [ConvexAppBar] for bottom navigation.
/// It relies on the [GlobalController] to manage the state of the currently
/// selected page.
///
/// The navigation bar has a special "add" button in the center which triggers a
/// separate action ([PostSignupWelcomePage]) instead of switching pages.
class HomePage extends GetView<GlobalController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds the widget when the global state changes (e.g., theme or page index).
    return GetBuilder<GlobalController>(
      builder: (globalController) {
        return Scaffold(
          body: PageView(
            // The controller is linked to the GlobalController to sync page views.
            controller: globalController.pageController,
            // Disables swiping between pages to enforce navigation via the bottom bar.
            physics: const NeverScrollableScrollPhysics(),
            children: [
              DashboardPage(),
              PetsPage(),
              ShoppingPage(),
              MainSettingsPage(),
            ],
          ),
          bottomNavigationBar: ConvexAppBar(
            initialActiveIndex: globalController.menuSelectedIndex,
            shadowColor: Theme.brightnessOf(context) == Brightness.dark
                ? AppPalette.lBackground.withValues(alpha: .2)
                : null,
            // Handles tap events on the navigation items.
            onTap: (value) => value == 2
                // The center button (index 2) opens the "Add Pet" flow.
                ? Get.to(
                    () => PostSignupWelcomePage(isPostSigning: false),
                    transition: Transition.downToUp,
                  )
                // Other buttons update the page index in the GlobalController.
                : globalController.updateMenuSelectedIndex(
                    // Adjusts the index to account for the special center button.
                    // If the tapped index is > 2, we subtract 1 to match the PageView index.
                    value < 2 ? value : value - 1,
                  ),
            style: TabStyle.fixedCircle,
            color: AppPalette.surfaces(context),
            backgroundColor: AppPalette.background(context),
            activeColor: AppPalette.primary,
            items: [
              // Dashboard / Home
              TabItem(
                icon: Icon(
                  FontAwesomeIcons.house,
                  size: globalController.menuSelectedIndex == 0 ? 25 : 18,
                  color: globalController.menuSelectedIndex == 0
                      ? AppPalette.primary
                      : AppPalette.primaryText(context),
                ),
              ),
              // My Pets
              TabItem(
                icon: Icon(
                  FontAwesomeIcons.paw,
                  size: globalController.menuSelectedIndex == 1 ? 25 : 18,
                  color: globalController.menuSelectedIndex == 1
                      ? AppPalette.primary
                      : AppPalette.primaryText(context),
                ),
              ),
              // Add Pet (Center Button)
              TabItem(icon: Icon(FontAwesomeIcons.plus)),
              // Shopping
              TabItem(
                icon: Icon(
                  FontAwesomeIcons.cartShopping,
                  size: globalController.menuSelectedIndex == 2 ? 25 : 18,
                  color: globalController.menuSelectedIndex == 2
                      ? AppPalette.primary
                      : AppPalette.primaryText(context),
                ),
              ),
              // Settings / Profile
              TabItem(
                icon: Icon(
                  FontAwesomeIcons.solidUser,
                  size: globalController.menuSelectedIndex == 3 ? 25 : 18,
                  color: globalController.menuSelectedIndex == 3
                      ? AppPalette.primary
                      : AppPalette.primaryText(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
