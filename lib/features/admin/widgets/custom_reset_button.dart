import 'package:flutter/material.dart';

class CustomResetButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CustomResetButton({
    super.key,
    required this.onPressed,
    this.label = 'Reset Form',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE0E0E0),
        foregroundColor: const Color(0xFF655F5B),
        elevation: 3,
        // side: const BorderSide(color: Color(0xFFAB2F2B), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }
}
