import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
===============================================================================
⚠️ IMPORTANT NOTICE – SAMPLE PRIVACY & SECURITY PAGE ⚠️
===============================================================================

This page is provided as a placeholder/example layout for a Privacy & Security 
section. The text, structure, and examples included here are purely illustrative 
and should NOT be considered legally accurate or complete.

Before publishing your app, you must:
- Replace all sample text with your own Privacy Policy and Security content.
- Ensure compliance with applicable data protection laws.
- Clearly describe how user data is collected, stored, used, shared, and protected.
- Include accurate contact information for privacy inquiries or requests.
- Review your content with a qualified legal or privacy professional if needed.

This example exists solely to demonstrate design and structure consistency 
within the Peticare UI Kit project — NOT to serve as a final or valid Privacy Policy.

===============================================================================
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// A page that displays the application's privacy and security policy. 🛡️
///
/// This [StatelessWidget] serves as a template for presenting crucial information
/// about data handling, security measures, and user control over personal data.
///
/// **Important:** The content within this page is for **demonstration purposes only**
/// and must be replaced with a legally compliant privacy policy before any
/// production release. It uses a series of [ListTile] widgets to structure
/// different sections of the policy for readability.
class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  /// Builds the UI for the Privacy & Security page.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'settings_privacy_security_title'.tr,
            style: AppTextStyles.headingMedium.copyWith(
              color: AppPalette.textOnSecondaryBg(context),
              fontSize: 22,
            ),
          ),
        ),
        actions: [SizedBox(width: 24.0)],
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              /// Decorative background illustration, subtly placed for visual texture.
              Positioned(
                top: -10,
                left: -15,
                child: Transform.rotate(
                  angle: 0.25,
                  child: Opacity(
                    opacity: .04,
                    child: SvgPicture.asset(
                      'assets/illustrations/privacy_security.svg',
                      height: 225,
                    ),
                  ),
                ),
              ),

              /// Another decorative background illustration, creating a layered effect.
              Positioned(
                top: 325,
                right: -15,
                child: Transform.rotate(
                  angle: -0.3,
                  child: Opacity(
                    opacity: .025,
                    child: SvgPicture.asset(
                      'assets/illustrations/lock2.svg',
                      height: 150,
                    ),
                  ),
                ),
              ),

              /// The main content column containing all the policy sections.
              Column(
                children: [
                  VerticalSpacing.md(context),

                  /// Section: Introduction to data protection commitment.
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Transform.rotate(
                        angle: 0.9,
                        child: Text("🐾", style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    titleAlignment: ListTileTitleAlignment.top,
                    title: Text(
                      'settings_privacy_section_intro'.tr,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppPalette.textOnSecondaryBg(context),
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      "En Peticare, entendemos lo importante que es la información de tu mascota. Nos comprometemos a mantener todos los datos —desde los registros de salud hasta los registros de actividad— seguros y utilizados únicamente para mejorar tu experiencia.",
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppPalette.secondaryText(context),
                        fontSize: 11,
                      ),
                    ),
                  ),

                  VerticalSpacing.md(context),

                  /// Section: Details on the types of data collected by the app.
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text("🔒", style: TextStyle(fontSize: 22)),
                    ),
                    titleAlignment: ListTileTitleAlignment.top,
                    title: Text(
                      'settings_privacy_section_data'.tr,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppPalette.textOnSecondaryBg(context),
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Solo recopilamos la información mínima necesaria para ofrecer un cuidado personalizado y el correcto funcionamiento de la aplicación, incluyendo:',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.secondaryText(context),
                              fontSize: 11,
                            ),
                          ),
                          ...[
                            "Datos básicos de la cuenta (nombre, correo electrónico, información de la mascota)",
                            "Datos de salud y actividad que decides registrar",
                            "Información de uso de la aplicación para mejorar el rendimiento",
                          ].map(
                            (element) => TextSpan(
                              text: '\n   • $element.',
                              style: AppTextStyles.bodyRegular.copyWith(
                                color: AppPalette.secondaryText(context),
                                fontSize: 11,
                              ),
                            ),
                          ),
                          TextSpan(text: '\n ', style: TextStyle(height: 0.5)),
                          TextSpan(
                            text: '\nNosotros ',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.secondaryText(context),
                              fontSize: 11,
                            ),
                          ),
                          TextSpan(
                            text: 'nunca vendemos o compartimos sus datos ',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.secondaryText(context),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'con terceros para marketing.',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.secondaryText(context),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  VerticalSpacing.md(context),

                  /// Section: Explanation of how the collected data is used.
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text("🧩", style: TextStyle(fontSize: 22)),
                    ),
                    titleAlignment: ListTileTitleAlignment.top,
                    title: Text(
                      'settings_privacy_section_usage'.tr,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppPalette.textOnSecondaryBg(context),
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Tus datos nos ayudan a ofrecerte mejores análisis y recomendaciones personalizadas, como:',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.secondaryText(context),
                              fontSize: 11,
                            ),
                          ),
                          ...[
                            "Seguimiento de tendencias de salud y recordatorio",
                            "Sugerencia de consejos de cuidado preventivo",
                            "Notificación de alertas de salud importantes",
                          ].map(
                            (element) => TextSpan(
                              text: '\n   • $element.',
                              style: AppTextStyles.bodyRegular.copyWith(
                                color: AppPalette.secondaryText(context),
                                fontSize: 11,
                              ),
                            ),
                          ),
                          TextSpan(text: '\n ', style: TextStyle(height: 0.5)),
                          TextSpan(
                            text: '\nToda la información es procesada ',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.secondaryText(context),
                              fontSize: 11,
                            ),
                          ),
                          TextSpan(
                            text: 'de forma segura ',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.secondaryText(context),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text:
                                'y utilizada estrictamente dentro del ecosistema de Peticare.',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.secondaryText(context),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  VerticalSpacing.md(context),

                  /// Section: Information on data security measures.
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text("🔐", style: TextStyle(fontSize: 22)),
                    ),
                    titleAlignment: ListTileTitleAlignment.top,
                    title: Text(
                      'settings_privacy_section_security'.tr,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppPalette.textOnSecondaryBg(context),
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Toda la información está',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.secondaryText(context),
                              fontSize: 11,
                            ),
                          ),
                          TextSpan(
                            text: 'cifrada en tránsito y en reposo ',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.secondaryText(context),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text:
                                "utilizando protocolos de seguridad estándar de la industria. El acceso está restringido únicamente a sistemas autorizados, garantizando que tus datos y los de tu mascota se mantengan privados y seguros.",
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppPalette.secondaryText(context),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  VerticalSpacing.md(context),

                  /// Section: Information on user control over their data.
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text("👤", style: TextStyle(fontSize: 22)),
                    ),
                    titleAlignment: ListTileTitleAlignment.top,
                    title: Text(
                      'settings_privacy_section_control'.tr,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppPalette.textOnSecondaryBg(context),
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      "Puedes ver, editar o eliminar tus datos en cualquier momento desde la configuración de tu perfil. Si desinstalas Peticare o eliminas tu cuenta, toda la información personal será eliminada permanentemente de nuestros servidores.",
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppPalette.secondaryText(context),
                        fontSize: 11,
                      ),
                    ),
                  ),

                  VerticalSpacing.md(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
