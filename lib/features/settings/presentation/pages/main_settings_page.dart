import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:shimmer/shimmer.dart';
import 'package:peticare/services/user_service.dart';
import 'package:get_storage/get_storage.dart';

/// Builds the main settings page, which serves as the central hub for all
/// user-configurable options. ⚙️
///
/// This page features a prominent header displaying the user's profile picture
/// and a personalized welcome message. The body consists of a scrollable,
/// categorized list of settings, allowing users to navigate to various sub-pages
/// for managing their account, security, preferences, and more.
///
/// Each setting item is constructed using the [_tile] helper method to ensure
/// a consistent look and feel across the page.
/// A consistent look and feel across the page.
class MainSettingsPage extends StatefulWidget {
  const MainSettingsPage({super.key});

  @override
  State<MainSettingsPage> createState() => _MainSettingsPageState();
}

class _MainSettingsPageState extends State<MainSettingsPage> {
  String? fullName;
  String? avatarUrl;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await UserService.getMe();
      setState(() {
        fullName = user['full_name'];
        avatarUrl = user['avatar_url'];
        isLoadingUser = false;
      });
    } catch (e) {
      isLoadingUser = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: AppPalette.background(context),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: SizedBox(
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: -15,
                right: 0,
                child: Transform.rotate(
                  angle: 0.4,
                  child: FaIcon(
                    FontAwesomeIcons.paw,
                    size: 35,
                    color: AppPalette.primary.withValues(alpha: .1),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 15,
                child: Transform.rotate(
                  angle: -0.25,
                  child: FaIcon(
                    FontAwesomeIcons.paw,
                    size: 45,
                    color: AppPalette.primary.withValues(alpha: .1),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppPalette.primary,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppPalette.primary.withValues(alpha: .1),
                        backgroundImage:
                            avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                        child: avatarUrl == null
                            ? Icon(
                                Icons.person,
                                color: AppPalette.disabled(context),
                                size: 30,
                              )
                            : null,
                      ),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'settings_greeting'.trParams({
                                'name': fullName ?? '',
                              }),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color:
                                    AppPalette.textOnSecondaryBg(context),
                              ),
                            ),
                            TextSpan(
                              text:
                                  '\n${'settings_pets_linked'.trParams({'count': '0'})}',
                              style: AppTextStyles.playfulTag.copyWith(
                                color: AppPalette.primary,
                              ),
                            ),
                          ],
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


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Spacing
            VerticalSpacing.md(context),

            Divider(
              color: AppPalette.disabled(context).withValues(alpha: .25),
              height: 1,
              thickness: 1,
              indent: screenSize.width * 0.1,
              endIndent: screenSize.width * 0.1,
            ),

            /// Spacing after Divider
            VerticalSpacing.md(context),

            // Personal Infos
            /// Section header for "Personal Info" settings.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              child: Text(
                'settings_section_personal'.tr,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppPalette.disabled(context),
                  fontSize: 12,
                ),
              ),
            ),

            /// Account
            /// Account settings tile.
            _tile(
              context,
              screenSize,
              AppPalette.primary,
              SvgPicture.asset('assets/illustrations/account.svg', height: 25),
              'Cuenta',
              () => Get.toNamed('/AccountDetails'),
            ),

            /// Payment Methods
            /// Payment Methods settings tile.
            _tile(
              context,
              screenSize,
              AppPalette.success(context),
              SvgPicture.asset(
                'assets/illustrations/credit_card.svg',
                height: 25,
              ),
              'Métodos de Pago',
              () => Get.toNamed('/PaymentMethods'),
            ),

            /// Minor Section Spacing
            VerticalSpacing.sm(context),
            // Security
            /// Section header for "Security" settings.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              child: Text(
                'settings_section_security'.tr,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppPalette.disabled(context),
                  fontSize: 12,
                ),
              ),
            ),

            /// 2FA
            /// Two-Factor Authentication settings tile.
            _tile(
              context,
              screenSize,
              AppPalette.secondary(context),
              SvgPicture.asset('assets/illustrations/lock2.svg', height: 27.5),
              'Autenticación de dos factores',
              () => Get.toNamed('/TwoFactorAuthentication'),
            ),

            /// Login History
            /// Login History settings tile.
            _tile(
              context,
              screenSize,
              AppPalette.secondaryText(context),

              SvgPicture.asset(
                'assets/illustrations/login_history.svg',
                height: 25,
              ),
              'Historial de Inicio de sesión',
              () => Get.toNamed('/LoginHistory'),
            ),

            /// Trusted Devices
            /// Trusted Devices settings tile.
            _tile(
              context,
              screenSize,
              AppPalette.success(context),
              SvgPicture.asset(
                'assets/illustrations/trusted_devices.svg',
                height: 27.5,
              ),
              'Dispositivos de Confianza',
              () => Get.toNamed('/TrustedDevices'),
            ),

            /// Minor Section Spacing
            VerticalSpacing.sm(context),
            // Notifications
            /// Section header for "Notifications" settings.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              child: Text(
                'settings_section_notifications'.tr,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppPalette.disabled(context),
                  fontSize: 12,
                ),
              ),
            ),

            /// Reminders
            /// Reminders settings tile.
            _tile(
              context,
              screenSize,
              AppPalette.primary,
              SvgPicture.asset(
                'assets/illustrations/notification_bell.svg',
                height: 25,
              ),
              'Recordatorios',
              () => Get.toNamed('/RemindersSetting'),
            ),

            /// Calendar Reminders settings tile.
            _tile(
              context,
              screenSize,
              AppPalette.secondary(context),
              SvgPicture.asset(
                'assets/illustrations/calendar_reminder.svg',
                height: 27.5,
              ),
              'Recordatorios del Calendario',
              () => Get.toNamed('/CalendarRemindersSetting'),
            ),

            /// Minor Section Spacing
            VerticalSpacing.sm(context),
            // App Preferences
            /// Section header for "App Preferences" settings.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              child: Text(
                'settings_section_preferences'.tr,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppPalette.disabled(context),
                  fontSize: 12,
                ),
              ),
            ),

            /// Theme & Appearance
            /// Theme & Appearance settings tile.
            _tile(
              context,
              screenSize,
              AppPalette.warning(context),
              SvgPicture.asset(
                'assets/illustrations/color_palette.svg',
                height: 25,
              ),
              'Tema y Apariencia',
              () => Get.toNamed('/AppearanceSeetings'),
            ),

            /// Language
            /// Language settings tile.
            _tile(
              context,
              screenSize,
              AppPalette.textOnSecondaryBg(context),
              SvgPicture.asset(
                'assets/illustrations/language.svg',
                height: 25,
                colorFilter: ColorFilter.mode(
                  AppPalette.primaryText(context),
                  BlendMode.srcATop,
                ),
              ),
              'Idioma',

              () => Get.toNamed('/LanguageSettings'),
            ),

            /// Minor Section Spacing
            VerticalSpacing.sm(context),
            // General
            /// Section header for "General" settings.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              child: Text(
                'settings_section_general'.tr,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppPalette.disabled(context),
                  fontSize: 12,
                ),
              ),
            ),

            /// Privacy & Security
            /// Privacy & Security settings tile.
            _tile(
              context,
              screenSize,
              AppPalette.success(context),
              SvgPicture.asset(
                'assets/illustrations/privacy_security.svg',
                height: 25,
              ),
              'Privacidad y Seguridad',
              () => Get.toNamed('/PrivacySecurity'),
            ),

            /// Help & Support
            /// Help & Support settings tile.
            _tile(
              context,
              screenSize,
              AppPalette.secondary(context),
              SvgPicture.asset(
                'assets/illustrations/help_support.svg',
                height: 25,
              ),
              'Ayuda y Soporte',
              () => Get.toNamed('/HelpSupport'),
            ),

            /// LogOut
            _tile(
              context,
              screenSize,
              AppPalette.danger(context),
              SvgPicture.asset('assets/illustrations/logout.svg', height: 25),
              'Cerrar Sesión',
              () async {
                final box = GetStorage();

                await box.remove("token");
                await box.remove("user");

                print("🚨 TOKEN ELIMINADO >>> ${box.read("token")}");

                Get.offAllNamed('/Signin');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// A helper method to build a consistent [ListTile] for each setting item.
  ///
  /// This widget factory ensures that all settings tiles share a uniform design,
  /// including a colored circular icon background, title styling, and navigation logic.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  ///   - `screenSize`: The dimensions of the screen.
  ///   - `color`: The background color for the leading icon's container.
  ///   - `leading`: The icon widget to display.
  ///   - `title`: The text to display as the tile's title.
  ///   - `onClick`: The callback function to execute when the tile is tapped.
  Widget _tile(
    BuildContext context,
    Size screenSize,
    Color color,
    Widget leading,
    String title,
    Function() onClick,
  ) {
    return ListTile(
      onTap: onClick,
      splashColor: AppPalette.primary.withValues(alpha: .1),
      contentPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: 4.0,
      ),
      leading: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: .25),
        ),
        child: leading,
      ),
      title: Text(
        title,
        style: AppTextStyles.buttonText.copyWith(
          color: AppPalette.textOnSecondaryBg(context),
          fontSize: 14,
        ),
      ),
      trailing: title == 'Log Out'
          ? null
          : Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 20,
              color: AppPalette.textOnSecondaryBg(context),
            ),
    );
  }
}
