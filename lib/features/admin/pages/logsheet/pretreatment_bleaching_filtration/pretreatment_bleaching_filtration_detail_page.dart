import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/data/remote/logsheet/pretreatment_bleaching_filtration_entity.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/pretreatment_bleaching_filtration/pretreatment_bleaching_filtration_edit_page.dart';
import 'package:logsheet_app/providers/logsheet/pretreatment_bleaching_filtration_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class LogsheetPretreatmentBleachingFiltrationDetailPage extends StatefulWidget {
  final PretreatmentBleachingFiltrationEntity item;
  final bool isDisplayed;
  const LogsheetPretreatmentBleachingFiltrationDetailPage({
    super.key,
    required this.item,
    required this.isDisplayed,
  });

  @override
  State<LogsheetPretreatmentBleachingFiltrationDetailPage> createState() =>
      _LogsheetPretreatmentBleachingFiltrationDetailPageState();
}

class _LogsheetPretreatmentBleachingFiltrationDetailPageState
    extends State<LogsheetPretreatmentBleachingFiltrationDetailPage> {
  late PretreatmentBleachingFiltrationEntity _currentReport;
  final TextEditingController _remarkController = TextEditingController();
  String _formatNullableDateTime(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('dd MMMM yyyy, HH:mm').format(dt);
  }

  /// Helper function to format a nullable DateTime object into a date-only string.
  /// If the date is null, it returns a dash.
  String _formatNullableDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('dd MMMM yyyy').format(dt);
  }

  @override
  void initState() {
    super.initState();
    _currentReport = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    String company = widget.item.company ?? '-';
    String plant = widget.item.plant ?? '-';
    final user = context.watch<UserProvider>().currentUser;
    final fullDateTimeForShift = DateTime(
      _currentReport.postingDate!.year,
      _currentReport.postingDate!.month,
      _currentReport.postingDate!.day,
      _currentReport.time!.hour,
      _currentReport.time!.minute,
      _currentReport.time!.second,
    );
    log("$fullDateTimeForShift");
    String formattedDate =
        _currentReport.transactionDate != null
            ? DateFormat('dd MMMM yyyy').format(fullDateTimeForShift)
            : '-';
    String formattedTime =
        _currentReport.time != null
            ? DateFormat('HH:mm').format(widget.item.time!)
            : '-';
    String shift =
        _currentReport.time != null ? _getShift(fullDateTimeForShift) : '-';
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(
        formattedDate,
        formattedTime,
        shift,
        company,
        plant,
        user,
        context,
      ),
    );
  }

  SingleChildScrollView _buildBody(
    String formattedDate,
    String formattedTime,
    String shift,
    String company,
    String plant,
    UserEntity? user,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 36, right: 16, left: 16),
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
                _buildInfoCard('Tanggal', formattedDate),
                const SizedBox(width: 8),
                _buildInfoCard('Jam', formattedTime),
                const SizedBox(width: 8),
                _buildInfoCard('Shift', shift),
              ],
            ),
          ),
          _buildSection('ID', [_buildDataRow('Ticket ID', _currentReport.id)]),
          _buildSection('Company & Plant', [
            _buildDataRow('Company', company),
            _buildDataRow('Plant', plant),
            _buildDataRow('Plant', _currentReport.plant ?? '-'),
            _buildDataRow('Work Center', _currentReport.refineryMachine ?? '-'),
          ]),

          // Section for Pre-Treatment data
          _buildSection('Pre-Treatment', [
            _buildDataRow(
              'Fit 001 (CPO) - Tph',
              _currentReport.ptFit001?.toString() ?? '-',
            ),
            _buildDataRow(
              'E001A Inlet (CPO) - °C',
              _currentReport.ptE001aInlet?.toString() ?? '-',
            ),
            _buildDataRow(
              'F001/2 Str - bar',
              _currentReport.ptF0012?.toString() ?? '-',
            ),
            _buildDataRow(
              'H3PO4 - % (Dosing)',
              _currentReport.ptH3po4?.toString() ?? '-',
            ),
            _buildDataRow(
              'BE - % (Dosing)',
              _currentReport.ptBe?.toString() ?? '-',
            ),
          ]),

          // Section for Bleaching data
          _buildSection('Bleaching', [
            _buildDataRow(
              'Vacuum - mmHg',
              _currentReport.blVacum?.toString() ?? '-',
            ),
            _buildDataRow(
              'T-Inlet - °C',
              _currentReport.blTInlet?.toString() ?? '-',
            ),
            _buildDataRow(
              'T B602 - °C',
              _currentReport.blTB602?.toString() ?? '-',
            ),
            _buildDataRow(
              'Spurge - Bar',
              _currentReport.blSpurge?.toString() ?? '-',
            ),
          ]),

          // Section for Pump P602 data
          _buildSection('Pump P602', [
            _buildDataRow('Pump A - Bar', _currentReport.pA?.toString() ?? '-'),
            _buildDataRow('Pump B - Bar', _currentReport.pB?.toString() ?? '-'),
            _buildDataRow('Pump C - Bar', _currentReport.pC?.toString() ?? '-'),
          ]),

          // Section for Niagara Filter data
          _buildSection('Niagara Filter', [
            _buildDataRow(
              'Filter 601 - Bar',
              _currentReport.fnF601?.toString() ?? '-',
            ),
            _buildDataRow(
              'Filter 602 - Bar',
              _currentReport.fnF602?.toString() ?? '-',
            ),
            _buildDataRow(
              'Filter 603 - Bar',
              _currentReport.fnF603?.toString() ?? '-',
            ),
          ]),

          // Section for Bag Filter data
          _buildSection('Bag Filter', [
            _buildDataRow(
              'Filter 604A - Bar',
              _currentReport.fb604a?.toString() ?? '-',
            ),
            _buildDataRow(
              'Filter 604B - Bar',
              _currentReport.fb604b?.toString() ?? '-',
            ),
            _buildDataRow(
              'Filter 604C - Bar',
              _currentReport.fb604c?.toString() ?? '-',
            ),
          ]),

          // Section for Cartridge Filter data
          _buildSection('Cartridge Filter', [
            _buildDataRow(
              'Filter 605A - Bar',
              _currentReport.fc605a?.toString() ?? '-',
            ),
            _buildDataRow(
              'Filter 605B - Bar',
              _currentReport.fc605b?.toString() ?? '-',
            ),
          ]),

          // Section for quality and remarks
          _buildSection('Clarity & Remarks', [
            _buildDataRow('Clarity', _currentReport.clarity ?? '-'),
            _buildDataRow('Remarks', _currentReport.remarks ?? '-'),
          ]),

          // Section for data entry details
          _buildSection('Entry Details', [
            _buildDataRow('Entry By', _currentReport.entryBy ?? '-'),
            _buildDataRow(
              'Entry Date',
              _formatNullableDateTime(_currentReport.entryDate),
            ),
            _buildDataRow(
              'Transaction Date',
              _formatNullableDateTime(_currentReport.transactionDate),
            ),
          ]),

          // Section for approval status
          _buildSection('Status & History', [
            _buildDataRow('Entried By', _currentReport.entryBy ?? '-'),
            _buildDataRow(
              'Entry Date',
              _formatNullableDateTime(_currentReport.entryDate),
            ),

            const Divider(),
            _buildDataRow('Prepared By', _currentReport.preparedBy ?? '-'),
            _buildDataRow(
              'Prepared Date',
              _formatNullableDateTime(_currentReport.preparedDate),
            ),
            _buildDataRow(
              'Prepared Status',
              _currentReport.preparedStatus ?? '-',
            ),
            _buildDataRow(
              'Prepared Remarks',
              _currentReport.preparedStatusRemarks ?? '-',
            ),
            const Divider(height: 24, color: Colors.black12),
            _buildDataRow('Checked By', _currentReport.checkedBy ?? '-'),
            _buildDataRow(
              'Checked Date',
              _formatNullableDateTime(_currentReport.checkedDate),
            ),
            _buildDataRow(
              'Checked Status',
              _currentReport.checkedStatus ?? '-',
            ),
            _buildDataRow(
              'Checked Remarks',
              _currentReport.checkedStatusRemarks ?? '-',
            ),
            const Divider(),
            _buildDataRow('Updated By', _currentReport.updatedBy ?? '-'),
            _buildDataRow(
              'Updated Date',
              _formatNullableDateTime(_currentReport.updatedDate),
            ),
          ]),

          // Section for form information
          _buildSection('Form Information', [
            _buildDataRow('Form No', _currentReport.formNo ?? '-'),
            _buildDataRow(
              'Date Issued',
              _formatNullableDate(_currentReport.dateIssued),
            ),
            _buildDataRow(
              'Revision No',
              _currentReport.revisionNo?.toString() ?? '-',
            ),
            _buildDataRow(
              'Revision Date',
              _formatNullableDate(_currentReport.revisionDate),
            ),
          ]),
          // Approval Buttons Section
          if (user?.role == 'LEAD' ||
              user?.role == 'MGR' ||
              user?.role == 'ADM')
            if (widget.isDisplayed && _currentReport.preparedStatus == null)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed:
                              () => _showApprovalBottomSheet(
                                context,
                                false,
                                shift,
                                user!,
                              ),
                          icon: const Icon(Icons.close),
                          label: Text("Reject Shift $shift"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed:
                              () => _showApprovalBottomSheet(
                                context,
                                true,
                                shift,
                                user!,
                              ),
                          icon: const Icon(Icons.check),
                          label: Text("Approve Shift $shift"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  void _showApprovalBottomSheet(
    BuildContext context,
    bool isApproved,
    String shift,
    UserEntity user,
  ) {
    // Clear remark controller before showing
    _remarkController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                isApproved ? "Approve Logsheet" : "Reject Logsheet",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (!isApproved)
                TextFormField(
                  controller: _remarkController,
                  decoration: const InputDecoration(
                    labelText: "Remarks (Wajib diisi untuk reject)",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isApproved ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  if (!isApproved && _remarkController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Remark wajib diisi untuk me-reject.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  final plantCode =
                      context.read<PlantProvider>().currentPlant?.code ?? "";
                  final provider =
                      context.read<PretreatmentBleachingFiltrationProvider>();

                  try {
                    await provider.sendApproveRejectReport(
                      user.username,
                      isApproved ? "Approved" : "Rejected",
                      user.role,
                      int.parse(shift),
                      _remarkController.text.isNotEmpty
                          ? _remarkController.text
                          : null,
                      _currentReport.id,
                      user.role, // Level
                      plantCode,
                    );

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Logsheet ${_currentReport.id} berhasil di-${isApproved ? 'approve' : 'reject'}",
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Pop bottom sheet and then detail page
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(
                  isApproved ? 'Submit Approval' : 'Submit Rejection',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        "Ticket Detail",
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (widget.item.preparedStatus == null)
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return LogsheetPretreatmentBleachingFiltrationEditPage(
                      logsheet: widget.item,
                    );
                  },
                ),
              );
              log(result != null ? 'result has value' : 'result has no value.');

              if (result != null &&
                  result is PretreatmentBleachingFiltrationEntity) {
                setState(() {
                  _currentReport = result;
                });
              }
            },

            icon: const Icon(Icons.edit),
          ),

        if (widget.item.preparedStatus == null)
          IconButton(
            onPressed: _showDeleteConfirmationDialog,
            icon: Icon(Icons.delete_rounded),
          ),
      ],
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

  String _getShift(DateTime time) {
    int hour = time.hour;
    int day = time.weekday;
    log("Day: $day, Hour: $hour");

    if (day >= DateTime.friday) {
      if (hour >= 8 && hour < 20) {
        return '4';
      } else {
        return '5';
      }
    } else {
      if (hour >= 8 && hour <= 15) {
        return '1';
      } else if (hour >= 16 && hour <= 23) {
        return '2';
      } else {
        return '3';
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isLoading =
                context
                    .watch<PretreatmentBleachingFiltrationProvider>()
                    .isLoadingDelete;

            return AlertDialog(
              title: const Text('Hapus Ticket'),
              content: Text(
                "Apakah anda yakin ingin menghapus Ticket ${_currentReport.id}?",
              ),
              actions: <Widget>[
                TextButton(
                  // Disable the "Tidak" button while loading.
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text("Tidak"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  // 1. Disable the button when loading to prevent multiple taps.
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            try {
                              await context
                                  .read<
                                    PretreatmentBleachingFiltrationProvider
                                  >()
                                  .deleteTicketById(_currentReport.id);
                              if (!context.mounted) return;
                              final user = context.read<UserProvider>();
                              final plant = context.read<PlantProvider>();

                              await context
                                  .read<
                                    PretreatmentBleachingFiltrationProvider
                                  >()
                                  .fetchAllTicket(
                                    null,
                                    null,
                                    user.currentUser!.username,
                                    user.currentUser!.role,
                                    plant.currentPlant!.code,
                                  );

                              if (!context.mounted) return;
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Ticket ${_currentReport.id} Terhapus.',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              if (!context.mounted) return;
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error deleting report: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                  // Conditionally show the loader or the text.
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                          : const Text('Ya'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
