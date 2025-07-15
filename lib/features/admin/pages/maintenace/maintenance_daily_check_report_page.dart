import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaintenanceChecksheetReportPage extends StatefulWidget {
  final String userName;
  const MaintenanceChecksheetReportPage({super.key, required this.userName});

  @override
  State<MaintenanceChecksheetReportPage> createState() =>
      _DailyChecklistReportPageState();
}

class _DailyChecklistReportPageState
    extends State<MaintenanceChecksheetReportPage> {
  DateTime selectedDate = DateTime.now();
  int? selectedHour;

  // Simulasi data checklist
  final Map<String, List<Map<String, dynamic>>> checklistData = {
    'Lampu': [
      {'name': 'Lampu 1', 'checked': true},
      {'name': 'Lampu 2', 'checked': false},
    ],
    'Kaca': [
      {'name': 'Kaca 1', 'checked': true},
    ],
  };

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  void _pickHour() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => SizedBox(
            height: 250,
            child: CupertinoPicker(
              itemExtent: 40,
              onSelectedItemChanged:
                  (index) => setState(() => selectedHour = index),
              children: List.generate(
                24,
                (i) => Text('${i.toString().padLeft(2, '0')}:00'),
              ),
            ),
          ),
    );
  }

  Widget _buildChecklistGroup(String group, List<Map<String, dynamic>> items) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(group, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...items.map(
              (item) => Row(
                children: [
                  Icon(
                    item['checked']
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: item['checked'] ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(item['name']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Laporan Checklist Harian',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F8FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickHour,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F8FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      selectedHour != null
                          ? '${selectedHour.toString().padLeft(2, '0')}:00'
                          : 'Pilih jam',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...checklistData.entries.map(
              (entry) => _buildChecklistGroup(entry.key, entry.value),
            ),
          ],
        ),
      ),
    );
  }
}
