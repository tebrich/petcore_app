import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/shopping/presentation/widgets/product_image_builder.dart';

/// Builds a customizable promotional banner widget. 🌟
///
/// This function creates a visually appealing banner commonly used for showcasing
/// special offers, discounts, or featured products. It combines text and an image
/// in a decorated container.
///
/// A key feature is the special subtitle formatting. By wrapping a portion of the
/// `subtitle` string in triple asterisks (e.g., `***30% OFF***`), that part will be
/// automatically rendered in a bold font, making it stand out.
///
/// [Args]:
///   - `context`: The build context.
///   - `color`: The primary background color of the banner.
///   - `title`: The main heading of the banner.
///   - `subtitle`: The descriptive text. Use `***...***` for bold highlights.
///   - `imageUrl`: The URL of the image to display on the banner.
///   - `borderRadius`: The corner radius of the banner container.
///   - `titleColor` & `titleTextStyle`: Optional custom styling for the title.
///   - `subtitleColor` & `subtitleTextStyle`: Optional custom styling for the subtitle.
///   - `promoText`: Optional text for a small tag in the top-left corner.
///   - `promoColor`: The background color for the `promoText` tag.
Widget promotionBannerWidget(
  BuildContext context, {
  required Color color,
  required String title,
  required String subtitle,
  required String imageUrl,
  double borderRadius = 15,
  Color? titleColor,
  TextStyle? titleTextStyle,
  Color? subtitleColor,
  TextStyle? subtitleTextStyle,
  String? promoText,
  Color promoColor = Colors.green,
}) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width * .9,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: Theme.brightnessOf(context) == Brightness.dark ? 0.8 : 0.5,
        ),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: Stack(
        children: [
          /// An optional promotional tag displayed in the top-left corner.
          if (promoText != null)
            Container(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(7.5),
                ),
                color: promoColor,
              ),
              child: Text(
                promoText,
                style: AppTextStyles.playfulTag.copyWith(
                  color: titleColor ?? AppPalette.background(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                /// The main text content of the banner (title and subtitle).
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: VerticalSpacing.md(context).spacing,
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: title,
                            style: AppTextStyles.playfulTag.copyWith(
                              color:
                                  titleColor ??
                                  AppPalette.textOnSecondaryBg(context),
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          /// The subtitle, which is passed to the formatter for special styling.
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsetsGeometry.only(
                                top: VerticalSpacing.sm(context).spacing * .5,
                              ),
                              child: _subtitleFormatter(
                                context,
                                subtitle,
                                subtitleTextStyle,
                                subtitleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),

                /// Some Horizontal Spacing
                SizedBox(width: 4),

                /// The product image, decorated with floating paw icons.
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: -16,
                      bottom: -10,
                      child: Transform.rotate(
                        angle: .9,
                        child: Icon(
                          FontAwesomeIcons.paw,
                          color: color.withValues(alpha: 0.5),
                          size: 35,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      top: -4.0,
                      child: Transform.rotate(
                        angle: -.6,
                        child: Icon(
                          FontAwesomeIcons.paw,
                          color: color.withValues(alpha: 0.5),
                          size: 30,
                        ),
                      ),
                    ),
                    productImageBuilder(imageUrl, height: 100),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// A private helper widget that formats the subtitle string.
///
/// This function uses a regular expression (`RegExp`) to find and extract text
/// enclosed in triple asterisks (`***...***`). It then constructs a `Text.rich`
/// widget where the extracted text is styled to be bold, and the remaining
/// text keeps its default style.
///
/// This allows for dynamic and easy highlighting of promotional text directly
/// from the source string without needing complex widget compositions at the
/// call site.
Widget _subtitleFormatter(
  BuildContext context,
  String subtitle,
  TextStyle? subtitleTextStyle,
  Color? subtitleColor,
) {
  // Extract text between *** markers
  RegExp regExp = RegExp(r'\*\*\*(.*?)\*\*\*(.*)');
  Match? match = regExp.firstMatch(subtitle);
  String? discountText;
  String descriptionText;

  if (match != null) {
    discountText = match.group(1)?.trim();
    descriptionText = match.group(2)?.trim() ?? '';
  } else {
    descriptionText = subtitle;
  }
  return Text.rich(
    TextSpan(
      children: [
        if (discountText != null)
          TextSpan(
            text: '$discountText ',
            style:
                subtitleTextStyle?.copyWith(fontWeight: FontWeight.bold) ??
                AppTextStyles.bodyRegular.copyWith(
                  color: subtitleColor ?? AppPalette.primaryText(context),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
          ),
        TextSpan(
          text: descriptionText,
          style:
              subtitleTextStyle ??
              AppTextStyles.bodyRegular.copyWith(
                color: subtitleColor ?? AppPalette.primaryText(context),
                fontSize: 12,
              ),
        ),
      ],
    ),
  );
}
