import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/quality_refinery/quality_report_qc_entity.dart';
import 'package:logsheet_app/features/admin/pages/quality/qc/quality_approval_detail_qc_page.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_qc_provider.dart';
import 'package:provider/provider.dart';

class QualityApprovalListScreenPage extends StatefulWidget {
  const QualityApprovalListScreenPage({super.key});

  @override
  State<QualityApprovalListScreenPage> createState() =>
      _QualityApprovalListScreenPageState();
}

class _QualityApprovalListScreenPageState
    extends State<QualityApprovalListScreenPage> {
  DataFormNoEntity? formQualityRefinery;

  @override
  void initState() {
    super.initState();

    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<QualityReportQCProvider>().fetchReportsForManager(
        plantCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    formQualityRefinery =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) => form.isMenu == "Quality_Report" && form.isActive == "T",
            )
            .first;
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody());
  }

  Widget _buildBody() {
    return Consumer<QualityReportQCProvider>(
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
                        context.read<PlantProvider>().currentPlant?.code ?? "";

                    provider.fetchReportsForManager(plantCode);
                  },
                  child: const Text("Refresh"),
                ),
              ],
            ),
          );
        }

        final allReports = provider.approvedTransactions;

        // Group reports by date
        final Map<String, List<QualityReportQcEntity>> groupedReports = {};

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
                        context.read<PlantProvider>().currentPlant?.code ?? "";

                    context
                        .read<QualityReportQCProvider>()
                        .fetchReportsForManager(plantCode);
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
                            ? r.preparedStatus == "Approved"
                            : r.shift == 5
                            ? r.preparedStatus == "Approved"
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
                            ? r.preparedStatus == "Approved"
                            : r.shift == 2
                            ? r.preparedStatus == "Approved"
                            : r.shift == 3
                            ? r.preparedStatus == "Approved"
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
            IconData icon = Icons.hourglass_bottom_rounded;
            Color iconColor = Colors.grey[700]!;
            String statusText = 'Shift Belum Lengkap';

            if (isReadyForApproval) {
              cardColor = Colors.white;
              icon = Icons.pending_rounded;
              iconColor = Colors.blue;
              statusText = 'Pending Approval';
            }

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
                                    (context) => QualityApprovalDetailQCScreen(
                                      reportEntities: reportsForGroup,
                                      reportIdentifier: compositeKey,
                                    ),
                              ),
                            );
                          }
                          : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Semua Shift belum Lengkap.'),
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
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Quality Approval QC (${formQualityRefinery?.code})'),
      actions: [
        IconButton(
          onPressed: () async {
            final plantCode =
                context.read<PlantProvider>().currentPlant?.code ?? "";

            context.read<QualityReportQCProvider>().fetchReportsForManager(
              plantCode,
            );
          },
          icon: Icon(Icons.replay_rounded),
        ),
      ],
    );
  }
}
