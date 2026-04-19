import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// Builds a widget that displays a summary card for a single pet. 🐾
///
/// This widget is designed to be used in a list, such as on the `PetsPage`.
/// It presents key information about a pet in a visually appealing and compact
/// format. The card includes the pet's avatar, name, energy level, breed, age,
/// and gender.
///
/// Decorative paw icons are placed in the background for added visual flair.
/// A `FloatingAnimation` is applied to the energy level indicator for high-energy
/// pets, creating a subtle, engaging effect.
///
/// [Args]:
///   - `context`: The build context for accessing theme and other resources.
///   - `screenSize`: The dimensions of the screen, used for layout calculations.
///   - `petDetails`: A map containing all the necessary details for the pet.
Widget petWidget(
  BuildContext context,
  Size screenSize,
  Map<String, dynamic> petDetails,
) {
  return Container(
    width: screenSize.width * 0.9,
    clipBehavior: Clip.hardEdge,
    decoration: BoxDecoration(
      color: AppPalette.textOnSecondaryBg(context).withValues(alpha: 0.1),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      border: Border.all(
        color: AppPalette.textOnSecondaryBg(context).withValues(alpha: 0.5),
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
    child: Stack(
      children: [
        /// Decorative paws (reduced impact)
        Positioned(
          bottom: -20,
          left: -10,
          child: FaIcon(
            FontAwesomeIcons.paw,
            size: screenSize.width * 0.25,
            color: AppPalette.primary.withValues(alpha: 0.08),
          ),
        ),
        Positioned(
          top: -25,
          right: -10,
          child: FaIcon(
            FontAwesomeIcons.paw,
            size: screenSize.width * 0.2,
            color: AppPalette.primary.withValues(alpha: 0.06),
          ),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// AVATAR (controlado)
            SizedBox(
              width: screenSize.width * 0.25,
              child: petDetails['avatar'](
                screenSize.width * 0.22,
                0.9,
                AppPalette.primary,
              ),
            ),

            const SizedBox(width: 16),

            /// INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name + Energy
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          petDetails['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.petName.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60, // 🔒 ancho fijo → NO overflow nunca
                        child: FloatingAnimation(
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(
                              3,
                              (index) => Icon(
                                FontAwesomeIcons.bolt,
                                size: 16,
                                color: index < petDetails['energy']
                                    ? AppPalette.textOnSecondaryBg(context)
                                        .withValues(alpha: 0.75)
                                    : AppPalette.disabled(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  VerticalSpacing.sm(context),

                  /// DETAILS (safe layout)
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      _petInfoChip(
                        context,
                        FontAwesomeIcons.paw,
                        "${petDetails['type']} • ${petDetails['race']}",
                      ),
                      _petInfoChip(
                        context,
                        FontAwesomeIcons.cakeCandles,
                        "${petDetails['age']} years",
                      ),
                      _petInfoChip(
                        context,
                        petDetails['gender'] == 'Female'
                            ? FontAwesomeIcons.venus
                            : FontAwesomeIcons.mars,
                        petDetails['gender'],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _petInfoChip(
  BuildContext context,
  IconData icon,
  String text,
) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      FaIcon(
        icon,
        size: 14,
        color: AppPalette.textOnSecondaryBg(context).withValues(alpha: 0.6),
      ),
      const SizedBox(width: 4),
      Text(
        text,
        style: AppTextStyles.playfulTag.copyWith(
          fontSize: 12,
          color: AppPalette.textOnSecondaryBg(context).withValues(alpha: 0.6),
        ),
      ),
    ],
  );
}
