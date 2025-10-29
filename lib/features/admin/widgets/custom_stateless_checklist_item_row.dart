import 'package:flutter/material.dart';

class CustomStatelessChecklistItemRow extends StatelessWidget {
  final int number;
  final String description;
  final bool value;

  const CustomStatelessChecklistItemRow({
    super.key,
    required this.number,
    required this.description,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(24), // Nomor
        1: FlexColumnWidth(),    // Deskripsi
        2: FixedColumnWidth(24), // Ikon di kanan
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                number.toString(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4B4B4B),
                  height: 1.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: value
                    ? const Icon(
                        Icons.check,
                        color: Color(0xFF6D5294),
                        size: 20,
                      )
                    : const Icon(
                        Icons.close,
                        color: Color(0xFF6D5294),
                        size: 20,
                      )
              ),
            ),
          ],
        ),
      ],
    );
  }
}
