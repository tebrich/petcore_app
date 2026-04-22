import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';

import 'package:peticare/features/groom_appointments/presentation/controllers/add_new_groom_appointment_page_controller.dart';

import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/welcoming_first_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/pet_selection_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/appointment_type_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/date_time_selection_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/mobility_selection_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/groomer_selection_page.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/groom_request_page.dart';

// OJO: review_page.dart SE MANTIENE EN EL PROYECTO PARA USARLO
// DESDE EL DETALLE DE CITAS GROOMING (NO EN ESTE WIZARD)
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/review_page.dart';

class AddNewGroomAppoitnmentPage extends StatelessWidget {
  const AddNewGroomAppoitnmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GetBuilder<AddNewGroomAppointmentPageController>(
      init: AddNewGroomAppointmentPageController(),
      builder: (controller) {
        return Scaffold(
          body: PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              /// 0 - Bienvenida
              welcomingFirstPage(screenSize),

              /// 1 - Mascota
              petSelectionPage(screenSize, controller),

              /// 2 - Tipo de grooming
              appointmentTypeSelectionPage(screenSize, controller),

              /// 3 - Fecha y hora
              dateTimeSelectionPage(screenSize, controller),

              /// 4 - Modalidad (domicilio / clínica)
              mobilitySelectionPage(screenSize, controller),

              /// 5 - Peluquería
              groomerSelectionPage(screenSize, controller),

              /// 6 - Solicitar cita (REQUEST) 🔥
              groomRequestAppointmentPage(screenSize, controller),
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

              /// 🔥 BOTÓN ÚNICO (igual que en VET)
              child: AnimatedElevatedButton(
                text: controller.currentPage == 6
                    ? "Solicitar servicio"
                    : "Continuar",
                size: Size(screenSize.width * 0.85, 45),
                onClick: ((controller.currentPage == 1 &&
                            controller.selectedPetId == null) ||
                        (controller.currentPage == 2 &&
                            controller.appointmentType == null) ||
                        (controller.currentPage == 4 &&
                            controller.isMobileGrooming == null) ||
                        (controller.currentPage == 5 &&
                            controller.selectedGroomerID == null))
                    ? null
                    : () async {
                        // Última página del wizard → crear cita grooming PENDING
                        if (controller.currentPage == 6) {
                          await controller.createGroomAppointment(context);
                          // El popup se muestra dentro de createGroomAppointment
                        } else {
                          // Avanzar de página + updatePage (igual que vet)
                          await controller
                              .updatePage(controller.currentPage + 1);

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
