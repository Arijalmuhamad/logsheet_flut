import 'package:flutter/material.dart';

class ChecklistItemRow extends StatelessWidget {
  final int number;
  final String description;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const ChecklistItemRow({
    super.key,
    required this.number,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(24), // Kolom nomor
        1: FixedColumnWidth(40), // Kolom checkbox
        2: FlexColumnWidth(), // Kolom deskripsi fleksibel
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                number.toString(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: Color(0xFF6D5294),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4B4B4B),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
