import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_daily_production_edit_page.dart';
import 'package:logsheet_app/providers/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionRefineryDetailPage extends StatefulWidget {
  final DailyProductionRefineryEntity item;
  final DataFormNoEntity dataForm;
  final bool isDisplayed;

  const DailyProductionRefineryDetailPage({
    super.key,
    required this.item,
    this.isDisplayed = true,
    required this.dataForm,
  });

  @override
  State<DailyProductionRefineryDetailPage> createState() =>
      _DailyProductionRefineryDetailPageState();
}

class _DailyProductionRefineryDetailPageState
    extends State<DailyProductionRefineryDetailPage> {
  final TextEditingController _remarkController = TextEditingController();
  late DailyProductionRefineryEntity _currentReport;

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
        'Refinery Detail',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (_currentReport.preparedStatus == null)
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => RefDailyProductionEditPage(
                        entity: _currentReport,
                        dataForm: widget.dataForm,
                      ),
                ),
              );
              if (result != null && result is DailyProductionRefineryEntity) {
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
                    'Machine',
                    _displayValue(_currentReport.refineryMachine),
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
              _buildDataRow('CPO Tank', _displayValue(_currentReport.cpoTank)),
            ]),

            _buildSection('Raw Material (RM)', [
              _buildDataRow(
                'Oil Type',
                _displayValue(_currentReport.oilTypeRm),
              ),
              _buildDataRow(
                'Awal Jam',
                _displayValue(_currentReport.oilTypeRmAwalJam),
              ),
              _buildDataRow(
                'Awal Flowmeter',
                _displayValue(_currentReport.oilTypeRmAwalFlowmeter),
              ),
              _buildDataRow(
                'Akhir Jam',
                _displayValue(_currentReport.oilTypeRmAkhirJam),
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
                _displayValue(_currentReport.oilTypeFg),
              ),
              _buildDataRow(
                'Awal Jam',
                _displayValue(_currentReport.oilTypeFgAwalJam),
              ),
              _buildDataRow(
                'Awal Flowmeter',
                _displayValue(_currentReport.oilTypeFgAwalFlowmeter),
              ),
              _buildDataRow(
                'Akhir Jam',
                _displayValue(_currentReport.oilTypeFgAkhirJam),
              ),
              _buildDataRow(
                'Akhir Flowmeter',
                _displayValue(_currentReport.oilTypeFgAkhirFlowmeter),
              ),
              _buildDataRow(
                'Total',
                _displayValue(_currentReport.oilTypeFgTotal),
              ),
              _buildDataRow(
                'To Tank',
                _displayValue(_currentReport.oilTypeFgToTank),
              ),
            ]),

            _buildSection('By-Product (BP) / PFAD', [
              _buildDataRow(
                'Awal Jam',
                _displayValue(_currentReport.bpAwalJam),
              ),
              _buildDataRow(
                'Awal Flowmeter',
                _displayValue(_currentReport.bpAwalFlowmeter),
              ),
              _buildDataRow(
                'Akhir Jam',
                _displayValue(_currentReport.bpAkhirJam),
              ),
              _buildDataRow(
                'Akhir Flowmeter',
                _displayValue(_currentReport.bpAkhirFlowmeter),
              ),
              _buildDataRow('Total', _displayValue(_currentReport.bpTotal)),
              _buildDataRow('To Tank', _displayValue(_currentReport.bpToTank)),
            ]),

            _buildSection('Bleaching Earth (BE)', [
              _buildDataRow(
                'Ref. Tank',
                _displayValue(_currentReport.beRefTank),
              ),
              _buildDataRow('Ref. Qty', _displayValue(_currentReport.beRefQty)),
              _buildDataRow(
                'Total Bag',
                _displayValue(_currentReport.beTotalBag),
              ),
              _buildDataRow(
                'Total Jenis',
                _displayValue(_currentReport.beTotalJenis),
              ),
              _buildDataRow(
                'Lot Batch Number',
                _displayValue(_currentReport.beLotBatchNumber),
              ),
              _buildDataRow(
                'Yield (%)',
                _displayValue(_currentReport.beYieldPercent),
              ),
            ]),

            _buildSection('Phosphoric Acid (PA)', [
              _buildDataRow(
                'Ref. Tank',
                _displayValue(_currentReport.paRefTank),
              ),
              _buildDataRow('Ref. Qty', _displayValue(_currentReport.paRefQty)),
              _buildDataRow('Total', _displayValue(_currentReport.paTotal)),
              _buildDataRow(
                'Lot Batch Number',
                _displayValue(_currentReport.paLotBatchNumber),
              ),
              _buildDataRow(
                'Yield (%)',
                _displayValue(_currentReport.paYieldPercent),
              ),
            ]),

            _buildSection('Utility Usage (UU)', [
              _buildDataRow('Item', _displayValue(_currentReport.uuItem)),
              _buildDataRow(
                'Budget Ref Tank',
                _displayValue(_currentReport.uuBudgetRefTank),
              ),
              _buildDataRow(
                'Budget Qty',
                _displayValue(_currentReport.uuBudgetQty),
              ),
              _buildDataRow(
                'Total CPO',
                _displayValue(_currentReport.uuTotalCpo),
              ),
              _buildDataRow(
                'Total Steam',
                _displayValue(_currentReport.uuTotalSteam),
              ),
              _buildDataRow(
                'Steam / CPO',
                _displayValue(_currentReport.uuSteamCpo),
              ),
              _buildDataRow(
                'Yield (%)',
                _displayValue(_currentReport.uuYieldPercent),
              ),
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
            if ((user?.role == 'ADM' ||
                user?.role == 'LEAD' ||
                user?.role == 'LEAD_QC'))
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
        // TODO: 4. Use a Consumer for your production provider
        // return Consumer<DailyProductionRefineryProvider>(
        //   builder: (context, provider, child) {
        //     bool isLoadingDelete = provider.isLoadingDelete;
        return Consumer2<DailyProductionRefineryProvider, UserProvider>(
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
                    // TODO: 6. Call the approve/reject method from your provider
                    // await context.read<DailyProductionRefineryProvider>()
                    //      .sendApproveRejectReport(...);

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isApproved
                              ? "Number ${_currentReport.id} berhasil diapprove"
                              : "Number ${_currentReport.id} berhasil direject",
                        ),
                      ),
                    );
                    Navigator.of(context).pop(); // Close bottom sheet
                    Navigator.of(context).pop(); // Go back from detail page
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
