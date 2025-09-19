import 'dart:developer';

import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String hint;
  final Widget? prefixIcon; // Ini bisa Icon() atau CustomPrefixIcon()
  final void Function(T?) onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.prefixIcon,
  });

  static CustomDropdown<String> fromStringItems({
    required String? value,
    required List<String> stringItems,
    required String hint,
    required void Function(String?) onChanged,
    Widget? prefixIcon,
    Key? key,
  }) {
    return CustomDropdown<String>(
      key: key,
      value: value,
      hint: hint,
      prefixIcon: prefixIcon,
      onChanged: onChanged,
      items:
          stringItems
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF0ECE9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
