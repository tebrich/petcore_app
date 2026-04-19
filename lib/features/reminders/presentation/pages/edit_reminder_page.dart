import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditReminderPage extends StatefulWidget {
  final Map<String, dynamic> reminder;

  const EditReminderPage({super.key, required this.reminder});

  @override
  State<EditReminderPage> createState() => _EditReminderPageState();
}

class _EditReminderPageState extends State<EditReminderPage> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  TimeOfDay? selectedTime;
  String selectedType = "";

  @override
  void initState() {
    super.initState();

    titleController.text = widget.reminder["title"] ?? "";
    noteController.text = widget.reminder["notes"] ?? "";
    selectedType = widget.reminder["type"] ?? "";

    if (widget.reminder["time"] != null) {
      final parts = widget.reminder["time"].split(":");
      selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }
  }

  /// 🔹 MAP TYPE → LABEL
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

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void saveReminder() async {

    final api = GetConnect();

    final body = {
      "title": titleController.text.trim(),
      "notes": noteController.text.trim(),
      "reminder_time": selectedTime != null
          ? "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00"
          : null,
    };

    print("BODY EDIT >>> $body");

    await api.put(
      "http://192.168.40.54:8000/api/v1/reminders/update/${widget.reminder["id"]}",
      body,
    );

    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Recordatorio"),
      ),

      /// 🔥 SOLUCIÓN OVERFLOW + TECLADO
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🏷 TIPO (SOLO LECTURA)
              const Text(
                "Tipo",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade200,
                ),
                child: Text(mapTypeLabel(selectedType)),
              ),

              const SizedBox(height: 16),

              /// 📝 TÍTULO
              const Text(
                "Título",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// 🗒 NOTAS
              const Text(
                "Notas",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// ⏰ HORA
              const Text(
                "Hora",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: pickTime,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : "Seleccionar hora",
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// 💾 GUARDAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveReminder,
                  child: const Text("Guardar cambios"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}