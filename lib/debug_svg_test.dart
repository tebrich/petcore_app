import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'core/assets/pet_avatars.dart';

class DebugSvgTest extends StatelessWidget {
  const DebugSvgTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 120,
          height: 120,
          color: Colors.yellow,
          child: SvgPicture.asset(
            PetAvatars.dog01,
          ),
        ),
      ),
    );
  }
}

