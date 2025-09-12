import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/quality_refinery/quality_report_production_entity.dart';
import 'package:logsheet_app/data/remote/quality_refinery/quality_report_qc_entity.dart';
import 'package:logsheet_app/features/admin/pages/quality/qc/quality_approval_detail_qc_page.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_qc_provider.dart';
import 'package:provider/provider.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
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
    return Scaffold(
      appBar: AppBar(title: const Text("Alerts")),
      body: Consumer<QualityReportQCProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingAlert) {
            return Center(child: const CircularProgressIndicator());
          }

          final readyReports = provider.readyReportsList;
          if (readyReports.isEmpty) {
            return Center(child: Text("Tidak ada notifikasi"));
          }

          return ListView.builder(
            itemCount: provider.readyReportsList.length,
            itemBuilder: (context, index) {
              final item = provider.readyReportsList[index];
              final postingDate = item.reportDate;
              final workCenter = item.workCenter;
              final oilType = item.oilType;

              return InkWell(
                onTap: () {
                  final reportIdentifier = "$postingDate|$workCenter|$oilType";

                  final List<QualityReportQcEntity> reportEntities =
                      provider.approvedTransactions
                          .where(
                            (report) =>
                                report.postingDate != null &&
                                DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(report.postingDate!) ==
                                    postingDate &&
                                report.workCenter == workCenter &&
                                report.oilType == oilType,
                          )
                          .toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => QualityApprovalDetailQCScreen(
                            reportEntities: reportEntities,
                            reportIdentifier: reportIdentifier,
                          ),
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text("Report Ready: $postingDate"),
                  subtitle: Text('$workCenter | $oilType'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
