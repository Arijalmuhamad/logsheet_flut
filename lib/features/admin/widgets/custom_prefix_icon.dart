import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPrefixIcon extends StatelessWidget {
  final String assetPath;
  final double size;

  const CustomPrefixIcon({
    super.key,
    required this.assetPath,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath.endsWith('.svg')) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      );
    }
  }
}
