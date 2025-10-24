import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_input_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_list_detail_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_report_list_detail_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/qc/quality_input_qc_page.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/providers/maintenance/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_qc_provider.dart';
import 'package:provider/provider.dart';

class MaintenanceChangeProductReportListPage extends StatefulWidget {
  const MaintenanceChangeProductReportListPage({super.key});

  @override
  State<MaintenanceChangeProductReportListPage> createState() =>
      _MaintenanceChangeProductReportListPageState();
}

class _MaintenanceChangeProductReportListPageState
    extends State<MaintenanceChangeProductReportListPage> {
  DataFormNoEntity? formData;
  final TextEditingController dateEntryController = TextEditingController();

  initState() {
    // super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await context
    //       .read<ChangeProductChecklistProvider>()
    //       .getAllChangeProductFromDate(date);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final username = context.read<UserProvider>().currentUser?.username;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          log("Tombol Tambah Change Product Ditekan");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => MaintenanceChangeProductInputPage(),
            ),
          ).then((_) async {
            // Refresh the list when returning from the detail page
            if (!mounted) return;
            final formatted = parseDateTimeForQuery(dateEntryController.text);
            await context
                .read<ChangeProductChecklistProvider>()
                .getAllChangeProductFromDate(formatted ?? '');
          });
        },
        label: const Text("Tambah Change Product"),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where((form) => form.isMenu == "Change_Product_Checklist")
            .first;
    return AppBar(
      title: Text("Change Product (${formData!.code})"),
      actions: [
        context.watch<ChangeProductChecklistProvider>().isLoading
            ? CircularProgressIndicator()
            : IconButton(
              onPressed: () async {},
              icon: Consumer<ChangeProductChecklistProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  return const Icon(Icons.replay);
                },
              ),
            ),
      ],
    );
  }

  Widget _buildBody() {
    final changeProductChecklistProvider =
        context.watch<ChangeProductChecklistProvider>();

    final isLoading = changeProductChecklistProvider.isLoading;
    final reportList = changeProductChecklistProvider.uniqueReportList;

    return Column(
      children: [
        _buildFilterSection(context),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    // 🔹 Tampilkan indikator loading
                    return const Center(child: CircularProgressIndicator());
                  } else if (reportList.isEmpty) {
                    // 🔹 Tampilkan teks jika tidak ada data
                    return const Center(child: Text("No Data Available"));
                  } else {
                    // 🔹 Tampilkan list jika ada data
                    return ListView.builder(
                      itemCount: reportList.length,
                      itemBuilder: (context, index) {
                        final item = reportList[index];
                        return _changeProductsCardItem(
                          id: item.id,
                          date: item.transactionDate,
                          time: item.transactionTime,
                          workCenter: item.workCenter ?? '',
                          entryBy: item.entryBy ?? '',
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
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
                    .read<ChangeProductChecklistProvider>()
                    .getAllChangeProductFromDate(formattedDate);
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

  Widget _changeProductsCardItem({
    required String id,
    required String date,
    required String time,
    required String workCenter,
    required String entryBy,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MaintenanceChangeProductReportListDetailPage(id: id),
          ),
        ).then((_) {
          // Refresh the list when returning from the detail page
          if (!mounted) return;
          final formatted = parseDateTimeForQuery(dateEntryController.text);
          context
              .read<ChangeProductChecklistProvider>()
              .getAllChangeProductFromDate(formatted ?? '');
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
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Fill With Status",
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
                    "$date",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(width: 16),

                  const Icon(Icons.schedule, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "$time",
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
                    "$workCenter",
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
      final outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
      return outputFormat.format(dateTime);
    } catch (e) {
      print("Error parsing date: $e");
      return null;
    }
  }
}