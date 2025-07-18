import 'package:flutter/material.dart';

class CustomFilterDropdownChip extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?> onSelected;
  final IconData chipIcon;
  final bool isCalendar;

  const CustomFilterDropdownChip({
    super.key,
    required this.label,
    required this.options,
    this.selectedOption,
    required this.onSelected,
    required this.chipIcon,
    required this.controller,
    required this.isCalendar,
  });

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Pilih Waktu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children:
                        options.map((option) {
                          return ListTile(
                            title: Center(child: Text(option)),
                            onTap: () {
                              onSelected(option);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedOption != null;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      child: ActionChip.elevated(
        backgroundColor: isSelected ? colorScheme.primaryContainer : null,
        label: Text(selectedOption ?? label),
        avatar: Icon(chipIcon),
        onPressed: () {
          if (isCalendar) {
            onSelected(null);
          } else {
            // For the hour chip, we show the modal with options.
            _showOptions(context);
          }
        },
      ),
    );
  }
}
