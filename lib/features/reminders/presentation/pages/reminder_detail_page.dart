import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'edit_reminder_page.dart';

class ReminderDetailPage extends StatelessWidget {
  final Map<String, dynamic> reminder;

  const ReminderDetailPage({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de Recordatorio"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text("Tipo", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(mapTypeLabel(reminder["type"])),
            const SizedBox(height: 16),

            const Text("Mascota", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(getPetName(reminder["pet_id"])),
            const SizedBox(height: 16),

            const Text("Hora", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(reminder["time"] ?? "-"),
            const SizedBox(height: 16),

            const Text("Notas", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(reminder["notes"] ?? "Sin notas"),
            const SizedBox(height: 30),

            /// 🗑 ELIMINAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Get.defaultDialog(
                    title: "Confirmar",
                    middleText: "¿Desea eliminar esta tarea?",
                    textConfirm: "Sí",
                    textCancel: "No",
                    onConfirm: () async {

                      final api = GetConnect();

                      await api.put(
                        "http://192.168.40.54:8000/api/v1/reminders/deactivate/${reminder["id"]}",
                        {},
                      );

                      Get.back();
                      Get.back();

                      Get.find<DashboardController>().loadReminders();
                    },
                  );
                },
                child: const Text("Eliminar"),
              ),
            ),

            const SizedBox(height: 16),

            /// ✏️ EDITAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Get.to(
                    () => EditReminderPage(reminder: reminder),
                  );

                  if (result != null) {
                    Get.find<DashboardController>().loadReminders();
                    Get.back();
                  }
                },
                child: const Text("Editar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String mapTypeLabel(String type) {
  switch (type) {
    case "feeding":
      return "Alimentación";
    case "medication":
      return "Medicación";
    case "walk":
      return "Paseo";
    case "clean":
      return "Limpieza";
    default:
      return type;
  }
}

String getPetName(dynamic petId) {
  final controller = Get.find<DashboardController>();

  final pet = controller.petsList.firstWhere(
    (p) => p["id"].toString() == petId.toString(),
    orElse: () => {"name": "Mascota"},
  );

  return pet["name"];
}