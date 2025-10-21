import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/pages/dry_fractionation/dry_fractionation_approval_detail_page.dart';
import 'package:logsheet_app/providers/dry_fractionation/dry_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class DryFractionationApprovalListPage extends StatefulWidget {
  const DryFractionationApprovalListPage({super.key});

  @override
  State<DryFractionationApprovalListPage> createState() =>
      _DryFractionationApprovalListPageState();
}

class _DryFractionationApprovalListPageState
    extends State<DryFractionationApprovalListPage> {
  DataFormNoEntity? form;

  @override
  void initState() {
    super.initState();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => context
          .read<DryFractionationProvider>()
          .fetchReportsForManager(plantCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      form =
          context
              .read<DataFormNoProvider>()
              .dataFormNoList
              .where(
                (form) =>
                    form.isMenu == "Logsheet_Dry_Fractionation" &&
                    form.isActive == "T",
              )
              .first;
    } catch (e) {
      log("$e");
      form = null;
    }
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<DryFractionationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingFetchTickets) {
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
                      onPressed: () async {
                        final plantCode =
                            context.read<PlantProvider>().currentPlant?.code ??
                            "";
                        await provider.fetchReportsForManager(plantCode);
                      },
                      child: const Text("Refresh"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.reportsForManager.isEmpty) {
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
                      onPressed: () async {
                        final username =
                            context.read<UserProvider>().currentUser?.username;
                        final role =
                            context.read<UserProvider>().currentUser?.role;
                        final plantCode =
                            context.read<PlantProvider>().currentPlant?.code ??
                            "";
                        await provider.fetchAllTickets(
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

          final Map<String, List<DryFractionationEntity>> groupedReports = {};

          for (var report in allReports) {
            if (report.postingDate != null && report.workCenter != null) {
              final datekey = DateFormat(
                'yyyy-MM-dd',
              ).format(report.postingDate!);
              final compositeKey = "$datekey|${report.workCenter}";
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
                    onPressed: () async {
                      final plantCode =
                          context.read<PlantProvider>().currentPlant?.code ??
                          "";

                      await provider.fetchReportsForManager(plantCode);
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

                if (reportsForGroup == null || reportsForGroup.isEmpty) {
                  return const SizedBox.shrink();
                }

                final keyParts = compositeKey.split('|');
                final date = keyParts[0];
                final workCenter = keyParts[1];

                bool isReadyForApproval =
                    reportsForGroup.isNotEmpty &&
                    reportsForGroup.every(
                      (r) => r.preparedStatus == "Approved",
                    );

                final bool isApprovedForDay = reportsForGroup.every(
                  (r) => r.checkedStatus == 'Approved',
                );
                final bool isRejectedForDay = reportsForGroup.any(
                  (r) => r.checkedStatus == 'Rejected',
                );

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
                                            DryFractionationApprovalDetailPage(
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
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
    title: Text("Dry Fract. Approval (${form?.code})"),
    actions: [
      IconButton(
        onPressed: () async {
          final plantCode =
              context.read<PlantProvider>().currentPlant?.code ?? "";
          await context.read<DryFractionationProvider>().fetchReportsForManager(
            plantCode,
          );
        },
        icon: const Icon(Icons.replay_rounded),
      ),
    ],
  );
}
