import 'package:flutter/material.dart';

class CustomHourMinuteField extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final VoidCallback onTap;

  const CustomHourMinuteField({
    super.key,
    required this.selectedTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String formatTime(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

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
          selectedTime != null ? formatTime(selectedTime!) : 'Pilih jam input',
          style: TextStyle(
            color:
                selectedTime != null
                    ? const Color(0xFF655F5B)
                    : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
