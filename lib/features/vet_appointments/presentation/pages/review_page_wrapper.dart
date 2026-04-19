import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:peticare/features/vet_appointments/presentation/widgets/add_new_appointment/review_page.dart';
import 'package:peticare/features/vet_appointments/presentation/controllers/add_new_vet_appointment_page_controller.dart';

class ReviewPageWrapper extends StatelessWidget {
  const ReviewPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text("Review OK")),
      body: Center(
        child: Text("ID: ${args?["appointment_id"]}"),
      ),
    );
  }
}