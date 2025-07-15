import 'package:flutter/material.dart';

class CustomHourField extends StatelessWidget {
  final int? selectedHour;
  final VoidCallback onTap;

  const CustomHourField({
    super.key,
    required this.selectedHour,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF0ECE9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.access_time),
        ),
        child: Text(
          selectedHour != null
              ? '${selectedHour.toString().padLeft(2, '0')}:00'
              : 'Pilih jam input',
          style: TextStyle(
            color:
                selectedHour != null
                    ? const Color(0xFF655F5B)
                    : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
