import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/notifications/pages/alerts_page.dart';
import 'package:peticare/features/notifications/pages/appointments_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

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
  void dispose() {
    pageController.dispose();
    super.dispose();
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

  Widget _subMenuBuilder(Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (pageController.hasClients) {
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.linear,
                  );
                } else {
                  pageController.jumpToPage(0);
                }
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
          const SizedBox(width: 16.0),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (pageController.hasClients) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.linear,
                  );
                } else {
                  pageController.jumpToPage(1);
                }
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
