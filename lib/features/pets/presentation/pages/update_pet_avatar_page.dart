import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_clickable_card.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/pet_avatars_list.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// A page that allows the user to select a new avatar for their pet. 🎨
///
/// This `StatefulWidget` displays a grid of available pet avatars based on the
/// provided `petType`. If the type is specific (e.g., 'Cat', 'Dog'), it shows
/// avatars for that species. If the type is 'Other', it displays a combined
/// list of all available avatars.
///
/// The user can select one avatar, which is then highlighted. The "Update"
/// button in the `BottomAppBar` is enabled only after a selection is made,
/// allowing the user to save their choice.
class UpdatePetAvatarPage extends StatefulWidget {
  final String petType;
  const UpdatePetAvatarPage({required this.petType, super.key});

  @override
  State<UpdatePetAvatarPage> createState() => _UpdatePetAvatarPageState();
}

class _UpdatePetAvatarPageState extends State<UpdatePetAvatarPage> {
  /// The string identifier for the currently selected avatar.
  ///
  /// This is `null` until the user makes a selection.
  String? selectedAvatar;
  @override
  /// Builds the main UI for the "Update Pet Avatar" page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Top spacing for visual balance.
                screenSize.height > 675
                    ? VerticalSpacing.xxl(context)
                    : VerticalSpacing.xl(context),

