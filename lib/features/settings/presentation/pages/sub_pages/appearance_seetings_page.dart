import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/controllers/theme_controller.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// A page for managing the app's theme and appearance settings. 🎨
///
/// This widget allows users to personalize their visual experience by choosing
/// a theme mode (Light, Dark, or System) and selecting a primary accent color.
///
/// The page is built using a [GetBuilder] that listens to a [ThemeController],
/// ensuring the UI instantly reflects any changes the user makes. It features
/// interactive previews for theme modes and a grid of selectable color swatches.
class AppearanceSeetingsPage extends StatelessWidget {
  const AppearanceSeetingsPage({super.key});

  @override
  /// Builds the UI for the Theme & Appearance settings page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'settings_appearance_title'.tr,
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
            /// Decorative background illustration, subtly placed for visual texture.
            Positioned(
              top: -10,
              left: -50,
              child: Transform.rotate(
                angle: 0.4,
                child: Opacity(
                  opacity: .025,
                  child: SvgPicture.asset(
                    'assets/illustrations/color_palette.svg',
                    height: 250,
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
                    'assets/illustrations/color_palette.svg',
                    height: 150,
                  ),
                ),
              ),
            ),

            /// A stateful builder that rebuilds the UI when the theme state changes.
            GetBuilder<ThemeController>(
              builder: (themeController) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Top spacing for visual balance.
                    VerticalSpacing.md(context),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * .05,
                      ),
                      child: Text(
                        'settings_appearance_description'.tr,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppPalette.disabled(context),
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),

                    /// Section Spacing
                    VerticalSpacing.xl(context),
                    _modeSection(context, screenSize),

                    /// Section Spacing
                    VerticalSpacing.xl(context),
                    _colorSection(context, screenSize),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the section for selecting the application's theme mode.
  ///
  /// This widget displays three interactive previews representing "Light", "Dark",
  /// and "System" modes. Tapping a preview updates the app's theme via the
  /// [ThemeController]. The currently active mode is highlighted with a border.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  ///   - `screenSize`: The dimensions of the screen, used for layout calculations.
  ///
  Widget _modeSection(BuildContext context, Size screenSize) {
    ThemeController themeController = Get.find<ThemeController>();
    return Container(
      width: screenSize.width * .9,
      margin: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppPalette.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'settings_theme_mode'.tr,
            style: AppTextStyles.headingMedium.copyWith(
              color: AppPalette.textOnSecondaryBg(context),
              fontSize: 13,
            ),
          ),

          /// Small Text Spacing
          VerticalSpacing.sm(context),

          Text(
            'settings_theme_mode_description'.tr,
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppPalette.disabled(context),
              fontSize: 11,
            ),
          ),

