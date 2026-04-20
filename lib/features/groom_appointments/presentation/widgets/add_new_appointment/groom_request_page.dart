import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/groom_appointments/presentation/controllers/add_new_groom_appointment_page_controller.dart';

Widget groomRequestAppointmentPage(
  Size size,
  AddNewGroomAppointmentPageController controller,
) {
  final formattedDate = controller.appointmentDateTime != null
      ? DateFormat("dd/MM/yyyy - HH:mm")
          .format(controller.appointmentDateTime!)
      : "-";

  // Peluquería seleccionada (igual lógica que en review_page)
  final groomer = controller.groomersList.firstWhereOrNull(
    (g) => g['id'].toString() == controller.selectedGroomerID,
  );

  final bool isMobile = controller.isMobileGrooming ?? false;

  return SafeArea(
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Solicitar servicio de grooming"),
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
            Text(controller.selectedPet?['name'] ?? "-"),

            VerticalSpacing.sm(Get.context!),

            /// ✂️ Peluquería
            const Text(
              "Peluquería",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              groomer != null ? (groomer['name'] ?? 'Peluquería') : "-",
            ),

            VerticalSpacing.sm(Get.context!),

            /// 🧼 Servicio de grooming
            const Text(
              "Servicio",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(controller.appointmentType ?? "-"),

            VerticalSpacing.sm(Get.context!),

            /// 🏠 Modalidad
            const Text(
              "Modalidad",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(isMobile ? "A domicilio" : "En clínica"),

            VerticalSpacing.sm(Get.context!),

            /// 📅 Fecha y Hora
            const Text(
              "Fecha y Hora",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(formattedDate),

            VerticalSpacing.md(Get.context!),

            /// ⚠️ MENSAJE UX CLARO (ADAPTADO A GROOMING)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Tu solicitud será enviada a la peluquería.\n\n"
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

