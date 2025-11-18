import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
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

class DailyQualityCompositeFractionationApprovalDetailPage
    extends StatefulWidget {
  DailyQualityCompositeFractionationApprovalDetailPage({
    super.key,
    required this.id,
  });

  String id;

  @override
  State<DailyQualityCompositeFractionationApprovalDetailPage> createState() =>
      _DailyQualityCompositeFractionationApprovalDetailPageState();
}

class _DailyQualityCompositeFractionationApprovalDetailPageState
    extends State<DailyQualityCompositeFractionationApprovalDetailPage> {
  DailyQualityCompositeFractionationEntity? approvalItem;
  final TextEditingController remarkController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final item = context
          .read<DailyQualityCompositeFractionationProvider>()
          .approvalList
          .firstWhere((element) => element.id == widget.id);

      setState(() {
        approvalItem = item;
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
                              approvalItem?.transactionDate?.toIso8601String(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    _buildSection('General Information', [
                      _buildDataRow('ID', approvalItem?.id ?? ''),
                    ]),

                    _buildSection('Raw Material', [
                      _buildDataRow(
                        'Crystalizer',
                        approvalItem?.crystalizer ?? '',
                      ),
                      _buildDataRow(
                        'M&I',
                        approvalItem?.rmMni.toString() ?? '',
                      ),
                      _buildDataRow('IV', approvalItem?.rmIv.toString() ?? ''),
                      _buildDataRow(
                        'Colour R',
                        approvalItem?.rmColorR.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour Y',
                        approvalItem?.rmColorY.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour W',
                        approvalItem?.rmColorW.toString() ?? '',
                      ),

                      _buildDataRow(
                        'Colour Y',
                        approvalItem?.rmColorB.toString() ?? '',
                      ),
                    ]),

                    _buildSection('Finish Goods', [
                      _buildDataRow(
                        'FFA',
                        approvalItem?.fgFfa.toString() ?? '',
                      ),
                      _buildDataRow(
                        'M&I',
                        approvalItem?.fgMni.toString() ?? '',
                      ),
                      _buildDataRow('IV', approvalItem?.rmIv.toString() ?? ''),
                      _buildDataRow(
                        'Colour R',
                        approvalItem?.fgColorR.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour Y',
                        approvalItem?.fgColorY.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour W',
                        approvalItem?.fgColorW.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour B',
                        approvalItem?.fgColorB.toString() ?? '',
                      ),
                      _buildDataRow('CP', approvalItem?.fgCp.toString() ?? ''),
                      _buildDataRow(
                        'Clarity',
                        approvalItem?.fgCp.toString() ?? '',
                      ),
                      _buildDataRow('To Tank', approvalItem?.fgToTank ?? ''),
                    ]),

                    _buildSection('By Product', [
                      _buildDataRow(
                        'FFA',
                        approvalItem?.bpFfa.toString() ?? '',
                      ),
                      _buildDataRow(
                        'M&I',
                        approvalItem?.bpMni.toString() ?? '',
                      ),
                      _buildDataRow('IV', approvalItem?.bpIv.toString() ?? ''),
                      _buildDataRow('PV', approvalItem?.bpPv.toString() ?? ''),
                      _buildDataRow(
                        'Colour R',
                        approvalItem?.bpColorR.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour Y',
                        approvalItem?.bpColorY.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour W',
                        approvalItem?.bpColorW.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Colour B',
                        approvalItem?.bpColorB.toString() ?? '',
                      ),

                      _buildDataRow('To Tank', approvalItem?.bpToTank ?? ''),
                    ]),

                    _buildSection('Remarks', [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              approvalItem?.remarks ?? '',
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
                        if (approvalItem?.preparedStatus == "Approved" &&
                            approvalItem?.checkedStatus == "Approved") ...[
                          Text(
                            "Checklist Approved",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ] else if (approvalItem?.preparedStatus == "Rejected" ||
                            approvalItem?.checkedStatus == "Rejected") ...[
                          Text(
                            "Checklist Rejected",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ] else if (AppRoles.qualityControlManagerApproval
                            .contains(userProvider.currentUser?.role)) ...[
                          if (approvalItem?.preparedStatus == "Approved" &&
                              approvalItem?.checkedStatus == null) ...[
                            Text('Approved Status:'),
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
                                            this.context,
                                          );
                                          Navigator.of(this.context).pop();
                                          log("Sukses Approve");
                                        } else {
                                          showSnackBar(
                                            "Gagal Approve Checklist",
                                            this.context,
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
                          ] else if (approvalItem?.preparedStatus == null) ...[
                            Text(
                              "Waiting Approval From Leader Productions...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ] else if (AppRoles.leadQC.contains(
                          userProvider.currentUser?.role,
                        )) ...[
                          if (approvalItem?.checkedStatus == null) ...[
                            Text(
                              "Waiting Apprvoal From Manager Productions...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
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
      actions: [],
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
                          showSnackBar(
                            "Berhasil Reject Checklist",
                            this.context,
                          );
                          Navigator.of(
                            this.context,
                          ).pop(); // Tutup bottom sheet
                        } else {
                          showSnackBar("Gagal Reject Checklist", this.context);
                          Navigator.of(this.context).pop();
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
