import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_approval_detail_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_approval_detail_page.dart';
import 'package:logsheet_app/providers/maintenance/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_provider.dart';
import 'package:provider/provider.dart';

// Dummy model class to simulate your report entity

class DailyStorageTankAnalyticalApprovalListPage extends StatefulWidget {
  const DailyStorageTankAnalyticalApprovalListPage({super.key});

  @override
  State<DailyStorageTankAnalyticalApprovalListPage> createState() =>
      _DailyStorageTankAnalyticalApprovalListPageState();
}

class _DailyStorageTankAnalyticalApprovalListPageState
    extends State<DailyStorageTankAnalyticalApprovalListPage> {
  DataFormNoEntity? formData;
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<DailyStorageTankAnalyticalProvider>()
          .getAllDailyStorageTankApproval();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<DailyStorageTankAnalyticalProvider>(
        builder: (
          BuildContext context,
          DailyStorageTankAnalyticalProvider provider,
          Widget? child,
        ) {
          return (provider.isLoadingApproval)
              ? const Center(child: CircularProgressIndicator())
              : (provider.approvalList.isEmpty)
              ? const Center(child: Text("No Data Available"))
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListView.builder(
                  itemCount: provider.approvalList.length,
                  itemBuilder: (context, index) {
                    final item = provider.approvalList[index];
                    log("item.transactionDate: ${item.transactionDate}");
                    return _approvalCardItem(
                      id: item.id ?? '',
                      date: item.transactionDate ?? '',
                      preparedStatus: item.preparedStatus ?? '',
                      approvedStatus: item.approvedStatus ?? '',
                      oilType: item.oilType,
                      tankNo: item.tankNo,
                    );
                  },
                ),
              );
        },
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
      title: Text("Approval (${formData!.code})"),
      actions: [
        Consumer<DailyStorageTankAnalyticalProvider>(
          builder: (
            BuildContext context,
            DailyStorageTankAnalyticalProvider provider,
            Widget? child,
          ) {
            return (provider.isLoading)
                ? CircularProgressIndicator()
                : IconButton(
                  onPressed: () async {
                    await provider.getAllDailyStorageTankApproval();
                  },
                  icon: Icon(Icons.replay),
                );
          },
        ),
      ],
    );
  }

  Widget _approvalCardItem({
    required String id,
    required String date,
    required String? preparedStatus,
    required String? approvedStatus,
    required String? oilType,
    required String? tankNo,

    IconData? icon,
    Color? iconColor,
    Color? cardColor,
    String? showedStatus,
  }) {
    // Tentukan warna dan ikon berdasarkan status
    if (preparedStatus == "Approved" && approvedStatus == "Approved") {
      icon = Icons.check_circle;
      iconColor = Colors.green;
      cardColor = Colors.green[50];
      showedStatus = "Approved";
    } else if (preparedStatus == "Rejected" || approvedStatus == "Rejected") {
      icon = Icons.cancel;
      iconColor = Colors.red;
      cardColor = Colors.red[50];
      showedStatus = "Rejected";
    } else if (preparedStatus != '') {
      icon = Icons.hourglass_empty;
      iconColor = Colors.orange;
      cardColor = Colors.orange[50];
      showedStatus = "Prepared";
    } else if (preparedStatus == '' && approvedStatus == '') {
      icon = Icons.hourglass_empty;
      iconColor = Colors.blue;
      cardColor = Colors.blue[50];
      showedStatus = "Submitted";
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      DailyStorageTankAnalyticalApprovalDetailPage(id: id),
            ),
          ).then((_) async {
            // Refresh the list when returning from the detail page
            if (!mounted) return;
            await context
                .read<DailyStorageTankAnalyticalProvider>()
                .getAllDailyStorageTankApproval();
          });
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
                    Text('Tank: $tankNo', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      'OilType: $oilType',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: $showedStatus',
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
