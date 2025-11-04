import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_report_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_edit_page.dart';
import 'package:logsheet_app/features/admin/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_stateless_checklist_item_row.dart';
import 'package:logsheet_app/providers/maintenance/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class MaintenanceChangeProductReportListDetailPage extends StatefulWidget {
  String id;

  MaintenanceChangeProductReportListDetailPage({super.key, required this.id});

  @override
  State<MaintenanceChangeProductReportListDetailPage> createState() =>
      _MaintenanceChangeProductReportListDetailPageState();
}

class _MaintenanceChangeProductReportListDetailPageState
    extends State<MaintenanceChangeProductReportListDetailPage> {
  MaintenanceChangeProductChecklistReportEntity? reportItem;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final item = context
          .read<ChangeProductChecklistProvider>()
          .uniqueReportList
          .firstWhere((element) => element.id == widget.id);

      setState(() {
        reportItem = item;
      });
      await context.read<ChangeProductChecklistProvider>().getLangkahKerja();

      final changeProductChecklistProvider =
          context.read<ChangeProductChecklistProvider>();

      changeProductChecklistProvider.prepopulateReportDetailListForDetail(
        widget.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (reportItem == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    final changeProductChecklistProvider =
        context.watch<ChangeProductChecklistProvider>();
    final user = context.read<UserProvider>();
    String _isNull(double? value) {
      if (value == null) {
        return '-';
      } else {
        return value.toString();
      }
    }

    String _formatDateString(String? s) {
      if (s == null || s.isEmpty) return '-';
      final dt = DateTime.tryParse(s);
      if (dt != null) {
        return DateFormat('dd MMMM yyyy').format(dt);
      }
      // If parsing fails, return the original string as a fallback
      return s;
    }

    String _formatTimeString(String? s) {
      if (s == null || s.isEmpty) return '-';
      try {
        final dt = DateFormat("HH:mm:ss").parse(s);
        return DateFormat("HH:mm").format(dt); // hasil: 08:00
      } catch (e) {
        return s; // fallback jika parsing gagal
      }
    }

    return context.watch<ChangeProductChecklistProvider>().isLoadingDelete
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 36,
              right: 16,
              left: 16,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAB2F2B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCard(
                        'Tanggal',
                        _formatDateString(reportItem?.transactionDate),
                      ),
                      const SizedBox(width: 8),
                      _buildInfoCard(
                        'Waktu',
                        _formatTimeString(reportItem?.transactionTime),
                      ),
                    ],
                  ),
                ),

                _buildSection('General Information', [
                  _buildDataRow('Ticket ID', reportItem?.id ?? ''),
                  _buildDataRow('Company', reportItem!.company),
                  _buildDataRow('Plant', reportItem!.plant),
                  _buildDataRow(
                    'First Product',
                    reportItem!.firstProduct ?? '',
                  ),
                  _buildDataRow('Next Product', reportItem!.nextProduct ?? ''),
                  _buildDataRow('Work Center', reportItem!.workCenter ?? ''),
                ]),

                _buildSection('Change Product Checklist', [
                  if (reportItem!.workCenter == 'REF-01' ||
                      reportItem!.workCenter == 'REF-02') ...[
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Pre-Treatment Section',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              changeProductChecklistProvider
                                  .langkahKerjaPreTreatmentList
                                  .length,
                          itemBuilder: (context, index) {
                            final item =
                                changeProductChecklistProvider
                                    .langkahKerjaPreTreatmentList[index];

                            final detailIndex = changeProductChecklistProvider
                                .reportDetailList
                                .indexWhere(
                                  (detail) => detail.checkItem == item.code,
                                );

                            // ambil status dari reportDetailList (default 'F' kalau belum ada)
                            final isChecked =
                                detailIndex != -1
                                    ? changeProductChecklistProvider
                                            .reportDetailList[detailIndex]
                                            .statusItem ==
                                        "T"
                                    : false;

                            return CustomStatelessChecklistItemRow(
                              number: index + 1,
                              description: item.name ?? '',
                              value: isChecked,
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Divider(
                          height: 0.0,
                          thickness: 1,
                          endIndent: 0,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Bleacher Section',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              changeProductChecklistProvider
                                  .langkahKerjaBleacherList
                                  .length,
                          itemBuilder: (context, index) {
                            final item =
                                changeProductChecklistProvider
                                    .langkahKerjaBleacherList[index];

                            final detailIndex = changeProductChecklistProvider
                                .reportDetailList
                                .indexWhere(
                                  (detail) => detail.checkItem == item.code,
                                );

                            // ambil status dari reportDetailList (default 'F' kalau belum ada)
                            final isChecked =
                                detailIndex != -1
                                    ? changeProductChecklistProvider
                                            .reportDetailList[detailIndex]
                                            .statusItem ==
                                        "T"
                                    : false;

                            return CustomStatelessChecklistItemRow(
                              number: index + 1,
                              description: item.name ?? '',
                              value: isChecked,
                            );
                          },
                        ),
                        SizedBox(height: 16.0),

                        const SizedBox(height: 16.0),
                        Divider(
                          height: 0.0,
                          thickness: 1,
                          endIndent: 0,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Deodorization Section',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              changeProductChecklistProvider
                                  .langkahKerjaDeodorizationList
                                  .length,
                          itemBuilder: (context, index) {
                            final item =
                                changeProductChecklistProvider
                                    .langkahKerjaDeodorizationList[index];

                            final detailIndex = changeProductChecklistProvider
                                .reportDetailList
                                .indexWhere(
                                  (detail) => detail.checkItem == item.code,
                                );

                            // ambil status dari reportDetailList (default 'F' kalau belum ada)
                            final isChecked =
                                detailIndex != -1
                                    ? changeProductChecklistProvider
                                            .reportDetailList[detailIndex]
                                            .statusItem ==
                                        "T"
                                    : false;

                            return CustomStatelessChecklistItemRow(
                              number: index + 1,
                              description: item.name ?? '',
                              value: isChecked,
                            );
                          },
                        ),
                      ],
                    ),
                  ] else ...[
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Fractionation Section',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              changeProductChecklistProvider
                                  .langkahKerjaFractionationList
                                  .length,
                          itemBuilder: (context, index) {
                            final item =
                                changeProductChecklistProvider
                                    .langkahKerjaFractionationList[index];

                            final detailIndex = changeProductChecklistProvider
                                .reportDetailList
                                .indexWhere(
                                  (detail) => detail.checkItem == item.code,
                                );

                            // ambil status dari reportDetailList (default 'F' kalau belum ada)
                            final isChecked =
                                detailIndex != -1
                                    ? changeProductChecklistProvider
                                            .reportDetailList[detailIndex]
                                            .statusItem ==
                                        "T"
                                    : false;

                            return CustomStatelessChecklistItemRow(
                              number: index + 1,
                              description: item.name ?? '',
                              value: isChecked,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ]),
              ],
            ),
          ),
        );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF655F5B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFAB2F2B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: title == "Shift" || title == "Jam" ? 24 : 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF655F5B),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        'Change Product Detail',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

 
}
