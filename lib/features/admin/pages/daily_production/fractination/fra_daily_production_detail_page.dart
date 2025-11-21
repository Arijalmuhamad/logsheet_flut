import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_daily_production_edit_page.dart';
import 'package:logsheet_app/providers/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionFractionationDetailPage extends StatefulWidget {
  final DailyProductionFractionationEntity item;
  final DataFormNoEntity formData;
  final bool isDisplayed;

  const DailyProductionFractionationDetailPage({
    super.key,
    required this.item,
    this.isDisplayed = true,
    required this.formData,
  });

  @override
  State<DailyProductionFractionationDetailPage> createState() =>
      _DailyProductionFractionationDetailPageState();
}

class _DailyProductionFractionationDetailPageState
    extends State<DailyProductionFractionationDetailPage> {
  final TextEditingController _remarkController = TextEditingController();
  late DailyProductionFractionationEntity _currentReport;

  @override
  void initState() {
    super.initState();
    _currentReport = widget.item;
  }

  // Helper to display values, defaulting to '-' for nulls
  String _displayValue(dynamic value) {
    return value?.toString() ?? '-';
  }

  // Helper to format date-times
  String _formatDateTime(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : '-';
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
                fontSize: title == "Shift" ? 24 : 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
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
            width: 150, // Adjusted width for potentially longer labels
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

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final String formattedDate =
        _currentReport.transactionDate != null
            ? DateFormat('dd MMMM yyyy').format(_currentReport.transactionDate!)
            : '-';
    final String shift = _displayValue(_currentReport.shift);

    String formatTime(TimeOfDay? time) =>
        time != null
            ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
            : '-';

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(context),
      body: _buildBody(context, user, formattedDate, shift),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        'Fractionation Detail',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (_currentReport.preparedStatus == null)
          IconButton(
            onPressed: () async {
              // Navigate to your edit page
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => FraDailyProductionEditPage(
                        dataForm: widget.formData,
                        entity: _currentReport,
                      ),
                ),
              );
              if (result != null &&
                  result is DailyProductionFractionationEntity) {
                setState(() {
                  _currentReport = result;
                });
              }
            },
            icon: const Icon(Icons.edit),
          ),
        if (_currentReport.preparedStatus == null)
          IconButton(
            onPressed: () async => _showDeleteConfirmationDialog(context),
            icon: const Icon(Icons.delete_rounded, color: Colors.red),
          ),
      ],
    );
  }

  String _displayTime(TimeOfDay? time) {
    if (time == null) return "-";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildBody(
    BuildContext context,
    UserEntity? user,
    String formattedDate,
    String shift,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Info Cards
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFAB2F2B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard('Tanggal', formattedDate),
                  const SizedBox(width: 8),
                  _buildInfoCard(
                    'Work Center',
                    _displayValue(_currentReport.workCenter),
                  ),
                  const SizedBox(width: 8),
                  _buildInfoCard('Shift', shift),
                ],
              ),
            ),

            _buildSection('ID & General Info', [
              _buildDataRow('Ticket ID', _currentReport.id),
              _buildDataRow('Company', _displayValue(_currentReport.company)),
              _buildDataRow('Plant', _displayValue(_currentReport.plant)),
            ]),

            _buildSection('Raw Material (RM)', [
              _buildDataRow(
                'Oil Type',
                _displayValue(_currentReport.oilTypeRm),
              ),
              _buildDataRow('No', _displayValue(_currentReport.oilTypeRmNo)),
              _buildDataRow('Cr', _displayValue(_currentReport.oilTypeRmCr)),
              _buildDataRow(
                'From Tank',
                _displayValue(_currentReport.oilTypeRmFromTank),
              ),
              _buildDataRow(
                'Awal Jam',
                _displayTime(_currentReport.oilTypeRmAwalJam),
              ),
              _buildDataRow(
                'Awal Flowmeter',
                _displayValue(_currentReport.oilTypeRmAwalFlowmeter),
              ),
              _buildDataRow(
                'Akhir Jam',
                _displayTime(_currentReport.oilTypeRmAkhirJam),
              ),
              _buildDataRow(
                'Akhir Flowmeter',
                _displayValue(_currentReport.oilTypeRmAkhirFlowmeter),
              ),
              _buildDataRow(
                'Total',
                _displayValue(_currentReport.oilTypeRmTotal),
              ),
            ]),

            _buildSection('Finished Goods (FG)', [
              _buildDataRow(
                'Oil Type',
                _displayValue(_currentReport.oilTypeFgs),
              ),
              _buildDataRow('No', _displayValue(_currentReport.oilTypeFgsNo)),
              _buildDataRow('Cr', _displayValue(_currentReport.oilTypeFgsCr)),
              _buildDataRow(
                'Awal Jam',
                _displayTime(_currentReport.oilTypeFgsAwalJam),
              ),
              _buildDataRow(
                'Awal Flowmeter',
                _displayValue(_currentReport.oilTypeFgsAwalFlowmeter),
              ),
              _buildDataRow(
                'Akhir Jam',
                _displayTime(_currentReport.oilTypeFgsAkhirJam),
              ),
              _buildDataRow(
                'Akhir Flowmeter',
                _displayValue(_currentReport.oilTypeFgsAkhirFlowmeter),
              ),
              _buildDataRow(
                'Total',
                _displayValue(_currentReport.oilTypeFgsTotal),
              ),
              _buildDataRow(
                'To Tank',
                _displayValue(_currentReport.oilTypeFgsToTank),
              ),
            ]),

            _buildSection('By-Product (BP)', [
              // _buildDataRow(
              //   'Oil Type',
              //   _displayValue(_currentReport.oilTypeFgh),
              // ),
              _buildDataRow('No', _displayValue(_currentReport.oilTypeFghNo)),
              _buildDataRow(
                'Awal Jam',
                _displayTime(_currentReport.oilTypeFghAwalJam),
              ),
              _buildDataRow(
                'Awal Flowmeter',
                _displayValue(_currentReport.oilTypeFghAwalFlowmeter),
              ),
              _buildDataRow(
                'Akhir Jam',
                _displayTime(_currentReport.oilTypeFghAkhirJam),
              ),
              _buildDataRow(
                'Akhir Flowmeter',
                _displayValue(_currentReport.oilTypeFghAkhirFlowmeter),
              ),
              _buildDataRow(
                'Total',
                _displayValue(_currentReport.oilTypeFghTotal),
              ),
              _buildDataRow(
                'To Tank',
                _displayValue(_currentReport.oilTypeFghToTank),
              ),
            ]),

            _buildSection('Utility Usage (UU)', [
              _buildDataRow('Item', _displayValue(_currentReport.uuItem)),
              _buildDataRow(
                'Budget Ref Qty',
                _displayValue(_currentReport.uuBudgetRefQty),
              ),
              _buildDataRow(
                'Flowmeter Before',
                _displayValue(_currentReport.uuFlowmeterBefore),
              ),
              _buildDataRow(
                'Flowmeter After',
                _displayValue(_currentReport.uuFlowmeterAfter),
              ),
              _buildDataRow(
                'Flowmeter Total',
                _displayValue(_currentReport.uuFlowmeterTotal),
              ),
              _buildDataRow(
                'Yield (%)',
                _displayValue(_currentReport.uuYieldPercent),
              ),
              _buildDataRow('Listrik', _displayValue(_currentReport.uuListrik)),
              _buildDataRow('Air', _displayValue(_currentReport.uuAir)),
            ]),

            _buildSection('Metadata & Remarks', [
              _buildDataRow(
                'Transaction Date',
                _formatDateTime(_currentReport.transactionDate),
              ),
              _buildDataRow(
                'Posting Date',
                _formatDateTime(_currentReport.postingDate),
              ),
              _buildDataRow('Remarks', _displayValue(_currentReport.remarks)),
              _buildDataRow('Flag', _displayValue(_currentReport.flag)),
            ]),

            _buildSection('Status & History', [
              _buildDataRow(
                'Entried By',
                _displayValue(_currentReport.entryBy),
              ),
              _buildDataRow(
                'Entry Date',
                _formatDateTime(_currentReport.entryDate),
              ),
              const Divider(),
              _buildDataRow(
                'Prepared By',
                _displayValue(_currentReport.preparedBy),
              ),
              _buildDataRow(
                'Prepared Date',
                _formatDateTime(_currentReport.preparedDate),
              ),
              _buildDataRow(
                'Prepared Status',
                _displayValue(_currentReport.preparedStatus),
              ),
              _buildDataRow(
                'Prepared Remarks',
                _displayValue(_currentReport.preparedStatusRemarks),
              ),
              const Divider(),
              _buildDataRow(
                'Verified By',
                _displayValue(_currentReport.verifiedBy),
              ),
              _buildDataRow(
                'Verified Date',
                _formatDateTime(_currentReport.verifiedDate),
              ),
              _buildDataRow(
                'Verified Status',
                _displayValue(_currentReport.verifiedStatus),
              ),
              _buildDataRow(
                'Verified Remarks',
                _displayValue(_currentReport.verifiedStatusRemarks),
              ),
              const Divider(),
              _buildDataRow(
                'Checked By',
                _displayValue(_currentReport.checkedBy),
              ),
              _buildDataRow(
                'Checked Date',
                _formatDateTime(_currentReport.checkedDate),
              ),
              _buildDataRow(
                'Checked Status',
                _displayValue(_currentReport.checkedStatus),
              ),
              _buildDataRow(
                'Checked Remarks',
                _displayValue(_currentReport.checkedStatusRemarks),
              ),
            ]),

            _buildSection('Form Info', [
              _buildDataRow('Form No', _displayValue(_currentReport.formNo)),
              _buildDataRow(
                'Date Issued',
                _formatDateTime(_currentReport.dateIssued),
              ),
              _buildDataRow(
                'Revision No',
                _displayValue(_currentReport.revisionNo),
              ),
              _buildDataRow(
                'Revision Date',
                _formatDateTime(_currentReport.revisionDate),
              ),
            ]),

            // Action Buttons
            // user?.role
            if (AppRoles.leadProd.contains(user?.role))
              if (widget.isDisplayed)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 62,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              _showApprovedRejectedBottomSheet(
                                context,
                                false,
                                shift,
                                user!,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Reject Shift $shift"),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 62,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              _showApprovedRejectedBottomSheet(
                                context,
                                true,
                                shift,
                                user!,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Approve Shift $shift"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Consumer2<DailyProductionFractionationProvider, UserProvider>(
          builder:
              (context, provider, userProvider, child) => AlertDialog(
                title: const Text('Hapus Ticket'),
                content: Text(
                  "Apakah anda yakin ingin menghapus Ticket ${_currentReport.id}?",
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Tidak"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child:
                        provider.isLoadingDelete
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Ya',
                              style: TextStyle(color: Colors.white),
                            ),
                    onPressed: () async {
                      final result = await provider.deleteTicketById(
                        _currentReport.id,
                        userProvider.currentUser?.username ?? "",
                      );

                      if (result) {
                        if (!context.mounted) return;
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back from detail page
                      }
                      // if (!context.mounted) return;
                      // Navigator.pop(context); // Close dialog
                      // Navigator.pop(context); // Go back from detail page
                    },
                  ),
                ],
              ),
        );
        //   },
        // );
      },
    );
  }

  void _showApprovedRejectedBottomSheet(
    BuildContext context,
    bool isApproved,
    String shift,
    UserEntity user,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  isApproved ? "Approve Report" : "Reject Report",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (!isApproved)
                  TextFormField(
                    controller: _remarkController,
                    decoration: const InputDecoration(
                      labelText: "Remarks",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final result = await context
                        .read<DailyProductionFractionationProvider>()
                        .sendApproveRejectReport(
                          user.username,
                          isApproved ? "Approved" : "Rejected",
                          user.role,
                          int.parse(shift),
                          isApproved ? null : _remarkController.text,
                          widget.item.id,
                          widget.item.plant!,
                        );

                    if (result) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isApproved
                                ? "N ${_currentReport.id} berhasil diapprove"
                                : "Number ${_currentReport.id} berhasil direject",
                          ),
                        ),
                      );
                      Navigator.of(context).pop(); // Close bottom sheet
                      Navigator.of(context).pop(); // Go back from detail page
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isApproved
                                ? "ID Transaksi ${_currentReport.id} gagal diapprove"
                                : "ID Transaksi ${_currentReport.id} gagal direject",
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    isApproved ? 'Submit Approval' : 'Submit Rejection',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
