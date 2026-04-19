import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:get/get.dart';


/// A page that displays the user's recent login history for security monitoring. 🕒
///
/// This [StatelessWidget] provides a read-only view of the devices and locations
/// from which the user's account has been accessed. It helps users identify
/// any suspicious or unrecognized activity.
///
/// The page features a list of login sessions, each showing the device type,
/// location, timestamp, and connection status. It also includes a placeholder
/// sorting menu to demonstrate where such functionality would be placed.
class LoginHistoryPage extends StatelessWidget {
  const LoginHistoryPage({super.key});

  @override
  /// Builds the UI for the Login History page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'login_history_title'.tr,
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
                    'assets/illustrations/trusted_devices.svg',
                    height: 300,
                  ),
                ),
              ),
            ),

            /// Another decorative background icon, creating a layered effect.
            Positioned(
              top: 325,
              right: 30,
              child: Transform.rotate(
                angle: -0.3,
                child: Icon(
                  FontAwesomeIcons.clockRotateLeft,
                  color: AppPalette.primary.withValues(alpha: 0.05),
                  size: 175,
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

                  /// A descriptive subtitle explaining the page's purpose.
                  Text(
                    'login_history_description'.tr,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppPalette.disabled(context),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),

                  VerticalSpacing.xl(context),

                  /// The main body content, including the sorting menu and the list of logins.
                  _bodyWidgetBuilder(context, screenSize),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A helper method that constructs the primary content of the page.
  ///
  /// This widget factory combines the sorting menu and the `ListView` of login
  /// activities into a single column.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  ///   - `screenSize`: The dimensions of the screen.
  Widget _bodyWidgetBuilder(BuildContext context, Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        /// Menu
        _sortingMenuWidgetBuilder(context),
        VerticalSpacing.sm(context),

        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: DummyData.loginHistory.length,
          itemBuilder: (context, index) => _loginActivityWidgetBuilder(
            context,
            screenSize,
            DummyData.loginHistory[index]["id"],
            DummyData.loginHistory[index]["device"],
            DummyData.loginHistory[index]["location"],
            DummyData.loginHistory[index]["timestamp"],
            DummyData.loginHistory[index]["status"],
          ),
        ),
      ],
    );
  }

  /// A helper method to build a consistent tile for each login history item.
  ///
  /// This widget factory creates a styled [Container] that displays details
  /// for a single login session. It includes an icon, device name, location,
  /// timestamp, and a colored dot indicating the session's status.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  ///   - `screenSize`: The dimensions of the screen.
  ///   - `id`: A unique identifier for the list item, used for the widget's [Key].
  ///   - `deviceName`: The name of the device used for the login.
  ///   - `address`: The geographical location of the login.
  ///   - `dateTime`: The timestamp of the login event.
  ///   - `status`: The status of the session (e.g., "Connected", "Logged Out").
  Widget _loginActivityWidgetBuilder(
    BuildContext context,
    Size screenSize,
    id,
    String deviceName,
    String address,
    DateTime dateTime,
    String status,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: VerticalSpacing.lg(context).spacing),
      decoration: BoxDecoration(
        color: AppPalette.background(context),
        borderRadius: BorderRadiusGeometry.all(Radius.circular(15)),
        border: Border.all(color: AppPalette.primary.withValues(alpha: .5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            spreadRadius: 2,
            blurRadius: 3,
          ),
        ],
      ),
      child: Container(
        key: Key(id),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        decoration: BoxDecoration(
          color: AppPalette.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadiusGeometry.all(Radius.circular(15)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/illustrations/trusted_devices.svg',
              height: 45,
            ),

            /// Spacing
            const SizedBox(width: 8.0),

            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$deviceName\n',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppPalette.textOnSecondaryBg(context),
                        fontSize: 16,
                      ),
                    ),
                    WidgetSpan(
                      child: SvgPicture.asset(
                        'assets/illustrations/location_pin.svg',
                        height: 15,
                      ),
                    ),
                    TextSpan(
                      text: "$address\n",
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppPalette.secondaryText(context),
                        fontSize: 12,
                      ),
                    ),
                    WidgetSpan(
                      alignment: ui.PlaceholderAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.0, right: 2.0),
                        child: SvgPicture.asset(
                          'assets/illustrations/clock.svg',
                          height: 13,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: DateFormat("yyyy-MM-dd • HH:mm").format(dateTime),
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppPalette.secondaryText(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Spacing
            const SizedBox(width: 24.0),

            /// A colored dot indicating the status of the login session.
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color:
                    (status == "Connected"
                            ? AppPalette.success(context)
                            : status == "Logged Out"
                            ? AppPalette.disabled(context)
                            : AppPalette.danger(context))
                        .withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A helper method that builds the sorting menu UI.
  ///
  /// This widget contains a text label and a [DropdownButton] that allows users
  // to select a sorting criterion. The functionality is currently a placeholder.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  Widget _sortingMenuWidgetBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'login_history_order_by'.tr,
          style: AppTextStyles.playfulTag.copyWith(
            color: AppPalette.disabled(context),
            fontSize: 12,
          ),
        ),
        SizedBox(
          height: 30,
          child: DropdownButton(
            value: "Name",
            style: AppTextStyles.buttonText.copyWith(
              color: AppPalette.disabled(context),
              fontSize: 12,
            ),
            iconSize: 20,
            iconEnabledColor: AppPalette.disabled(context),
            elevation: 2,
            underline: const SizedBox(),
            padding: EdgeInsets.zero,
            dropdownColor: AppPalette.surfaces(context),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            items: [
              DropdownMenuItem(value: "Name", child: Text('login_history_sort_name'.tr)),
              DropdownMenuItem(value: "Date", child: Text('login_history_sort_date'.tr)),
              DropdownMenuItem(value: "Location", child: Text('login_history_sort_location'.tr)),
            ],
            onChanged: (newValue) {},
          ),
        ),
      ],
    );
  }
}
