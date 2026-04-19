import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_paw.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_text_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:peticare/core/services/location_service.dart';
import 'package:peticare/services/auth_service.dart';



/// The user registration screen for the Peticare application.
///
/// This page serves as the entry point for new users to create an account. It is
/// built within a `SingleChildScrollView` to ensure responsiveness and prevent
/// overflow on smaller screens. The background uses a theme-adaptive gradient.
///
/// Key UI elements include:
/// - A "Create an account" title decorated with `AnimatedPaw` widgets.
/// - A `Stack` layout that overlays a climbing cat illustration (`cat_climb.svg`)
///   on top of the username input field.
/// - A series of `TextFormField`s for collecting the user's username, email,
///   password, and password confirmation.
/// - An `AnimatedIconButton` with an eye icon to toggle password visibility,
///   improving user experience during password entry.
/// - An `AnimatedElevatedButton` as the primary call-to-action for submitting
///   the registration form.
/// - An `AnimatedTextButton` for existing users to navigate to the `SignInPage`.
///
/// Navigation is handled using the GetX package. `Get.toNamed('/PostSignup')`
/// is called upon successful sign-up, and `Get.off(() => SignInPage())` is used
/// for switching to the login screen.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

@override
void dispose() {
  nameController.dispose();
  emailController.dispose();
  passwordController.dispose();
  confirmPasswordController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool isDarkMode = Theme.brightnessOf(context) == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? LinearGradient(
                    colors: [
                      AppPalette.primary.withValues(alpha: 0.025),
                      AppPalette.primary.withValues(alpha: 0.125),
                      AppPalette.primary.withValues(alpha: 0.35),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : RadialGradient(
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
                  const Spacer(flex: 1),

                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'signup_title'.tr,
                                style: AppTextStyles.headingLarge.copyWith(
                                  color: isDarkMode
                                      ? AppPalette.dSecondaryText
                                      : AppPalette.lBackground,
                                  fontSize: 35,
                                ),
                              ),
                              TextSpan(
                                text:'\n${'signup_subtitle'.tr}',
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: isDarkMode
                                      ? AppPalette.dTextOnSecondaryBg
                                            .withValues(alpha: .75)
                                      : Colors.grey.shade300,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        left: -30,
                        child: AnimatedPaw(
                          rotationAngle: 20,
                          pawSize: 25,
                          pawColor: AppPalette.primary.withValues(
                            alpha: isDarkMode ? 0.15 : 0.35,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: -25,
                        child: AnimatedPaw(
                          pawSize: 30,
                          rotationAngle: 20,
                          pawColor: AppPalette.primary.withValues(
                            alpha: isDarkMode ? 0.2 : 0.45,
                          ),
                        ),
                      ),

                      Positioned(
                        top: 5,
                        right: -35,
                        child: AnimatedPaw(
                          rotationAngle: 20,
                          pawColor: AppPalette.primary.withValues(
                            alpha: isDarkMode ? 0.2 : 0.45,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 45,
                        right: -25,
                        child: AnimatedPaw(
                          rotationAngle: 20,
                          pawSize: 30,
                          pawColor: AppPalette.primary.withValues(
                            alpha: isDarkMode ? 0.15 : 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Space after title
                  VerticalSpacing.lg(context),
                  SizedBox(
                    height: screenSize.height < 675 ? 130 : 150,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: 45,
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              filled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              fillColor: AppPalette.background(
                                context,
                              ).withValues(alpha: isDarkMode ? 0.5 : 1.0),
                              labelText: 'signup_username'.tr,
                              hintText: 'signup_username_hint'.tr,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: screenSize.height < 675 ? 18 : 14,
                          child: SvgPicture.asset(
                            'assets/illustrations/cat_climb.svg',
                            height: screenSize.height < 675 ? 125 : 150,
                            colorFilter: isDarkMode
                                ? ColorFilter.mode(
                                    AppPalette.dBackground.withValues(
                                      alpha: .25,
                                    ),
                                    BlendMode.srcATop,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Space between TextFields
                  VerticalSpacing.md(context),
                  SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppPalette.background(
                          context,
                        ).withValues(alpha: isDarkMode ? 0.5 : 1.0),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'signup_email'.tr,
                        hintText: 'signup_email_hint'.tr,
                      ),
                    ),
                  ),
                  // Space between TextFields
                  VerticalSpacing.md(context),
                  SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,  
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: AppPalette.background(
                          context,
                        ).withValues(alpha: isDarkMode ? 0.5 : 1.0),
                        labelText: 'signup_password'.tr,
                        hintText: 'signup_password_hint'.tr,
                        suffixIcon: AnimatedIconButton(
                          foregroundColor: AppPalette.primary.withValues(
                            alpha: 0.5,
                          ),
                          iconSize: 15,
                          iconData: FontAwesomeIcons.eye,
                          onClick: () {},
                        ),
                      ),
                    ),
                  ),
                  // Space between TextFields
                  VerticalSpacing.md(context),
                  SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true, 
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppPalette.background(
                          context,
                        ).withValues(alpha: isDarkMode ? 0.5 : 1.0),
                        labelText: 'signup_confirm_password'.tr,
                        hintText: 'signup_password_hint'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: AnimatedIconButton(
                          foregroundColor: AppPalette.primary.withValues(
                            alpha: 0.5,
                          ),
                          iconSize: 15,
                          iconData: FontAwesomeIcons.eye,
                          onClick: () {},
                        ),
                      ),
                    ),
                  ),
                  // Space before Sign up button
                  VerticalSpacing.md(context),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 30),
                    child: AnimatedElevatedButton(
                      text: '',
                      size: Size(screenSize.width * 0.6, 45),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              'signup_button'.tr,
                              style: AppTextStyles.ctaBold,
                            ),
                          ),
                          FaIcon(FontAwesomeIcons.paw, size: 15),
                        ],
                      ),
                      onClick: () async {
                        // 1️⃣ Validar passwords
                        if (passwordController.text != confirmPasswordController.text) {
                          Get.snackbar(
                            'Error',
                            'Las contraseñas no coinciden',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        try {
                          // 2️⃣ Crear usuario REAL
                          await AuthService.register(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            fullName: nameController.text.trim(),
                            phoneCountryCode: '+595', // temporal
                            phoneNumber: '000000000',
                            countryCode: 'PY',
                          );

                          // 3️⃣ Feedback visual
                          Get.snackbar(
                            'Cuenta creada',
                            'Registro exitoso',
                            snackPosition: SnackPosition.BOTTOM,
                          );

                          // 4️⃣ Continuar flujo SOLO si fue exitoso
                          Get.toNamed('/PostSignup');

                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'No se pudo crear la cuenta',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                    ),
                  ),

                  // Space before sign up section
                  VerticalSpacing.lg(context),

                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'signup_have_account'.tr + '\n',
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: isDarkMode
                                ? AppPalette.dBackground
                                : AppPalette.lSurfaces,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 0.6,
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(
                            height: 20,
                            child: AnimatedTextButton(
                              text: 'signup_sign_in'.tr,
                              textStyle: AppTextStyles.ctaBold.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),

                              onClick: () {
                                Get.off(
                                  () => SignInPage(),
                                  transition: Transition.downToUp,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Bottom spacer - flexible for centering
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
