import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_approval_detail_page.dart';
import 'package:logsheet_app/providers/maintenance/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:provider/provider.dart';

// Dummy model class to simulate your report entity
class ReportEntity {
  final String preparedStatus;
  final String checkedStatus;

  ReportEntity({required this.preparedStatus, required this.checkedStatus});
}

class MaintenanceChangeProductApprovalPage extends StatefulWidget {
  const MaintenanceChangeProductApprovalPage({super.key});

  @override
  State<MaintenanceChangeProductApprovalPage> createState() =>
      _MaintenanceChangeProductApprovalPageState();
}

class _MaintenanceChangeProductApprovalPageState
    extends State<MaintenanceChangeProductApprovalPage> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<ChangeProductChecklistProvider>()
          .getAllApprovalHeaderAndDetail();
    });
  }

  // Dummy data setup
  late List<String> groupKeys;
  late Map<String, List<ReportEntity>> groupedReports;

  @override
  Widget build(BuildContext context) {
    final changeProductChecklistProvider =
        context.watch<ChangeProductChecklistProvider>();

    final isLoading = changeProductChecklistProvider.isLoading;
    final approvalList = changeProductChecklistProvider.uniqueApprovalList;

    return Scaffold(
      appBar: _buildAppBar(),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : approvalList.isEmpty
              ? const Center(child: Text("No Data Available"))
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListView.builder(
                  itemCount: approvalList.length,
                  itemBuilder: (context, index) {
                    final item = approvalList[index];
                    log("item.transactionDate: ${item.transactionDate}");
                    return _approvalCardItem(
                      id: item.id ?? '',
                      date: item.checkedDate ?? item.preparedDate ?? '',
                      workCenter: item.workCenter ?? '',
                      statusText:
                          item.checkedStatus ?? item.preparedStatus ?? '',
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Refresh clicked")));
        },
        icon: const Icon(Icons.replay_rounded),
      ),
    ],
  );

  Widget _approvalCardItem({
    required String id,
    required String date,
    required String workCenter,
    required String statusText,
    IconData? icon,
    Color? iconColor,
    Color? cardColor,
  }) {
    // Tentukan warna dan ikon berdasarkan status
    if (statusText.toLowerCase() == "approved") {
      icon = Icons.check_circle;
      iconColor = Colors.green;
      cardColor = Colors.green[50];
    } else if (statusText.toLowerCase() == "rejected") {
      icon = Icons.cancel;
      iconColor = Colors.red;
      cardColor = Colors.red[50];
    } else {
      icon = Icons.hourglass_empty;
      iconColor = Colors.orange;
      cardColor = Colors.orange[50];
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (statusText.toLowerCase() == "approved") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        MaintenanceChangeProductApprovalDetailPage(id: id),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  statusText.toLowerCase() == "rejected"
                      ? 'Laporan ini telah ditolak.'
                      : 'Laporan belum siap untuk approval.',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      id,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Date: $date', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      'Work Center: $workCenter',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: $statusText',
                      style: TextStyle(
                        fontSize: 14,
                        color: iconColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
