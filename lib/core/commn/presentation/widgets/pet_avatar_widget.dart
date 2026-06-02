import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PetAvatarWidget extends StatelessWidget {

  final Map<String, dynamic> pet;

  final double radius;

  const PetAvatarWidget({
    required this.pet,
    this.radius = 28,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final photoUrl = pet["photo_url"];

    return CircleAvatar(
      radius: radius,

      backgroundImage:
      photoUrl != null &&
          photoUrl.toString().isNotEmpty

          ? NetworkImage(photoUrl)

          : null,

      child:
      photoUrl == null ||
          photoUrl.toString().isEmpty

          ? SvgPicture.asset(
        _getAvatarPath(
          pet["avatar_code"],
        ),
        width: radius * 1.5,
        height: radius * 1.5,
      )

          : null,
    );
  }
}

////////////////////////////////////////////////////////////
/// AVATAR PATH
////////////////////////////////////////////////////////////
String _getAvatarPath(String? avatarCode) {

  if (avatarCode == null) {
    return 'assets/avatars/dogs/dog1.svg';
  }

  final code = avatarCode.toLowerCase();

  if (code.startsWith('dog')) {
    return 'assets/avatars/dogs/$code.svg';
  }

  if (code.startsWith('cat')) {
    return 'assets/avatars/cats/$code.svg';
  }

  if (code.startsWith('rabbit')) {
    return 'assets/avatars/rabbits/$code.svg';
  }

  if (code.startsWith('bird')) {
    return 'assets/avatars/birds/$code.svg';
  }

  if (code.startsWith('fish')) {
    return 'assets/avatars/fish/$code.svg';
  }

  return 'assets/avatars/others/other1.svg';
}
