import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrefixIconHelper {
  static Widget get(String name, {double size = 24.0}) {
    // Mapping icon dari string ke IconData
    final builtinIcons = <String, IconData>{
      'tank': Icons.oil_barrel,
      'water': Icons.water_drop,
      'job': Icons.assignment,
      'floor': Icons.apartment_outlined,
      'date': Icons.event,
      'hour': Icons.schedule,
      'factory': Icons.factory,
      'location': Icons.location_on,
      'filter': Icons.filter_alt_outlined,
      'fiter_list': Icons.filter_list,
      'flow_mater': Icons.speed,
    };

    if (builtinIcons.containsKey(name)) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(builtinIcons[name], size: size, color: Colors.black),
      );
    }

    // Default: cari asset di folder 'assets/icons/{name}.svg'
    final assetPath = 'assets/icons/$name.svg';
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
