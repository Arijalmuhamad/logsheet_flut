import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_report_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/data/remote/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_entity.dart';
import 'package:logsheet_app/data/remote/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_from_db_entity.dart';
import 'package:logsheet_app/data/remote/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_to_db_entity.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_edit_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_edit_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_edit_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_report_detail_page.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_stateless_checklist_item_row.dart';
import 'package:logsheet_app/providers/maintenance/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:logsheet_app/providers/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_provider.dart';
import 'package:provider/provider.dart';

class DailyQualityCompositeFractionationListDetailPage extends StatefulWidget {
  DailyQualityCompositeFractionationListDetailPage({
    super.key,
    required this.id,
  });

  String id;

  @override
  State<DailyQualityCompositeFractionationListDetailPage> createState() =>
      _DailyQualityCompositeFractionationListDetailPageState();
}

class _DailyQualityCompositeFractionationListDetailPageState
    extends State<DailyQualityCompositeFractionationListDetailPage> {
  DailyQualityCompositeFractionationEntity? reportItem;
  final TextEditingController remarkController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final item = context
          .read<DailyQualityCompositeFractionationProvider>()
          .reportsList
          .firstWhere((element) => element.id == widget.id);

      setState(() {
        reportItem = item;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<DailyQualityCompositeFractionationProvider>(
        builder: (
          BuildContext context,
          DailyQualityCompositeFractionationProvider value,
          Widget? child,
        ) {
          return (value.isLoadingApproval)
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer2<DailyQualityCompositeFractionationProvider, UserProvider>(
      builder: (
        BuildContext context,
        DailyQualityCompositeFractionationProvider reportProvider,
        UserProvider userProvider,
        Widget? child,
      ) {
        return (reportProvider.isLoading || reportProvider.isLoadingDelete)
            ? Center(child: CircularProgressIndicator())
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
                            'Date',
                            _formatDateString(
                              reportItem?.transactionDate?.toIso8601String(),
                            ),
                          ),
                          _buildInfoCard(
                            'Time',
                            formatTimeOfDay(
                                  reportItem?.time,
                                  showSecond: false,
                                ) ??
                                '',
                          ),
                        ],
                      ),
                    ),

                    _buildSection('General Information', [
                      _buildDataRow('ID', reportItem?.id ?? ''),
                    ]),

                    _buildSection('Raw Material', [
                      _buildDataRow(
                        'Crystalizer',
                        reportItem?.crystalizer ?? '',
                      ),
                      _buildDataRow('M&I', reportItem?.rmMni.toString() ?? ''),
                      _buildDataRow('IV', reportItem?.rmIv.toString() ?? ''),
                      _buildDataRow(
                        'Colour R',
                        reportItem?.rmColorR.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour Y',
                        reportItem?.rmColorY.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour W',
                        reportItem?.rmColorW.toString() ?? '',
                      ),

                      _buildDataRow(
                        'Colour Y',
                        reportItem?.rmColorB.toString() ?? '',
                      ),
                    ]),

                    _buildSection('Finish Goods', [
                      _buildDataRow('FFA', reportItem?.fgFfa.toString() ?? ''),
                      _buildDataRow('M&I', reportItem?.fgMni.toString() ?? ''),
                      _buildDataRow('IV', reportItem?.rmIv.toString() ?? ''),
                      _buildDataRow(
                        'Colour R',
                        reportItem?.fgColorR.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour Y',
                        reportItem?.fgColorY.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour W',
                        reportItem?.fgColorW.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour B',
                        reportItem?.fgColorB.toString() ?? '',
                      ),
                      _buildDataRow('CP', reportItem?.fgCp.toString() ?? ''),
                      _buildDataRow(
                        'Clarity',
                        reportItem?.fgCp.toString() ?? '',
                      ),
                      _buildDataRow('To Tank', reportItem?.fgToTank ?? ''),
                    ]),

                    _buildSection('By Product', [
                      _buildDataRow('FFA', reportItem?.bpFfa.toString() ?? ''),
                      _buildDataRow('M&I', reportItem?.bpMni.toString() ?? ''),
                      _buildDataRow('IV', reportItem?.bpIv.toString() ?? ''),
                      _buildDataRow('PV', reportItem?.bpPv.toString() ?? ''),
                      _buildDataRow(
                        'Colour R',
                        reportItem?.bpColorR.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour Y',
                        reportItem?.bpColorY.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour W',
                        reportItem?.bpColorW.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour B',
                        reportItem?.bpColorB.toString() ?? '',
                      ),

                      _buildDataRow('To Tank', reportItem?.bpToTank ?? ''),
                    ]),

                    _buildSection('Remarks', [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              reportItem?.remarks ?? '',
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ]),

                    if ((AppRoles.leadQC.contains(
                          userProvider.currentUser?.role,
                        )) ||
                        (AppRoles.qualityControlManagerApproval.contains(
                          userProvider.currentUser?.role,
                        )))
                      _buildSection('Approval Actions', [
                        if (reportItem?.preparedStatus == "Approved" &&
                            reportItem?.checkedStatus == "Approved") ...[
                          Text(
                            "Checklist Approved",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ] else if (reportItem?.preparedStatus == "Rejected" ||
                            reportItem?.checkedStatus == "Rejected") ...[
                          Text(
                            "Checklist Rejected",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ] else if (AppRoles.leadQC.contains(
                          userProvider.currentUser?.role,
                        )) ...[
                          if (reportItem?.preparedStatus == null) ...[
                            Text('Prepared Status:'),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 8.0,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        _showRejectBottomSheet(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: const [
                                          Text('Reject'),
                                          Icon(Icons.close),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 8.0,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        bool isSuccess =
                                            await _approveRejectReport(
                                              "Approved",
                                            );
                                        if (isSuccess) {
                                          showSnackBar(
                                            "Berhasil Approve Checklist",
                                            context,
                                          );

                                          log("Sukses Approve");
                                          if (!mounted) return;
                                          Navigator.of(this.context).pop();
                                        } else {
                                          showSnackBar(
                                            "Gagal Approve Checklist",
                                            context,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: const [
                                          Text('Approve'),
                                          Icon(Icons.check),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else if (reportItem?.preparedStatus != null &&
                              reportItem?.checkedStatus == null) ...[
                            Text(
                              "Waiting Apprvoal From Manager Productions...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ] else if (AppRoles.qualityControlManagerApproval
                            .contains(userProvider.currentUser?.role)) ...[
                          if (reportItem?.preparedStatus == null) ...[
                            Text(
                              "Waiting Apprvoal From Leader QC...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ] else if (reportItem?.preparedStatus == "Approved" ||
                              reportItem?.checkedStatus == "Rejected") ...[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "Checklist Prepared",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ]),
                  ],
                ),
              ),
            );
      },
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF655F5B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(), // <-- ini kuncinya
          Text(value, style: const TextStyle(color: Colors.black54)),
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
        'Detail',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (reportItem?.preparedStatus == null)
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DailyQualityCompositeFractionationEditPage(
                        id: widget.id,
                      ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        if (reportItem?.preparedStatus == null)
          IconButton(
            onPressed: () async {
              return _showDeleteConfirmationDialog(context);
            },
            icon: const Icon(Icons.delete_rounded, color: Colors.red),
          ),
      ],
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    // Simpan context utama ke variabel
    final parentContext = context;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Delete Report',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this report? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed:
                  () => Navigator.of(dialogContext).pop(), // tutup dialog
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // tutup dialog dulu

                final provider =
                    parentContext
                        .read<DailyQualityCompositeFractionationProvider>();

                final isSuccess = await provider
                    .deletedailyQualityCompositeFractionation(widget.id);

                if (isSuccess) {
                  if (parentContext.mounted) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      const SnackBar(
                        content: Text('Report deleted successfully.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(
                      parentContext,
                    ).pop(); // ✅ ini menutup halaman detail
                  }
                } else {
                  if (parentContext.mounted) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to delete report.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _approveRejectReport(String status) {
    final user = context.read<UserProvider>();

    var isSuccess = context
        .read<DailyQualityCompositeFractionationProvider>()
        .updateApproveRejectToHeader(
          id: widget.id,
          approvedBy: user.currentUser!.username,
          status: status,
          role: user.currentUser!.role,
          remarks: remarkController.text,
        );
    return isSuccess;
  }

  void _showRejectBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Reject Checklist',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red[800],
                ),
              ),
              const SizedBox(height: 12),
              CustomRemarkField(controller: remarkController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (remarkController.text.isEmpty) {
                          showSnackBar(
                            "Harap isi remark sebelum reject",
                            context,
                          );
                          return;
                        }
                        Navigator.of(context).pop();
                        bool isSuccess = await _approveRejectReport("Rejected");
                        if (isSuccess) {
                          Navigator.of(
                            this.context,
                          ).pop(); // Tutup bottom sheet
                          showSnackBar(
                            "Berhasil Reject Checklist",
                            this.context,
                          );
                        } else {
                          Navigator.of(this.context).pop();
                          showSnackBar("Gagal Reject Checklist", this.context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Confirm Reject',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
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
}
