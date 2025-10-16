import 'package:flutter/material.dart';

class CustomDateField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isLimitDate;
  final bool isDisabled;

  const CustomDateField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isLimitDate = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          isDisabled
              ? null
              : () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate:
                      isLimitDate
                          ? DateTime.now().subtract(Duration(days: 1))
                          : DateTime(2020),
                  lastDate: isLimitDate ? DateTime.now() : DateTime(2100),
                );
                if (picked != null) {
                  controller.text =
                      "${picked.day}-${picked.month}-${picked.year}";
                }
              },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(color: Color(0xFF655F5B)),
            prefixIcon: Icon(icon, color: Color(0xFF655F5B)),
            filled: true,
            fillColor: const Color(0xFFF0ECE9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Color(0xFF655F5B), fontSize: 16),
        ),
      ),
    );
  }
}
