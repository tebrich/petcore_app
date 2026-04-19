import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:peticare/core/commn/presentation/pages/add_reminder_page.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/pets/presentation/pages/update_pet_avatar_page.dart';
import 'package:peticare/features/pets/presentation/pages/update_pet_details.dart';
import 'package:peticare/features/pets/presentation/widgets/pet_details_page/pet_details_menu.dart';

/// A page that displays a comprehensive overview of a specific pet's profile. 🐶
///
/// This widget serves as the main detail screen for a pet, consolidating all
/// relevant information into a single, scrollable view. It is typically accessed
/// via a "container transform" animation from the `PetsPage`.
///
/// The page is composed of three main sections:
/// 1.  **General Details:** A header section (`petGeneralDetails`) showing the pet's
///     avatar, name, age, breed, and other key attributes.
/// 2.  **Quick Actions:** A row of prominent call-to-action buttons (`ctaSection`)
///     for common tasks like adding a reminder or booking an appointment.
/// 3.  **Detailed Menu:** A tabbed menu (`PetDetailsMenu`) that provides in-depth
///     views for Health, Appointments, and Gallery.
class PetDetailsPage extends StatelessWidget {
  final Map<String, dynamic> petDetails;
  const PetDetailsPage({required this.petDetails, super.key});

  @override
  /// Builds the main UI for the pet details page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        scrolledUnderElevation: 0,

