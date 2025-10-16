import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/approval/ref_daily_production_approval_detail_page.dart';
import 'package:logsheet_app/providers/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionRefineryApprovalListPage extends StatefulWidget {
  const DailyProductionRefineryApprovalListPage({super.key});

  @override
  State<DailyProductionRefineryApprovalListPage> createState() =>
      _DailyProductionRefineryApprovalListPageState();
}

class _DailyProductionRefineryApprovalListPageState
    extends State<DailyProductionRefineryApprovalListPage> {
  DataFormNoEntity? formRefinery;

  @override
  void initState() {
    super.initState();
    // Fetch data when the page loads
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context
          .read<DailyProductionRefineryProvider>()
          .fetchReportsForManager(plantCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Find the form number details for the app bar title
    try {
      formRefinery = context
          .read<DataFormNoProvider>()
          .dataFormNoList
          .firstWhere(
            (form) =>
                form.isMenu == "Daily_Production_Refinery" &&
                form.isActive == "T",
          );
    } catch (e) {
      formRefinery = null; // Handle case where form is not found
    }
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() =>
      AppBar(title: Text("Refinery Approval (${formRefinery?.code ?? 'N/A'})"));

  Widget _buildBody() {
    return Consumer<DailyProductionRefineryProvider>(
      builder: (context, provider, child) {
        // Loading State
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error State
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
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _refreshData,
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
          );
        }

        // Empty State
        if (provider.reportsForManager.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'No data available for approval',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _refreshData,
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
          );
        }

        // Grouping the reports by date and work center
        final allReports = provider.reportsForManager;
        final Map<String, List<DailyProductionRefineryEntity>> groupedReports =
            {};

        for (var report in allReports) {
          if (report.postingDate != null && report.workCenter != null) {
            final dateKey = DateFormat(
              'yyyy-MM-dd',
            ).format(report.postingDate!);
            final compositeKey = "$dateKey|${report.workCenter}";
            groupedReports.putIfAbsent(compositeKey, () => []).add(report);
          }
        }

        // Sort keys to show the most recent dates first
        final List<String> groupKeys = groupedReports.keys.toList();
        groupKeys.sort((a, b) => b.compareTo(a));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListView.builder(
            itemCount: groupKeys.length,
            itemBuilder: (context, index) {
              final compositeKey = groupKeys[index];
              final reportsForGroup = groupedReports[compositeKey]!;
              final keyParts = compositeKey.split('|');
              final date = keyParts[0];
              final workCenter = keyParts[1];

              // --- Approval Logic ---
              // Assumption: A day is ready for approval if all 3 shifts are present
              // and have been prepared ('Approved' by the previous role).
              const int requiredShifts = 3;
              final shifts = reportsForGroup.map((r) => r.shift).toSet();
              final isReadyForApproval =
                  reportsForGroup.length >= requiredShifts &&
                  shifts.contains('1') &&
                  shifts.contains('2') &&
                  shifts.contains('3') &&
                  reportsForGroup.every((r) => r.preparedStatus == "Approved");

              final isApprovedForDay = reportsForGroup.every(
                (r) => r.checkedStatus == 'Approved',
              );
              final isRejectedForDay = reportsForGroup.any(
                (r) => r.checkedStatus == 'Rejected',
              );

              // --- Card UI Logic ---
              Color cardColor = Colors.white;
              IconData icon = Icons.hourglass_bottom_rounded;
              Color iconColor = Colors.grey[700]!;
              String statusText = 'Shift Belum Lengkap';

              if (isReadyForApproval) {
                cardColor = Colors.white;
                icon = Icons.pending_actions_rounded;
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
                  onTap: () {
                    if (isReadyForApproval) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  DailyProductionRefineryApprovalDetailPage(
                                    reportEntities: reportsForGroup,
                                    reportIdentifier: compositeKey,
                                  ),
                        ),
                      );
                    } else if (isApprovedForDay) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'This group has already been approved.',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'All shifts must be prepared before approval.',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _refreshData() {
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";
    context.read<DailyProductionRefineryProvider>().fetchReportsForManager(
      plantCode,
    );
  }
}
