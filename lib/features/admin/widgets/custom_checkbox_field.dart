import 'package:flutter/material.dart';

class CustomCheckboxField extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CustomCheckboxField({
    super.key,
    required this.label,
    required this.icon,
    this.initialValue = false,
    required this.onChanged,
  });

  @override
  State<CustomCheckboxField> createState() => _CustomCheckboxFieldState();
}

class _CustomCheckboxFieldState extends State<CustomCheckboxField> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _isChecked = !_isChecked;
          });
          widget.onChanged(_isChecked);
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0ECE9),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(widget.icon, color: const Color(0xFF655F5B)),
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: Color(0xFF655F5B),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Checkbox(
                value: _isChecked,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                  });
                  widget.onChanged(value!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
