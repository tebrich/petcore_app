import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';

/// A page for managing Two-Factor Authentication (2FA) settings. 🔐
///
/// This stateful widget allows users to enable or disable 2FA for their account
/// and select their preferred verification methods, such as SMS, an authenticator
/// app, or email. The UI provides clear explanations for each option and uses
/// switches to reflect the current state.
class TwoFactorAuthenticationPage extends StatefulWidget {
  const TwoFactorAuthenticationPage({super.key});

  @override
  State<TwoFactorAuthenticationPage> createState() =>
      _TwoFactorAuthenticationPageState();
}

class _TwoFactorAuthenticationPageState
    extends State<TwoFactorAuthenticationPage> {
  /// A boolean to control the master switch for enabling or disabling 2FA.
  late bool is2FAenabled;

  /// A boolean to indicate if SMS is selected as a verification method.
  late bool sMSVerification;

  /// A boolean to indicate if an authenticator app is selected as a verification method.
  late bool authenticatorApp;

  /// A boolean to indicate if email is selected as a verification method.
  late bool emailVerification;

  /// Initializes the state of the widget.
  /// Sets the default values for the 2FA settings.
  @override
  void initState() {
    super.initState();
    is2FAenabled = true;
    sMSVerification = true;
    authenticatorApp = false;
    emailVerification = false;
  }

  @override
  /// Builds the UI for the Two-Factor Authentication settings page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'two_factor_title'.tr,
            style: AppTextStyles.headingMedium.copyWith(
              color: AppPalette.textOnSecondaryBg(context),
              fontSize: 22,
            ),
          ),
        ),
        actions: [SizedBox(width: 24.0)],
      ),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /// Decorative background illustration with opacity to avoid distraction.
            /// The illustration is rotated and positioned to add visual interest.
            Positioned(
              top: -10,
              left: -15,
              child: Transform.rotate(
                angle: 0.25,
                child: Opacity(
                  opacity: .04,
                  child: SvgPicture.asset(
                    'assets/illustrations/lock2.svg',
                    height: 225,
                  ),
                ),
              ),
            ),

            /// Another decorative background illustration, positioned differently.
            /// This creates a layered, subtle background effect.
            Positioned(
              top: 325,
              right: -15,
              child: Transform.rotate(
                angle: -0.3,
                child: Opacity(
                  opacity: .025,
                  child: SvgPicture.asset(
                    'assets/illustrations/lock.svg',
                    height: 150,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top spacing for visual balance.
                  VerticalSpacing.md(context),

                  /// An introductory text explaining the purpose of 2FA.
                  Text(
                    'two_factor_description'.tr,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppPalette.disabled(context),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),

                  /// Spacing before the main content.
                  VerticalSpacing.xl(context),

                  /// The master switch tile for enabling or disabling 2FA.
                  _switchTile(
                    'two_factor_master_title'.tr,
                    is2FAenabled
                        ? 'two_factor_master_enabled'.tr: 'two_factor_master_disabled'.tr,
                    is2FAenabled,  
                    (value) {
                      if (value == false) {
                        setState(() {
                          is2FAenabled = false;
                          sMSVerification = false;
                          authenticatorApp = false;
                          emailVerification = false;
                        });
                      } else {
                        setState(() {
                          is2FAenabled = true;
                        });
                      }
                    },
                  ),
                  VerticalSpacing.lg(context),

                  /// A visual separator to distinguish the master switch from the method options.
                  Divider(
                    color: AppPalette.disabled(context).withValues(alpha: .5),
                    height: 1,
                    thickness: 1,
                  ),
                  VerticalSpacing.md(context),

                  /// A switch tile for the SMS verification method.
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'two_factor_sms'.tr,
                      null,
                      sMSVerification,
                      (value) {
                        setState(() {
                          sMSVerification = value;
                        });
                      },
                    ),
                  ),
                  VerticalSpacing.md(context),

                  /// A switch tile for the Authenticator App verification method.
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'two_factor_app'.tr,
                      null,
                      authenticatorApp,
                      (value) {
                        setState(() {
                          authenticatorApp = value;
                        });
                      },
                    ),
                  ),
                  VerticalSpacing.md(context),

                  /// A switch tile for the Email Verification method.
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'two_factor_email'.tr,
                      null,
                      emailVerification,
                      (value) {
                        setState(() {
                          emailVerification = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A helper method to build a consistent [Row] containing a title, an optional
  /// subtitle, and a [Switch].
  ///
  /// This widget factory ensures that all setting toggles share a uniform design.
  ///
  /// [Args]:
  ///   - `title` (String): The main text label for the switch.
  ///   - `subtitle` (String?): An optional description displayed below the title.
  ///   - `value` (bool): The current boolean state of the switch.
  ///   - `onUpdate` (Function(bool)): The callback function executed when the switch is toggled.
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
