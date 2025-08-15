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

    final plantCode =
        Provider.of<PlantProvider>(context, listen: false).currentPlant?.code ??
        "";

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<QualityReportRefineryProvider>(
        context,
        listen: false,
      ).fetchAllPreparedTransactions(plantCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quality Transaction Approval'),
        actions: [
          IconButton(
            onPressed: () async {
              final plantCode =
                  Provider.of<PlantProvider>(
                    context,
                    listen: false,
                  ).currentPlant?.code ??
                  "";

              Provider.of<QualityReportRefineryProvider>(
                context,
                listen: false,
              ).fetchAllPreparedTransactions(plantCode);
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
                          Provider.of<PlantProvider>(
                            context,
                            listen: false,
                          ).currentPlant?.code ??
                          "";

                      Provider.of<QualityReportRefineryProvider>(
                        context,
                        listen: false,
                      ).fetchAllPreparedTransactions(plantCode);
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }

          final allReports = provider.approvedTransactions;

          // Group reports by date
          final Map<String, List<QualityReportRefineryEntity>> groupedByDate =
              {};

          for (var report in allReports) {
            if (report.postingDate != null) {
              final dateKey = DateFormat(
                'yyyy-MM-dd',
              ).format(report.postingDate!);
              groupedByDate.putIfAbsent(dateKey, () => []).add(report);
            }
          }

          final List<String> dates = groupedByDate.keys.toList();

          dates.sort((a, b) => b.compareTo(a));

          if (dates.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("No data"),
                  OutlinedButton(
                    onPressed: () {
                      final plantCode =
                          Provider.of<PlantProvider>(
                            context,
                            listen: false,
                          ).currentPlant?.code ??
                          "";

                      Provider.of<QualityReportRefineryProvider>(
                        context,
                        listen: false,
                      ).fetchAllPreparedTransactions(plantCode);
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final dateKey = dates[index];
              final reportsForDate = groupedByDate[dateKey];

              final bool isShift1Prepared =
                  reportsForDate?.any(
                    (r) => r.shift == 1 && r.preparedStatusShift1 == "Approved",
                  ) ??
                  false;
              final bool isShift2Prepared =
                  reportsForDate?.any(
                    (r) => r.shift == 2 && r.preparedStatusShift2 == "Approved",
                  ) ??
                  false;
              final bool isShift3Prepared =
                  reportsForDate?.any(
                    (r) => r.shift == 3 && r.preparedStatusShift3 == "Approved",
                  ) ??
                  false;

              final bool isAllReportPrepared =
                  isShift1Prepared && isShift2Prepared && isShift3Prepared;

              final bool isApprovedForDay =
                  reportsForDate!.isNotEmpty &&
                  isAllReportPrepared &&
                  reportsForDate.every((r) => r.checkedStatus == 'Approved');
              final isRejectedForDay =
                  isAllReportPrepared &&
                  reportsForDate.any((r) => r.checkedStatus == 'Rejected');

              //Determine the card color
              Color cardColor = Colors.white;
              IconData icon = Icons.pending_rounded;
              Color iconColor = Colors.blue;
              String statusText = 'Pending Approval';
              bool isClickable = isAllReportPrepared;

              if (isApprovedForDay) {
                cardColor = Colors.green[50]!;
                icon = Icons.check_circle_outlined;
                iconColor = Colors.green;
                statusText = 'Approved';
                isClickable = false; // Not clickable after being approved
              } else if (isRejectedForDay) {
                cardColor = Colors.red[50]!;
                icon = Icons.cancel_rounded;
                iconColor = Colors.red;
                statusText = 'Rejected';
                isClickable = false; // Not clickable after being rejected
              } else if (!isAllReportPrepared) {
                cardColor = Colors.grey[200]!;
                icon = Icons.warning_amber_rounded;
                iconColor = Colors.orange;
                statusText = 'Incomplete shifts';
                isClickable = false;
              }

              return Card(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(icon, color: iconColor),
                    title: Text(
                      'Date: $dateKey',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Status: $statusText',
                      style: TextStyle(color: iconColor),
                    ),
                    onTap:
                        isAllReportPrepared
                            ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => QualityApprovalDetailScreen(
                                        reportEntities: reportsForDate,
                                        reportIdentifier: dateKey,
                                      ),
                                ),
                              );
                            }
                            : () {
                              if (!isClickable) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Cannot approve. All three shifts are not yet submitted.',
                                    ),
                                  ),
                                );
                              }
                            },
                  ),
                ),
              );
            },
          );
        },
        // child: ListView.builder(
        //   itemCount: datesToApprove.length,
        //   itemBuilder: (context, index) {
        //     final dateKey = datesToApprove[index];
        //     final shiftsForDate = groupedByDateAndShift[dateKey]!;

        //     final bool isComplete =
        //         shiftsForDate.containsKey(1) &&
        //         shiftsForDate.containsKey(2) &&
        //         shiftsForDate.containsKey(3);

        //     String subtitleText = 'Shifts submitted: ';
        //     if (shiftsForDate.containsKey(1)) subtitleText += '1 ';
        //     if (shiftsForDate.containsKey(2)) subtitleText += '2 ';
        //     if (shiftsForDate.containsKey(3)) subtitleText += '3';

        //     return Card(
        //       color: isComplete ? Colors.green[50] : Colors.orange[50],
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: ListTile(
        //           title: Row(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             children: [
        //               Icon(Icons.calendar_today_rounded),
        //               SizedBox(width: 4),
        //               Text(dateKey),
        //             ],
        //           ),
        //           subtitle: Text(subtitleText),
        //           trailing:
        //               isComplete
        //                   ? Icon(Icons.check_circle, color: Colors.green)
        //                   : Icon(Icons.warning, color: Colors.orange),
        //           onTap: () {
        //             if (isComplete) {
        //               // Flatten all entities for the selected date to pass to the detail screen
        //               final allEntitiesForDate =
        //                   shiftsForDate.values
        //                       .expand((element) => element)
        //                       .toList();
        //               Navigator.of(context).push(
        //                 MaterialPageRoute(
        //                   builder:
        //                       (context) => ApprovalDetailScreen(
        //                         reportEntities: allEntitiesForDate,
        //                         reportIdentifier: dateKey,
        //                       ),
        //                 ),
        //               );
        //             } else {
        //               ScaffoldMessenger.of(context).showSnackBar(
        //                 SnackBar(
        //                   content: Text(
        //                     'Belum bisa approve. Semua Shift belum terisi/prepared.',
        //                   ),
        //                 ),
        //               );
        //             }
        //           },
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
