import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peticare/core/network/api_client.dart';

class PendingPage extends StatefulWidget {
  final DateTime expiresAt;
  final String vetName;
  final DateTime appointmentDateTime;
  final int appointmentId; // 🔥 NUEVO

  const PendingPage({
    super.key,
    required this.expiresAt,
    required this.vetName,
    required this.appointmentDateTime,
    required this.appointmentId, // 🔥 NUEVO
  });

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  late Duration remaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    updateRemaining();

    /// 🔥 TIMER GLOBAL
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      updateRemaining();

      /// 🔥 cada 10 segundos revisa backend
      if (t.tick % 10 == 0) {
        checkAppointmentStatus();
      }
    });
  }

  /// ===============================
  /// ⏳ FIX TIMEZONE (CORRECTO)
  /// ===============================
  void updateRemaining() {
    final now = DateTime.now(); // ✅ LOCAL
    final diff = widget.expiresAt.difference(now); // ✅ YA VIENE LOCAL

    if (diff.isNegative) {
      timer?.cancel();
      remaining = Duration.zero;
    } else {
      remaining = diff;
    }

    setState(() {});
  }

  /// ===============================
  /// 🔍 CHECK STATUS (AUTO REFRESH)
  /// ===============================
  Future<void> checkAppointmentStatus() async {
    try {
      final response = await ApiClient.get(
        "/api/v1/vet-appointments/my",
        auth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final appointment = data.firstWhere(
          (a) => a["id"] == widget.appointmentId, // 🔥 CLAVE
          orElse: () => null,
        );

        if (appointment != null && appointment["status"] == "accepted") {

          timer?.cancel();

          /// 🚀 CAMBIO AUTOMÁTICO DE PANTALLA
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text("Cita confirmada")),
                body: const Center(
                  child: Text(
                    "El veterinario confirmó tu cita",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print("Error checking status: $e");
    }
  }

  /// ===============================
  /// ⏱ FORMAT TIME
  /// ===============================
  String formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);

    return "${hours}h ${minutes}m";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitud enviada"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            /// 🟡 TITULO
            const Text(
              "Esperando confirmación",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// 📍 VET
            Text(
              "Veterinaria: ${widget.vetName}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            /// 📅 FECHA
            Text(
              "Fecha: ${DateFormat("dd MMM yyyy – HH:mm").format(widget.appointmentDateTime)}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            /// 🧠 TEXTO PRO
            const Text(
              "El veterinario tiene hasta 2 horas para confirmar tu cita.\n"
              "Si no responde, la solicitud expirará automáticamente.",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 30),

            /// ⏳ COUNTDOWN
            Text(
              "Tiempo restante: ${formatDuration(remaining)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 30),

            /// 🔄 INFO
            const Text(
              "Puedes salir de esta pantalla. Te notificaremos cuando el veterinario responda.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}