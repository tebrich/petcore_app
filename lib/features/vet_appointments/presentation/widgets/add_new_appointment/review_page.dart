import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/vet_appointments/presentation/controllers/add_new_vet_appointment_page_controller.dart';
import 'package:peticare/features/vet_appointments/data/services/vet_appointments_service.dart';
import 'package:peticare/features/vet_appointments/presentation/widgets/add_new_appointment/succes_page.dart';
import 'package:peticare/features/notifications/controllers/notifications_controller.dart';
import 'package:intl/intl.dart';

Widget reviewAndPayPage(
  Size size,
  AddNewVetAppointmentPageController controller,
) {
  /// 🔥 GARANTIZAR VETS + PRECIO EN REVIEW
  WidgetsBinding.instance.addPostFrameCallback((_) {
    print("📄 REVIEW MONTADO → FORZANDO loadPrice()");
    controller.loadPrice(); // 👈 IMPORTANTE

    if (controller.vetsList.isEmpty) {
      print("📡 FORZANDO LOAD VETS DESDE REVIEW");
      controller.loadVets();
    }
  });

  Future<void> _handlePay(BuildContext ctx) async {
    // show processing dialog (prevents double taps)
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      print("DBG REVIEW BEFORE PAY -> selectedPetId=${controller.selectedPetId} selectedPetName=${controller.selectedPetName}");
      final created = await controller.createAppointment(ctx);

      print("DBG CREATE APPT RESULT -> $created");

      if (!created) {
        Navigator.of(ctx).pop(); // close processing
        return;
      }

      // If controller knows appointmentId (e.g. from notification flow), try mark-paid
      final apptId = controller.appointmentId;
      bool paidOk = false;

      if (apptId != null) {
        paidOk = await VetAppointmentsService.markAppointmentPaid(apptId);
      } else {
        // If appointmentId not present, try to reload user's appointments and find the latest matching by datetime/vet/pet
        // (best-effort) then mark paid.
        try {
          final myList = await VetAppointmentsService.getMyAppointments();
          final match = myList.firstWhere(
            (a) =>
                a["pet_id"] == controller.selectedPetId &&
                a["vet_id"] == controller.selectedVetID &&
                a["appointment_datetime"] == controller.appointmentDateTime?.toIso8601String(),
            orElse: () => null,
          );
          if (match != null) {
            final foundId = match["id"] ?? match["appointment_id"] ?? match["id"];
            if (foundId != null) {
              paidOk = await VetAppointmentsService.markAppointmentPaid(foundId);
            }
          }
        } catch (e) {
          print("DBG unable to auto-find appointment id after create: $e");
        }
      }

      Navigator.of(ctx).pop(); // close processing

      if (paidOk) {
        controller.isReadOnly.value = true;

        // refresh notifications immediately
        try {
          final notifsCtrl = Get.find<NotificationsController>();
          await notifsCtrl.loadNotifications();
        } catch (e) {
          print("WARN: reload notifs failed -> $e");
        }
      }


      // refresh notifications / user data might be handled elsewhere; navigate to success only if paid or created
      Get.to(() => const SuccessPageScreen());
    } catch (e) {
      Navigator.of(ctx).pop(); // close processing
      print("ERROR PAY FLOW >>> $e");
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text("Error procesando el pago")),
      );
    }
  }

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

            Builder(
              builder: (_) {
                print("VETS LIST >>> ${controller.vetsList}");
                print("SELECTED VET ID >>> ${controller.selectedVetID}");
                return const SizedBox();
              },
            ),

            Obx(() {
              final vetName = controller.selectedVetID != null
                  ? (controller.vetsList
                          .firstWhere(
                            (vet) => vet["id"] == controller.selectedVetID,
                            orElse: () => {},
                          )["name"] ??
                      "Veterinaria")
                  : "-";

              return Text(vetName);
            }),

            VerticalSpacing.sm(Get.context!),

            /// 🩺 Servicio
            const Text(
              "Servicio",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(controller.appointmentType ?? "-"),

            /// 💰 PRECIO REAL MOSTRADO JUNTO AL SERVICIO
            Obx(() {
              final formatter = NumberFormat("#,##0", "es_PY"); // 50.000
              final formattedPrice = formatter.format(controller.servicePrice.value);

              return Text(
                "${controller.currency.value} $formattedPrice",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              );
            }),

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
                onPressed: controller.isReadOnly.value
                    ? null
                    : () async {
                        await _handlePay(Get.context!);
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
