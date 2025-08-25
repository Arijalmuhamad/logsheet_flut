import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_approval_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_refinery_provider.dart';
import 'package:provider/provider.dart';

class QualityApprovalListScreen extends StatefulWidget {
  const QualityApprovalListScreen({super.key});

  @override
  State<QualityApprovalListScreen> createState() =>
      _QualityApprovalListScreenState();
}

class _QualityApprovalListScreenState extends State<QualityApprovalListScreen> {
  @override
  void initState() {
    super.initState();

    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context
          .read<QualityReportRefineryProvider>()
          .fetchAllPreparedTransactions(plantCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quality Approval (F/RFA-001)'),
        actions: [
          IconButton(
            onPressed: () async {
              final plantCode =
                  context.read<PlantProvider>().currentPlant?.code ?? "";

              context
                  .read<QualityReportRefineryProvider>()
                  .fetchAllPreparedTransactions(plantCode);
            },
            icon: Icon(Icons.replay_rounded),
          ),
        ],
      ),
      body: Consumer<QualityReportRefineryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${provider.errorMessage}'),
                  OutlinedButton(
                    onPressed: () {
                      final plantCode =
                          context.read<PlantProvider>().currentPlant?.code ??
                          "";

                      context
                          .read<QualityReportRefineryProvider>()
                          .fetchAllPreparedTransactions(plantCode);
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }

          final allReports = provider.approvedTransactions;

          // Group reports by date
          final Map<String, List<QualityReportRefineryEntity>> groupedReports =
              {};

          for (var report in allReports) {
            if (report.postingDate != null &&
                report.oilType != null &&
                report.workCenter != null) {
              final dateKey = DateFormat(
                'yyyy-MM-dd',
              ).format(report.postingDate!);
              final compositeKey =
                  "$dateKey|${report.oilType}|${report.workCenter}";
              groupedReports.putIfAbsent(compositeKey, () => []).add(report);
            }
          }

          final List<String> groupKeys = groupedReports.keys.toList();
          groupKeys.sort((a, b) => b.compareTo(a));

          if (groupKeys.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("No data"),
                  OutlinedButton(
                    onPressed: () {
                      final plantCode =
                          context.read<PlantProvider>().currentPlant?.code ??
                          "";

                      context
                          .read<QualityReportRefineryProvider>()
                          .fetchAllPreparedTransactions(plantCode);
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: groupKeys.length,
            itemBuilder: (context, index) {
              final compositeKey = groupKeys[index];
              final reportsForGroup = groupedReports[compositeKey];
              final firstReport = reportsForGroup!.first;
              final postingDate = firstReport.postingDate!;
              final dayOfWeek = postingDate.weekday;

              final keyParts = compositeKey.split('|');
              final date = keyParts[0];
              final oilType = keyParts[1];
              final workCenter = keyParts[2];

              bool isReadyForApproval = false;
              int requiredReports = 24;

              if (dayOfWeek >= DateTime.friday) {
                final shifts = reportsForGroup.map((r) => r.shift).toSet();
                isReadyForApproval =
                    reportsForGroup.length >= requiredReports &&
                    shifts.contains(4) &&
                    shifts.contains(5) &&
                    reportsForGroup.every(
                      (r) =>
                          r.shift == 4
                              ? r.preparedStatusShift4 == "Approved"
                              : r.shift == 5
                              ? r.preparedStatusShift5 == "Approved"
                              : false,
                    );
              } else {
                final shifts = reportsForGroup.map((r) => r.shift).toSet();
                isReadyForApproval =
                    reportsForGroup.length >= requiredReports &&
                    shifts.contains(1) &&
                    shifts.contains(2) &&
                    shifts.contains(3) &&
                    reportsForGroup.every(
                      (r) =>
                          r.shift == 1
                              ? r.preparedStatusShift1 == "Approved"
                              : r.shift == 2
                              ? r.preparedStatusShift2 == "Approved"
                              : r.shift == 3
                              ? r.preparedStatusShift3 == "Approved"
                              : false,
                    );
              }

              final bool isApprovedForDay = reportsForGroup.every(
                (r) => r.checkedStatus == 'Approved',
              );
              final bool isRejectedForDay = reportsForGroup.any(
                (r) => r.checkedStatus == 'Rejected',
              );

              // Determine card color, icon, and status text based on the group's state
              Color cardColor = Colors.white;
              IconData icon = Icons.pending_rounded;
              Color iconColor = Colors.blue;
              String statusText = 'Pending Approval';

              if (isApprovedForDay) {
                cardColor = Colors.green[50]!;
                icon = Icons.check_circle_outlined;
                iconColor = Colors.green;
                statusText = 'Approved';
                // Not clickable after being approved
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
                      'Oil Type: $oilType | Work Center: $workCenter\nStatus: $statusText',
                      style: TextStyle(color: iconColor, height: 1.4),
                    ),
                    onTap:
                        isReadyForApproval
                            ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => QualityApprovalDetailScreen(
                                        reportEntities: reportsForGroup,
                                        reportIdentifier: compositeKey,
                                      ),
                                ),
                              );
                            }
                            : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Cannot approve. All three shifts are not yet submitted.',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
