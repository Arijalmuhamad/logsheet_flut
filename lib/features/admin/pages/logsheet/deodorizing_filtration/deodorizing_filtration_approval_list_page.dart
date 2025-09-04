import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/logsheet/deodorizing_filtration_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/deodorizing_filtration/deodorizing_filtration_approval_detail_page.dart';
import 'package:logsheet_app/providers/logsheet/deodorizing_filtration_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class DeodorizingFiltrationApprovalListPage extends StatefulWidget {
  const DeodorizingFiltrationApprovalListPage({super.key});

  @override
  State<DeodorizingFiltrationApprovalListPage> createState() =>
      _DeodorizingFiltrationApprovalListPageState();
}

class _DeodorizingFiltrationApprovalListPageState
    extends State<DeodorizingFiltrationApprovalListPage> {
  DataFormNoEntity? formDeodorizing;

  @override
  void initState() {
    super.initState();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => context
          .read<DeodorizingFiltrationProvider>()
          .fetchReportsForManager(plantCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    formDeodorizing =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Logsheet_Pretreatment_Bleaching_Filtration" &&
                  form.isActive == "T",
            )
            .first;
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() =>
      AppBar(title: Text("PBF Approval (${formDeodorizing?.code})"));

  Widget _buildBody() {
    return Consumer<DeodorizingFiltrationProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (provider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Error: ${provider.errorMessage!}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      final username =
                          context.read<UserProvider>().currentUser?.username ??
                          "";
                      final role =
                          context.read<UserProvider>().currentUser?.role ?? "";
                      final plantCode =
                          context.read<PlantProvider>().currentPlant?.code ??
                          "";
                      context
                          .read<DeodorizingFiltrationProvider>()
                          .fetchAllTicket(
                            null,
                            null,
                            username,
                            role,
                            plantCode,
                          );
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.deodorizingList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No data',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      final username =
                          context.read<UserProvider>().currentUser?.username;
                      final role =
                          context.read<UserProvider>().currentUser?.role;
                      final plantCode =
                          context.read<PlantProvider>().currentPlant?.code ??
                          "";
                      context
                          .read<DeodorizingFiltrationProvider>()
                          .fetchAllTicket(
                            null,
                            null,
                            username ?? "",
                            role ?? "",
                            plantCode,
                          );
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
          );
        }

        final allReports = provider.reportsForManager;

        final Map<String, List<DeodorizingFiltrationEntity>> groupedReports =
            {};

        for (var report in allReports) {
          if (report.postingDate != null && report.refineryMachine != null) {
            final datekey = DateFormat(
              'yyyy-MM-dd',
            ).format(report.postingDate!);
            final compositeKey = "$datekey|${report.refineryMachine}";
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
                        .read<DeodorizingFiltrationProvider>()
                        .fetchReportsForManager(plantCode);
                  },
                  child: const Text("Refresh"),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 4),
          child: ListView.builder(
            itemCount: groupKeys.length,
            itemBuilder: (context, index) {
              final compositeKey = groupKeys[index];
              final reportsForGroup = groupedReports[compositeKey];
              final firstReport = reportsForGroup!.first;
              final postingDate = firstReport.postingDate!;
              final dayOfWeek = postingDate.weekday;

              final keyParts = compositeKey.split('|');
              final date = keyParts[0];
              final workCenter = keyParts[1];

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
                icon = Icons.check_circle_rounded;
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
                      'Work Center: $workCenter\nStatus: $statusText',
                      style: TextStyle(color: iconColor, height: 1.4),
                    ),
                    onTap:
                        isReadyForApproval
                            ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          DeodorizingFiltrationApprovalDetailPage(
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
          ),
        );
      },
    );
  }

  String _getStatusText(DeodorizingFiltrationEntity report) {
    if (report.checkedStatus == "Approved") {
      return "Approved";
    }

    if (report.checkedStatus == "Rejected") {
      return "Rejected";
    }
    if (report.preparedStatus != null) {
      return "Prepared ${report.shift}";
    }

    if (report.preparedStatus == "Rejected") {
      return "Rejected";
    }
    return "Submitted";
  }

  Color _getStatusColor(DeodorizingFiltrationEntity report) {
    if (report.checkedStatus == "Approved") {
      return Colors.green;
    }

    if (report.checkedStatus == "Rejected") {
      return Colors.red;
    }

    if (report.preparedStatus == "Approved") {
      return Colors.orangeAccent;
    }

    if (report.preparedStatus == "Rejected") {
      return Colors.red;
    }
    return Colors.grey;
  }
}
