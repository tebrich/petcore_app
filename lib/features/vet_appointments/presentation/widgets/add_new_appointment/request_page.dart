import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/vet_appointments/presentation/controllers/add_new_vet_appointment_page_controller.dart';

Widget requestAppointmentPage(
  Size size,
  AddNewVetAppointmentPageController controller,
) {
  final formattedDate = controller.appointmentDateTime != null
      ? DateFormat("dd/MM/yyyy - HH:mm")
          .format(controller.appointmentDateTime!)
      : "-";

  return SafeArea(
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Solicitar cita"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: size.width * .05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            VerticalSpacing.md(Get.context!),

            /// 🐶 Mascota
            const Text(
              "Mascota",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(controller.selectedPetName ?? "-"),

            VerticalSpacing.sm(Get.context!),

            /// 🏥 Veterinaria
            const Text(
              "Veterinaria",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              controller.selectedVetID != null
                  ? (controller.vetsList
                          .firstWhere(
                            (vet) => vet["id"] == controller.selectedVetID,
                            orElse: () => {},
                          )["name"] ??
                      "Veterinaria")
                  : "-",
            ),

            VerticalSpacing.sm(Get.context!),

            /// 🩺 Servicio
            const Text(
              "Servicio",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(controller.appointmentType ?? "-"),

            VerticalSpacing.sm(Get.context!),

            /// 📅 Fecha y Hora
            const Text(
              "Fecha y Hora",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(formattedDate),

            VerticalSpacing.md(Get.context!),

            /// ⚠️ MENSAJE UX CLARO
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Tu solicitud será enviada a la veterinaria.\n\n"
                "Podrás ver su estado en:\n"
                "🔔 Alertas o 📅 Mis citas.\n\n"
                "Recibirás una notificación cuando sea confirmada, rechazada o reprogramada.",
                style: TextStyle(height: 1.4),
              ),
            ),

            VerticalSpacing.lg(Get.context!),
          ],
        ),
      ),
    ),
  );
}