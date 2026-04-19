import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/vet_appointments/presentation/controllers/add_new_vet_appointment_page_controller.dart';

Widget vetSelectionPage(
  Size screenSize,
  AddNewVetAppointmentPageController controller,
) {
  return SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final vetsList = controller.vetsList;

        return Column(
          children: [
            /// 🔝 BACK
            VerticalSpacing.md(context),

            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedIconButton(
                iconData: Icons.arrow_back_rounded,
                foregroundColor: AppPalette.primaryText(context),
                onClick: () {
                  controller.pageController.previousPage(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.linear,
                  );
                },
              ),
            ),

            /// 🏥 TITLE
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
              ),
              child: Text(
                "Selecciona una veterinaria",
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppPalette.textOnSecondaryBg(context),
                  fontSize: constraints.maxHeight > 580 ? 35 : 32,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            VerticalSpacing.md(context),

            /// 🔍 SEARCH (preparado para siguiente fase)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Buscar veterinaria...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            VerticalSpacing.md(context),

            /// 📍 SELECTOR DE UBICACIÓN (🔥 NUEVO)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// 🏠 DOMICILIO
                  ChoiceChip(
                    label: Text("Domicilio"),
                    selected: !controller.useMobileLocation,
                    selectedColor: AppPalette.primary.withValues(alpha: 0.2),
                    onSelected: (_) {
                      controller.toggleLocationMode(false);
                    },
                  ),

                  SizedBox(width: 10),

                  /// 📱 UBICACIÓN ACTUAL
                  ChoiceChip(
                    label: Text("Ubicación actual"),
                    selected: controller.useMobileLocation,
                    selectedColor: AppPalette.primary.withValues(alpha: 0.2),
                    onSelected: (_) {
                      controller.toggleLocationMode(true);
                    },
                  ),
                ],
              ),
            ),

            VerticalSpacing.md(context),

            /// 📋 LISTA
            Expanded(
              child: vetsList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: vetsList.length,
                      itemBuilder: (context, index) {
                        final vet = vetsList[index];

                        final isSelected =
                            controller.selectedVetID == vet['id'];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: screenSize.width * 0.05,
                          ),
                          child: Material(
                            color: isSelected
                                ? AppPalette.primary.withValues(alpha: .15)
                                : AppPalette.background(context),
                            borderRadius: BorderRadius.circular(15),

                            child: ListTile(
                              onTap: () {
                                controller.updateSelectedVetID(vet['id']);
                              },

                              splashColor:
                                  AppPalette.primary.withValues(alpha: .3),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppPalette.primary
                                      : AppPalette.disabled(context)
                                          .withValues(alpha: .4),
                                ),
                              ),

                              contentPadding: const EdgeInsets.all(16),

                              /// 🐾 AVATAR
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: AppPalette.primary,
                                child: Text(
                                  (vet['name'] ?? "?")[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              /// 🏷 NAME
                              title: Text(
                                vet['name'] ?? "Sin nombre",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppPalette.textOnSecondaryBg(context),
                                  fontSize: 18,
                                ),
                              ),

                              /// 📍 ADDRESS + DISTANCE + ⭐ RATING
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      /// 📍 DIRECCIÓN + DISTANCIA
                                      WidgetSpan(
                                        alignment:
                                            ui.PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: FaIcon(
                                            FontAwesomeIcons.locationDot,
                                            size: 13,
                                            color: AppPalette.secondaryText(
                                                context),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "${vet['address'] ?? 'Sin dirección'}",
                                        style: AppTextStyles.bodyRegular
                                            .copyWith(
                                          fontSize: 13,
                                          color: AppPalette.secondaryText(
                                              context),
                                        ),
                                      ),

                                      if (vet['distance_km'] != null)
                                        TextSpan(
                                          text:
                                              " • ${vet['distance_km']} km de distancia",
                                          style: AppTextStyles.bodyRegular
                                              .copyWith(
                                            fontSize: 13,
                                            color: AppPalette.secondaryText(
                                                    context)
                                                .withValues(alpha: 0.7),
                                          ),
                                        )
                                      else
                                        const TextSpan(text: "\n"),

                                      /// ⭐ RATING
                                      WidgetSpan(
                                        alignment:
                                            ui.PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: FaIcon(
                                            FontAwesomeIcons.solidStar,
                                            size: 13,
                                            color: AppPalette.secondaryText(
                                                    context)
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "${vet['rating'] ?? 'N/A'}",
                                        style: AppTextStyles.bodyRegular
                                            .copyWith(
                                          fontSize: 13,
                                          color: AppPalette.secondaryText(
                                                  context)
                                              .withValues(alpha: 0.6),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// ✅ CHECK
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: AppPalette.primary,
                                      size: 30,
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    ),
  );
}