        /// The title of the AppBar.
        title: Text(
          "Detalles de la mascota",
          style: AppTextStyles.headingMedium.copyWith(
            //fontWeight: FontWeight.w500,
            fontSize: 20,
            color: AppPalette.textOnSecondaryBg(context),
          ),
        ),
        actions: [
          /// An "Edit" button that navigates to the `UpdatePetDetails` page.
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: AnimatedIconButton(
              backgroundColor: AppPalette.background(context),
              foregroundColor: AppPalette.textOnSecondaryBg(context),
              iconData: Icons.edit_note_rounded,
              iconSize: 25,
              onClick: () {
                Get.to(
                  () => UpdatePetDetails(petDetails: petDetails),
                  transition: Transition.rightToLeftWithFade,
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            clipBehavior: Clip.none,

            /// A decorative paw icon in the background for visual flair.
            children: [
              Positioned(
                top: 0,
                left: -25,
                child: Transform.rotate(
                  angle: 0.36,
                  child: FaIcon(
                    FontAwesomeIcons.paw,
                    size: 225,
                    color: AppPalette.primary.withValues(alpha: .05),
                  ),
                ),
              ),
              Column(
                children: [
                  /// Heading Space
                  VerticalSpacing.lg(context),

                  /// Displays the pet's primary information (avatar, name, etc.).
                  petGeneralDetails(context, screenSize, petDetails),

                  /// Cta Space
                  VerticalSpacing.xl(context),

                  /// A row of quick action buttons.
                  ctaSection(context, screenSize),

                  /// Space between Sections
                  VerticalSpacing.xxl(context),

                  /// The main tabbed menu for Health, Appointments, and Gallery.
                  PetDetailsMenu(),
                  VerticalSpacing.md(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the section containing the main call-to-action (CTA) buttons.
  ///
  /// This widget creates a row of three `AnimatedIconButton`s for:
  /// - Adding a new reminder.
  /// - Booking a new vet appointment.
  /// - Booking a new grooming appointment.
  Widget ctaSection(BuildContext context, Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// CTA button for adding a new reminder.
          AnimatedIconButton(
            iconData: FontAwesomeIcons.plus,
            foregroundColor: AppPalette.background(context),
            backgroundColor: AppPalette.softBlue.withValues(alpha: .9),
            radius: BorderRadius.all(Radius.circular(15)),
            size: Size(80, 90),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.bell, size: 20),
                const SizedBox(height: 8.0),
                Text(
                  "Agregar\nRecordatorio",
                  style: AppTextStyles.ctaBold.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppPalette.background(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            onClick: () {
              Get.to(() => AddReminderPage(selectedPetName: 'Luna'));
            },
          ),

          /// CTA button for booking a new vet appointment.
          AnimatedIconButton(
            iconData: FontAwesomeIcons.plus,
            foregroundColor: AppPalette.background(context),
            backgroundColor: AppPalette.coralRose.withValues(alpha: .9),
            radius: BorderRadius.all(Radius.circular(15)),
            size: Size(80, 90),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.heartPulse, size: 20),
                const SizedBox(height: 8.0),
                Text(
                  "Agendar\nVeterinario",
                  style: AppTextStyles.ctaBold.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppPalette.background(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            onClick: () {
              Get.toNamed('/NewVetAppointment');
            },
          ),

          /// CTA button for booking a new grooming appointment.
          AnimatedIconButton(
            iconData: FontAwesomeIcons.plus,
            foregroundColor: AppPalette.background(context),
            backgroundColor: AppPalette.aquaBreeze.withValues(alpha: .9),
            radius: BorderRadius.all(Radius.circular(15)),
            size: Size(80, 90),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.scissors, size: 20),
                const SizedBox(height: 8.0),
                Text(
                  "Agendar\nBaño",
                  style: AppTextStyles.ctaBold.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppPalette.background(context),
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
    );
  }

  /// Builds the header section displaying the pet's general information.
  ///
  /// This includes the pet's avatar, name, energy level, type, breed,
  /// birthdate, and gender. The avatar is tappable and navigates to the
  /// `UpdatePetAvatarPage` for modification.
  Widget petGeneralDetails(
    BuildContext context,
    Size screenSize,
    Map<String, dynamic> petDetails,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Row(
        children: [
          /// A tappable container for the pet's avatar.
          GestureDetector(
            onTap: () {
              Get.to(
                () => UpdatePetAvatarPage(petType: petDetails['type']),
                transition: Transition.downToUp,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.secondary(context),
              ),
              padding: EdgeInsets.all(4),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  petDetails['avatar'](
                    screenSize.width * 0.3 - 20,
                    0.9,
                    AppPalette.primary,
                  ),

                  Positioned(
                    bottom: -20,
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: AnimatedIconButton(
                        backgroundColor: AppPalette.secondary(context),
                        foregroundColor: AppPalette.background(context),
                        iconData: FontAwesomeIcons.pencil,
                        iconSize: 18,
                        onClick: () {
                          Get.to(
                            () => UpdatePetAvatarPage(
                              petType: petDetails['type'],
                            ),
                            transition: Transition.downToUp,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      petDetails['name'],
                      style: AppTextStyles.petName.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    const Spacer(),

                    /// Displays the pet's energy level using a series of bolt icons.
                    /// A `FloatingAnimation` is used for high-energy pets to add a subtle visual effect.
                    FloatingAnimation(
                      duration: Duration(
                        seconds: petDetails['energy'] == 3
                            ? 2
                            : petDetails['energy'] == 2
                            ? 5
                            : 0,
                      ),
                      floatStrength: petDetails['energy'] == 3
                          ? 0.5
                          : petDetails['energy'] == 2
                          ? 0.25
                          : 0,
                      type: FloatingType.wave,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FontAwesomeIcons.bolt,
                            size: 20,
                            color: AppPalette.secondary(context),
                          ),
                          Icon(
                            FontAwesomeIcons.bolt,
                            size: 20,
                            color: petDetails['energy'] == 1
                                ? AppPalette.disabled(context)
                                : AppPalette.secondary(context),
                          ),
                          Icon(
                            FontAwesomeIcons.bolt,
                            size: 20,
                            color: petDetails['energy'] == 3
                                ? AppPalette.secondary(context)
                                : AppPalette.disabled(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// Space between texts
                VerticalSpacing.sm(context),
                Text.rich(
                  /// A rich text widget displaying multiple lines of pet details with icons.
                  TextSpan(
                    children: [
                      /// Type + Race
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: FaIcon(
                            FontAwesomeIcons.paw,
                            size: 15,
                            color: AppPalette.textOnSecondaryBg(
                              context,
                            ).withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: "${petDetails['type']} • ${petDetails['race']}\n",
                        style: AppTextStyles.playfulTag.copyWith(
                          color: AppPalette.textOnSecondaryBg(
                            context,
                          ).withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: FaIcon(
                            FontAwesomeIcons.cakeCandles,
                            size: 15,
                            color: AppPalette.textOnSecondaryBg(
                              context,
                            ).withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: DateFormat(
                          'MM/dd/yyy',
                        ).format(petDetails['birthdate']),
                        style: AppTextStyles.playfulTag.copyWith(
                          color: AppPalette.textOnSecondaryBg(
                            context,
                          ).withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: " (${petDetails['age']} years old)\n",
                        style: AppTextStyles.playfulTag.copyWith(
                          fontSize: 12,
                          color: AppPalette.textOnSecondaryBg(
                            context,
                          ).withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: FaIcon(
                            petDetails['gender'] == 'Female'
                                ? FontAwesomeIcons.venus
                                : FontAwesomeIcons.mars,
                            size: 15,
                            color: AppPalette.textOnSecondaryBg(
                              context,
                            ).withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: petDetails['gender'],
                        style: AppTextStyles.playfulTag.copyWith(
                          color: AppPalette.textOnSecondaryBg(
                            context,
                          ).withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
