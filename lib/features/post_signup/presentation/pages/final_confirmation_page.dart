import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/pet_avatars_list.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/post_signup/presentation/controllers/post_signup_page_controller.dart';

class FinalConfirmationPage extends StatefulWidget {
  final bool isPostSigning;
  const FinalConfirmationPage({required this.isPostSigning, super.key});

  @override
  State<FinalConfirmationPage> createState() => _FinalConfirmationPageState();
}

class _FinalConfirmationPageState extends State<FinalConfirmationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController avatarAnimationController;
  late Animation<double> avatarAnimation;

  @override
  void initState() {
    avatarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    avatarAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: avatarAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    avatarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostSignupPageController>();

    Size screenSize = MediaQuery.of(context).size;

    /// =========================
    /// 🔥 DATOS DINÁMICOS
    /// =========================
    final petName = controller.petNameController.text;
    final gender = controller.petGenderController.text;
    final birthDate = controller.petBirthdate;
    final energy = controller.selectedEnergyLevelId ?? 1;
    final avatarCode = controller.avatarName;

    final isDog = controller.petType == "Dog";
    final petType = isDog ? "Perro" : "Gato";

    /// Edad
    int age = 0;
    if (birthDate != null) {
      final today = DateTime.now();
      age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month &&
              today.day < birthDate.day)) {
        age--;
      }
    }

    /// Avatar dinámico
    final avatarWidget =
        petAvatars(context)[isDog ? "Dog" : "Cat"]![avatarCode];

    avatarAnimationController.forward();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                AppPalette.primary.withValues(alpha: 0.285),
                AppPalette.primary.withValues(alpha: 0.3),
                AppPalette.primary.withValues(alpha: 0.4),
                AppPalette.primary.withValues(alpha: 0.45),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: screenSize.width * 0.05,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (screenSize.hashCode >= 675)
                      ? const Spacer(flex: 1)
                      : VerticalSpacing.lg(context),

                  /// AVATAR
                  AnimatedBuilder(
                    animation: avatarAnimationController,
                    builder: (context, child) => Transform.scale(
                      scale: avatarAnimation.value,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/illustrations/background_shape.svg',
                            height: screenSize.height < 675 ? 260 : 285,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).brightness == Brightness.dark
                                  ? AppPalette.primary.withValues(alpha: 0.8)
                                  : AppPalette.lSurfaces.withValues(alpha: 0.75),
                              BlendMode.srcATop,
                            ),
                          ),

                          FloatingAnimation(
                            type: FloatingType.drift,
                            duration: Duration(seconds: 8),
                            floatStrength: 2.5,
                            curve: Curves.linear,
                            child: avatarWidget?.call(
                                  screenSize.height < 675.0 ? 160.0 : 185.0,
                                  0.8,
                                  AppPalette.primary,
                                ) ??
                                const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  VerticalSpacing.xl(context),

                  /// NOMBRE
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Bienvenido, ",
                          style: AppTextStyles.playfulTag.copyWith(
                            color: AppPalette.textOnSecondaryBg(context),
                            fontSize: 35,
                          ),
                        ),
                        TextSpan(
                          text: petName,
                          style: AppTextStyles.playfulTag.copyWith(
                            color: AppPalette.primary,
                            fontSize: 35,
                          ),
                        ),
                        TextSpan(
                          text: " !",
                          style: AppTextStyles.playfulTag.copyWith(
                            color: AppPalette.textOnSecondaryBg(context),
                            fontSize: 35,
                          ),
                        ),
                        TextSpan(
                          text: "\n(Tu mascota está lista)",
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: AppPalette.textOnSecondaryBg(context)
                                .withValues(alpha: 0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  VerticalSpacing.lg(context),

                  /// CARD INFO
                  FloatingAnimation(
                    type: FloatingType.pulse,
                    duration: Duration(seconds: 8),
                    floatStrength: 0.25,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.surfaces(context),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// EDAD + GENERO
                          Row(
                            children: [
                              Text(
                                "$age años",
                                style: AppTextStyles.playfulTag.copyWith(
                                  color: AppPalette.primaryText(context),
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),

                              Padding(
                                padding: const EdgeInsets.only(right: 7.5),
                                child: FaIcon(
                                  gender == "Macho"
                                      ? FontAwesomeIcons.mars
                                      : FontAwesomeIcons.venus,
                                  size: 20,
                                  color: AppPalette.primaryText(context),
                                ),
                              ),
                              Text(
                                gender,
                                style: AppTextStyles.playfulTag.copyWith(
                                  color: AppPalette.primaryText(context),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: AppPalette.disabled(context)
                                  .withValues(alpha: 0.75),
                              indent: screenSize.width * 0.05,
                              endIndent: screenSize.width * 0.05,
                            ),
                          ),

                          /// TIPO + ENERGÍA
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 7.5),
                                child: FaIcon(
                                  FontAwesomeIcons.paw,
                                  size: 20,
                                  color: AppPalette.primaryText(context),
                                ),
                              ),
                              Text(
                                petType,
                                style: AppTextStyles.playfulTag.copyWith(
                                  color: AppPalette.primaryText(context),
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),

                              /// ⚡ ENERGÍA DINÁMICA
                              Row(
                                children: List.generate(
                                  energy,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: FaIcon(
                                      FontAwesomeIcons.bolt,
                                      size: 20,
                                      color:
                                          AppPalette.primaryText(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  VerticalSpacing.xl(context),

                  /// BOTÓN FINAL
                  AnimatedElevatedButton(
                    text: 'Ir al Dashboard',
                    size: Size(screenSize.width * 0.85, 45),
                    onClick: () {
                      if (widget.isPostSigning) {
                        Get.offAllNamed('HomePage');
                      } else {
                        Get.close(2);
                      }
                    },
                  ),

                  (screenSize.hashCode >= 675)
                      ? const Spacer(flex: 1)
                      : VerticalSpacing.lg(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}