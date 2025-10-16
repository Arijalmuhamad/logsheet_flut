import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_picker.dart';

void showHourPickerAndUpdateState({
  required BuildContext context,
  required TimeOfDay? selectedTime,
  required Function(TimeOfDay) onTimeSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder:
        (context) => CustomHourMinutePicker(
          selectedTime: selectedTime,
          onTimeSelected: (time) {
            onTimeSelected(time);
          },
        ),
  );
}
