import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/features/post_signup/presentation/controllers/post_signup_page_controller.dart';
import 'package:peticare/features/post_signup/presentation/pages/final_confirmation_page.dart';
import 'package:peticare/features/post_signup/presentation/widgets/first_welcome_page.dart';
import 'package:peticare/features/post_signup/presentation/widgets/pet_avatar_selection_page.dart';
import 'package:peticare/features/post_signup/presentation/widgets/pet_general_infos_firstpage.dart';
import 'package:peticare/features/post_signup/presentation/widgets/pet_general_infos_secondpage.dart';
import 'package:peticare/features/post_signup/presentation/widgets/pet_type_selection_page.dart';

class PostSignupWelcomePage extends StatelessWidget {
  final bool isPostSigning;

  const PostSignupWelcomePage({required this.isPostSigning, super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    /// 🔥 UNA SOLA INSTANCIA (CORRECTO)
    final controller = Get.find<PostSignupPageController>();

    return GetBuilder<PostSignupPageController>(
      builder: (controller) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: screenSize.height - 70,
              width: screenSize.width,
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (isPostSigning) firstWelcomePage(context, screenSize),

                  petTypeSelectionPage(context, screenSize),

                  petGeneralInfosFirstPage(
                    context,
                    screenSize,
                    controller,
                  ),

                  petGeneralInfosSecondPage(
                    context,
                    screenSize,
                    controller,
                  ),

                  petAvatarSelectionPage(
                    context,
                    screenSize,
                    controller,
                  ),
                ],
              ),
            ),
          ),

          bottomNavigationBar: BottomAppBar(
            height: 65,
            padding: const EdgeInsets.all(5),
            child: Center(
              child: AnimatedElevatedButton(
                text: isPostSigning
                    ? controller.currentPage == 0
                        ? "Agregar tu Mascota"
                        : controller.currentPage == 4
                            ? 'Finalizar'
                            : 'Siguiente'
                    : controller.currentPage == 3
                        ? 'Finalizar'
                        : 'Siguiente',

                size: Size(screenSize.width * 0.85, 45),

                onClick: _canProceed(controller)
                    ? () {
                        /// 🔥 FINAL → GUARDAR
                        if (controller.currentPage ==
                            (isPostSigning ? 4 : 3)) {
                          controller.savePet();

                          Get.to(
                            () => FinalConfirmationPage(
                              isPostSigning: isPostSigning,
                            ),
                            transition:
                                Transition.rightToLeftWithFade,
                          );
                        } else {
                          controller.pageController.nextPage(
                            duration:
                                const Duration(milliseconds: 150),
                            curve: Curves.linear,
                          );
                        }
                      }
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  /// =========================
  /// VALIDACIÓN CENTRALIZADA
  /// =========================
  bool _canProceed(PostSignupPageController controller) {
    if (controller.currentPage == 1) {
      return controller.petType != null;
    }

    if (controller.currentPage == 2) {
      return controller.petNameController.text.isNotEmpty &&
          controller.petBreedController.text.isNotEmpty &&
          controller.petGenderController.text.isNotEmpty;
    }

    if (controller.currentPage == 3) {
      return controller.petWeightController.text.isNotEmpty &&
          controller.petBirthdate != null &&
          controller.petActivityLevelController.text.isNotEmpty;
    }

    if (controller.currentPage == 4) {
      return controller.avatarName != null;
    }

    return true;
  }
}