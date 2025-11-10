import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_report_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/data/remote/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_from_db_entity.dart';
import 'package:logsheet_app/data/remote/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_to_db_entity.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_edit_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_edit_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_report_detail_page.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_stateless_checklist_item_row.dart';
import 'package:logsheet_app/providers/maintenance/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_provider.dart';
import 'package:provider/provider.dart';

class DailyStorageTankAnalyticalApprovalDetailPage extends StatefulWidget {
  DailyStorageTankAnalyticalApprovalDetailPage({super.key, required this.id});

  String id;

  @override
  State<DailyStorageTankAnalyticalApprovalDetailPage> createState() =>
      _DailyStorageTankAnalyticalListDetailPageState();
}

class _DailyStorageTankAnalyticalListDetailPageState
    extends State<DailyStorageTankAnalyticalApprovalDetailPage> {
  DailyStorageTankAnalyticalFromDbEntity? approvalItem;
  final TextEditingController remarkController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final item = context
          .read<DailyStorageTankAnalyticalProvider>()
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
      body: Consumer<ChangeProductChecklistProvider>(
        builder: (
          BuildContext context,
          ChangeProductChecklistProvider value,
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
    return Consumer2<DailyStorageTankAnalyticalProvider, UserProvider>(
      builder: (
        BuildContext context,
        DailyStorageTankAnalyticalProvider reportProvider,
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
                            'Analysis Date',
                            _formatDateString(approvalItem?.transactionDate),
                          ),
                        ],
                      ),
                    ),

                    _buildSection('General Information', [
                      _buildDataRow('ID', approvalItem?.id ?? ''),
                      _buildDataRow('Company', approvalItem?.company ?? ''),
                      _buildDataRow('Plant', approvalItem?.plant ?? ''),
                    ]),

                    _buildSection('Storage Tank Analytical Result', [
                      _buildDataRow('Tank No', approvalItem?.tankNo ?? ''),
                      _buildDataRow('Oil Type', approvalItem?.oilType ?? ''),
                      _buildDataRow(
                        'Kapasitas Tanki',
                        approvalItem?.kapasitasTanki ?? '',
                      ),
                      _buildDataRow('Quantity', approvalItem?.quantity ?? ''),
                      _buildDataRow(
                        'Empty Space',
                        approvalItem?.emptySpace ?? '',
                      ),
                      _buildDataRow('Suhu', approvalItem?.suhu ?? ''),

                      _buildSection('Quality Parameter', [
                        _buildDataRow('FFA', approvalItem?.qpFFA ?? ''),
                        _buildDataRow(
                          'Moisture',
                          approvalItem?.qpMoisture ?? '',
                        ),
                        _buildDataRow(
                          'LoviBondColor R',
                          approvalItem?.qpColorR ?? '',
                        ),
                        _buildDataRow(
                          'LoviBondColor Y',
                          approvalItem?.qpColorY ?? '',
                        ),
                        _buildDataRow('IV', approvalItem?.qpIV ?? ''),
                        _buildDataRow('PV', approvalItem?.qpPV ?? ''),
                        _buildDataRow(
                          'Slip Melting Point',
                          approvalItem?.qpSlipMeltingPoint ?? '',
                        ),
                        _buildDataRow(
                          'Cloud Point',
                          approvalItem?.qpCloudPoint ?? '',
                        ),
                        _buildDataRow('AnV', approvalItem?.qpANV ?? ''),
                        _buildDataRow(
                          'B-Carotene',
                          approvalItem?.betaCarotene ?? '',
                        ),
                        _buildDataRow('P', approvalItem?.qpP ?? ''),
                        _buildDataRow('Dobi', approvalItem?.qpDobi ?? ''),
                        _buildDataRow('Totox', approvalItem?.qpTotox ?? ''),
                        CustomStatelessChecklistItemRow(
                          description: 'Odor',
                          value: approvalItem?.qpOdor == "T" ? true : false,
                          isShowNumber: false,
                        ),
                      ]),
                    ]),

                    _buildSection('Operator Information', [
                      _buildDataRow(
                        'Prepared By',
                        approvalItem?.preparedBy ?? '-',
                      ),
                      _buildDataRow(
                        'Approved By',
                        approvalItem?.approvedBy ?? '-',
                      ),
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
                            approvalItem?.approvedStatus == "Approved") ...[
                          Text(
                            "Checklist Approved",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ] else if (approvalItem?.preparedStatus == "Rejected" ||
                            approvalItem?.approvedStatus == "Rejected") ...[
                          Text(
                            "Checklist Rejected",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ] else if (AppRoles.qualityControlManagerApproval
                            .contains(userProvider.currentUser?.role)) ...[
                          // 👉 tambahkan widget khusus untuk role manager di sini, misalnya:
                          if (approvalItem?.preparedStatus == "Approved" &&
                              approvalItem?.approvedStatus == null) ...[
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
                                        bool isSuccess = await _approveReport(
                                          "Approved",
                                        );
                                        if (isSuccess) {
                                          showSnackBar(
                                            "Berhasil Approve Checklist",
                                            context,
                                          );
                                          Navigator.of(context).pop();
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
                          if (approvalItem?.approvedStatus == null) ...[
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
        'Approval Detail',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  Future<bool> _approveReport(String status) {
    final user = context.read<UserProvider>();

    var isSuccess = context
        .read<DailyStorageTankAnalyticalProvider>()
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

                        bool isSuccess = await _approveReport("Rejected");
                        if (isSuccess) {
                          Navigator.of(context).pop(); // Tutup bottom sheet
                          showSnackBar("Berhasil Reject Checklist", context);
                          Navigator.of(context).pop();
                        } else {
                          showSnackBar("Gagal Reject Checklist", context);
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
