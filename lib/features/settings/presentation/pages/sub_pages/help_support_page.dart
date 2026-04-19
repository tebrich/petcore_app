import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
===============================================================================
ℹ️ IMPORTANT NOTICE – SAMPLE HELP CENTER / SUPPORT PAGE ℹ️
===============================================================================

This page serves as a **template example** for the Help & Support section of 
the Peticare app. All text, questions, and responses currently included are 
**placeholder examples** meant to demonstrate the intended structure, layout, 
and tone of a functional Help Center interface.

Before using this page in production, you must:
- Replace all example FAQs, guides, and support topics with your own verified content.
- Ensure that the instructions accurately reflect your app’s real features, 
  workflows, and troubleshooting steps.
- Update links, contact details, and support channels (email, chat, or hotline).
- Localize or translate the content if your product supports multiple languages.
- Review and verify the accuracy of all information before publishing.

This example is included **solely for demonstration and UI testing purposes** 
within the Peticare project. It is **not an official support resource** and 
should not be used as-is in any public release.

===============================================================================
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  late List<bool> _isOpen;

  /// INIT STATE
  ///
  @override
  void initState() {
    super.initState();
    _isOpen = List.generate(6, (index) => false);
  }

  ///
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'help_support_title'.tr,
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
              Positioned(
                top: -10,
                left: -15,
                child: Transform.rotate(
                  angle: 0.25,
                  child: Opacity(
                    opacity: .04,
                    child: SvgPicture.asset(
                      'assets/illustrations/help_support.svg',
                      height: 225,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 325,
                right: -15,
                child: Transform.rotate(
                  angle: -0.3,
                  child: Opacity(
                    opacity: .025,
                    child: SvgPicture.asset(
                      'assets/illustrations/help_support.svg',
                      height: 150,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 550,
                left: -15,
                child: Transform.rotate(
                  angle: 0.25,
                  child: Opacity(
                    opacity: .04,
                    child: SvgPicture.asset(
                      'assets/illustrations/help_support.svg',
                      height: 225,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 850,
                right: -15,
                child: Transform.rotate(
                  angle: -0.3,
                  child: Opacity(
                    opacity: .025,
                    child: SvgPicture.asset(
                      'assets/illustrations/help_support.svg',
                      height: 150,
                    ),
                  ),
                ),
              ),

              /// Page Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top Spacing
                  VerticalSpacing.md(context),

                  /// General
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .03,
                    ),
                    child: Text(
                      'Estamos aquí para ayudarte a cuidar mejor a tus mascotas.',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppPalette.textOnSecondaryBg(context),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .03,
                    ),
                    child: Text(
                      'Encuentra respuestas, contacta a nuestro equipo o soluciona problemas fácilmente.',
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppPalette.secondaryText(context),
                        fontSize: 13,
                      ),
                    ),
                  ),

                  /// Section Spacing
                  VerticalSpacing.lg(context),

                  /// Commun Topics
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .05,
                    ),
                    child: Text(
                      'Temas frecuentes',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppPalette.textOnSecondaryBg(context),
                        fontSize: 20,
                      ),
                    ),
                  ),

                  ...{
                    'Cuenta e inicio de sesión': {
                      'subtitle':
                          'Restablece tu contraseña, actualiza tu perfil y gestiona notificaciones.',
                      'icon': FontAwesomeIcons.user,
                    },
                    'Perfiles de mascotas': {
                      'subtitle': 'Agrega, edita o elimina información y registros de tus mascotas.',
                      'icon': FontAwesomeIcons.paw,
                    },
                    'Recordatorios y alertas': {
                      'subtitle':
                          'Configura recordatorios de medicación, alimentación o visitas al veterinario.',
                      'icon': FontAwesomeIcons.bell,
                    },
                    'Registros de salud': {
                      'subtitle':
                          'Aprende a registrar datos de salud y acceder a notas veterinarias.',
                      'icon': FontAwesomeIcons.heartCircleCheck,
                    },
                    'Suscripciones y pagos': {
                      'subtitle':
                          'Administra tu plan Peticare Plus y los detalles de pago.',
                      'icon': FontAwesomeIcons.creditCard,
                    },
                  }.entries.map(
                    (element) => ListTile(
                      dense: true,
                      onTap: () {},
                      leading: Icon(
                        element.value['icon'] as IconData,
                        size: 16,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * .05,
                        vertical: 8.0,
                      ),
                      title: Text(
                        element.key,
                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppPalette.textOnSecondaryBg(context),
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        element.value['subtitle'] as String,
                        style: AppTextStyles.bodyRegular.copyWith(
                          color: AppPalette.secondaryText(context),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  /// Section Spacing
                  VerticalSpacing.lg(context),

                  /// FAQs
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .05,
                    ),
                    child: Text(
                      'Preguntas frecuentes',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppPalette.textOnSecondaryBg(context),
                        fontSize: 20,
                      ),
                    ),
                  ),

                  ...{
                    '¿Cómo edito el registro de salud de mi mascota?':
                        'Ve al perfil de tu mascota → toca Registro de salud → edita o agrega nueva información.',
                    'Mis recordatorios no envían notificaciones.':
                        'Verifica los permisos de notificaciones en la configuración de tu teléfono y asegúrate de que los recordatorios estén habilitados dentro de Peticare.',
                    '¿Puedo sincronizar mis datos entre dispositivos?':
                        'Sí, solo inicia sesión en tu cuenta desde otro dispositivo y tus datos se sincronizarán de forma segura',
                    '¿Cómo puedo restablecer mi contraseña?':
                        'Ve a la pantalla de inicio de sesión y toca <¿Olvidaste tu contraseña?>. Ingresa tu correo registrado y te enviaremos un enlace seguro para restablecerla. Si no lo recibes, revisa tu carpeta de spam o contacta a soporte.',

                    '¿Cómo agrego una nueva mascota a mi cuenta?':
                        'Desde el panel principal, toca el botón “+ Agregar mascota”. Completa la información básica de tu mascota — nombre, especie, edad y foto — y guarda. Puedes editar este perfil en cualquier momento desde la pestaña Mascotas.',

                    '¿Por qué no recibo alertas de salud o recordatorios?':
                        'Asegúrate de que las notificaciones estén habilitadas tanto en la configuración de tu dispositivo como dentro de Peticare (Configuración → Notificaciones). Además, verifica que los registros de salud y las fechas de recordatorios de tu mascota estén actualizados.',
                  }.entries.toList().indexed.map((indexed) {
                    final index = indexed.$1;
                    final entry = indexed.$2;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * .05,
                        vertical: 8.0,
                      ),
                      child: InkWell(
                        onTap: () => setState(() {
                          _isOpen[index] = !_isOpen[index];
                        }),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          width: screenSize.width * .9,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: AppPalette.surfaces(
                              context,
                            ).withValues(alpha: .5),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: AppPalette.disabled(
                                context,
                              ).withValues(alpha: .25),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 16.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        entry.key,
                                        style: AppTextStyles.headingMedium
                                            .copyWith(
                                              color:
                                                  AppPalette.textOnSecondaryBg(
                                                    context,
                                                  ),
                                              fontSize: 14,
                                            ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: AnimatedIconButton(
                                        iconSize: 16,
                                        foregroundColor:
                                            AppPalette.secondaryText(context),
                                        iconData: _isOpen[index]
                                            ? FontAwesomeIcons.angleUp
                                            : FontAwesomeIcons.angleDown,
                                        onClick: () => setState(() {
                                          _isOpen[index] = !_isOpen[index];
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              AnimatedContainer(
                                duration: const Duration(microseconds: 400),
                                width: screenSize.width * .9,
                                constraints: BoxConstraints(minHeight: 0),
                                decoration: BoxDecoration(
                                  color: AppPalette.background(context),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10),
                                  ),
                                ),
                                padding: _isOpen[index]
                                    ? const EdgeInsets.symmetric(vertical: 16.0)
                                    : EdgeInsets.zero,
                                child: Column(
                                  children: [
                                    if (_isOpen[index])
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Text(
                                          entry.value,
                                          style: AppTextStyles.bodyRegular
                                              .copyWith(
                                                color: AppPalette.secondaryText(
                                                  context,
                                                ),
                                                fontSize: 12,
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  /*  ExpansionPanelList(
                    elevation: 0,
                    materialGapSize: 24.0,
        
                    dividerColor: AppPalette.disabled(context),
                    //expandedHeaderPadding: EdgeInsets.zero,
                    children:
                        {
                          'How do I edit my pet’s health record?':
                              'Go to your pet’s profile → tap Health Record → edit or add new info.',
                          'My reminders are not sending notifications.':
                              'Check notification permissions in your phone settings and ensure reminders are enabled inside Peticare.',
                          'Can I sync data across devices?':
                              'Yes, simply log into your account on another device — your data will be securely synced.',
                        }.entries.toList().indexed.map((indexed) {
                          final index = indexed.$1;
                          final entry = indexed.$2;
                          return ExpansionPanel(
                            isExpanded: _isOpen[index],
                            canTapOnHeader: true,
                            headerBuilder: (context, isExpanded) => Padding(
                              padding: EdgeInsets.fromLTRB(
                                screenSize.width * .05,
                                0,
                                screenSize.width * .05,
                                _isOpen[index] ? 0.0 : 16.0,
                              ),
                              child: Text(
                                entry.key,
                                style: AppTextStyles.headingMedium.copyWith(
                                  color: AppPalette.textOnSecondaryBg(context),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            body: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * .05 + 6.0,
                              ),
                              child: Text(
                                entry.value,
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: AppPalette.secondaryText(context),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
        
                    expansionCallback: (panelIndex, isExpanded) => setState(() {
                      _isOpen[panelIndex] = isExpanded;
                    }),
                  ),
        */
                  /// Bottom Spacing
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
