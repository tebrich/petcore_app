import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Página de ajustes para gestionar recordatorios (notificaciones locales).
class RemindersSettingPage extends StatefulWidget {
  const RemindersSettingPage({super.key});

  @override
  State<RemindersSettingPage> createState() => _RemindersSettingPageState();
}

class _RemindersSettingPageState extends State<RemindersSettingPage> {
  /// Variables
  late bool areNotificationEnabled;
  late bool dailyReminders;
  late bool feedingReminders;
  late bool medicationReminders;
  late bool activityReminders;
  late bool groomingReminders;

  final _box = GetStorage();
  final String _keyMasterNotifications = "settings_notifications_enabled";

  /// INIT STATE
  @override
  void initState() {
    super.initState();

    // Master desde storage (default true)
    final stored = _box.read(_keyMasterNotifications);
    areNotificationEnabled = stored is bool ? stored : true;

    // El resto de toggles por ahora se mantienen en true por defecto
    dailyReminders = true;
    feedingReminders = true;
    medicationReminders = true;
    activityReminders = true;
    groomingReminders = true;

    // Si el master está apagado, apagamos todos visualmente
    if (!areNotificationEnabled) {
      dailyReminders = false;
      feedingReminders = false;
      medicationReminders = false;
      activityReminders = false;
      groomingReminders = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Recordatorios',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppPalette.textOnSecondaryBg(context),
              fontSize: 22,
            ),
          ),
        ),
        actions: const [SizedBox(width: 24.0)],
      ),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -10,
              left: -50,
              child: Transform.rotate(
                angle: 0.4,
                child: Opacity(
                  opacity: .025,
                  child: SvgPicture.asset(
                    'assets/illustrations/notification_bell.svg',
                    height: 250,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 300,
              right: -50,
              child: Transform.rotate(
                angle: -0.3,
                child: Opacity(
                  opacity: 0.025,
                  child: SvgPicture.asset(
                    'assets/illustrations/clock.svg',
                    height: 200,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading Space
                  VerticalSpacing.md(context),

                  Text(
                    'Personaliza cómo y cuándo recibir recordatorios sobre las tareas de cuidado de tu mascota.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppPalette.disabled(context),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),

                  // Sections Spacing
                  VerticalSpacing.xl(context),

                  /// Master switch: Notificaciones
                  _switchTile(
                    'Notificaciones',
                    'Mantente informado con actualizaciones oportunas sobre el cuidado y las actividades de tu mascota. Activa o desactiva aquí todas las notificaciones de la aplicación.',
                    areNotificationEnabled,
                    (value) {
                      setState(() {
                        areNotificationEnabled = value;

                        if (!value) {
                          dailyReminders = false;
                          feedingReminders = false;
                          medicationReminders = false;
                          activityReminders = false;
                          groomingReminders = false;
                        }
                      });

                      // 🔥 guardar en storage para usarlo como default en citas
                      _box.write(_keyMasterNotifications, areNotificationEnabled);
                    },
                  ),

                  VerticalSpacing.lg(context),
                  Divider(
                    color: AppPalette.disabled(context).withValues(alpha: .5),
                    height: 1,
                    thickness: 1,
                  ),

                  VerticalSpacing.md(context),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'Notificaciones de tareas',
                      null,
                      dailyReminders,
                      (value) {
                        setState(() {
                          dailyReminders = value;
                          if (!value) areNotificationEnabled = false;
                        });
                      },
                    ),
                  ),

                  VerticalSpacing.md(context),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'Recordatorios de comidas:',
                      null,
                      feedingReminders,
                      (value) {
                        setState(() {
                          feedingReminders = value;
                          if (!value) areNotificationEnabled = false;
                        });
                      },
                    ),
                  ),

                  VerticalSpacing.md(context),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'Alertas de medicación',
                      null,
                      medicationReminders,
                      (value) {
                        setState(() {
                          medicationReminders = value;
                          if (!value) areNotificationEnabled = false;
                        });
                      },
                    ),
                  ),

                  VerticalSpacing.md(context),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'Alertas de actividad',
                      null,
                      activityReminders,
                      (value) {
                        setState(() {
                          activityReminders = value;
                          if (!value) areNotificationEnabled = false;
                        });
                      },
                    ),
                  ),

                  VerticalSpacing.md(context),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'Recordatorios de Baños, Peluquería',
                      null,
                      groomingReminders,
                      (value) {
                        setState(() {
                          groomingReminders = value;
                          if (!value) areNotificationEnabled = false;
                        });
                      },
                    ),
                  ),

                  VerticalSpacing.xl(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
    String title,
    String? subtitle,
    bool value,
    Function(bool) onUpdate,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: AppTextStyles.buttonText.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: 15,
                  ),
                ),
                if (subtitle != null)
                  TextSpan(
                    text: '\n$subtitle',
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppPalette.secondaryText(context),
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Switch(value: value, onChanged: onUpdate),
      ],
    );
  }
}
