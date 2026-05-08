import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/constants/tips.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

class TipsInfoWidget extends StatefulWidget {
  const TipsInfoWidget({super.key});

  @override
  State<TipsInfoWidget> createState() => _TipsInfoWidgetState();
}

class _TipsInfoWidgetState extends State<TipsInfoWidget>
    with SingleTickerProviderStateMixin {

  final indexNotifier = ValueNotifier<int>(0);

  late AnimationController animationController;

  late Animation<double> scalingAnimation;

  @override
  void initState() {
    indexNotifier.value = 0;

    animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        )..addListener(() async {

          if (animationController.isCompleted) {

            if (indexNotifier.value < Constants.tipsList.length - 1) {
              indexNotifier.value++;
            } else {
              indexNotifier.value = 0;
            }

            if (mounted) {
              animationController.reverse();
            }

          } else if (animationController.isDismissed) {

            await Future.delayed(const Duration(seconds: 20));

            if (mounted) {
              animationController.forward();
            }
          }
        });

    scalingAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutBack,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      await Future.delayed(const Duration(seconds: 20));

      if (mounted) {
        animationController.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    indexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: ValueListenableBuilder(
        valueListenable: indexNotifier,
        builder: (context, index, _) {

          return AnimatedBuilder(
            animation: animationController,

            builder: (context, child) {

              return Transform.scale(
                scale: scalingAnimation.value,

                child: _tipWidget(
                  screenSize,
                  Constants.tipsList[index],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _tipWidget(
    Size screenSize,
    Map<String, dynamic> tipDetails,
  ) {

    return Container(
      width: screenSize.width * 0.8,

      clipBehavior: Clip.hardEdge,

      decoration: BoxDecoration(
        color: AppPalette.primary,

        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .3),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),

      child: Stack(
        alignment: Alignment.center,

        children: [

          Positioned(
            top: -30,
            left: -15,

            child: Container(
              height: 75,
              width: 75,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: AppPalette.background(context).withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.09
                      : 0.15,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -30,
            right: -10,

            child: Container(
              height: 100,
              width: 100,

              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.only(bottom: 30),

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: AppPalette.background(context).withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.09
                      : 0.19,
                ),
              ),

              child: Opacity(
                opacity: .75,

                child: SvgPicture.asset(
                  'assets/illustrations/paw_grip.svg',

                  height: 80,
                  fit: BoxFit.fitWidth,

                  colorFilter: ColorFilter.mode(
                    AppPalette.primary.withValues(
                      alpha: Theme.of(context).brightness == Brightness.dark
                          ? 0.8
                          : 0.7,
                    ),
                    BlendMode.srcATop,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                Text(
                  '(Consejos útiles)',

                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppPalette.secondary(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),

                  textAlign: TextAlign.center,
                ),

                VerticalSpacing.sm(context),

                Text(
                  tipDetails['tip'],

                  style: AppTextStyles.playfulTag.copyWith(
                    color: AppPalette.background(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),

                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
