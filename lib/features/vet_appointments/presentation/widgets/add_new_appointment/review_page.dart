import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/vet_appointments/presentation/controllers/add_new_vet_appointment_page_controller.dart';

Widget reviewAndPayPage(
  Size size,
  AddNewVetAppointmentPageController controller,
) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Revisar y confirmar"),
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
            Text("Vet ID: ${controller.selectedVetID ?? '-'}"),

            VerticalSpacing.sm(Get.context!),

            /// 🩺 Servicio
            const Text(
              "Servicio",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(controller.appointmentType ?? "-"),

            VerticalSpacing.sm(Get.context!),

            /// 📅 Fecha
            const Text(
              "Fecha y Hora",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              controller.appointmentDateTime != null
                  ? controller.appointmentDateTime.toString()
                  : "-",
            ),

            VerticalSpacing.md(Get.context!),

            /// ⚠️ Aviso
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "El precio final puede variar dependiendo del diagnóstico del veterinario.",
              ),
            ),

            VerticalSpacing.md(Get.context!),

            /// 🔘 Recordatorio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Agregar recordatorio"),
                Switch(value: false, onChanged: (v) {}),
              ],
            ),

            /// 🔘 Calendario
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Agregar al calendario"),
                Switch(value: false, onChanged: (v) {}),
              ],
            ),

            VerticalSpacing.md(Get.context!),

            /// 💳 Método de pago
            const Text(
              "Método de pago",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            VerticalSpacing.sm(Get.context!),

            _paymentCard(),

            VerticalSpacing.lg(Get.context!),

            /// 🔥 Botón pagar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print("💳 PAGAR CITA");

                  Get.snackbar(
                    "Pago",
                    "Aquí conectamos la pasarela de pago",
                  );
                },
                child: const Text("Pagar"),
              ),
            ),

            VerticalSpacing.lg(Get.context!),
          ],
        ),
      ),
    ),
  );
}

/// 💳 Tarjeta reutilizada (simple y segura)
Widget _paymentCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const Icon(Icons.credit_card),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Visa **** 1234",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Exp: 09/29"),
          ],
        ),
        const Spacer(),
        const Icon(Icons.check_circle, color: Colors.green),
      ],
    ),
  );
}