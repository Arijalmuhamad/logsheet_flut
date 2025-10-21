import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_approval_detail_page.dart';

// Dummy model class to simulate your report entity
class ReportEntity {
  final String preparedStatus;
  final String checkedStatus;

  ReportEntity({
    required this.preparedStatus,
    required this.checkedStatus,
  });
}

class MaintenanceChangeProductApprovalPage extends StatefulWidget {
  const MaintenanceChangeProductApprovalPage({super.key});

  @override
  State<MaintenanceChangeProductApprovalPage> createState() =>
      _MaintenanceChangeProductApprovalPageState();
}

class _MaintenanceChangeProductApprovalPageState
    extends State<MaintenanceChangeProductApprovalPage> {
  // Dummy data setup
  late List<String> groupKeys;
  late Map<String, List<ReportEntity>> groupedReports;

  @override
  void initState() {
    super.initState();

    // Simulated group keys: "date|workCenter"
    groupKeys = [
      '2025-10-21|WC-1001',
      '2025-10-21|WC-1002',
      '2025-10-20|WC-1003',
      '2025-10-19|WC-1004',
    ];

    // Dummy grouped reports for each key
    groupedReports = {
      // Ready for approval (all preparedStatus = Approved)
      '2025-10-21|WC-1001': [
        ReportEntity(preparedStatus: "Approved", checkedStatus: ""),
        ReportEntity(preparedStatus: "Approved", checkedStatus: ""),
      ],

      // Approved (all checkedStatus = Approved)
      '2025-10-21|WC-1002': [
        ReportEntity(preparedStatus: "Approved", checkedStatus: "Approved"),
      ],

      // Rejected (any checkedStatus = Rejected)
      '2025-10-20|WC-1003': [
        ReportEntity(preparedStatus: "Approved", checkedStatus: "Rejected"),
      ],

      // Not ready (not all preparedStatus = Approved)
      '2025-10-19|WC-1004': [
        ReportEntity(preparedStatus: "Pending", checkedStatus: ""),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListView.builder(
          itemCount: groupKeys.length,
          itemBuilder: (context, index) {
            final compositeKey = groupKeys[index];
            final reportsForGroup = groupedReports[compositeKey];

            if (reportsForGroup == null || reportsForGroup.isEmpty) {
              return const SizedBox.shrink();
            }

            final keyParts = compositeKey.split('|');
            final date = keyParts[0];
            final workCenter = keyParts[1];

            bool isReadyForApproval = reportsForGroup.isNotEmpty &&
                reportsForGroup.every((r) => r.preparedStatus == "Approved");

            final bool isApprovedForDay =
                reportsForGroup.every((r) => r.checkedStatus == 'Approved');
            final bool isRejectedForDay =
                reportsForGroup.any((r) => r.checkedStatus == 'Rejected');

            Color cardColor = Colors.white;
            IconData icon = Icons.hourglass_bottom_rounded;
            Color iconColor = Colors.grey[700]!;
            String statusText = 'Belum ada ticket';

            if (isReadyForApproval) {
              cardColor = Colors.white;
              icon = Icons.pending_rounded;
              iconColor = Colors.blue;
              statusText = 'Pending Approval';
            }

            if (isApprovedForDay) {
              cardColor = Colors.green[50]!;
              icon = Icons.check_circle_rounded;
              iconColor = Colors.green;
              statusText = 'Approved';
            } else if (isRejectedForDay) {
              cardColor = Colors.red[50]!;
              icon = Icons.cancel_rounded;
              iconColor = Colors.red;
              statusText = 'Rejected';
            }

            return Card(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(icon, color: iconColor),
                  title: Text(
                    'Date: $date',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Work Center: $workCenter\nStatus: $statusText',
                    style: TextStyle(color: iconColor, height: 1.4),
                  ),
                  onTap: isReadyForApproval
                      ? () {
                          // For UI testing only
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MaintenanceChangeProductApprovalDetailPage(),
                            ),
                          );
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Laporan belum siap untuk approval.',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: const Text("Change Product Approval"),
        actions: [
          IconButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Refresh clicked")),
              );
            },
            icon: const Icon(Icons.replay_rounded),
          ),
        ],
      );
}
