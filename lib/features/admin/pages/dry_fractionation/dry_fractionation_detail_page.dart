import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/time_of_day_to_string.dart';
import 'package:logsheet_app/core/utils/to_string.dart';
import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/features/admin/pages/dry_fractionation/dry_fractionation_edit_page.dart';
import 'package:logsheet_app/providers/dry_fractionation/dry_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class DryFractionationDetailPage extends StatefulWidget {
  const DryFractionationDetailPage({
    super.key,
    required this.item,
    required this.isDisplayed,
  });
  final DryFractionationEntity item;
  final bool isDisplayed;

  @override
  State<DryFractionationDetailPage> createState() =>
      _DryFractionationDetailPageState();
}

class _DryFractionationDetailPageState
    extends State<DryFractionationDetailPage> {
  late DryFractionationEntity _currentReport;

  final TextEditingController _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentReport = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    String formattedDate =
        _currentReport.postingDate != null
            ? DateFormat('dd MMMM yyyy').format(_currentReport.postingDate!)
            : '-';

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(
        formattedDate: formattedDate,
        user: user,
        context: context,
      ),
    );
  }

  SingleChildScrollView _buildBody({
    required String formattedDate,
    required UserEntity? user,
    required BuildContext context,
  }) {
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
                _buildInfoCard('Shift', _currentReport.shift ?? '-  '),
                _buildInfoCard('Oil', _currentReport.oilType ?? '-'),
                _buildInfoCard(
                  'Work Center',
                  _currentReport.workCenter ?? '-  ',
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),

          _buildSection('ID', [_buildDataRow('Ticket ID', _currentReport.id)]),

          _buildSection('Dry Fractionation', [
            _buildDataRow('Crystallizier', _currentReport.crystalizier ?? '-'),
            _buildDataRow(
              'Filling Start Time',
              displayTime(_currentReport.fillingStartTime),
            ),
            _buildDataRow(
              'Filling End Time',
              displayTime(_currentReport.fillingEndTime),
            ),
            _buildDataRow(
              'Cooling Start Time',
              displayTime(_currentReport.collingStartTime),
            ),
            _buildDataRow(
              'Initial Oil Level',
              formatDouble(_currentReport.initialOilLevel),
            ),
            _buildDataRow('Initial Tank', _currentReport.initialTank ?? '-'),
            _buildDataRow('Feed IV', formatDouble(_currentReport.feedIV)),
            _buildDataRow(
              'Agitator Speed',
              _currentReport.agitatorSpeed ?? '-',
            ),
            _buildDataRow(
              'Water Pump Pressure',
              formatDouble(_currentReport.waterPumpPress),
            ),

            _buildDataRow(
              'Crystal Start Time',
              displayTime(_currentReport.crystalStartTime),
            ),
            _buildDataRow(
              'Crystal Temperature',
              _currentReport.crystalTemp ?? '-',
            ),
            _buildDataRow(
              'Filtration Start Time',
              displayTime(_currentReport.filtrationStartTime),
            ),
            _buildDataRow(
              'Filtration Temperature',
              _currentReport.filtrationTemp ?? '-',
            ),
            _buildDataRow(
              'Filtration Cycle No.',
              formatInt(_currentReport.filtrationCycleNo),
            ),
            _buildDataRow(
              'Filtration Oil Level',
              _currentReport.filtrationOilLevel ?? '-',
            ),
            _buildDataRow(
              'Olein IV Red',
              formatDouble(_currentReport.oleinIVRed),
            ),
            _buildDataRow(
              'Olein Cloud Point',
              formatDouble(_currentReport.oleinCloudPoint),
            ),
            _buildDataRow('Stearin IV', formatDouble(_currentReport.stearinIV)),
            _buildDataRow(
              'Stearin Slep Point Red',
              formatDouble(_currentReport.stearinSlepPointRed),
            ),
            _buildDataRow(
              'Olein Yield (%)',
              formatDouble(_currentReport.oleinYield),
            ),
          ]),

          _buildSection('Remarks', [
            _buildDataRow('Remarks', _currentReport.remarks ?? '-'),
          ]),

          _buildSection('Entry Details', [
            _buildDataRow('Entry By', _currentReport.entryBy ?? '-'),
            _buildDataRow('Entry Date', formatDate(_currentReport.entryDate)),
          ]),

          _buildSection('Status & History', [
            _buildDataRow('Prepared By', _currentReport.preparedBy ?? '-'),
            _buildDataRow(
              'Prepared Date',
              formatDate(_currentReport.preparedDate),
            ),
            _buildDataRow(
              'Prepared Status',
              _currentReport.preparedStatus ?? '-',
            ),
            _buildDataRow(
              'Prepared Status Remarks',
              _currentReport.preparedStatusRemarks ?? '-',
            ),
            _buildDataRow('Checked By', _currentReport.checkedBy ?? '-'),
            _buildDataRow(
              'Checked Date',
              formatDate(_currentReport.checkedDate),
            ),
            _buildDataRow(
              'Checked Status',
              _currentReport.checkedStatus ?? '-',
            ),
            _buildDataRow(
              'Checked Status Remarks',
              _currentReport.checkedStatusRemarks ?? '-',
            ),
            _buildDataRow('Updated By', _currentReport.updatedBy ?? '-'),
            _buildDataRow(
              'Updated Date',
              formatDate(_currentReport.updatedDate),
            ),
          ]),

          _buildSection('Form Information', [
            _buildDataRow('Form No.', _currentReport.formNo ?? '-'),
            _buildDataRow('Date Issued', formatDate(_currentReport.dateIssued)),
            _buildDataRow('Revision No.', formatInt(_currentReport.revisionNo)),
            _buildDataRow(
              'Revision Date',
              formatDate(_currentReport.revisionDate),
            ),
          ]),

          if (AppRoles.leadProd.contains(user?.role) ||
              AppRoles.admin.contains(user?.role))
            if (widget.isDisplayed &&
                _currentReport.preparedStatus == null) ...[
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
                                user!,
                              ),
                          icon: const Icon(Icons.close),
                          label: Text("Reject Ticket"),
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
                                user!,
                              ),
                          icon: const Icon(Icons.check),
                          label: Text("Approve Ticket"),
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
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
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
                    return DryFractionationEditPage(entity: _currentReport);
                  },
                ),
              );
              log(result != null ? 'result has value' : 'result has no value.');

              if (result != null && result is DryFractionationEntity) {
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
            icon: Icon(Icons.delete_rounded, color: Colors.red),
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
            width: 150,
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
                context.watch<DryFractionationProvider>().isLoadingDelete;

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
                              final user = context.read<UserProvider>();
                              final plant = context.read<PlantProvider>();
                              await context
                                  .read<DryFractionationProvider>()
                                  .deleteTicketById(
                                    _currentReport.id,
                                    user.currentUser?.username ?? "",
                                  );

                              if (!context.mounted) return;
                              await context
                                  .read<DryFractionationProvider>()
                                  .fetchAllTickets(
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

  void _showApprovalBottomSheet(
    BuildContext context,
    bool isApproved,
    UserEntity user,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
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
                  final provider = context.read<DryFractionationProvider>();

                  try {
                    await provider.sendApproveRejectReport(
                      user.username,
                      isApproved ? "Approved" : "Rejected",
                      user.role,
                      _remarkController.text.isNotEmpty
                          ? _remarkController.text
                          : null,
                      _currentReport.id,
                      plantCode,
                    );

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Ticket ${_currentReport.id} berhasil di-${isApproved ? 'approve' : 'reject'}",
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
}
