import 'package:flutter/material.dart';

class ChecklistGroupSection extends StatelessWidget {
  final String group;
  final List<String> items;
  final Set<String> expandedGroups;
  final Map<String, bool> checklistValues;
  final Function(String group) onToggle;
  final Function(String key, bool value) onCheckChanged;

  const ChecklistGroupSection({
    super.key,
    required this.group,
    required this.items,
    required this.expandedGroups,
    required this.checklistValues,
    required this.onToggle,
    required this.onCheckChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = expandedGroups.contains(group);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.3 * 255).toInt()),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Group
          InkWell(
            onTap: () => onToggle(group),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFFF7F5F2),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    group,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4E4745),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 28,
                    color: const Color(0xFF4E4745),
                  ),
                ],
              ),
            ),
          ),

          // Checklist Items
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState:
                isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                children:
                    items.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final item = entry.value;
                      final key = '$group-$item';
                      final isChecked = checklistValues[key] ?? false;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isChecked
                                  ? const Color(0xFFFFF5F4)
                                  : const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isChecked
                                    ? const Color(0xFFAB2F2B)
                                    : const Color(0xFFDCDCDC),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '$index',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF4E4745),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Checkbox(
                              value: isChecked,
                              activeColor: const Color(0xFFAB2F2B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged:
                                  (value) =>
                                      onCheckChanged(key, value ?? false),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF655F5B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
