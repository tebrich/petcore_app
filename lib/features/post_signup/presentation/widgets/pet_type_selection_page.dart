import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_clickable_card.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/post_signup/presentation/controllers/post_signup_page_controller.dart';

Widget petTypeSelectionPage(BuildContext context, Size screenSize) {
  final Map<String, String> petTypes = {
    "Dog": 'assets/illustrations/pet_types/dog.svg',
    "Cat": 'assets/illustrations/pet_types/cat.svg',
    "Rabbit": 'assets/illustrations/pet_types/rabbit.svg',
    "Bird": 'assets/illustrations/pet_types/bird.svg',
    "Fish": 'assets/illustrations/pet_types/fish.svg',
    "Other": 'assets/illustrations/pet_types/other.svg',
  };

  return SafeArea(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VerticalSpacing.xl(context),

          Text(
            'Selecciona el tipo de tu mascota',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppPalette.textOnSecondaryBg(context),
              fontSize: 35,
            ),
            textAlign: TextAlign.center,
          ),

          VerticalSpacing.lg(context),

          Text(
            "Elige el tipo de mascota para continuar con el registro.",
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppPalette.secondaryText(context),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),

          VerticalSpacing.md(context),

          GetBuilder<PostSignupPageController>(
            builder: (postSignupPageController) => LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: List.generate(
                    petTypes.keys.length,
                    (index) {
                      final type = petTypes.keys.elementAt(index);

                      return AnimatedClickableContainer(
                        onSelectedColor: AppPalette.primary,

                        containerSize: constraints.maxWidth < 234
                            ? 70
                            : constraints.maxWidth < 324
                                ? (constraints.maxWidth - 24) / 3
                                : 100,

                        childText: type,

                        image: LayoutBuilder(
                          builder: (context, bConstraints) {
                            return SvgPicture.asset(
                              petTypes.values.elementAt(index),
                              height: bConstraints.maxWidth * 0.5,
                              colorFilter: index == 5
                                  ? ColorFilter.mode(
                                      AppPalette.textOnSecondaryBg(context),
                                      BlendMode.srcATop,
                                    )
                                  : null,
                            );
                          },
                        ),

                        isSelected:
                            postSignupPageController.petType == type,

                        onTap: () {
                          print("🟢 CLICK EN TIPO: $type");

                          /// 🔥 UNA SOLA REFERENCIA (CORRECTO)
                          postSignupPageController.updatePetType(type);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}