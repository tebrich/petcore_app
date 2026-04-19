import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';


/// A page for managing the application's language settings. 🌐
///
/// This [StatefulWidget] presents the user with a comprehensive list of
/// available languages. Users can scroll through the list and select their
/// preferred language, which is then visually indicated with a checkmark.
///
/// In a production application, selecting a language would trigger the app's
/// internationalization (i18n) logic to update all UI text accordingly.
class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

/// The state for the [LanguageSettingsPage].
///
/// Manages the currently selected language and provides the list of all
/// available languages for the UI.
class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  /// The currently selected language. Defaults to 'English'.
  String selectedLanguage = 'English';

  /// A static list of supported languages displayed to the user.
  /// In a real-world scenario, this might be managed by an i18n configuration file.
  final List<String> languagesList = [
    'Arabic',
    'Bengali',
    'English',
    'French',
    'German',
    'Gujarati',
    'Hindi',
    'Indonesian',
    'Italian',
    'Japanese',
    'Javanese',
    'Korean',
    'Mandarin Chinese',
    'Marathi',
    'Persian (Farsi)',
    'Polish',
    'Portuguese',
    'Punjabi',
    'Russian',
    'Spanish',
    'Tamil',
    'Telugu',
    'Turkish',
    'Urdu',
    'Vietnamese',
  ];

  @override
  /// Builds the UI for the Language settings page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'language_settings_title'.tr,
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /// Decorative background illustration, subtly placed for visual texture.
            Positioned(
              top: -10,
              left: -50,
              child: Transform.rotate(
                angle: 0.4,
                child: Opacity(
                  opacity: 0.025,
                  child: SvgPicture.asset(
                    'assets/illustrations/language.svg',
                    height: 250,
                    colorFilter: ColorFilter.mode(
                      AppPalette.primaryText(context),
                      BlendMode.srcATop,
                    ),
                  ),
                ),
              ),
            ),

            /// Another decorative background illustration, creating a layered effect.
            Positioned(
              top: 300,
              right: -50,
              child: Transform.rotate(
                angle: -0.3,
                child: Opacity(
                  opacity: .025,
                  child: SvgPicture.asset(
                    'assets/illustrations/language.svg',
                    height: 150,
                    colorFilter: ColorFilter.mode(
                      AppPalette.primaryText(context),
                      BlendMode.srcATop,
                    ),
                  ),
                ),
              ),
            ),

            /// The main content column containing the description and language list.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalSpacing.md(context),

                /// A descriptive subtitle for the page.
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * .05,
                  ),
                  child: Text(
                    'language_settings_description'.tr,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppPalette.disabled(context),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),

                /// Section Spacing
                VerticalSpacing.lg(context),

                /// The scrollable list of available languages.
                Expanded(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .05,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: AppPalette.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: languagesList.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          _languageTile(context, index),
                    ),
                  ),
                ),

                /// Bottom Spacing
                VerticalSpacing.md(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// A helper method to build a consistent [ListTile] for each language item.
  ///
  /// This widget factory ensures that all language tiles share a uniform design.
  /// It handles tap events to update the [selectedLanguage] and displays a
  /// checkmark icon for the currently active language.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  ///   - `index`: The index of the language in the [languagesList].
  Widget _languageTile(BuildContext context, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () {
            setState(() {
              selectedLanguage = languagesList[index];
            });
          },
          splashColor: AppPalette.primary.withValues(alpha: 0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),

          title: Text(
            languagesList[index],
            style: AppTextStyles.buttonText.copyWith(
              color: AppPalette.textOnSecondaryBg(context),
              fontSize: 14,
            ),
          ),
          trailing: languagesList[index] == selectedLanguage
              ? Icon(
                  Icons.check_circle_rounded,
                  size: 24.0,
                  color: AppPalette.primary,
                )
              : null,
        ),

        if (index != languagesList.length - 1)
          Divider(
            color: AppPalette.disabled(context).withValues(alpha: .25),
            height: 1,
            thickness: 1,
            indent: 8.0,
            endIndent: 8.0,
          ),
      ],
    );
  }
}
