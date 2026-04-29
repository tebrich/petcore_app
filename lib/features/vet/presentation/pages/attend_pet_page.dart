// C:\peticare\peticare_app\lib\features\vet\presentation\pages\attend_pet_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import '../controllers/attend_pet_controller.dart';

class AttendPetPage extends StatelessWidget {
  final int petId;
  final int? appointmentId;
  const AttendPetPage({required this.petId, this.appointmentId, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AttendPetController(petId: petId, appointmentId: appointmentId));

    final weightCtrl = TextEditingController();
    final tempCtrl = TextEditingController();
    final diagCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Ficha clínica / Atención")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final pet = controller.pet;
        weightCtrl.text = pet['weight_kg']?.toString() ?? '';
        tempCtrl.text = pet['temperature_c']?.toString() ?? '';
        diagCtrl.text = pet['diagnosis_text'] ?? '';
        notesCtrl.text = '';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: avatar + pet name (owner info removed)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar: photo_url -> network, else local SVG by avatar_code, else icon
                  Obx(() {
                    final petMap = controller.pet;
                    final avatarUrl = petMap['photo_url'] as String?;
                    final avatarCode = petMap['avatar_code'] as String?;
                    if (avatarUrl != null && avatarUrl.isNotEmpty) {
                      return ClipOval(child: Image.network(avatarUrl, width: 80, height: 80, fit: BoxFit.cover));
                    }
                    // Temporarily do NOT attempt to load SVG from assets (avoid async load crash)
                    // Show avatarCode text as placeholder until you add real SVG files.
                    if (avatarCode != null && avatarCode.isNotEmpty) {
                      return Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppPalette.primary.withOpacity(.1)),
                        alignment: Alignment.center,
                        child: Text(avatarCode, style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    }
                    return Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppPalette.primary.withOpacity(.1)),
                      child: const Icon(Icons.pets, size: 40),
                    );
                  }),

                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(controller.pet['name'] ?? 'Mascota', style: AppTextStyles.headingMedium)),
                        const SizedBox(height: 6),
                        // Removed owner fields as requested
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Raza editable (dropdown)
              Obx(() {
                final selectedBreedId = controller.pet['breed_id'] as int?;
                final items = controller.breeds.map((b) {
                  final id = b['id'] as int?;
                  final name = (b['name'] ?? b['standardized_name']) as String?;
                  return DropdownMenuItem<int>(value: id, child: Text(name ?? ''));
                }).toList();

                return DropdownButtonFormField<int>(
                  value: selectedBreedId,
                  items: items,
                  onChanged: (v) {
                    if (v != null) controller.patchBreed(v);
                  },
                  decoration: const InputDecoration(labelText: 'Raza'),
                );
              }),

              const SizedBox(height: 12),

              // Form fields
              TextField(
                controller: weightCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: "Peso (kg)"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: tempCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: "Temperatura (°C)"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: diagCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Diagnóstico / Notas"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: "Observaciones adicionales"),
              ),
              const SizedBox(height: 12),

              // Reordered buttons: Subir examen, Próxima visita, Guardar visita
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Subir examen / archivo"),
                      onPressed: () {
                        Get.dialog(AlertDialog(
                          title: const Text("Subir examen"),
                          content: const Text("Aquí podrá seleccionar y subir archivos (implementación en el siguiente paso)."),
                          actions: [TextButton(onPressed: () => Get.back(), child: const Text("Cerrar"))],
                        ));
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.event_available),
                      label: const Text("Próxima visita"),
                      onPressed: () async {
                        final DateTime? date = await showDatePicker(
                          context: Get.context!,
                          initialDate: DateTime.now().add(const Duration(days: 30)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date == null) return;

                        // show dialog to enter note/motif
                        final TextEditingController motifCtrl = TextEditingController();
                        final time = await showTimePicker(context: Get.context!, initialTime: const TimeOfDay(hour: 9, minute: 0));
                        if (time == null) return;

                        final confirmed = await Get.dialog<bool>(
                          AlertDialog(
                            title: const Text("Motivo / Nota"),
                            content: TextField(controller: motifCtrl, decoration: const InputDecoration(hintText: "Ej: Vacuna antirrábica")),
                            actions: [
                              TextButton(onPressed: () => Get.back(result: false), child: const Text("Cancelar")),
                              TextButton(onPressed: () => Get.back(result: true), child: const Text("Confirmar")),
                            ],
                          ),
                        );

                        if (confirmed != true) return;

                        final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                        final note = motifCtrl.text;

                        final success = await controller.createFollowUpAppointment(dt, appointmentType: "vaccine", note: note);
                        if (success) {
                          Get.showSnackbar(const GetSnackBar(message: "Próxima visita propuesta creada", duration: Duration(seconds: 2)));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final weight = weightCtrl.text.isNotEmpty ? double.tryParse(weightCtrl.text) : null;
                        final temp = tempCtrl.text.isNotEmpty ? double.tryParse(tempCtrl.text) : null;
                        final diag = diagCtrl.text.isNotEmpty ? diagCtrl.text : null;
                        final notes = notesCtrl.text.isNotEmpty ? notesCtrl.text : null;

                        await controller.savePetEdits(weightKg: weight, temperatureC: temp, diagnosis: diag);

                        final recordId = await controller.createMedicalRecord(
                          weightKg: weight,
                          temperatureC: temp,
                          diagnosis: diag,
                          notes: notes,
                        );

                        if (recordId != null) {
                          Get.showSnackbar(const GetSnackBar(message: "Visita registrada", duration: Duration(seconds: 2)));
                        }
                      },
                      child: const Text("Guardar visita"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Historial
              Text("Historial médico", style: AppTextStyles.bodyRegular.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              Obx(() {
                final records = controller.medicalRecords;
                if (records.isEmpty) {
                  return const Text("No hay registros médicos");
                }

                return Column(
                  children: records.map((r) {
                    final docs = (r['documents'] as List<dynamic>?) ?? [];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Fecha: ${r['visit_date'] ?? r['created_at']}", style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 6),
                            if (r['weight_kg'] != null) Text("Peso: ${r['weight_kg']} kg"),
                            if (r['temperature_c'] != null) Text("Temp: ${r['temperature_c']} °C"),
                            if (r['diagnosis_text'] != null) Text("Diagnóstico: ${r['diagnosis_text']}"),
                            if (r['notes'] != null) Text("Notas: ${r['notes']}"),
                            const SizedBox(height: 8),
                            if (docs.isNotEmpty) Text("Documentos:", style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w600)),
                            ...docs.map((d) {
                              final url = d['file_url'] as String? ?? '';
                              final name = d['original_name'] ?? d['file_url'];
                              return InkWell(
                                onTap: () async {
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                  } else {
                                    Get.showSnackbar(const GetSnackBar(message: "No se pudo abrir el documento", duration: Duration(seconds: 2)));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.picture_as_pdf, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(name, overflow: TextOverflow.ellipsis)),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.open_in_new, size: 16),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
