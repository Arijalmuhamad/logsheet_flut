import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomHourMinutePicker extends StatefulWidget {
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;

  const CustomHourMinutePicker({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  State<CustomHourMinutePicker> createState() => _CustomHourMinutePickerState();
}

class _CustomHourMinutePickerState extends State<CustomHourMinutePicker> {
  late int tempSelectedHour;
  late int tempSelectedMinute;

  @override
  void initState() {
    super.initState();
    // Initialize with the provided time or the current time
    final initialTime = widget.selectedTime ?? TimeOfDay.now();
    tempSelectedHour = initialTime.hour;
    tempSelectedMinute = initialTime.minute;
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
              'Pilih Waktu Input',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF655F5B),
              ),
            ),
          ),
          Expanded(
            // Use a Row to place two pickers side-by-side
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour Picker
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: tempSelectedHour,
                    ),
                    onSelectedItemChanged: (int value) {
                      setState(() {
                        tempSelectedHour = value;
                      });
                    },
                    children: List.generate(
                      24,
                      (index) => Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF655F5B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Separator
                const Text(
                  ':',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF655F5B),
                  ),
                ),
                // Minute Picker
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: tempSelectedMinute,
                    ),
                    onSelectedItemChanged: (int value) {
                      setState(() {
                        tempSelectedMinute = value;
                      });
                    },
                    children: List.generate(
                      60,
                      (index) => Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF655F5B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 8),
            child: ElevatedButton(
              onPressed: () {
                // Create a TimeOfDay object from the selected values
                final selectedTime = TimeOfDay(
                  hour: tempSelectedHour,
                  minute: tempSelectedMinute,
                );
                // Send the result back to the parent widget
                widget.onTimeSelected(selectedTime);
                Navigator.pop(context); // Close the bottom sheet
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
