import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomHourPicker extends StatefulWidget {
  final int? selectedHour;
  final Function(int) onHourSelected;

  const CustomHourPicker({
    super.key,
    required this.selectedHour,
    required this.onHourSelected,
  });

  @override
  State<CustomHourPicker> createState() => _CustomHourPickerState();
}

class _CustomHourPickerState extends State<CustomHourPicker> {
  late int tempSelectedHour;

  @override
  void initState() {
    super.initState();
    tempSelectedHour = widget.selectedHour ?? TimeOfDay.now().hour;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Pilih Jam Input',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF655F5B),
              ),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: tempSelectedHour,
              ),
              onSelectedItemChanged: (int value) {
                tempSelectedHour = value;
              },
              children: List.generate(
                24,
                (index) => Center(
                  child: Text(
                    '${index.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF655F5B),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: () {
                widget.onHourSelected(
                  tempSelectedHour,
                ); // Kirim hasil ke parent
                Navigator.pop(context); // Tutup bottom sheet
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAB2F2B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Pilih', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
