import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/features/vet/presentation/controllers/groom_vet_appointments_controller.dart';

class AttendGroomPage extends StatefulWidget {
  final int petId;
  final int? appointmentId;

  const AttendGroomPage({
    required this.petId,
    this.appointmentId,
    super.key,
  });

  @override
  State<AttendGroomPage> createState() => _AttendGroomPageState();
}

class _AttendGroomPageState extends State<AttendGroomPage> {

  final controller = Get.find<GroomVetAppointmentsController>();

  Map<String, dynamic>? petData;

  final serviceCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  // 🔥 LOAD PET
  Future<void> loadPet() async {
    final res = await GetConnect().get(
      "http://192.168.40.54:8000/api/v1/pets/${widget.petId}",
    );

    if (res.statusCode == 200) {
      setState(() {
        petData = res.body;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadPet(); // 🔥 SE EJECUTA AL ENTRAR
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Atención Grooming")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 NOMBRE CORRECTO
            Text(
              "Mascota: ${petData?['name'] ?? '-'}",
              style: AppTextStyles.headingMedium,
            ),

            const SizedBox(height: 16),

            TextField(
              controller: serviceCtrl,
              decoration: const InputDecoration(
                labelText: "Tipo de servicio (Ej: Baño completo)",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Observaciones",
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );

                      if (date == null) return;

                      final success = await controller.createFollowUp(
                        petId: widget.petId,
                        scheduledAt: date,
                        note: notesCtrl.text,
                      );

                      if (success) {
                        Get.snackbar("OK", "Próximo servicio creado");
                      }
                    },
                    child: const Text("Próximo servicio"),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar("OK", "Servicio guardado");

                      // 🔥 REDIRECCIÓN
                      Get.offAllNamed('/VetHome');
                    },
                    child: const Text("Guardar"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}