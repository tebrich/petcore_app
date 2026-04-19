import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/features/authentication/presentation/widgets/reset_confirmation_page.dart';
import 'package:peticare/features/authentication/presentation/widgets/reset_password_page.dart';



/// A screen that guides the user through the password reset process.
///
/// This page uses a `PageView` to manage a two-step flow:
/// 1.  **Email Entry:** The user is prompted to enter their email address in the
///     `resetPasswordPage` widget.
/// 2.  **Confirmation:** After submitting, the view transitions to the
///     `resetConfirmationPage` widget, which confirms that a reset link has been sent.
///
/// The page features a dynamic `BottomAppBar` whose button changes based on the
/// current step. Navigation between steps is controlled programmatically via a
/// `PageController`, with physical swiping disabled.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

/// Manages the state and page flow for the [ForgotPasswordPage].
///
/// This state class uses a `PageController` to navigate between the password
/// reset steps and a boolean flag, `isOnLastPage`, to update the bottom
/// navigation button accordingly.
class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  /// Controls the `PageView` to switch between reset steps.
  final PageController _pageController = PageController();
  late bool isOnLastPage;

  @override
  void initState() {
    isOnLastPage = false;
    _pageController.addListener(() {
      if (_pageController.page != null) {
        if (_pageController.page == 1.0) {
          if (!isOnLastPage) {
            setState(() {
              isOnLastPage = true;
            });
          }
        } else {
          if (isOnLastPage) {
            setState(() {
              isOnLastPage = false;
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenSize.height - 70, // - the BottomAppBar height = 70
          width: screenSize.width,
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              resetPasswordPage(context, screenSize),
              resetConfirmationPage(context, screenSize),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        padding: EdgeInsets.all(5),
        child: Center(
          child: isOnLastPage
              ? AnimatedElevatedButton(
                  text: 'forgot_close'.tr,
                  size: Size(screenSize.width * 0.6, 50),

                  onClick: () {
                    Get.back();
                  },
                )
              : AnimatedElevatedButton(
                  text: 'forgot_reset_password'.tr,
                  size: Size(screenSize.width * 0.6, 50),

                  onClick: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.linear,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
