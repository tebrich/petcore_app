import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/notifications/pages/alerts_page.dart';
import 'package:peticare/features/notifications/pages/appointments_page.dart';

/// A stateful widget that displays the main Notifications screen.
///
/// This page consists of an `AppBar` with a title and a sub-menu for
/// switching between "Alerts" and "Appointments" categories. The main content
/// is a `PageView` that displays the corresponding page based on the selected
/// category.
///
/// The `AppBar` includes:
/// - An `AnimatedIconButton` for navigating back.
/// - A title "Notifications".
/// - A sub-menu built using the `_subMenuBuilder` method, which allows the
///   user to select either "Alerts" or "Appointments".
///
/// The `PageView` displays either the `AlertsPage` or the `AppointmentsPage`,
/// and its state is managed by a `PageController`. The `isAlertsPage` boolean
/// determines which page is currently visible.
///
/// The `initState` method initializes the `PageController` and sets
/// `isAlertsPage` to true, indicating that the "Alerts" page is initially
/// selected.

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

/// The state for the [NotificationsPage] widget.
///
/// This class manages the state of the `PageView` and the sub-menu,
/// including the current page index and the `isAlertsPage` boolean that
/// determines which category is selected.
class _NotificationsPageState extends State<NotificationsPage> {
  late PageController pageController;
  late bool isAlertsPage;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    isAlertsPage = true;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
              children: [
                AnimatedIconButton(
                  iconData: Platform.isIOS
                      ? Icons.arrow_back_ios_new_rounded
                      : Icons.arrow_back_rounded,
                  foregroundColor: AppPalette.primaryText(context),
                  iconSize: 24,
                  onClick: () => Get.back(),
                ),

                /// Some Spacing
                const SizedBox(width: 16.0),

                Text(
                  'Notificaciones',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            /// Space after title
            VerticalSpacing.lg(context),
            _subMenuBuilder(screenSize),
          ],
        ),
      ),
      body: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        child: PageView(
          controller: pageController,
          onPageChanged: (value) => setState(() {
            isAlertsPage = value == 0;
          }),
          children: [AlertsPage(), AppointmentsPage()],
        ),
      ),
    );
  }

  /// A private helper widget that builds the sub-menu for switching between
  /// "Alerts" and "Appointments".
  ///
  /// This widget consists of two `Expanded` widgets, each containing a
  /// `GestureDetector` and an `AnimatedContainer`. Tapping on a category
  /// animates the `PageView` to the corresponding page and updates the
  /// `isAlertsPage` boolean.
  /// [screenSize] - The size of the screen
  Widget _subMenuBuilder(Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.linear,
                );
                setState(() {
                  isAlertsPage = true;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isAlertsPage
                      ? AppPalette.textOnSecondaryBg(context)
                      : AppPalette.primary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.all(Radius.circular(7.5)),
                ),
                child: Text(
                  "Alertas",
                  style: AppTextStyles.buttonText.copyWith(
                    fontSize: 16,
                    color: isAlertsPage
                        ? AppPalette.lBackground
                        : AppPalette.textOnSecondaryBg(context),
                  ),
                ),
              ),
            ),
          ),

          /// Minor Horizontal Spacing
          const SizedBox(width: 16.0),

          Expanded(
            child: GestureDetector(
              onTap: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.linear,
                );
                setState(() {
                  isAlertsPage = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isAlertsPage
                      ? AppPalette.textOnSecondaryBg(context)
                      : AppPalette.primary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.all(Radius.circular(7.5)),
                ),
                child: Text(
                  "Cita",
                  style: AppTextStyles.buttonText.copyWith(
                    fontSize: 16,
                    color: !isAlertsPage
                        ? AppPalette.lBackground
                        : AppPalette.textOnSecondaryBg(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
