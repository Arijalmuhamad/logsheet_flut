import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/logsheet/deodorizing_filtration_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/deodorizing_filtration/deodorizing_filtration_edit_page.dart';
import 'package:logsheet_app/providers/logsheet/deodorizing_filtration_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class DeodorizingFiltrationDetailPage extends StatefulWidget {
  final DeodorizingFiltrationEntity item;
  final bool isDisplayed;
  const DeodorizingFiltrationDetailPage({
    super.key,
    required this.item,
    required this.isDisplayed,
  });

  @override
  State<DeodorizingFiltrationDetailPage> createState() =>
      _DeodorizingFiltrationDetailPageState();
}

class _DeodorizingFiltrationDetailPageState
    extends State<DeodorizingFiltrationDetailPage> {
  late DeodorizingFiltrationEntity _currentReport;
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
            ? DateFormat('HH:mm').format(_currentReport.time!)
            : '-';
    String shift =
        _currentReport.time != null ? _getShift(fullDateTimeForShift) : '-';
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 36,
          right: 16,
          left: 16,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
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
            // Section for Ticket ID
            _buildSection('ID', [
              _buildDataRow('Ticket ID', _currentReport.id),
            ]),

            // Section for Company & Plant info
            _buildSection('Company & Plant', [
              _buildDataRow('Company', company),
              _buildDataRow('Plant', plant),
              _buildDataRow(
                'Work Center',
                _currentReport.refineryMachine ?? '-',
              ),
            ]),

            // Section for Fit 701
            _buildSection('Fit 701 (BPO) - tph', [
              _buildDataRow(
                'Fit 701 (BPO) - tph',
                _currentReport.fit701Bpo?.toString() ?? '-',
              ),
            ]),

            // Section for D701
            _buildSection('D701', [
              _buildDataRow(
                'D701 (Vacum) - cmHg',
                _currentReport.d701Vacum?.toString() ?? '-',
              ),
              _buildDataRow(
                'D701 (T D701) - c',
                _currentReport.d701Td701?.toString() ?? '-',
              ),
            ]),

            // Section for E702
            _buildSection('E702', [
              _buildDataRow('E702 - c', _currentReport.e702?.toString() ?? '-'),
            ]),

            // Section for Thermopac
            _buildSection('Thermopac', [
              _buildDataRow(
                'Thermopac - Inlet',
                _currentReport.thermopacInlet?.toString() ?? '-',
              ),
              _buildDataRow(
                'Thermopac - Outlet',
                _currentReport.thermopacOutlet?.toString() ?? '-',
              ),
            ]),

            // Section for D702
            _buildSection('D702', [
              _buildDataRow(
                'D702 - Inlet - c',
                _currentReport.d702Inlet?.toString() ?? '-',
              ),
              _buildDataRow(
                'D702 - Outlet - c',
                _currentReport.d702Outlet?.toString() ?? '-',
              ),
              _buildDataRow(
                'D702 - Vacum - mbar',
                _currentReport.d702Vacum?.toString() ?? '-',
              ),
            ]),

            // Section for Sparging
            _buildSection('Sparging', [
              _buildDataRow(
                'Sparging A - bar',
                _currentReport.spargingA?.toString() ?? '-',
              ),
              _buildDataRow(
                'Sparging B - bar',
                _currentReport.spargingB?.toString() ?? '-',
              ),
            ]),

            // Section for E 703
            _buildSection('E 703', [
              _buildDataRow(
                'E 703 Inlet - c',
                _currentReport.e730Inlet?.toString() ?? '-',
              ),
            ]),

            // NEW: Section for Steam & Pish
            _buildSection('Steam & Pish', [
              _buildDataRow(
                'Steam Inlet - bar',
                _currentReport.steamInlet?.toString() ?? '-',
              ),
              _buildDataRow(
                'Pish 706 - bar',
                _currentReport.pish706?.toString() ?? '-',
              ),
              _buildDataRow(
                'TIWH 706 - c',
                _currentReport.tiwh706?.toString() ?? '-',
              ),
            ]),

            // NEW: Section for F702
            _buildSection('F702', [
              _buildDataRow(
                'F702 A - bar',
                _currentReport.f702A?.toString() ?? '-',
              ),
              _buildDataRow(
                'F702 B - bar',
                _currentReport.f702B?.toString() ?? '-',
              ),
              _buildDataRow(
                'F702 C - bar',
                _currentReport.f702C?.toString() ?? '-',
              ),
            ]),

            // NEW: Section for FIT 704
            _buildSection('FIT 704 (RPO)', [
              _buildDataRow(
                'FIT 704 (RPO) - tph',
                _currentReport.fit704Rpo?.toString() ?? '-',
              ),
            ]),

            // NEW: Section for E704
            _buildSection('E 704', [
              _buildDataRow(
                'E 704 - c',
                _currentReport.e704?.toString() ?? '-',
              ),
            ]),

            // NEW: Section for FIT 705
            _buildSection('FIT 705 (PFAD)', [
              _buildDataRow(
                'FIT 705 (PFAD) - bar',
                _currentReport.fit705Pfad?.toString() ?? '-',
              ),
            ]),

            // NEW: Section for E705
            _buildSection('E705', [
              _buildDataRow('E705 - c', _currentReport.e705?.toString() ?? '-'),
            ]),

            // NEW: Section for Clarity
            _buildSection('Clarity', [
              _buildDataRow('Clarity', _currentReport.clarity ?? '-'),
            ]),

            // NEW: Section for Remarks
            _buildSection('Remarks', [
              _buildDataRow('Remarks', _currentReport.remarks ?? '-'),
            ]),

            // NEW: Section for Approval Status
            _buildSection('Approval Status', [
              _buildDataRow('Entered by', _currentReport.entryBy ?? '-'),
              _buildDataRow(
                'Entry Date',
                _formatNullableDateTime(_currentReport.entryDate),
              ),
              _buildDataRow('Prepared by', _currentReport.preparedBy ?? '-'),
              _buildDataRow(
                'Prepared Date',
                _formatNullableDateTime(_currentReport.preparedDate),
              ),
              _buildDataRow('Checked by', _currentReport.checkedBy ?? '-'),
              _buildDataRow(
                'Checked Date',
                _formatNullableDateTime(_currentReport.checkedDate),
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
                      context.read<DeodorizingFiltrationProvider>();

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

  AppBar _buildAppBar(BuildContext context) {
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
                    return DeodorizingFiltrationEditPage(logsheet: widget.item);
                  },
                ),
              );

              log(result != null ? 'result has value' : 'result has no value.');

              if (result != null && result is DeodorizingFiltrationEntity) {
                setState(() {
                  _currentReport = result;
                });
              }
            },
            icon: const Icon(Icons.edit),
          ),

        if (_currentReport.preparedStatus == null)
          IconButton(
            onPressed: _showDeleteConfirmationDialog,
            icon: Icon(Icons.delete_rounded, color: Colors.red),
          ),
        SizedBox(width: 12),
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

  Future<void> _showDeleteConfirmationDialog() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isLoading =
                context.watch<DeodorizingFiltrationProvider>().isLoadingDelete;

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
                                  .read<DeodorizingFiltrationProvider>()
                                  .deleteTicketById(_currentReport.id);
                              if (!context.mounted) return;
                              final user = context.read<UserProvider>();
                              final plant = context.read<PlantProvider>();

                              await context
                                  .read<DeodorizingFiltrationProvider>()
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
