import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  final String userName;

  const StatusPage({super.key, required this.userName});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<Map<String, dynamic>> dataList = [
    {"time": "08:00", "status": "Uploaded", "approval": "Approved"},
    {"time": "09:00", "status": "Not Uploaded", "approval": "Pending"},
    {"time": "10:00", "status": "Uploaded", "approval": "Rejected"},
    {"time": "11:00", "status": "Not Uploaded", "approval": "Pending"},
  ];

  String? selectedHour;

  List<Map<String, dynamic>> get filteredData {
    if (selectedHour == null) return dataList;
    return dataList.where((d) => d['time'] == selectedHour).toList();
  }

  List<String> get hourOptions {
    return dataList.map((d) => d['time'] as String).toSet().toList();
  }

  IconData getStatusIcon(String status) {
    return status == 'Uploaded' ? Icons.cloud_done : Icons.cloud_off;
  }

  Color getStatusColor(String status) {
    return status == 'Uploaded' ? Colors.green : Colors.orange;
  }

  IconData getApprovalIcon(String approval) {
    switch (approval) {
      case 'Approved':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.cancel;
      default:
        return Icons.hourglass_empty;
    }
  }

  Color getApprovalColor(String approval) {
    switch (approval) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Status Input Harian',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => selectedHour = null),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter berdasarkan Jam:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedHour,
              decoration: InputDecoration(
                hintText: 'Pilih jam input',
                prefixIcon: const Icon(Icons.access_time),
                filled: true,
                fillColor: const Color(0xFFF5F8FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items:
                  hourOptions
                      .map(
                        (hour) =>
                            DropdownMenuItem(value: hour, child: Text(hour)),
                      )
                      .toList(),
              onChanged: (value) => setState(() => selectedHour = value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final item = filteredData[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.schedule, color: Colors.blueAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jam: ${item['time']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E1E),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      getStatusIcon(item['status']),
                                      color: getStatusColor(item['status']),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Status: ${item['status']}',
                                      style: TextStyle(
                                        color: getStatusColor(item['status']),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      getApprovalIcon(item['approval']),
                                      color: getApprovalColor(item['approval']),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Approval: ${item['approval']}',
                                      style: TextStyle(
                                        color: getApprovalColor(
                                          item['approval'],
                                        ),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
