import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:peticare/features/groom_appointments/presentation/controllers/add_new_groom_appointment_page_controller.dart';

Widget petSelectionPage(
  Size screenSize,
  AddNewGroomAppointmentPageController controller,
) {
  return SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) {

        final dashboardController = Get.find<DashboardController>();
        final petsList = dashboardController.petsList;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            VerticalSpacing.md(context),

            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedIconButton(
                iconData: Icons.arrow_back_rounded,
                foregroundColor: AppPalette.primaryText(context),
                onClick: () {
                  controller.pageController.previousPage(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.linear,
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
              ),
              child: Text(
                "¿Para qué mascota es la cita?",
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppPalette.textOnSecondaryBg(context),
                  fontSize: constraints.maxHeight > 580 ? 35 : 32,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            VerticalSpacing.lg(context),

            Expanded(
              child: ListView.builder(
                itemCount: petsList.length,
                itemBuilder: (context, index) {
                  final pet = petsList[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: screenSize.width * 0.05,
                    ),
                    child: Material(
                      color: controller.selectedPetId == pet['id']
                          ? AppPalette.primary.withValues(alpha: .25)
                          : AppPalette.background(context),
                      borderRadius: BorderRadius.circular(15),

                      child: ListTile(
                        onTap: () {
                          controller.updateSelectedPet(pet);
                        },

                        splashColor:
                            AppPalette.primary.withValues(alpha: .5),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: controller.selectedPetId == pet['id']
                                ? AppPalette.primary
                                : AppPalette.disabled(context)
                                    .withValues(alpha: .5),
                          ),
                        ),

                        contentPadding: EdgeInsets.all(16.0),

                        leading: pet['avatar'](
                          75.0,
                          0.9,
                          AppPalette.primary,
                        ),

                        title: Text(
                          pet['name'],
                          style: AppTextStyles.petName.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),
                        ),

                        trailing: controller.selectedPetId == pet['id']
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: AppPalette.primary,
                                size: 35,
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    ),
  );
}