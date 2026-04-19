import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/pages/add_reminder_page.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// A widget function that builds a summary card for a single pet.
///
/// This widget is designed to be used in a horizontally scrolling list on the
/// dashboard. It provides a quick, at-a-glance view of a pet, including their
/// name, age, and current energy level, along with quick-action buttons.
///
/// Key UI elements include:
/// - A decorated `Container` with subtle background paw print icons that are
///   color-coded based on the pet's gender.
/// - A corner element displaying the pet's age.
/// - The pet's avatar, rendered via a function passed in the `petDetails` map.
/// - A status tag indicating the pet's energy level (e.g., "Energized", "Relaxed"),
///   which includes a `FloatingAnimation` for more active pets.
/// - A row of `AnimatedIconButton`s for common actions:
///   - Add Reminder: Navigates to the `AddReminderPage`.
///   - Book Vet: Navigates to the `NewVetAppointment` page.
///   - Book Grooming: Navigates to the `NewGroomAppointment` page.
///
/// [context] The build context.
/// [screenSize] The size of the screen, used for responsive layouts.
/// [petDetails] A map containing the data for the pet to be displayed.
///
/// > **Refactoring Note:** This function currently accepts a `Map<String, dynamic>`
/// for `petDetails`. For better type safety and maintainability, this should be
/// refactored to accept a strongly-typed `Pet` model object.
Widget petWidget(
  BuildContext context,
  Size screenSize,
  Map<String, dynamic> petDetails,
) {
  return Center(
    child: Container(
      width: 175,
      height: 225,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppPalette.background(context),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -30,
            left: -10,
            child: FaIcon(
              FontAwesomeIcons.paw,
              size: 125,
              color:
                  (petDetails['gender'] == 'Female'
                          ? AppPalette.roseQuartz
                          : AppPalette.softBlue)
                      .withValues(
                        alpha: Theme.of(context).brightness == Brightness.dark
                            ? 0.05
                            : 0.1,
                      ),
            ),
          ),

          Positioned(
            top: -25,
            right: -10,
            child: FaIcon(
              FontAwesomeIcons.paw,
              size: 75,
              color:
                  (petDetails['gender'] == 'Female'
                          ? AppPalette.roseQuartz
                          : AppPalette.primary)
                      .withValues(
                        alpha: Theme.of(context).brightness == Brightness.dark
                            ? 0.05
                            : 0.125,
                      ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: petDetails['gender'] == 'Female'
                    ? AppPalette.roseQuartz
                    : AppPalette.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                ),
              ),
              padding: EdgeInsets.only(top: 6.0, right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FaIcon(
                    FontAwesomeIcons.cakeCandles,
                    size: 7.5,
                    color: AppPalette.dPrimaryText.withValues(alpha: 0.75),
                  ),
                  Text(
                    "${petDetails['age']}",
                    style: AppTextStyles.playfulTag.copyWith(
                      fontSize: 16,
                      color: AppPalette.dPrimaryText,
                      fontWeight: FontWeight.w700,
                      height: 0.95,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                petDetails['avatar']?.call(
                    80.0,
                    0.9,
                    petDetails['gender'] == 'Female'
                        ? AppPalette.roseQuartz
                        : AppPalette.softBlue,
                        ) ??
                        const SizedBox(),

                Text(
                  petDetails['name'],
                  style: AppTextStyles.petName.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                /// Some Title Spacing
                VerticalSpacing.sm(context),
                FloatingAnimation(
                  duration: Duration(
                    seconds: petDetails['energy'] == 3
                        ? 2
                        : petDetails['energy'] == 2
                        ? 5
                        : 1,
                  ),
                  floatStrength: petDetails['energy'] == 3
                      ? 0.5
                      : petDetails['energy'] == 2
                      ? 0.25
                      : 0,
                  type: FloatingType.bounce,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color:
                          (petDetails['gender'] == 'Female'
                                  ? AppPalette.roseQuartz
                                  : AppPalette.primary)
                              .withValues(alpha: 0.25),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Text(
                      petDetails['energy'] == 3
                          ? 'Enérgico'
                          : petDetails['energy'] == 2
                          ? 'Equilibrado'
                          : 'Relax',

                      style: AppTextStyles.playfulTag.copyWith(
                        fontSize: 12,
                        color: petDetails['gender'] == 'Female'
                            ? AppPalette.roseQuartz
                            : AppPalette.primary,
                      ),
                    ),
                  ),
                ),

                // Space before CTA section
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedIconButton(
                      iconData: FontAwesomeIcons.plus,
                      foregroundColor: AppPalette.textOnSecondaryBg(context),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.bell,
                            size: 15,
                            color: AppPalette.textOnSecondaryBg(context),
                          ),
                          Text(
                            "Agregar\nAlerta",
                            style: AppTextStyles.ctaBold.copyWith(
                              fontSize: 7,
                              fontWeight: FontWeight.w500,
                              color: AppPalette.textOnSecondaryBg(context),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      onClick: () {
                        Get.to(() => AddReminderPage());
                      },
                    ),

                    AnimatedIconButton(
                      iconData: FontAwesomeIcons.plus,
                      foregroundColor: AppPalette.textOnSecondaryBg(context),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.heartPulse,
                            size: 15,
                            color: AppPalette.textOnSecondaryBg(context),
                          ),
                          Text(
                            "Cita\nVet",
                            style: AppTextStyles.ctaBold.copyWith(
                              fontSize: 7,
                              fontWeight: FontWeight.w500,
                              color: AppPalette.textOnSecondaryBg(context),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      onClick: () {
                        Get.toNamed('/NewVetAppointment');
                      },
                    ),

                    AnimatedIconButton(
                      iconData: FontAwesomeIcons.plus,
                      foregroundColor: AppPalette.textOnSecondaryBg(context),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.scissors,
                            size: 15,
                            color: AppPalette.textOnSecondaryBg(context),
                          ),
                          Text(
                            "Cita\nPelu",
                            style: AppTextStyles.ctaBold.copyWith(
                              fontSize: 7,
                              fontWeight: FontWeight.w500,
                              color: AppPalette.textOnSecondaryBg(context),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      onClick: () {
                        Get.toNamed('/NewGroomAppointment');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
