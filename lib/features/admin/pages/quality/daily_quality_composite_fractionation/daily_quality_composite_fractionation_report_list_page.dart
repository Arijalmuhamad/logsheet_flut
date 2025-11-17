import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_report_list_detail_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_input_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_report_detail_page.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/providers/maintenance/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:logsheet_app/providers/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_provider.dart';
import 'package:provider/provider.dart';

class DailyQualityCompositeFractionationReportListPage extends StatefulWidget {
  const DailyQualityCompositeFractionationReportListPage({super.key});

  @override
  State<DailyQualityCompositeFractionationReportListPage> createState() =>
      _DailyQualityCompositeFractionationReportListPageState();
}

class _DailyQualityCompositeFractionationReportListPageState
    extends State<DailyQualityCompositeFractionationReportListPage> {
  DataFormNoEntity? formData;

  final TextEditingController dateEntryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userRole = context.read<UserProvider>().currentUser?.role;
    return Scaffold(appBar: _buildAppBar(), body: _buildBody(userRole ?? ''));
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where((form) => form.isMenu == "Change_Product_Checklist")
            .first;
    return AppBar(title: Text("List (${formData!.code})"), actions: [
        
      ],
    );
  }

  Widget _buildBody(String role) {
    return Column(
      children: [
        _buildFilterSection(context, role),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  return Consumer<DailyQualityCompositeFractionationProvider>(
                    builder: (
                      BuildContext context,
                      DailyQualityCompositeFractionationProvider provider,
                      Widget? child,
                    ) {
                      return (provider.isLoading)
                          ? Center(child: CircularProgressIndicator())
                          : (provider.reportsList.isEmpty)
                          ? Center(child: Text('No data'))
                          : ListView.builder(
                            itemCount: provider.reportsList.length,
                            itemBuilder: (context, index) {
                              final item = provider.reportsList[index];
                              return _cardItem(
                                id: item.id ?? '',
                                date: item.transactionDate?.toString() ?? '',
                                entryBy: item.entryBy ?? '',
                                oilType: '',
                                tank: item.crystalizer ?? '',
                                role: role,
                                approvedStatus: item.checkedStatus ?? '',
                                preparedStatus: item.preparedStatus ?? '',
                              );
                            },
                          );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context, String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomDateField(
              controller: dateEntryController,
              label: 'Tanggal',
              icon: Icons.event,
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final formattedDate = parseDateTimeForQuery(
                dateEntryController.text,
              );
              log('Searching for date: $formattedDate');
              if (formattedDate != null) {
                await context
                    .read<DailyQualityCompositeFractionationProvider>()
                    .getAllDailyCompositeFractionationReport(
                      formattedDate,
                      role,
                    );
              }
            },
            icon: const Icon(Icons.search),
            label: const Text('Cari'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAB2F2B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardItem({
    required String id,
    required String date,
    required String? tank,
    required String? oilType,
    required String? entryBy,
    required String? role,
    required String approvedStatus,
    required String preparedStatus,
    Color? badgeColor,
    String? showedStatus,
  }) {
    if (preparedStatus == "Approved" && approvedStatus == "Approved") {
      badgeColor = Colors.green;
      showedStatus = "Approved";
    } else if (preparedStatus == "Rejected" || approvedStatus == "Rejected") {
      badgeColor = Colors.red;
      showedStatus = "Rejected";
    } else if (preparedStatus != '') {
      badgeColor = Colors.orange;
      showedStatus = "Prepared";
    } else if (preparedStatus == '') {
      badgeColor = Colors.blue;
      showedStatus = "Submitted";
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DailyQualityCompositeFractionationReportListDetailPage(id: id),
          ),
        ).then((_) {
          // Refresh the list when returning from the detail page
          if (!mounted) return;
          final formatted = parseDateTimeForQuery(dateEntryController.text);
          context
              .read<ChangeProductChecklistProvider>()
              .getAllChangeProductFromDate(formatted ?? '', role ?? '');
        });
      },
      child: Card(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "$id",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$showedStatus',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 16),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${_formatDateString(date)}",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(width: 16),

                  const Icon(Icons.storage, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "$tank",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.home_work_rounded,
                    size: 18,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "$oilType",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Entried by: $entryBy',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? parseDateTimeForQuery(String? selectedDate) {
    if (selectedDate == null || selectedDate.isEmpty) return null;

    try {
      // Step 1: Parse dari format UI
      final inputFormat = DateFormat('dd-MM-yyyy');
      final dateTime = inputFormat.parse(selectedDate);

      // Step 2: Ubah ke format yang diinginkan
      final outputFormat = DateFormat('yyyy-MM-dd');
      return outputFormat.format(dateTime);
    } catch (e) {
      print("Error parsing date: $e");
      return null;
    }
  }

  String _formatDateString(String? s) {
    if (s == null || s.isEmpty) return '-';
    final dt = DateTime.tryParse(s);
    if (dt != null) {
      return DateFormat('dd-MM-yyyy').format(dt);
    }
    // If parsing fails, return the original string as a fallback
    return s;
  }
}
