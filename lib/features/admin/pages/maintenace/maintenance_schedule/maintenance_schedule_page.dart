import 'package:flutter/material.dart';

class MaintenanceSchedulePage extends StatelessWidget {
  final String userName;
  const MaintenanceSchedulePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final List<CleaningScheduleItem> scheduleItems = [
      CleaningScheduleItem(
        equipment: 'Strainer CPO 150 & 500',
        planning: ['Januari', 'April', 'Juli', 'Oktober'],
        realisasi: ['11 Januari', '19 April', '20 Agustus'],
        remarks: '11 Januari, 19 April, 20 Agustus',
      ),
      CleaningScheduleItem(
        equipment: 'Jalur Degumming Plant 150 & 500',
        planning: ['Februari', 'Mei', 'Agustus'],
        realisasi: ['20 Februari', '25 Mei'],
        remarks: '20 Februari, 25 Mei',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule Cleaning',
          style: TextStyle(
            color: Color(0xFF655F5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      ),
      backgroundColor: const Color(0xFFEFF3F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Code Box
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0ECE9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.description_outlined,
                    size: 18,
                    color: Color(0xFF655F5B),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Form Code: F/RFA-011',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF655F5B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            ...scheduleItems.map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                // ignore: deprecated_member_use
                shadowColor: Colors.grey.withOpacity(0.2),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.equipment,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF655F5B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Color(0xFF655F5B),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Planning:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF655F5B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            item.planning
                                .map(
                                  (month) => Chip(
                                    label: Text(month),
                                    backgroundColor: Color(0xFFF0ECE9),
                                    labelStyle: const TextStyle(
                                      color: Color(0xFF655F5B),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(Icons.check, size: 18, color: Color(0xFF655F5B)),
                          SizedBox(width: 6),
                          Text(
                            'Realisasi:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF655F5B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            item.realisasi
                                .map(
                                  (date) => Chip(
                                    label: Text(date),
                                    backgroundColor: Color(0xFFF0ECE9),
                                    labelStyle: const TextStyle(
                                      color: Color(0xFF655F5B),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      if (item.remarks.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Remarks:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF655F5B),
                          ),
                        ),
                        Text(
                          item.remarks,
                          style: const TextStyle(color: Color(0xFF655F5B)),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class CleaningScheduleItem {
  final String equipment;
  final List<String> planning;
  final List<String> realisasi;
  final String remarks;

  CleaningScheduleItem({
    required this.equipment,
    required this.planning,
    required this.realisasi,
    required this.remarks,
  });
}
