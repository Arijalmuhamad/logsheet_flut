import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_report_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_edit_page.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_stateless_checklist_item_row.dart';
import 'package:logsheet_app/providers/maintenance/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class MaintenanceChangeProductApprovalDetailPage extends StatefulWidget {
  String id;

  MaintenanceChangeProductApprovalDetailPage({super.key, required this.id});

  @override
  State<MaintenanceChangeProductApprovalDetailPage> createState() =>
      _MaintenanceChangeProductApprovalDetailPageState();
}

class _MaintenanceChangeProductApprovalDetailPageState
    extends State<MaintenanceChangeProductApprovalDetailPage> {
  MaintenanceChangeProductChecklistReportEntity? approvalItem;
  final TextEditingController remarkController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final item = context
          .read<ChangeProductChecklistProvider>()
          .uniqueApprovalList
          .firstWhere((element) => element.id == widget.id);

      setState(() {
        approvalItem = item;
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
    if (approvalItem == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<ChangeProductChecklistProvider>(
        builder: (
          BuildContext context,
          ChangeProductChecklistProvider provider,
          Widget? child,
        ) {
          return (provider.isLoadingDelete || provider.isLoadingApproval)
              ? Center(child: CircularProgressIndicator())
              : _buildBody(context);
        },
      ),
    );
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

    return SafeArea(
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
                    _formatDateString(approvalItem?.transactionDate),
                  ),
                  const SizedBox(width: 8),
                  _buildInfoCard(
                    'Waktu',
                    _formatTimeString(approvalItem?.transactionTime),
                  ),
                ],
              ),
            ),

            _buildSection('General Information', [
              _buildDataRow('ID', approvalItem?.id ?? ''),
              _buildDataRow('Company', approvalItem!.company),
              _buildDataRow('Plant', approvalItem!.plant),
              _buildDataRow('First Product', approvalItem!.firstProduct ?? ''),
              _buildDataRow('Next Product', approvalItem!.nextProduct ?? ''),
              _buildDataRow('Work Center', approvalItem!.workCenter ?? ''),
              _buildDataRow('Prepared By', approvalItem!.preparedBy ?? ''),
              _buildDataRow('Prepared Date', approvalItem!.preparedDate ?? ''),
              _buildDataRow(
                'Prepared Status',
                approvalItem!.preparedStatus ?? '',
              ),
              _buildDataRow('Checked By', approvalItem!.checkedBy ?? '-'),
              _buildDataRow('Checked Date', approvalItem!.checkedDate ?? '-'),
              _buildDataRow(
                'Checked Status',
                approvalItem!.checkedStatus ?? '-',
              ),
            ]),
            _buildSection('Change Product Checklist', [
              if (approvalItem!.workCenter == 'REF-01' ||
                  approvalItem!.workCenter == 'REF-02') ...[
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
              ] else if (AppRoles.managerProd.contains(
                user.currentUser?.role,
              )) ...[
                // 👉 tambahkan widget khusus untuk role manager di sini, misalnya:
                if (approvalItem?.preparedStatus == "Approved" &&
                    approvalItem?.checkedStatus == null) ...[
                  Text('Checked Status:'),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  await _approveRejectChangeProductChecklist(
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ] else if (AppRoles.leadProd.contains(
                user.currentUser?.role,
              )) ...[
                if (approvalItem?.preparedStatus == null) ...[
                  Text(
                    "Waiting Apprvoal From Leader Productions...",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ] else if (approvalItem?.checkedStatus == null) ...[
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

  Future<bool> _approveRejectChangeProductChecklist(String status) {
    final user = context.read<UserProvider>();

    var isSuccess = context
        .read<ChangeProductChecklistProvider>()
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

                        bool isSuccess =
                            await _approveRejectChangeProductChecklist(
                              "Rejected",
                            );
                        if (isSuccess) {
                          Navigator.of(context).pop(); // Tutup bottom sheet
                          showSnackBar("Berhasil Reject Checklist", context);
                          Navigator.of(
                            context,
                          ).pop(); // Kembali ke halaman sebelumnya
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
}
