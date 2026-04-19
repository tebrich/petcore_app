import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/constants/global_consts.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/post_signup/presentation/controllers/post_signup_page_controller.dart';

/// Builds the second page for collecting a pet's general information. 📝
///
/// This widget is part of a multi-page form in the post-signup flow. It is
/// responsible for gathering more specific details about the pet, including
/// their weight, birthdate, and activity level. This information is crucial for
/// personalizing the user's experience and providing tailored care recommendations.
///
/// The UI features a playful illustration, a title, a back button, and a series
/// of input fields (`TextFormField` and `DropdownMenu`). State management and
/// navigation are handled by the provided [postSignupPageController].
///
/// [Args]:
///   - `context` (BuildContext): The build context for accessing theme and other resources.
///   - `screenSize` (Size): The dimensions of the screen, used for responsive UI adjustments.
///   - `postSignupPageController` (PostSignupPageController): The controller managing the state of the post-signup flow.
Widget petGeneralInfosSecondPage(
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
            /// Top spacing for visual balance, adjusted for screen height.
            screenSize.height > 675
                ? VerticalSpacing.xl(context)
                : VerticalSpacing.lg(context),

            SizedBox(
              width: screenSize.width * 0.9,
              child: Stack(
                clipBehavior: Clip.none,
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
                    duration: Duration(seconds: 7),
                    floatStrength: 2.75,
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

                        /// The main illustration for this page, featuring a playful pet.
                        Padding(
                          padding: const EdgeInsets.only(top: 20, right: 7.5),
                          child: SvgPicture.asset(
                            'assets/illustrations/playful_pet.svg',
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
              'Completa el perfil de tu mascota',
              style: AppTextStyles.headingLarge.copyWith(
                color: AppPalette.textOnSecondaryBg(context),
                fontSize: 35,
              ),
              textAlign: TextAlign.center,
            ),

            /// The descriptive subheading that prompts the user for the next action.
            Text(
              "Ingresa los datos para personalizar la experiencia y obtener mejores recomendaciones!",
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppPalette.disabled(context),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            VerticalSpacing.lg(context),

            SizedBox(
              height: 45,
              child: TextFormField(
                controller: postSignupPageController.petWeightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppPalette.background(context),

                  labelText: 'Peso',
                  hintText: 'Ej: 20',

                  prefixIcon: Center(
                    child: Icon(
                      FontAwesomeIcons.weightScale,
                      size: 15,
                      color: AppPalette.primary,
                    ),
                  ),

                  /// 🔥 FIX REAL
                  suffixText: " KG",
                  suffixStyle: AppTextStyles.playfulTag.copyWith(
                    fontSize: 13,
                    color: AppPalette.primary,
                  ),
                ),
              ),
            ),
            VerticalSpacing.md(context),

            /// Input field for the pet's birthdate, which launches a date picker on tap.
            SizedBox(
              height: 45,
              child: TextFormField(
                controller: TextEditingController(
                  text: postSignupPageController.petBirthdate == null
                      ? null
                      : '${postSignupPageController.petBirthdate!.month}/${postSignupPageController.petBirthdate!.day}/${postSignupPageController.petBirthdate!.year}',
                ),
                textInputAction: TextInputAction.next,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 18250),
                    ),
                    lastDate: DateTime.now(),
                  );
                  postSignupPageController.updatePetBirthdate(selectedDate);
                },
                readOnly: true,

                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppPalette.background(context),
                  labelText: 'Fecha de nacimiento',
                  hintText: "Selecciona la fecha",
                  prefixIcon: Center(
                    child: Icon(
                      FontAwesomeIcons.cakeCandles,
                      size: 15,
                      color: AppPalette.primary,
                    ),
                  ),
                ),
              ),
            ),

            VerticalSpacing.md(context),

            SizedBox(
              /// Dropdown menu for selecting the pet's activity level.
              height: 45,
              child: DropdownMenu(
                label: Text('Nivel de energía'),
                hintText: "Selecciona el nivel de energía",
                textInputAction: TextInputAction.done,
                controller: postSignupPageController.petActivityLevelController,
                onSelected: (value) {
                  if (value == null) return;

                  if (value == "Low Energy") {
                    postSignupPageController.setEnergyLevel(1);
                  } else if (value == "Moderate Energy") {
                    postSignupPageController.setEnergyLevel(2);
                  } else if (value == "High Energy") {
                    postSignupPageController.setEnergyLevel(3);
                  }

                  postSignupPageController.petActivityLevelController.text = value;
                  postSignupPageController.update();
                },
                leadingIcon: Center(
                  child: Icon(
                    FontAwesomeIcons.venusMars,
                    size: 15,
                    color: AppPalette.primary,
                  ),
                ),

                width: screenSize.width * 0.9,
                menuStyle: MenuStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppPalette.surfaces(context),
                  ),
                  elevation: WidgetStateProperty.all(4),
                ),
                dropdownMenuEntries: [
                  /// Each entry uses a custom `labelWidget` to display rich text,
                  /// combining a bold title with a descriptive subtitle.
                  DropdownMenuEntry<String>(
                    value: "High Energy",
                    label: 'Alta energía',
                    labelWidget: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${energyLevels[0].split('-').first} - ",
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.textOnSecondaryBg(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: energyLevels[0].split('-').last,
                            style: AppTextStyles.bodyRegular.copyWith(
                              fontSize: 11,
                              color: AppPalette.secondaryText(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DropdownMenuEntry<String>(
                    value: "Moderate Energy",
                    label: 'Moderada energía',
                    labelWidget: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${energyLevels[1].split('-').first} - ",
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.textOnSecondaryBg(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: energyLevels[1].split('-').last,
                            style: AppTextStyles.bodyRegular.copyWith(
                              fontSize: 11,
                              color: AppPalette.secondaryText(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DropdownMenuEntry<String>(
                    value: "Low Energy",
                    label: 'Baja energía',
                    labelWidget: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${energyLevels[2].split('-').first} - ",
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.textOnSecondaryBg(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: energyLevels[2].split('-').last,
                            style: AppTextStyles.bodyRegular.copyWith(
                              fontSize: 11,
                              color: AppPalette.secondaryText(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            VerticalSpacing.md(context),
          ],
        ),
      ),
    ),
  );
}
