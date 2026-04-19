import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/features/shopping/presentation/widgets/cart_loading_widget.dart';

/// Builds a widget to display a product image from a network URL. 🖼️
///
/// This helper function is used throughout the shopping feature to ensure a
/// consistent appearance for product images. It provides a custom loading state
/// using the [AnimatedCartLoading] widget and a user-friendly error state if
/// the image fails to load.
///
/// [Args]:
///   - `pUrl`: The URL of the product image to display.
///   - `height`: The height of the image container. Defaults to 90.
///   - `loadingCartSize`: The size of the animated cart icon in the loading state. Defaults to 40.
///   - `applyPadding`: Whether to apply left padding to the container. Useful for layout adjustments. Defaults to true.
Widget productImageBuilder(
  String pUrl, {
  double height = 90,
  double loadingCartSize = 40,
  bool applyPadding = true,
}) {
  return Image.network(
    pUrl,
    height: height,
    fit: BoxFit.cover,
    alignment: Alignment.center,

    /// Displays an [AnimatedCartLoading] widget while the image is being fetched from the network.
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Container(
        height: height,
        width: height - (applyPadding ? 8 : 0),
        margin: EdgeInsets.only(left: applyPadding ? 8.0 : 0.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(height * .1)),
          color: AppPalette.disabled(context).withValues(alpha: 0.3),
        ),
        child: AnimatedCartLoading(
          logoSize: Size(loadingCartSize, loadingCartSize),
          rightOutsideLineColor: AppPalette.textOnSecondaryBg(context),
          rightOutsideLineStrokeWidth: 0.75,
          roadLineColor: AppPalette.primaryText(context),
          roadStrokeWidth: 1.5,
          color: AppPalette.textOnSecondaryBg(context),
          strokeWidth: 0.5,
        ),
      );
    },

    /// Displays a user-friendly error message with an icon if the image fails to load.
    errorBuilder: (context, error, stackTrace) => Container(
      height: height,
      width: height - (applyPadding ? 8 : 0),
      margin: EdgeInsets.only(left: applyPadding ? 8.0 : 0.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(height * .1)),
        color: AppPalette.disabled(context).withValues(alpha: 0.3),
      ),
      padding: EdgeInsets.all(height * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: height * 0.4 > 90 ? 90 : height * 0.4,
            color: AppPalette.secondaryText(context),
          ),

          const SizedBox(height: 4.0),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Image failed to load',
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppPalette.secondaryText(context),
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}
