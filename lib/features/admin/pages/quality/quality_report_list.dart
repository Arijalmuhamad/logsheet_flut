import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_detail.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_input.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_refinery_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class QualityReportList extends StatefulWidget {
  const QualityReportList({super.key});

  @override
  State<QualityReportList> createState() => _QualityReportListState();
}

class _QualityReportListState extends State<QualityReportList> {
  @override
  void initState() {
    final username = context.read<UserProvider>().currentUser?.username;
    final role = context.read<UserProvider>().currentUser?.role;
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => context
          .read<QualityReportRefineryProvider>()
          .fetchAllReports(null, null, username ?? "", role ?? "", plantCode),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await context.read<ValueProvider>().fetchOilTypes(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final username = context.read<UserProvider>().currentUser?.username;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          log("Tombol tambah report diklik");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => QualityReportRefineryPage(
                    userName: username ?? "Unknown",
                  ),
            ),
          );
        },
        label: const Text("Tambah Quality Report"),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
    title: const Text("Quality List (F/QCO-002)"),
    actions: [
      context.watch<QualityReportRefineryProvider>().isLoading
          ? CircularProgressIndicator()
          : IconButton(
            onPressed: () {
              final username =
                  context.read<UserProvider>().currentUser?.username;
              final role = context.read<UserProvider>().currentUser?.role;
              final plantCode =
                  context.read<PlantProvider>().currentPlant?.code ?? "";
              context.read<QualityReportRefineryProvider>().fetchAllReports(
                null,
                null,
                username ?? "",
                role ?? "",
                plantCode,
              );
            },
            icon: Consumer<QualityReportRefineryProvider>(
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

  Widget _buildBody() {
    return Consumer<QualityReportRefineryProvider>(
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
            ),
          );
        }
        if (provider.reportsList.isEmpty) {
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
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: provider.reportsList.length,
            itemBuilder: (context, index) {
              final report = provider.reportsList[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QualityDetailPage(item: report),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 18.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                report.id,
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
                                color: _getStatusColor(report),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getStatusText(report),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),

                        // Transaction Date and Time
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat(
                                'yyyy-MM-dd',
                              ).format(report.transactionDate!),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 16),
                            const Icon(
                              Icons.schedule,
                              size: 18,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Text(
                              DateFormat('HH:mm').format(report.time!),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 16),
                            const Icon(
                              Icons.timelapse,
                              size: 18,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Shift ${report.shift}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Entered By
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Entried by: ${report.entryBy}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _getStatusText(QualityReportRefineryEntity report) {
    if (report.checkedStatus == "Approved") {
      return "Approved";
    }

    if (report.checkedStatus == "Rejected") {
      return "Rejected";
    }
    if (report.preparedStatusShift1 == "Approved" ||
        report.preparedStatusShift2 == "Approved" ||
        report.preparedStatusShift3 == "Approved") {
      return "Prepared ${report.shift}";
    }

    if (report.preparedStatusShift1 == "Rejected" ||
        report.preparedStatusShift2 == "Rejected" ||
        report.preparedStatusShift3 == "Rejected") {
      return "Rejected";
    }
    return "Submitted";
  }

  Color _getStatusColor(QualityReportRefineryEntity report) {
    if (report.checkedStatus == "Approved") {
      return Colors.green;
    }

    if (report.checkedStatus == "Rejected") {
      return Colors.red;
    }

    if (report.preparedStatusShift1 == "Approved" ||
        report.preparedStatusShift2 == "Approved" ||
        report.preparedStatusShift3 == "Approved") {
      return Colors.orangeAccent;
    }

    if (report.preparedStatusShift1 == "Rejected" ||
        report.preparedStatusShift2 == "Rejected" ||
        report.preparedStatusShift3 == "Rejected") {
      return Colors.red;
    }
    return Colors.grey;
  }
}
