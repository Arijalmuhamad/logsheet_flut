import 'package:flutter/material.dart';

class CustomHourMinuteField extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final VoidCallback onTap;
  final String hint;

  const CustomHourMinuteField({
    super.key,
    required this.selectedTime,
    required this.onTap,
    this.hint = "Pilih Jam Input",
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: InputDecorator(
          isFocused: false,
          isEmpty: selectedTime == null,
          decoration: InputDecoration(
            labelText: hint,
            filled: true,
            fillColor: const Color(0xFFF0ECE9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.access_time),
          ),
          child: Text(
            selectedTime != null ? formatTime(selectedTime!) : "",
            style: TextStyle(
              fontSize: 16,
              color:
                  selectedTime != null
                      ? const Color(0xFF655F5B)
                      : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