                /// A decorative header with a floating illustration and a back button.
                SizedBox(
                  width: screenSize.width * 0.9,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(
                        'assets/illustrations/background_shape.svg',
                        height: screenSize.height < 675 ? 250 : 275,
                        colorFilter: ColorFilter.mode(
                          AppPalette.surfaces(context),
                          BlendMode.srcATop,
                        ),
                      ),

                      /// The animated illustration in the center.
                      FloatingAnimation(
                        type: FloatingType.wave,
                        duration: Duration(seconds: 8),
                        floatStrength: 2.5,
                        curve: Curves.linear,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            SvgPicture.asset(
                              'assets/illustrations/background_shape.svg',
                              height: screenSize.height < 675 ? 175 : 200,
                              colorFilter: ColorFilter.mode(
                                AppPalette.primary.withValues(alpha: 0.5),
                                BlendMode.srcATop,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                right: 7.5,
                              ),
                              child: SvgPicture.asset(
                                'assets/illustrations/pet_profile_pic.svg',
                                height: screenSize.height < 675 ? 125 : 150,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// The back button to exit the update page.
                      Positioned(
                        top: 0,
                        left: -screenSize.width * 0.025,
                        child: AnimatedIconButton(
                          iconData: FontAwesomeIcons.arrowLeftLong,
                          foregroundColor: AppPalette.textOnSecondaryBg(
                            context,
                          ),
                          iconSize: 17.5,
                          onClick: () {
                            Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                VerticalSpacing.xl(context),

                /// The main page title.
                Text(
                  'Update Pet Profile Picture',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),

                /// Title Spacing
                VerticalSpacing.lg(context),

                /// A `LayoutBuilder` ensures the grid of avatars is responsive.
                LayoutBuilder(
                  builder: (context, constraints) {
                    /// The `Wrap` widget creates a grid that automatically wraps to the next line.
                    return Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      children: List.generate(
                        /// The number of avatars to display depends on the `petType`.
                        /// If 'Other', it shows all 40 avatars; otherwise, it shows 8.
                        widget.petType == 'Other' ? 40 : 8,
                        (index) => AnimatedClickableContainer(
                          onSelectedColor: AppPalette.primary,
                          containerSize: constraints.maxWidth < 234
                              ? 70
                              : constraints.maxWidth < 324
                              ? (constraints.maxWidth - 24) / 3
                              : 100,
                          childText: '',
                          onlyImage: true,

                          /// Fetches the appropriate avatar widget for the given index.
                          image: getPetAvatar(index),

                          /// Determines if the current avatar is the selected one.
                          isSelected: getIsSelected(index),
                          onTap: () {
                            /// Updates the state with the newly selected avatar's name.
                            setState(() {
                              selectedAvatar = getSelectedAvatar(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),

                /// Bottom Spacing
                VerticalSpacing.lg(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 65,
        padding: EdgeInsets.all(5),
        child: Center(
          child: AnimatedElevatedButton(
            text: 'Update',
            size: Size(screenSize.width * 0.85, 45),

            /// The button is disabled (`onClick` is null) if no avatar has been selected.
            onClick: selectedAvatar == null
                ? null
                : () {
                    /// TODO: Implement the update logic here (e.g., call an API to save the new avatar).
                    Get.back();
                  },
          ),
        ),
      ),
    );
  }

  /// Retrieves the avatar widget for a given index based on the `petType`.
  ///
  /// If `petType` is 'Other', it cycles through all available pet types
  /// (Cat, Dog, Rabbit, etc.) to build a combined list. Otherwise, it
  /// only pulls from the specified pet type's list.
  Widget getPetAvatar(int index) {
    if (widget.petType != 'Other') {
      return petAvatars(context)[widget.petType]!.values.elementAt(index)(
        100 * 0.8,
        0.8,
        AppPalette.primary.withValues(alpha: 0.5),
      );
    } else {
      if (index < 8) {
        return petAvatars(context)["Cat"]!.values.elementAt(index)(
          100 * 0.8,
          0.8,
          AppPalette.primary.withValues(alpha: 0.5),
        );
      } else if (index < 16) {
        return petAvatars(context)["Dog"]!.values.elementAt(index - 8)(
          100 * 0.8,
          0.8,
          AppPalette.primary.withValues(alpha: 0.5),
        );
      } else if (index < 24) {
        return petAvatars(context)["Rabbit"]!.values.elementAt(index - 16)(
          100 * 0.8,
          0.8,
          AppPalette.primary.withValues(alpha: 0.5),
        );
      } else if (index < 32) {
        return petAvatars(context)["Bird"]!.values.elementAt(index - 24)(
          100 * 0.8,
          0.8,
          AppPalette.primary.withValues(alpha: 0.5),
        );
      } else {
        return petAvatars(context)["Fish"]!.values.elementAt(index - 32)(
          100 * 0.8,
          0.8,
          AppPalette.primary.withValues(alpha: 0.5),
        );
      }
    }
  }

  /// Retrieves the string identifier (key) for an avatar at a given index.
  ///
  /// This logic mirrors `getPetAvatar` to ensure the correct key is returned
  /// for the avatar being displayed, especially when `petType` is 'Other' and
  /// multiple lists are being combined.
  String getSelectedAvatar(int index) {
    if (widget.petType != 'Other') {
      return petAvatars(context)[widget.petType]!.keys.elementAt(index);
    } else {
      if (index < 8) {
        return petAvatars(context)["Cat"]!.keys.elementAt(index);
      } else if (index < 16) {
        return petAvatars(context)["Dog"]!.keys.elementAt(index - 8);
      } else if (index < 24) {
        return petAvatars(context)["Rabbit"]!.keys.elementAt(index - 16);
      } else if (index < 32) {
        return petAvatars(context)["Bird"]!.keys.elementAt(index - 24);
      } else {
        return petAvatars(context)["Fish"]!.keys.elementAt(index - 32);
      }
    }
  }

  /// Checks if the avatar at a given index is the currently selected one.
  ///
  /// This is used to apply the visual "selected" state to the
  /// `AnimatedClickableContainer`. The logic mirrors the other `get...`
  /// methods to ensure the correct comparison is made.
  bool getIsSelected(int index) {
    if (widget.petType != 'Other') {
      return selectedAvatar ==
          petAvatars(context)[widget.petType]!.keys.elementAt(index);
    } else {
      if (index < 8) {
        return selectedAvatar ==
            petAvatars(context)["Cat"]!.keys.elementAt(index);
      } else if (index < 16) {
        return selectedAvatar ==
            petAvatars(context)["Dog"]!.keys.elementAt(index - 8);
      } else if (index < 24) {
        return selectedAvatar ==
            petAvatars(context)["Rabbit"]!.keys.elementAt(index - 16);
      } else if (index < 32) {
        return selectedAvatar ==
            petAvatars(context)["Bird"]!.keys.elementAt(index - 24);
      } else {
        return selectedAvatar ==
            petAvatars(context)["Fish"]!.keys.elementAt(index - 32);
      }
    }
  }
}