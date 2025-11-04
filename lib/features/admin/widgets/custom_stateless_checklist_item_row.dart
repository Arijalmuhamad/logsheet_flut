import 'package:flutter/material.dart';

class CustomStatelessChecklistItemRow extends StatelessWidget {
  final int? number;
  final String description;
  final bool value;
  final bool isShowNumber;

  const CustomStatelessChecklistItemRow({
    super.key,
    this.number,
    required this.description,
    required this.value,
    this.isShowNumber = true,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the table structure dynamically
    final columnWidths = isShowNumber
        ? const {
            0: FixedColumnWidth(24), // Number
            1: FlexColumnWidth(),    // Description
            2: FixedColumnWidth(24), // Icon
          }
        : const {
            0: FlexColumnWidth(),    // Description
            1: FixedColumnWidth(24), // Icon
          };

    final children = <Widget>[];

    if (isShowNumber) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            number?.toString() ?? '',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      );
    }

    children.addAll([
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
                ),
        ),
      ),
    ]);

    return Table(
      columnWidths: columnWidths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: children),
      ],
    );
  }
}
