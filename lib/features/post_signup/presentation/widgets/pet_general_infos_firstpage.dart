import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/post_signup/presentation/controllers/post_signup_page_controller.dart';

Widget petGeneralInfosFirstPage(
  BuildContext context,
  Size screenSize,
  PostSignupPageController postSignupPageController,
) {
  /// 🔥 CARGA AUTOMÁTICA DE RAZAS SEGÚN TIPO
  if (postSignupPageController.breeds.isEmpty &&
      postSignupPageController.petType != null) {
    int speciesId =
        postSignupPageController.petType == "Dog" ? 1 : 2;

    postSignupPageController.loadBreeds(speciesId);
  }

  return SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            screenSize.height > 675
                ? VerticalSpacing.xl(context)
                : VerticalSpacing.lg(context),

            SizedBox(
              width: screenSize.width * 0.9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/illustrations/background_shape.svg',
                    height: screenSize.height < 675 ? 250 : 275,
                    colorFilter: ColorFilter.mode(
                      AppPalette.surfaces(context),
                      BlendMode.srcATop,
                    ),
                  ),

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
                            AppPalette.primary.withValues(
                              alpha:
                                  Theme.brightnessOf(context) == Brightness.dark
                                      ? 0.8
                                      : 0.5,
                            ),
                            BlendMode.srcATop,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20, right: 7.5),
                          child: SvgPicture.asset(
                            'assets/illustrations/happy_pet.svg',
                            height: screenSize.height < 675 ? 125 : 150,
                          ),
                        ),
                      ],
                    ),
                  ),

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

            Text(
              'Información Básica de la Mascota',
              style: AppTextStyles.headingLarge.copyWith(
                color: AppPalette.textOnSecondaryBg(context),
                fontSize: 35,
              ),
              textAlign: TextAlign.center,
            ),

            Text(
              "Completa los datos de tu mascota para una experiencia personalizada.",
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppPalette.disabled(context),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            VerticalSpacing.lg(context),

            /// NOMBRE
            SizedBox(
              height: 45,
              child: TextFormField(
                controller: postSignupPageController.petNameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppPalette.background(context),
                  labelText: 'Nombre de la Mascota',
                  hintText: '',

                  prefixIcon: Center(
                    child: Icon(
                      FontAwesomeIcons.tag,
                      size: 15,
                      color: AppPalette.primary,
                    ),
                  ),
                ),
              ),
            ),
            VerticalSpacing.md(context),

            /// RAZA (DINÁMICA)
            SizedBox(
              height: 45,
              child: DropdownMenu(
                label: Text('Raza'),
                hintText: "Selecciona la raza",
                textInputAction: TextInputAction.next,
                onSelected: (value) {
                  if (value != null) {
                    final breed = value as Map<String, dynamic>;

                    /// 🔥 USAR EL CONTROLLER CORRECTO
                    postSignupPageController.setBreed(breed);
                  }
                },
                leadingIcon: Center(
                  child: Icon(
                    FontAwesomeIcons.paw,
                    size: 15,
                    color: AppPalette.primary,
                  ),
                ),
                width: screenSize.width * 0.9,
                dropdownMenuEntries:
                    postSignupPageController.breeds.map((breed) {
                  return DropdownMenuEntry<Map<String, dynamic>>(
                    value: breed,
                    label: breed["name"],
                  );
                }).toList(),
              ),
            ),
            VerticalSpacing.md(context),

            /// GÉNERO
            SizedBox(
              height: 45,
              child: DropdownMenu(
                label: Text('Género'),
                hintText: "Selecciona el género",
                controller: postSignupPageController.petGenderController,
                textInputAction: TextInputAction.done,
                onSelected: (value) {
                  postSignupPageController.petGenderController.text = value!;
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
                dropdownMenuEntries: [
                  DropdownMenuEntry<String>(value: "Macho", label: "Macho"),
                  DropdownMenuEntry<String>(value: "Hembra", label: "Hembra"),
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