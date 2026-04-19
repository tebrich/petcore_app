import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/features/groom_appointments/presentation/controllers/add_new_groom_appointment_page_controller.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/appointment_type_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/date_time_selection_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/mobility_selection_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/pet_selection_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/review_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/success_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/groomer_selection_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/welcoming_first_page.dart';

/// A multi-step wizard page for creating a new grooming appointment.
///
/// This page orchestrates the entire appointment booking process using a `PageView`
/// to navigate through a series of steps. The state and logic for this flow are
/// managed by the [AddNewGroomAppointmentPageController].
///
/// The sequence of steps is as follows:
/// 1.  **Welcome:** An introductory screen.
/// 2.  **Pet Selection:** User chooses which pet the appointment is for.
/// 3.  **Appointment Type:** User selects the type of grooming service.
/// 4.  **Date & Time:** User picks a date and time for the appointment.
/// 5.  **Mobility:** User chooses between in-clinic or mobile grooming.
/// 6.  **Groomer Selection:** User selects a specific groomer or clinic.
/// 7.  **Review & Pay:** A summary of the appointment details and payment options.
/// 8.  **Success:** A confirmation screen shown after the appointment is booked.
///
/// The page features a dynamic `BottomNavigationBar` that adapts its content
/// based on the current step. For most steps, it displays a "Continue" button
/// that is enabled or disabled based on whether the user has made a valid
/// selection on the current page. On the "Review & Pay" step, the bottom bar
/// expands to show payment details and a confirmation button.
class AddNewGroomAppoitnmentPage extends StatelessWidget {
  const AddNewGroomAppoitnmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GetBuilder<AddNewGroomAppointmentPageController>(
      init: AddNewGroomAppointmentPageController(),
      builder: (addNewGroomAppointmentPageController) {
        return Scaffold(
          body: SafeArea(
            child: PageView(
              controller: addNewGroomAppointmentPageController.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                welcomingFirstPage(screenSize),

                petSelectionPage(
                  screenSize,
                  addNewGroomAppointmentPageController,
                ),
                appointmentTypeSelectionPage(
                  screenSize,
                  addNewGroomAppointmentPageController,
                ),
                dateTimeSelectionPage(
                  screenSize,
                  addNewGroomAppointmentPageController,
                ),
                mobilitySelectionPage(
                  screenSize,
                  addNewGroomAppointmentPageController,
                ),
                groomerSelectionPage(
                  screenSize,
                  addNewGroomAppointmentPageController,
                ),
                reviewAndPayPage(
                  screenSize,
                  addNewGroomAppointmentPageController,
                ),
                successPage(screenSize),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: addNewGroomAppointmentPageController.currentPage == 6.0
                  ? 150
                  : 61,
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: AppPalette.background(context),
                boxShadow:
                    addNewGroomAppointmentPageController.currentPage == 6.0
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .1),
                          offset: Offset(0, -3),
                          blurRadius: 3,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .05),
                          offset: Offset(0, -1),
                          blurRadius: 1,
                        ),
                      ],
              ),
              alignment: Alignment.center,
              child: addNewGroomAppointmentPageController.currentPage != 6.0
                  ? AnimatedElevatedButton(
                      text:
                          addNewGroomAppointmentPageController.currentPage ==
                              7.0
                          ? 'Done'
                          : 'Continue',
                      size: Size(screenSize.width * 0.85, 45),
                      onClick:
                          ((addNewGroomAppointmentPageController.currentPage == 1.0 &&
                                  addNewGroomAppointmentPageController.selectedPetId == null) ||
                              (addNewGroomAppointmentPageController.currentPage == 2.0 &&
                                  addNewGroomAppointmentPageController.appointmentType == null) ||
                              (addNewGroomAppointmentPageController.currentPage == 4.0 &&
                                  addNewGroomAppointmentPageController.isMobileGrooming == null) ||
                              (addNewGroomAppointmentPageController.currentPage == 5.0 &&
                                  addNewGroomAppointmentPageController.selectedGroomerID == null))
                          ? null
                          : () {
                              if (addNewGroomAppointmentPageController
                                      .currentPage ==
                                  7.0) {
                                Get.back();
                              } else {
                                addNewGroomAppointmentPageController
                                    .pageController
                                    .nextPage(
                                      duration: const Duration(
                                        milliseconds: 150,
                                      ),
                                      curve: Curves.linear,
                                    );
                              }
                            },
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: AppPalette.background(context),
                          //color: Colors.transparent,
                          child: ListTile(
                            onTap: () {},
                            splashColor: AppPalette.primary.withValues(
                              alpha: .1,
                            ),
                            title: Text(
                              'Payment method',
                              style: AppTextStyles.headingMedium.copyWith(
                                color: AppPalette.textOnSecondaryBg(context),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.ccVisa,
                                    size: 25,
                                    color: AppPalette.primary,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "************ 1234",
                                      style: AppTextStyles.playfulTag.copyWith(
                                        color: AppPalette.textOnSecondaryBg(
                                          context,
                                        ).withValues(alpha: .8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppPalette.textOnSecondaryBg(context),
                              size: 24,
                            ),
                          ),
                        ),
                        AnimatedElevatedButton(
                          text: 'Confirm',
                          size: Size(screenSize.width * 0.85, 45),
                          onClick: () {
                            addNewGroomAppointmentPageController.pageController
                                .nextPage(
                                  duration: const Duration(milliseconds: 150),
                                  curve: Curves.linear,
                                );
                          },
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
