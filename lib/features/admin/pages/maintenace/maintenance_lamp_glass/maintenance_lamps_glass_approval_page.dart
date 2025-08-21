import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_lamp_glass/maintenance_lamps_glass_approval_detail.dart';
import 'package:logsheet_app/providers/maintenance/maintenance_lamps_and_glass_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class MaintenanceLampsGlassApprovalPage extends StatefulWidget {
  const MaintenanceLampsGlassApprovalPage({super.key});

  @override
  State<MaintenanceLampsGlassApprovalPage> createState() =>
      _MaintenanceLampsGlassApprovalPageState();
}

class _MaintenanceLampsGlassApprovalPageState
    extends State<MaintenanceLampsGlassApprovalPage> {
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  Future<void> _pickMonthYear(BuildContext context) async {
    final selectedMonthYear = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedMonthYear != null) {
      setState(() {
        _selectedYear = selectedMonthYear.year;
        _selectedMonth = selectedMonthYear.month;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("L&G Approval (F/RFA-013)")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickMonthYear(context),
                    icon: const Icon(Icons.calendar_month),
                    label: Text(
                      DateFormat(
                        'MMMM yyyy',
                      ).format(DateTime(_selectedYear, _selectedMonth)),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    log(
                      "Searching for Year: $_selectedYear, Month: $_selectedMonth",
                    );
                    context
                        .read<MaintenanceLampsAndGlassProvider>()
                        .fetchAllLampsAndGlassFromMonth(
                          year: _selectedYear,
                          month: _selectedMonth,
                        );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text("Search"),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Consumer<MaintenanceLampsAndGlassProvider>(
              builder: (context, provider, child) {
                if (provider.lampsAndGlassApprovalList.isEmpty) {
                  return Center(child: const Text("No Data"));
                }
                if (provider.isLoading) {
                  return Center(child: const CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(child: Text("error: ${provider.errorMessage}"));
                }

                if (provider.approvalStatus == null) {
                  return const Center(child: Text("Pilih Bulan dan Tahun."));
                }

                final status = provider.approvalStatus!;
                final sortedDailyChecks =
                    status.dailyChecks.entries.toList()
                      ..sort((a, b) => a.key.compareTo(b.key));

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Monthly Progress: ${status.completedDays} / ${status.totalDaysInMonth} Days Complete',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          if (status.canApprove &&
                              sortedDailyChecks[0].value[0].checkedStatus ==
                                  "Approved")
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.green,
                              size: 46,
                            ),

                          if (status.canApprove &&
                              sortedDailyChecks[0].value[0].checkedStatus ==
                                  null)
                            Icon(
                              Icons.pending_rounded,
                              color: Colors.blue,
                              size: 46,
                            ),
                          if (status.canApprove &&
                              sortedDailyChecks[0].value[0].checkedStatus ==
                                  "Rejected")
                            Icon(
                              Icons.cancel_rounded,
                              color: Colors.red,
                              size: 46,
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: sortedDailyChecks.length,
                        itemBuilder: (context, index) {
                          // final item =
                          //     provider.lampsAndGlassApprovalList[index];
                          final dayEntry = sortedDailyChecks[index];
                          final date = dayEntry.key;
                          final checks = dayEntry.value;
                          final isDayComplete = checks.length == 9;
                          return InkWell(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            MaintenanceLampsGlassApprovalDetail(
                                              checks: checks,
                                              date: date,
                                            ),
                                  ),
                                ),
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              color:
                                  isDayComplete
                                      ? Colors.green.shade50
                                      : Colors.orange.shade50,
                              child: ListTile(
                                leading: Icon(
                                  isDayComplete
                                      ? Icons.check_circle
                                      : Icons.warning,
                                  color:
                                      isDayComplete
                                          ? Colors.green
                                          : Colors.orange,
                                ),
                                title: Text(
                                  DateFormat('EEEE, d MMMM yyyy').format(date),
                                ),
                                subtitle: Text(
                                  '${checks.length} / 9 items checked',
                                  style: TextStyle(
                                    fontWeight:
                                        isDayComplete
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                  ),
                                ),
                                // You could make this expandable to show the 9 items
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    if (context
                        .watch<MaintenanceLampsAndGlassProvider>()
                        .approvalStatus!
                        .canApprove)
                      _buildApprovalButtonRow(
                        context,
                        _selectedMonth,
                        _selectedYear,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalButtonRow(
    BuildContext context,
    int month,
    int year,
    // String username,
    // String role,
    // Function(String) onStatusChange,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                // Handle Reject logic
                _showRejectModalBottomSheet(context, month, year);
              },
              icon: const Icon(Icons.close),
              label: const Text('Reject'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  !context
                          .watch<MaintenanceLampsAndGlassProvider>()
                          .isSubmitLoading
                      ? () async {
                        final currentUsername =
                            context
                                .read<UserProvider>()
                                .currentUser
                                ?.username ??
                            "";

                        final response = await context
                            .read<MaintenanceLampsAndGlassProvider>()
                            .updateApproveRejectToHeader(
                              checkedBy: currentUsername,
                              status: "Approved",
                              month: month,
                              year: year,
                              remark: null,
                            );
                        if (response) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Approved")));
                        } else {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Error: ${context.read<MaintenanceLampsAndGlassProvider>().errorMessage}",
                              ),
                            ),
                          );
                        }
                      }
                      : () {},
              icon:
                  context
                          .watch<MaintenanceLampsAndGlassProvider>()
                          .isSubmitLoading
                      ? SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Icon(Icons.check_rounded),
              label: const Text('Approve'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectModalBottomSheet(
    BuildContext context,
    int month,
    int year,
  ) async {
    TextEditingController remarksController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reject Remark",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextField(
                  controller: remarksController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Remarks',
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final currentUsername =
                          context.read<UserProvider>().currentUser?.username ??
                          "";
                      final response = await context
                          .read<MaintenanceLampsAndGlassProvider>()
                          .updateApproveRejectToHeader(
                            checkedBy: currentUsername,
                            status: "Rejected",
                            month: month,
                            year: year,
                            remark: remarksController.text,
                          );

                      if (!context.mounted) return;
                      Navigator.pop(context);

                      if (response) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Rejected")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Error: ${context.read<MaintenanceLampsAndGlassProvider>().errorMessage}",
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Reject"),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
