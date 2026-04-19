import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/groom_appointments/presentation/controllers/add_new_groom_appointment_page_controller.dart';

Widget groomerSelectionPage(
  Size screenSize,
  AddNewGroomAppointmentPageController controller,
) {
  return GetBuilder<AddNewGroomAppointmentPageController>(
    builder: (controller) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [

              VerticalSpacing.md(context),

              /// 🔙 BACK
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedIconButton(
                  iconData: Icons.arrow_back_rounded,
                  foregroundColor: AppPalette.primaryText(context),
                  onClick: controller.previousPage,
                ),
              ),

              /// 🧠 TITLE
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Text(
                  "Selecciona una peluquería",
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: constraints.maxHeight > 580 ? 30 : 26,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              VerticalSpacing.md(context),

              /// 📍 SELECTOR UBICACIÓN (🔥 NUEVO / RESTAURADO)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Row(
                  children: [

                    /// 🏠 DOMICILIO
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.useMobileLocation = false;
                          controller.fetchGroomers();
                          controller.update();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: controller.useMobileLocation == false
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.white,
                            border: Border.all(
                              color: controller.useMobileLocation == false
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text("Mi domicilio"),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// 📱 UBICACIÓN ACTUAL
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.useMobileLocation = true;
                          controller.fetchGroomers();
                          controller.update();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: controller.useMobileLocation == true
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.white,
                            border: Border.all(
                              color: controller.useMobileLocation == true
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text("Ubicación actual"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              VerticalSpacing.lg(context),

              /// 🔄 LOADING
              if (controller.isLoadingGroomers)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )

              /// ❌ SIN RESULTADOS
              else if (controller.groomersList.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text("No hay servicios disponibles"),
                  ),
                )

              /// ✅ LISTA
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.groomersList.length,
                    itemBuilder: (context, index) {
                      final groomer = controller.groomersList[index];

                      final isSelected =
                          controller.selectedGroomerID ==
                              groomer['id'].toString();

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: screenSize.width * 0.05,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            controller.updateSelectedGroomerID(
                              groomer['id'].toString(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// 📍 INFO
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      /// NAME
                                      Text(
                                        groomer['name'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      /// ADDRESS
                                      Text(
                                        groomer['address'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      /// DISTANCE
                                      if (groomer['distance_km'] != null)
                                        Text(
                                          "${groomer['distance_km']} km",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),

                                      const SizedBox(height: 6),

                                      /// ⭐ RATING
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${groomer['rating'] ?? 4.5}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                /// ✅ CHECK
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                    size: 28,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      );
    },
  );
}