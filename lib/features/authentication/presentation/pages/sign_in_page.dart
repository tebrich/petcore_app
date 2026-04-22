import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:peticare/services/auth_service.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_text_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDarkMode = Theme.brightnessOf(context) == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? LinearGradient(
                    colors: [
                      AppPalette.primary.withValues(alpha: 0.05),
                      AppPalette.primary.withValues(alpha: 0.15),
                      AppPalette.primary.withValues(alpha: 0.35),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : RadialGradient(
                    colors: [
                      AppPalette.primary.withValues(alpha: 0.3),
                      AppPalette.primary.withValues(alpha: 0.4),
                      AppPalette.primary.withValues(alpha: 0.5),
                    ],
                  ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (screenSize.height >= 675) const Spacer(),

                  /// ILUSTRACIÓN
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/illustrations/background_shape.svg',
                        height: 260,
                        colorFilter: ColorFilter.mode(
                          AppPalette.surfaces(context)
                              .withValues(alpha: isDarkMode ? 1 : 0.5),
                          BlendMode.srcATop,
                        ),
                      ),
                      FloatingAnimation(
                        type: FloatingType.wave,
                        duration: const Duration(seconds: 8),
                        floatStrength: 2.5,
                        curve: Curves.linear,
                        child: SvgPicture.asset(
                          'assets/illustrations/sleepy_cat.svg',
                          height: 170,
                        ),
                      ),
                    ],
                  ),

                  VerticalSpacing.xl(context),

                  /// TÍTULO
                  Text(
                    'login_welcome_back'.tr,
                    style: AppTextStyles.headingLarge.copyWith(
                      fontSize: 30,
                      color: isDarkMode
                          ? AppPalette.dSecondaryText
                          : AppPalette.lBackground,
                    ),
                  ),

                  VerticalSpacing.lg(context),

                  /// EMAIL
                  SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppPalette.background(context)
                            .withValues(alpha: isDarkMode ? 0.5 : 1),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'login_email'.tr,
                        hintText: 'usuario@email.com',
                      ),
                    ),
                  ),

                  VerticalSpacing.md(context),

                  /// PASSWORD
                  SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppPalette.background(context)
                            .withValues(alpha: isDarkMode ? 0.5 : 1),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Contraseña',
                        hintText: '********',
                        suffixIcon: AnimatedIconButton(
                          iconData: _obscurePassword
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          iconSize: 14,
                          onClick: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  VerticalSpacing.sm(context),

                  /// OLVIDÉ CONTRASEÑA
                  Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedTextButton(
                      text: 'login_forgot_password'.tr,
                      onClick: () => Get.toNamed('/ForgotPassword'),
                    ),
                  ),

                  VerticalSpacing.xl(context),

                  /// BOTÓN LOGIN
                  AnimatedElevatedButton(
                    text: _isLoading ? 'login_loading'.tr : 'login_button'.tr,
                    size: Size(screenSize.width * 0.6, 45),
                    onClick: _isLoading
                        ? null
                        : () async {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('login_fill_fields'.tr),
                                ),
                              );
                              return;
                            }

                            setState(() => _isLoading = true);

                            try {
                              await AuthService.login(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );

                              final rawUser =
                                  await const FlutterSecureStorage().read(key: 'user');
                              final user =
                                  rawUser != null ? jsonDecode(rawUser) : null;

                              print("🧠 USER FROM STORAGE >>> $user");

                              if (user != null && user["role"] == "vet") {
                                print("🚀 NAV → VET PANEL");
                                Get.offAllNamed('/VetPanel');
                              } else {
                                print("🚀 NAV → USER");
                                Get.offAllNamed('/HomePage');
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString()
                                        .replaceAll('Exception: ', ''),
                                  ),
                                ),
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          },
                  ),

                  VerticalSpacing.lg(context),

                  /// REGISTRO
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'login_no_account'.tr + '\n',
                          style: const TextStyle(fontSize: 12),
                        ),
                        WidgetSpan(
                          child: AnimatedTextButton(
                            text: 'Crear cuenta',
                            onClick: () {
                              Get.off(
                                () => const SignUpPage(),
                                transition: Transition.downToUp,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (screenSize.height >= 675) const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
