import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/features/vet/presentation/controllers/groom_vet_appointments_controller.dart';

class GroomVetAppointmentsPage extends StatelessWidget {
  const GroomVetAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Citas Grooming"),
        centerTitle: true,
      ),
      body: GetX<GroomVetAppointmentsController>(
        init: GroomVetAppointmentsController(),
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.appointments.isEmpty) {
            return const Center(child: Text("No hay citas de grooming"));
          }

          return ListView.builder(
            itemCount: controller.appointments.length,
            itemBuilder: (context, index) {
              final appointment = controller.appointments[index];

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🐶 Mascota
                      Text(
                        appointment['pet_name'] ?? "Mascota",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// 👤 Cliente
                      Text(
                        "Cliente: ${appointment['owner_name'] ?? '-'}",
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 8),

                      /// 📅 Fecha
                      Text(
                        "📅 ${_formatDate(appointment['appointment_datetime'].toString())}",
                      ),

                      /// 🕒 Hora
                      Text(
                        "🕒 ${_formatTime(appointment['appointment_datetime'].toString())}",
                      ),

                      const SizedBox(height: 6),

                      /// 📌 Estado
                      Text(
                        "📌 ${_translateStatus(appointment['status'] ?? '')}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// 📞 Teléfono
                      Text("📞 ${appointment['phone'] ?? '-'}"),

                      /// ✉️ Email
                      Text("✉️ ${appointment['email'] ?? '-'}"),

                      const SizedBox(height: 12),

                      /// 🔥 BOTONES DINÁMICOS (igual que vet)
                      _buildActionButtons(appointment),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// 🔥 BOTONES SEGÚN ESTADO (GROOMING)
////////////////////////////////////////////////////////////////

Widget _buildActionButtons(Map<String, dynamic> appointment) {
  final status = appointment['status'];
  final controller = Get.find<GroomVetAppointmentsController>();

  /// 🟡 PENDING → aceptar / rechazar / reprogramar
  if (status == "pending") {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton(
          onPressed: () {
            controller.acceptAppointment(appointment['id']);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text("Aceptar"),
        ),
        ElevatedButton(
          onPressed: () {
            controller.rejectAppointment(appointment['id']);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text("Rechazar"),
        ),
        ElevatedButton(
          onPressed: () {
            _openRescheduleDialog(appointment['id']);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text("Reprogramar"),
        ),
      ],
    );
  }

  /// 🟢 ACCEPTED → atender (opcional)
  if (status == "accepted") {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          print("Atender grooming ${appointment['id']}");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        child: const Text("Atender"),
      ),
    );
  }

  /// 🔴 REJECTED / EXPIRED / RESCHEDULED
  return const SizedBox();
}

////////////////////////////////////////////////////////////////
/// 🔥 FORMATOS
////////////////////////////////////////////////////////////////

String _formatDate(String date) {
  final parsed = DateTime.parse(date);
  return "${parsed.day} de ${_monthName(parsed.month)} ${parsed.year}";
}

String _formatTime(String date) {
  final parsed = DateTime.parse(date);
  return "${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}";
}

String _monthName(int month) {
  const months = [
    "",
    "enero",
    "febrero",
    "marzo",
    "abril",
    "mayo",
    "junio",
    "julio",
    "agosto",
    "septiembre",
    "octubre",
    "noviembre",
    "diciembre",
  ];
  return months[month];
}

String _translateStatus(String status) {
  switch (status) {
    case "accepted":
      return "Aceptado";
    case "pending":
      return "Pendiente";
    case "rejected":
      return "Rechazado";
    case "expired":
      return "Expirado";
    case "rescheduled":
      return "Reprogramado";
    default:
      return status;
  }
}

void _openRescheduleDialog(int appointmentId) async {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  selectedDate = await showDatePicker(
    context: Get.overlayContext!,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );

  if (selectedDate == null) return;

  selectedTime = await showTimePicker(
    context: Get.overlayContext!,
    initialTime: TimeOfDay.now(),
  );

  if (selectedTime == null) return;

  final newDateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  Get.defaultDialog(
    title: "Confirmar",
    middleText: "¿Reprogramar cita a ${newDateTime.toString()}?",
    textConfirm: "Sí",
    textCancel: "No",
    onConfirm: () {
      Get.back();
      Get.find<GroomVetAppointmentsController>()
          .rescheduleAppointment(appointmentId, newDateTime);
    },
  );
}
