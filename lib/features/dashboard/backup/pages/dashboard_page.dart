import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:peticare/features/dashboard/presentation/widgets/health_alerts.dart';
import 'package:peticare/features/dashboard/presentation/widgets/pet_widget.dart';
import 'package:peticare/features/dashboard/presentation/widgets/reminders_widget.dart';
import 'package:peticare/features/dashboard/presentation/widgets/todos_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalSpacing.lg(context),

                /// HEADER
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'dashboard_greeting'.trParams({
                                  'name': controller.userName.value,
                                }),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppPalette.textOnSecondaryBg(context),
                                  fontSize: 27,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: '\n${'dashboard_subtitle'.tr}',
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: AppPalette.disabled(context),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 16.0),

                      AnimatedIconButton(
                        iconData: Icons.shopping_cart,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          clipBehavior: Clip.none,
                          children: [
                            SvgPicture.asset(
                              'assets/illustrations/notification_bell.svg',
                              height: 35,
                            ),
                            Positioned(
                              top: -6.0,
                              right: 0.0,
                              child: Container(
                                height: 17.5,
                                width: 17.5,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppPalette.danger(context),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "3",
                                  style: AppTextStyles.playfulTag.copyWith(
                                    fontSize: 12,
                                    color: AppPalette.lBackground,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onClick: () {
                          Get.toNamed('/Notifications');
                        },
                      ),
                    ],
                  ),
                ),

                VerticalSpacing.xl(context),

                /// 🔥 PETS REALES
                SizedBox(
                  height: 235,
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.petsList.length,
                          itemBuilder: (context, index) {
                            final pet = controller.petsList[index];

                            return Padding(
                              padding: index == 0
                                  ? EdgeInsets.only(
                                      left: screenSize.width * 0.05,
                                      right: 10,
                                    )
                                  : index ==
                                          controller.petsList.length - 1
                                      ? EdgeInsets.only(
                                          left: 10,
                                          right: screenSize.width * 0.05,
                                        )
                                      : const EdgeInsets.symmetric(
                                          horizontal: 10),
                              child: petWidget(
                                context,
                                screenSize,
                                pet,
                              ),
                            );
                          },
                        ),
                ),

                VerticalSpacing.xxl(context),

                /// TODOS (de momento igual)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                  ),
                  child: Text(
                    'dashboard_todos_today'.tr,
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 17,
                      color: AppPalette.textOnSecondaryBg(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                VerticalSpacing.md(context),

                TodosWidget(),

                VerticalSpacing.xl(context),

                /// UPCOMING EVENTS (igual por ahora)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                  ),
                  child: Text(
                    'dashboard_upcoming_events'.tr,
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 17,
                      color: AppPalette.textOnSecondaryBg(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                VerticalSpacing.md(context),

                remindersWidget(context, []),

                VerticalSpacing.xl(context),

                /// ALERTAS
                healthAlerts(context, screenSize),

                VerticalSpacing.xxl(context),
              ],
            ),
          );
        }),
      ),
    );
  }
}