          /// Small Title Spacing
          VerticalSpacing.md(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _mobileScreenWidgetBuilder(
                    context,
                    screenSize,
                    'light',
                    themeController.themeMode == ThemeMode.light,
                    () {
                      themeController.setTheme(ThemeMode.light);
                    },
                  ),
                  VerticalSpacing.sm(context),
                  Text(
                    'settings_theme_light'.tr,
                    style: AppTextStyles.playfulTag.copyWith(
                      color: AppPalette.secondaryText(context),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  _mobileScreenWidgetBuilder(
                    context,
                    screenSize,
                    'dark',
                    themeController.themeMode == ThemeMode.dark,
                    () {
                      themeController.setTheme(ThemeMode.dark);
                    },
                  ),
                  VerticalSpacing.sm(context),
                  Text(
                    'settings_theme_dark'.tr,
                    style: AppTextStyles.playfulTag.copyWith(
                      color: AppPalette.secondaryText(context),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  _mobileScreenWidgetBuilder(
                    context,
                    screenSize,
                    'system',
                    themeController.themeMode == ThemeMode.system,
                    () {
                      themeController.setTheme(ThemeMode.system);
                    },
                  ),
                  VerticalSpacing.sm(context),
                  Text(
                    'settings_theme_system'.tr,
                    style: AppTextStyles.playfulTag.copyWith(
                      color: AppPalette.primaryText(context),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the section for selecting the application's primary accent color.
  ///
  /// This widget displays a grid of predefined color swatches. When a user taps
  /// a color, it updates the app's primary color via the [ThemeController].
  /// The currently selected color is visually indicated with a border and a checkmark icon.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  ///   - `screenSize`: The dimensions of the screen, used for layout calculations.
  ///
  Widget _colorSection(BuildContext context, Size screenSize) {
    Map<String, Color> colorsList = {
      'Soft Blue': AppPalette.softBlue,
      'Rose Quartz': AppPalette.roseQuartz,
      'Coral Rose': AppPalette.coralRose,
      'Lavender': AppPalette.lavenderMist,
      'Gold': AppPalette.dunflowerGold,
      'Aqua Breeze': AppPalette.aquaBreeze,
      'Peach': AppPalette.blushPeach,
      'Storm Blue': AppPalette.stormBlue,
    };
    ThemeController themeController = Get.find<ThemeController>();
    return Container(
      width: screenSize.width * .9,
      margin: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppPalette.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'settings_highlight_color'.tr,
            style: AppTextStyles.headingMedium.copyWith(
              color: AppPalette.textOnSecondaryBg(context),
              fontSize: 13,
            ),
          ),

          /// Small Text Spacing
          VerticalSpacing.sm(context),

          Text(
            'settings_highlight_color_description'.tr,
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppPalette.disabled(context),
              fontSize: 11,
            ),
          ),

          /// Small Title Spacing
          VerticalSpacing.md(context),

          Wrap(
            spacing: 8,
            runSpacing: 16.0,
            direction: Axis.horizontal,
            children: List.generate(
              colorsList.length,
              (index) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      themeController.setPrimaryColor(
                        colorsList.values.elementAt(index),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            colorsList.values.elementAt(index) ==
                                themeController.primaryColor
                            ? Border.all(color: AppPalette.primary)
                            : null,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height:
                            colorsList.values.elementAt(index) ==
                                themeController.primaryColor
                            ? 35
                            : 30,
                        width:
                            colorsList.values.elementAt(index) ==
                                themeController.primaryColor
                            ? 35
                            : 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorsList.values.elementAt(index),
                        ),

                        child:
                            colorsList.values.elementAt(index) ==
                                themeController.primaryColor
                            ? Icon(
                                Icons.check,
                                size: 20.0,
                                color: AppPalette.background(context),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A helper method to build a visual preview of a mobile screen for a theme mode.
  ///
  /// This widget factory creates a miniature, non-interactive representation of the app's
  /// UI in a specific theme (Light, Dark, or System). It uses a combination of
  /// colored [Container]s to simulate the appearance, helping the user visualize
  /// their selection.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  ///   - `screenSize`: The dimensions of the screen.
  ///   - `mode`: A string representing the theme to preview ('light', 'dark', or 'system').
  ///   - `isSelected`: A boolean indicating if this is the currently active theme mode.
  ///   - `onSelect`: The callback function to execute when the preview is tapped.
  ///
  Widget _mobileScreenWidgetBuilder(
    BuildContext context,
    Size screenSize,
    String mode,
    bool isSelected,
    Function() onSelect,
  ) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        border: isSelected ? Border.all(color: AppPalette.primary) : null,
      ),
      child: GestureDetector(
        onTap: onSelect,
        child: Container(
          height: 120,
          width: 70,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: mode == 'light' ? Color(0xffF8F9FA) : Color(0xff121417),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Color(0xffAFAFAF)),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 60,
                  width: mode == 'dark'
                      ? 70
                      : mode == 'system'
                      ? 35
                      : 0,
                  decoration: BoxDecoration(
                    color: Color(0xff23272C),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                ),
              ),
              if (mode == 'system')
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 120,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Color(0xffF8F9FA),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 16,
                      width: 59,
                      decoration: BoxDecoration(
                        color: Color(0xffAFAFAF).withValues(alpha: .25),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Container(
                      height: 8,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Color(0xffAFAFAF).withValues(alpha: .25),
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 9,
                          width: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffAFAFAF).withValues(alpha: .25),
                          ),
                        ),
                        Container(
                          height: 9,
                          width: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffAFAFAF).withValues(alpha: .25),
                          ),
                        ),
                        Container(
                          height: 9,
                          width: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffAFAFAF).withValues(alpha: .25),
                          ),
                        ),
                        Container(
                          height: 9,
                          width: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffAFAFAF).withValues(alpha: .25),
                          ),
                        ),
                        Container(
                          height: 9,
                          width: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffAFAFAF).withValues(alpha: .25),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppPalette.primary,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
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
  }
}
