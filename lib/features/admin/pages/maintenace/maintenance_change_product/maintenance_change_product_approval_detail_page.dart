import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Simple mock model to simulate your report data
class ReportEntity {
  final int id;
  final String checkedStatus;
  final DateTime? transactionDate;

  ReportEntity({
    required this.id,
    required this.checkedStatus,
    this.transactionDate,
  });
}

class MaintenanceChangeProductApprovalDetailPage extends StatefulWidget {
  const MaintenanceChangeProductApprovalDetailPage({super.key});

  @override
  State<MaintenanceChangeProductApprovalDetailPage> createState() =>
      _MaintenanceChangeProductApprovalDetailPageState();
}

class _MaintenanceChangeProductApprovalDetailPageState
    extends State<MaintenanceChangeProductApprovalDetailPage> {
  // ✅ Define your reportEntities list here (no constructor required)
  final List<ReportEntity> reportEntities = [
    ReportEntity(
      id: 101,
      checkedStatus: "Approved",
      transactionDate: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    ReportEntity(
      id: 102,
      checkedStatus: "Rejected",
      transactionDate: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    ReportEntity(
      id: 103,
      checkedStatus: "Pending",
      transactionDate: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approve Detail')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: reportEntities.length,
          itemBuilder: (context, index) {
            final report = reportEntities[index];
            final isApproved = report.checkedStatus == "Approved";
            final isRejected = report.checkedStatus == "Rejected";
            final transactionTime = report.transactionDate != null
                ? DateFormat('HH:mm').format(report.transactionDate!)
                : 'N/A';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                title: Text('Time: $transactionTime'),
                subtitle: Text('Ticket ID: ${report.id}'),
                trailing: Icon(
                  isApproved
                      ? Icons.check_circle_rounded
                      : isRejected
                          ? Icons.cancel_rounded
                          : Icons.keyboard_arrow_right_rounded,
                  color: isApproved
                      ? Colors.green
                      : isRejected
                          ? Colors.red
                          : Colors.grey,
                ),
                onTap: () {
                  _buildBottomSheet(context, report);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _buildBottomSheet(BuildContext context, ReportEntity report) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ticket ID: ${report.id}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text("Status: ${report.checkedStatus}"),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Approved")),
                      );
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text("Approve"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Rejected")),
                      );
                    },
                    icon: const Icon(Icons.close_rounded),
                    label: const Text("Reject"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
