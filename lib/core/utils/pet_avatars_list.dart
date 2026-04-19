import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peticare/core/assets/pet_avatars.dart';
import 'package:peticare/core/theme/app_pallete.dart';

/// Registry of pet avatars by pet type.
/// Each avatar is a widget builder function.
Map<String, Map<String, Widget Function(double, double, Color)>> petAvatars(
  BuildContext context,
) {
  return {
    // 🐶 DOGS
    "Dog": {
      "Dog1": (h, r, c) => _avatar(context, h, r, c, PetAvatars.dog1),
      "Dog2": (h, r, c) => _avatar(context, h, r, c, PetAvatars.dog2),
      "Dog3": (h, r, c) => _avatar(context, h, r, c, PetAvatars.dog3),
      "Dog4": (h, r, c) => _avatar(context, h, r, c, PetAvatars.dog4),
      "Dog5": (h, r, c) => _avatar(context, h, r, c, PetAvatars.dog5),
      "Dog6": (h, r, c) => _avatar(context, h, r, c, PetAvatars.dog6),
      "Dog7": (h, r, c) => _avatar(context, h, r, c, PetAvatars.dog7),
      "Dog8": (h, r, c) => _avatar(context, h, r, c, PetAvatars.dog8),
    },

    // 🐱 CATS
    "Cat": {
      "Cat1": (h, r, c) => _avatar(context, h, r, c, PetAvatars.cat1),
      "Cat2": (h, r, c) => _avatar(context, h, r, c, PetAvatars.cat2),
      "Cat3": (h, r, c) => _avatar(context, h, r, c, PetAvatars.cat3),
      "Cat4": (h, r, c) => _avatar(context, h, r, c, PetAvatars.cat4),
      "Cat5": (h, r, c) => _avatar(context, h, r, c, PetAvatars.cat5),
      "Cat6": (h, r, c) => _avatar(context, h, r, c, PetAvatars.cat6),
      "Cat7": (h, r, c) => _avatar(context, h, r, c, PetAvatars.cat7),
      "Cat8": (h, r, c) => _avatar(context, h, r, c, PetAvatars.cat8),
    },

    // 🐰 RABBITS
    "Rabbit": {
      "Rabbit1": (h, r, c) => _avatar(context, h, r, c, PetAvatars.rabbit1),
      "Rabbit2": (h, r, c) => _avatar(context, h, r, c, PetAvatars.rabbit2),
      "Rabbit3": (h, r, c) => _avatar(context, h, r, c, PetAvatars.rabbit3),
      "Rabbit4": (h, r, c) => _avatar(context, h, r, c, PetAvatars.rabbit4),
      "Rabbit5": (h, r, c) => _avatar(context, h, r, c, PetAvatars.rabbit5),
      "Rabbit6": (h, r, c) => _avatar(context, h, r, c, PetAvatars.rabbit6),
      "Rabbit7": (h, r, c) => _avatar(context, h, r, c, PetAvatars.rabbit7),
      "Rabbit8": (h, r, c) => _avatar(context, h, r, c, PetAvatars.rabbit8),
    },

    // 🐦 BIRDS
    "Bird": {
      "Bird1": (h, r, c) => _avatar(context, h, r, c, PetAvatars.bird1),
      "Bird2": (h, r, c) => _avatar(context, h, r, c, PetAvatars.bird2),
      "Bird3": (h, r, c) => _avatar(context, h, r, c, PetAvatars.bird3),
      "Bird4": (h, r, c) => _avatar(context, h, r, c, PetAvatars.bird4),
      "Bird5": (h, r, c) => _avatar(context, h, r, c, PetAvatars.bird5),
      "Bird6": (h, r, c) => _avatar(context, h, r, c, PetAvatars.bird6),
      "Bird7": (h, r, c) => _avatar(context, h, r, c, PetAvatars.bird7),
      "Bird8": (h, r, c) => _avatar(context, h, r, c, PetAvatars.bird8),
    },

    // 🐠 FISH
    "Fish": {
      "Fish1": (h, r, c) => _avatar(context, h, r, c, PetAvatars.fish1),
      "Fish2": (h, r, c) => _avatar(context, h, r, c, PetAvatars.fish2),
      "Fish3": (h, r, c) => _avatar(context, h, r, c, PetAvatars.fish3),
      "Fish4": (h, r, c) => _avatar(context, h, r, c, PetAvatars.fish4),
      "Fish5": (h, r, c) => _avatar(context, h, r, c, PetAvatars.fish5),
      "Fish6": (h, r, c) => _avatar(context, h, r, c, PetAvatars.fish6),
      "Fish7": (h, r, c) => _avatar(context, h, r, c, PetAvatars.fish7),
      "Fish8": (h, r, c) => _avatar(context, h, r, c, PetAvatars.fish8),
    },
  };
}

/// Shared avatar widget (UI Kit compatible)
Widget _avatar(
  BuildContext context,
  double parentHeight,
  double ratio,
  Color bgColor,
  String asset,
) {
  return Container(
    height: parentHeight,
    width: parentHeight,
    decoration: BoxDecoration(
      color: AppPalette.surfaces(context),
      shape: BoxShape.circle,
    ),
    child: Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        asset,
        height: parentHeight * ratio,
        fit: BoxFit.contain,
      ),
    ),
  );
}
