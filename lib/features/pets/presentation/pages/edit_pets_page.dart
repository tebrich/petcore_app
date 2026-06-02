import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/pet_avatar_widget.dart';

import 'package:peticare/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:peticare/features/pets/presentation/pages/edit_pet_page.dart';


class EditPetsPage extends StatelessWidget {
  const EditPetsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<DashboardController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Mascotas"),
      ),

      body: Obx(() {

        if (controller.petsList.isEmpty) {
          return const Center(
            child: Text("No tienes mascotas"),
          );
        }

        return ListView.builder(
          itemCount: controller.petsList.length,

          itemBuilder: (_, index) {

            final pet = controller.petsList[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),

              child: ListTile(

                leading: PetAvatarWidget(
                  pet: pet,
                  radius: 28,
                ),


                title: Text(
                  pet["name"] ?? "Mascota",
                ),

                subtitle: Text(
                  "${pet["species"] ?? "-"} • ${pet["breed"] ?? "-"}",
                ),

                trailing: ElevatedButton(
                  onPressed: () {

                    Get.to(
                          () => EditPetPage(
                        pet: pet,
                      ),
                    );
                  },

                  child: const Text("Editar"),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

