import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/features/vet_appointments/presentation/controllers/add_new_vet_appointment_page_controller.dart';

import 'package:peticare/features/vet_appointments/presentation/widgets/add_new_appointment/appointment_type_page.dart';
import 'package:peticare/features/vet_appointments/presentation/widgets/add_new_appointment/date_time_selection_page.dart';
import 'package:peticare/features/vet_appointments/presentation/widgets/add_new_appointment/pet_selection_page.dart';
import 'package:peticare/features/vet_appointments/presentation/widgets/add_new_appointment/review_page.dart';
import 'package:peticare/features/vet_appointments/presentation/widgets/add_new_appointment/vet_selection_page.dart';
import 'package:peticare/features/vet_appointments/presentation/widgets/add_new_appointment/welcoming_first_page.dart';
import 'package:peticare/features/vet_appointments/presentation/widgets/add_new_appointment/request_page.dart';

class AddNewVetAppoitnmentPage extends StatelessWidget {
  const AddNewVetAppoitnmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GetBuilder<AddNewVetAppointmentPageController>(
      init: AddNewVetAppointmentPageController(),
      builder: (controller) {
        return Scaffold(
          body: PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              welcomingFirstPage(screenSize),
              petSelectionPage(screenSize, controller),
              appointmentTypeSelectionPage(screenSize, controller),
              dateTimeSelectionPage(screenSize, controller),
              vetSelectionPage(screenSize, controller),
              requestAppointmentPage(screenSize, controller), // 🔥 confirmar
            ],
          ),

          bottomNavigationBar: SafeArea(
            child: Container(
              height: 61,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppPalette.background(context),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    offset: const Offset(0, -1),
                    blurRadius: 2,
                  ),
                ],
              ),
              alignment: Alignment.center,

              /// 🔥 BOTÓN ÚNICO
              child: AnimatedElevatedButton(
                text: controller.currentPage == 5
                    ? "Solicitar cita"
                    : "Continuar",
                size: Size(screenSize.width * 0.85, 45),

                onClick:
                    ((controller.currentPage == 1 &&
                                controller.selectedPetId == null) ||
                            (controller.currentPage == 2 &&
                                controller.selectedAppointmentTypeId == null) ||
                            (controller.currentPage == 4 &&
                                controller.selectedVetID == null))
                        ? null
                        : () {

                            /// 🔥 SI ESTÁ EN REVIEW → CREA CITA
                            if (controller.currentPage == 5) {
                              controller.createAppointment(context);
                            } else {

                              /// 🔥 🔥 🔥 FIX REAL (NO MÁS LOOP)
                              controller.updatePage(controller.currentPage + 1);

                              controller.pageController.nextPage(
                                duration: const Duration(milliseconds: 150),
                                curve: Curves.linear,
                              );
                            }
                          },
              ),
            ),
          ),
        );
      },
    );
  }
}