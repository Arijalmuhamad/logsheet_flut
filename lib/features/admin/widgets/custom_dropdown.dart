import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String hint;
  final Widget? prefixIcon; // Ini bisa Icon() atau CustomPrefixIcon()
  final void Function(T?) onChanged;
  final bool isDisabled; 

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.prefixIcon,
    this.isDisabled = false, 
  });

  static CustomDropdown<String> fromStringItems({
    required String? value,
    required List<String> stringItems,
    required String hint,
    required void Function(String?) onChanged,
    Widget? prefixIcon,
    bool isDisabled = false, 
    Key? key,
  }) {
    return CustomDropdown<String>(
      key: key,
      value: value,
      hint: hint,
      prefixIcon: prefixIcon,
      onChanged: onChanged,
      isDisabled: isDisabled,
      items: stringItems
          .map(
            (item) => DropdownMenuItem<String>(value: item, child: Text(item)),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final Color currentFillColor =
        isDisabled ? const Color(0xFFEAEAEA) : const Color(0xFFF0ECE9);

    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      items: items,
      
      onChanged: isDisabled ? null : onChanged,
      decoration: InputDecoration(
        labelText: hint,
        filled: true,
        fillColor: currentFillColor, 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        prefixIcon: prefixIcon,
        // 8. Secara eksplisit mengatur 'enabled' pada dekorasi
        //    untuk memastikan tema visual disabled diterapkan.
        enabled: !isDisabled,
      ),
    );
  }
}