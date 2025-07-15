import 'package:flutter/material.dart';

class CustomRemarkField extends StatefulWidget {
  final TextEditingController controller;

  const CustomRemarkField({super.key, required this.controller});

  @override
  State<CustomRemarkField> createState() => _CustomRemarkFieldState();
}

class _CustomRemarkFieldState extends State<CustomRemarkField> {
  late FocusNode _focusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow:
            isFocused
                ? [
                  BoxShadow(
                    color: Colors.grey.withAlpha((0.3 * 255).toInt()),
                    offset: const Offset(0, 2),
                    blurRadius: 5,
                  ),
                ]
                : [],
      ),
      height: isFocused ? 150 : 100,
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLines: null,
            expands: true,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
              hintText: 'Catatan / Remark',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 12, left: 8, right: 8),
            ),
          ),
          const Positioned(
            bottom: 8,
            left: 8,
            child: Icon(Icons.edit, size: 20, color: Color(0xFF655F5B)),
          ),
        ],
      ),
    );
  }
}
