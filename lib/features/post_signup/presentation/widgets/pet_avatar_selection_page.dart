import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_clickable_card.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/pet_avatars_list.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/post_signup/presentation/controllers/post_signup_page_controller.dart';

/// Builds the pet avatar selection page for the post-signup user flow. 🖼️
///
/// This widget displays a grid of selectable avatars for the user's pet. The
/// content of the grid is dynamically determined by the `petType` selected on the
/// previous page. If a specific type (e.g., "Dog") is chosen, only avatars for
/// that type are shown. If "Other" was selected, a comprehensive list of all
/// available avatars across all types is presented.
///
/// The UI includes a decorative illustration, a title, a back button to navigate
/// to the previous page, and a responsive `Wrap` widget for the avatar grid.
/// State management is handled by the provided [postSignupPageController].
///
/// [Args]:
///   - `context` (BuildContext): The build context for accessing theme and other resources.
///   - `screenSize` (Size): The dimensions of the screen, used for responsive UI adjustments.
///   - `postSignupPageController` (PostSignupPageController): The controller managing the state of the post-signup flow.
Widget petAvatarSelectionPage(
  BuildContext context,
  Size screenSize,
  PostSignupPageController postSignupPageController,
) {
  return SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Top spacing for visual balance.
            screenSize.height > 675
                ? VerticalSpacing.xl(context)
                : VerticalSpacing.lg(context),

            SizedBox(
              width: screenSize.width * 0.9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// The primary background shape, providing a surface for other elements.
                  SvgPicture.asset(
                    'assets/illustrations/background_shape.svg',
                    height: screenSize.height < 675 ? 250 : 275,
                    colorFilter: ColorFilter.mode(
                      AppPalette.surfaces(context),
                      BlendMode.srcATop,
                    ),
                  ),

                  /// Applies a gentle wave-like motion to the central illustration stack.
                  FloatingAnimation(
                    type: FloatingType.wave,
                    duration: Duration(seconds: 8),
                    floatStrength: 2.5,
                    curve: Curves.linear,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        /// A secondary, colored background shape within the animation.
                        SvgPicture.asset(
                          'assets/illustrations/background_shape.svg',
                          height: screenSize.height < 675 ? 175 : 200,
                          colorFilter: ColorFilter.mode(
                            AppPalette.primary.withValues(
                              alpha:
                                  Theme.brightnessOf(context) == Brightness.dark
                                  ? 0.8
                                  : 0.5,
                            ),
                            BlendMode.srcATop,
                          ),
                        ),

                        /// The main illustration for the avatar selection page.
                        Padding(
                          padding: const EdgeInsets.only(top: 20, right: 7.5),
                          child: SvgPicture.asset(
                            'assets/illustrations/pet_profile_pic.svg',
                            height: screenSize.height < 675 ? 125 : 150,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// A back button to navigate to the previous page in the `PageView`.
                  Positioned(
                    top: 0,
                    left: -screenSize.width * 0.025,
                    child: AnimatedIconButton(
                      iconData: FontAwesomeIcons.arrowLeftLong,
                      foregroundColor: AppPalette.textOnSecondaryBg(context),
                      iconSize: 17.5,
                      onClick: () {
                        postSignupPageController.pageController.previousPage(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.linear,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            VerticalSpacing.xl(context),

            /// The main heading for the page.
            Text(
              'Pet Profile Picture',
              style: AppTextStyles.headingLarge.copyWith(
                color: AppPalette.textOnSecondaryBg(context),
                fontSize: 35,
              ),
              textAlign: TextAlign.center,
            ),
            VerticalSpacing.lg(context),

            /// A `LayoutBuilder` is used to create a responsive grid of avatars.
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,

                  /// The number of avatars to display is determined by the selected `petType`.
                  /// If the type is 'Other', it shows all 40 avatars. Otherwise, it shows the 8
                  /// avatars specific to the selected type.
                  children: List.generate(
                    postSignupPageController.petType == 'Other' ? 40 : 8,
                    (index) => AnimatedClickableContainer(
                      onSelectedColor: AppPalette.primary,

                      /// The size of each container is calculated dynamically based on the
                      /// available width, ensuring a responsive layout.
                      containerSize: constraints.maxWidth < 234
                          ? 70
                          : constraints.maxWidth < 324
                          ? (constraints.maxWidth - 24) / 3
                          : 100,
                      childText: '',
                      onlyImage: true,

                      /// Dynamically retrieves the avatar widget for the given index.
                      image: getPetAvatar(
                        context,
                        index,
                        postSignupPageController,
                      ),

                      /// Checks if the avatar at the current index is the selected one.
                      isSelected: getIsSelected(
                        context,
                        index,
                        postSignupPageController,
                      ),

                      /// Updates the controller with the name of the selected avatar when tapped.
                      onTap: () => postSignupPageController.updatePetAvatar(
                        getSelectedAvatar(
                          context,
                          index,
                          postSignupPageController,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            VerticalSpacing.lg(context),
          ],
        ),
      ),
    ),
  );
}

/// Retrieves the appropriate pet avatar widget based on the selected pet type and index.
///
/// This function handles the complex logic of displaying avatars. If a specific
/// pet type (e.g., "Dog") is selected, it returns the avatar at the given [index]
/// from that type's list. If the pet type is "Other", it concatenates all avatar
/// lists and returns the avatar at the global [index].
///
/// [Args]:
///   - `context`: The build context.
///   - `index`: The index of the avatar in the grid.
///   - `postSignupPageController`: The controller holding the selected `petType`.
///
/// [Returns]:
///   A `Widget` representing the pet avatar.
Widget getPetAvatar(
  BuildContext context,
  int index,
  PostSignupPageController postSignupPageController,
) {
  if (postSignupPageController.petType != 'Other') {
    return petAvatars(
      context,
    )[postSignupPageController.petType!]!.values.elementAt(index)(
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

/// Retrieves the unique name (key) of the avatar at a specific grid index.
///
/// This function's logic mirrors [getPetAvatar]. It is used to get the string
/// identifier for the selected avatar, which is then stored in the
/// [postSignupPageController].
///
/// [Args]:
///   - `context`: The build context.
///   - `index`: The index of the avatar in the grid.
///   - `postSignupPageController`: The controller holding the selected `petType`.
///
/// [Returns]:
///   A `String` representing the unique name of the avatar.
String getSelectedAvatar(
  BuildContext context,
  int index,
  PostSignupPageController postSignupPageController,
) {
  if (postSignupPageController.petType != 'Other') {
    return petAvatars(
      context,
    )[postSignupPageController.petType!]!.keys.elementAt(index);
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

/// Determines if the avatar at a given index is the currently selected one.
///
/// This function compares the name of the avatar at the specified [index] with
/// the `avatarName` stored in the [postSignupPageController] to determine
/// its selection state.
///
/// [Args]:
///   - `context`: The build context.
///   - `index`: The index of the avatar in the grid.
///   - `postSignupPageController`: The controller holding the currently selected `avatarName`.
///
/// [Returns]:
///   A `bool` which is `true` if the avatar is selected, and `false` otherwise.
bool getIsSelected(
  BuildContext context,
  int index,
  PostSignupPageController postSignupPageController,
) {
  if (postSignupPageController.petType != 'Other') {
    return postSignupPageController.avatarName ==
        petAvatars(
          context,
        )[postSignupPageController.petType!]!.keys.elementAt(index);
  } else {
    if (index < 8) {
      return postSignupPageController.avatarName ==
          petAvatars(context)["Cat"]!.keys.elementAt(index);
    } else if (index < 16) {
      return postSignupPageController.avatarName ==
          petAvatars(context)["Dog"]!.keys.elementAt(index - 8);
    } else if (index < 24) {
      return postSignupPageController.avatarName ==
          petAvatars(context)["Rabbit"]!.keys.elementAt(index - 16);
    } else if (index < 32) {
      return postSignupPageController.avatarName ==
          petAvatars(context)["Bird"]!.keys.elementAt(index - 24);
    } else {
      return postSignupPageController.avatarName ==
          petAvatars(context)["Fish"]!.keys.elementAt(index - 32);
    }
  }
}
