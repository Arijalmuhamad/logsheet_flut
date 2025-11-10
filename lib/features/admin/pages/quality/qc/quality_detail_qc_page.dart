import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/data/remote/quality/quality_refinery/quality_report_qc_entity.dart';
import 'package:logsheet_app/features/admin/pages/quality/qc/quality_edit_qc_page.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:logsheet_app/providers/quality/quality_report/quality_report_production_provider.dart';
import 'package:logsheet_app/providers/quality/quality_report/quality_report_qc_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class QualityDetailQCPage extends StatefulWidget {
  final QualityReportQcEntity item;
  final bool isDisplayed;

  const QualityDetailQCPage({
    super.key,
    required this.item,
    this.isDisplayed = true,
  });

  @override
  State<QualityDetailQCPage> createState() => _QualityDetailQCPageState();
}

class _QualityDetailQCPageState extends State<QualityDetailQCPage> {
  final TextEditingController _remarkController = TextEditingController();
  late QualityReportQcEntity _currentReport;

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
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  isApproved ? "Approve Report" : "Reject Report",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    final plantCode =
                        context.read<PlantProvider>().currentPlant?.code ?? "";
                    //ke provider
                    await context
                        .read<QualityReportQCProvider>()
                        .sendApproveRejectReport(
                          user.username,
                          isApproved ? "Approved" : "Rejected",
                          user.role,
                          int.parse(shift),
                          _remarkController.text.isNotEmpty
                              ? _remarkController.text
                              : "",
                          _currentReport.id,
                          user.role,
                          plantCode,
                        );
                    // Number (id) berhasil diapproved
                    // Number (id) berhasil direject
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isApproved
                              ? "Number ${_currentReport.id} berhasil diapprove"
                              : "Number ${_currentReport.id} berhasil direject",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.black,
                      ),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
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

  @override
  void initState() {
    super.initState();

    _currentReport = widget.item;
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => context.read<ValueProvider>().fetchOilTypes(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final fullDateTimeForShift = DateTime(
      _currentReport.postingDate!.year,
      _currentReport.postingDate!.month,
      _currentReport.postingDate!.day,
      _currentReport.time!.hour,
      _currentReport.time!.minute,
      _currentReport.time!.second,
    );
    log("$fullDateTimeForShift");
    final user = context.read<UserProvider>().currentUser;
    final finishedGoods =
        context
            .read<ValueProvider>()
            .oilTypeLists
            .where((element) => element.code == _currentReport.oilType)
            .toList();

    log("FinishedGoods list length: ${finishedGoods.length}");

    final String finishedGoodsTitle =
        finishedGoods.isNotEmpty
            ? 'Finished Goods (${finishedGoods[0].outputOilType})'
            : 'Finished Goods';
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
    String company = _currentReport.company ?? '-';
    String plant = _currentReport.plant ?? '-';

    String formatDate(DateTime? date) {
      return date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : '-';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(context),
      body: _buildBody(
        formattedDate,
        formattedTime,
        shift,
        company,
        plant,
        finishedGoodsTitle,
        formatDate,
        user,
        context,
      ),
    );
  }

  Widget _buildBody(
    String formattedDate,
    String formattedTime,
    String shift,
    String company,
    String plant,
    String finishedGoodsTitle,
    String Function(DateTime? date) formatDate,
    UserEntity? user,
    BuildContext context,
  ) {
    String isNull(double? value) {
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
                  _buildInfoCard('Tanggal', formattedDate),
                  const SizedBox(width: 8),
                  _buildInfoCard('Jam', formattedTime),
                  const SizedBox(width: 8),
                  _buildInfoCard('Shift', shift),
                ],
              ),
            ),

            _buildSection('ID', [_buildDataRow('Ticket ID', widget.item.id)]),

            _buildSection('Company & Plant', [
              _buildDataRow('Company', company),
              _buildDataRow('Plant', plant),
            ]),

            _buildSection('Raw Material', [
              _buildDataRow('Oil Type', _currentReport.oilType ?? '-'),
              _buildDataRow('Work Center', _currentReport.workCenter ?? '-'),
              _buildDataRow('Tank Source', _currentReport.rmTankSource ?? '-'),
              _buildDataRow("Flow Rate", isNull(_currentReport.rmFlowRate)),
              _buildDataRow('Temp (°C)', isNull(_currentReport.rmTemp)),
              _buildDataRow('FFA (%)', isNull(_currentReport.rmFFA)),
              _buildDataRow('IV', isNull(_currentReport.rmIV)),
              _buildDataRow('PV', isNull(_currentReport.rmPV)),
              _buildDataRow('AV', isNull(_currentReport.rmAV)),
              _buildDataRow('DOBI', isNull(_currentReport.rmDobi)),
              _buildDataRow('M&I (%)', isNull(_currentReport.rmMNI)),
              _buildDataRow('Totox', isNull(_currentReport.rmToTox)),
              _buildDataRow('Color R', isNull(_currentReport.rmColorR)),
              _buildDataRow('Color Y', isNull(_currentReport.rmColorY)),
              _buildDataRow('Color B', isNull(_currentReport.rmColorB)),
            ]),

            _buildSection('Bleach Oil', [
              _buildDataRow('Color R', isNull(_currentReport.boColorR)),
              _buildDataRow('Color Y', isNull(_currentReport.boColorY)),
              _buildDataRow('Color B', isNull(_currentReport.boColorB)),
              _buildDataRow('Break Test', _currentReport.boBreakTest ?? '-'),
            ]),

            _buildSection(finishedGoodsTitle, [
              _buildDataRow('FFA (%)', isNull(_currentReport.fgFFA)),
              _buildDataRow('IV', isNull(_currentReport.fgIV)),
              _buildDataRow('PV', isNull(_currentReport.fgPV)),
              _buildDataRow('Moisture', isNull(_currentReport.fgMoisture)),
              _buildDataRow('Impurities', isNull(_currentReport.fgImpurities)),
              _buildDataRow('Color R', isNull(_currentReport.fgColorR)),
              _buildDataRow('Color Y', isNull(_currentReport.fgColorY)),
              _buildDataRow(
                'Color B',
                _currentReport.fgColorB?.toStringAsFixed(0) ?? '-',
              ),
              _buildDataRow('Tank Destination', _currentReport.fgTankTo ?? '-'),
              _buildDataRow(
                'Tank Others Remarks',
                _currentReport.fgTankToOthersRemarks ?? '-',
              ),
            ]),

            _buildSection('By-Product', [
              _buildDataRow('FFA (%)', isNull(_currentReport.bpFFA)),
              _buildDataRow('M&I (%)', isNull(_currentReport.bpMNI)),
              _buildDataRow('To Tank', _currentReport.bpToTank ?? '-'),
            ]),

            _buildSection('Waste', [
              _buildDataRow('OC', isNull(_currentReport.wSBEQC)),
              _buildDataRow('M&I', isNull(_currentReport.wasteMNI)),
            ]),

            _buildSection('Metadata & Remarks', [
              _buildDataRow(
                'Transaction Date',
                formatDate(_currentReport.transactionDate),
              ),
              _buildDataRow(
                'Remarks',
                _currentReport.remarks != null
                    ? "${_currentReport.remarks}"
                    : "-",
              ),
            ]),

            _buildSection('Status & History', [
              _buildDataRow('Entried By', _currentReport.entryBy ?? '-'),
              _buildDataRow('Entry Date', formatDate(_currentReport.entryDate)),

              const Divider(),
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
                'Prepared Remarks',
                _currentReport.preparedStatusRemarks ?? '-',
              ),
              const Divider(),
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
                'Checked Remarks',
                _currentReport.checkedStatusRemarks ?? '-',
              ),
              const Divider(),
              _buildDataRow('Updated By', _currentReport.updatedBy ?? '-'),
              _buildDataRow(
                'Updated Date',
                formatDate(_currentReport.updatedDate),
              ),
              const Divider(),
              _buildDataRow('Form No', _currentReport.formNo ?? '-'),
              _buildDataRow(
                'Date Issued',
                formatDate(_currentReport.dateIssued),
              ),
              _buildDataRow(
                'Revision No',
                _currentReport.revisionNo == null
                    ? "-"
                    : _currentReport.revisionNo.toString(),
              ),
            ]),

            if ((user?.role == 'ADM' ||
                user?.role == 'LEAD' ||
                user?.role == 'LEAD_QC' ||
                user?.role == 'MGR' ||
                user?.role == 'MGR_QC'))
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
                              // Show modal bottom sheet
                              _showApprovedRejectedBottomSheet(
                                context,
                                false,
                                shift,
                                user!,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red[700], // Example color for Reject
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
                              // Show modal bottom sheet
                              _showApprovedRejectedBottomSheet(
                                context,
                                true,
                                shift,
                                user!,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
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

  AppBar _buildAppBar(BuildContext context) {
    UserEntity? currentUser = context.read<UserProvider>().currentUser;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        'Quality Detail',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (_currentReport.preparedStatus == null ||
            AppRoles.leadQC.contains(currentUser?.role)) ...[
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return QualityEditQCPage(report: _currentReport);
                  },
                ),
              );

              log(result != null ? 'result has value' : 'result has no value.');

              if (result != null && result is QualityReportQcEntity) {
                setState(() {
                  _currentReport = result;
                });
              }
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async => await _showDeleteConfirmationDialog(context),
            icon: const Icon(Icons.delete_rounded, color: Colors.red),
          ),
        ],
      ],
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    // Use showDialog which returns a Future.
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Consumer3<
          QualityReportQCProvider,
          QualityReportProductionProvider,
          UserProvider
        >(
          builder: (context, providerQC, providerProd, userProvider, child) {
            bool isLoadingDelete = providerQC.isLoadingDelete;
            return AlertDialog(
              title: const Text('Hapus Ticket'),
              content: Text(
                "Apakah anda yakin ingin menghapus Ticket ${_currentReport.id}?",
              ),
              actions: <Widget>[
                // The "Cancel" button returns false.
                TextButton(
                  child: const Text("Tidak"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // The "Delete" button returns true.
                ElevatedButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child:
                      isLoadingDelete
                          ? SizedBox(
                            width: 2,
                            height: 2,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : Text('Ya', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    await providerQC.deleteTicketById(
                      _currentReport.id,
                      userProvider.currentUser?.username ?? "",
                    );
                    if (!context.mounted) return;
                    await providerProd.deleteTicketById(
                      _currentReport.id,
                      userProvider.currentUser?.username ?? "",
                    );
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    // If the user tapped "Delete", shouldDelete will be true.
    // if (shouldDelete == true) {
    //   try {
    //     // Call your provider's delete method.
    //     if (!context.mounted) return;
    //     await context.read<QualityReportQCProvider>().deleteTicketById(
    //       _currentReport.id,
    //     );

    //     // Show a success message.
    //     if (!context.mounted) return;
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Report ${_currentReport.id} has been deleted.'),
    //         backgroundColor: Colors.green,
    //       ),
    //     );

    //     // Go back to the previous screen.
    //     if (!context.mounted) return;
    //     Navigator.of(context).pop();
    //     Navigator.of(context).pop();
    //   } catch (e) {
    //     // Show an error message if something goes wrong.
    //     if (!context.mounted) return;
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Error deleting report: $e'),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   }
    // }
  }
}
