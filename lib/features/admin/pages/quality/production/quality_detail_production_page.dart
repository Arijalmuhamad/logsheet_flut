import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/data/remote/quality_refinery/quality_refinery_entity.dart';
import 'package:logsheet_app/features/admin/pages/quality/production/quality_edit_production_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/qc/quality_edit_qc_page.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_qc_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class QualityDetailProductionPage extends StatefulWidget {
  final QualityRefineryEntity item;
  final bool isDisplayed;

  const QualityDetailProductionPage({
    super.key,
    required this.item,
    this.isDisplayed = true,
  });

  @override
  State<QualityDetailProductionPage> createState() =>
      _QualityDetailProductionPageState();
}

class _QualityDetailProductionPageState
    extends State<QualityDetailProductionPage> {
  final TextEditingController _remarkController = TextEditingController();
  late QualityRefineryEntity _currentReport;

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
              _buildDataRow("Flow Rate", _currentReport.rmFlowRate.toString()),
              _buildDataRow('Temp (°C)', _currentReport.rmTemp.toString()),
              _buildDataRow('FFA (%)', _currentReport.rmFFA.toString()),
              _buildDataRow('IV', _currentReport.rmIV.toString()),
              _buildDataRow('PV', _currentReport.rmPV.toString()),
              _buildDataRow('AV', _currentReport.rmAV.toString()),
              _buildDataRow('DOBI', _currentReport.rmDobi.toString()),
              _buildDataRow('M&I (%)', _currentReport.rmMNI.toString()),
              _buildDataRow('Totox', _currentReport.rmToTox.toString()),
              _buildDataRow('Color R', _currentReport.rmColorR.toString()),
              _buildDataRow('Color Y', _currentReport.rmColorY.toString()),
              _buildDataRow('Color B', _currentReport.rmColorB.toString()),
            ]),

            _buildSection('Bleach Oil', [
              _buildDataRow('Color R', _currentReport.boColorR.toString()),
              _buildDataRow('Color Y', _currentReport.boColorY.toString()),
              _buildDataRow('Color B', _currentReport.boColorB.toString()),
              _buildDataRow(
                'Break Test',
                _currentReport.boBreakTest.toString(),
              ),
            ]),

            _buildSection(finishedGoodsTitle, [
              _buildDataRow('FFA (%)', _currentReport.fgFFA.toString()),
              _buildDataRow('IV', _currentReport.fgIV.toString()),
              _buildDataRow('PV', _currentReport.fgPV.toString()),
              _buildDataRow('Moisture', _currentReport.fgMoisture.toString()),
              _buildDataRow(
                'Impurities',
                _currentReport.fgImpurities.toString(),
              ),
              _buildDataRow('Color R', _currentReport.fgColorR.toString()),
              _buildDataRow('Color Y', _currentReport.fgColorY.toString()),
              _buildDataRow(
                'Color B',
                _currentReport.fgColorB?.toStringAsFixed(0) ?? '-',
              ),
              _buildDataRow('Tank Destination', _currentReport.fgTankTo ?? '-'),
              _buildDataRow(
                'Tank Others Remarks',
                _currentReport.fgTankToOthersRemarks.toString(),
              ),
            ]),

            _buildSection('By-Product', [
              _buildDataRow('FFA (%)', _currentReport.bpFFA.toString()),
              _buildDataRow('M&I (%)', _currentReport.bpMNI.toString()),
              _buildDataRow('To Tank', _currentReport.bpToTank.toString()),
            ]),

            _buildSection('Waste', [
              _buildDataRow('OC', _currentReport.wSBEQC.toString()),
              _buildDataRow('M&I', _currentReport.wasteMNI.toString()),
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
                _currentReport.revisionNo.toString(),
              ),
            ]),

            if ((user?.role == 'ADM' ||
                user?.role == 'LEAD' ||
                user?.role == 'MGR'))
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
        if (_currentReport.preparedStatus == null)
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return QualityEditProductionPage(report: _currentReport);
                  },
                ),
              );

              log(result != null ? 'result has value' : 'result has no value.');

              if (result != null && result is QualityRefineryEntity) {
                setState(() {
                  _currentReport = result;
                });
              }
            },
            icon: const Icon(Icons.edit),
          ),
        // if (_currentReport.preparedStatus == null)
        //   IconButton(
        //     onPressed: () async => await _showDeleteConfirmationDialog(context),
        //     icon: const Icon(Icons.delete_rounded, color: Colors.red),
        //   ),
      ],
    );
  }

  // Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
  //   // Use showDialog which returns a Future.
  //   final bool? shouldDelete = await showDialog<bool>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Consumer<QualityReportQCProvider>(
  //         builder: (context, provider, child) {
  //           bool isLoadingDelete = provider.isLoadingDelete;
  //           return AlertDialog(
  //             title: const Text('Hapus Ticket'),
  //             content: Text(
  //               "Apakah anda yakin ingin menghapus Ticket ${_currentReport.id}?",
  //             ),
  //             actions: <Widget>[
  //               // The "Cancel" button returns false.
  //               TextButton(
  //                 child: const Text("Tidak"),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               // The "Delete" button returns true.
  //               ElevatedButton(
  //                 style: TextButton.styleFrom(foregroundColor: Colors.red),
  //                 child:
  //                     isLoadingDelete
  //                         ? SizedBox(
  //                           width: 2,
  //                           height: 2,
  //                           child: CircularProgressIndicator(
  //                             color: Colors.white,
  //                           ),
  //                         )
  //                         : Text('Ya', style: TextStyle(color: Colors.white)),
  //                 onPressed: () async {
  //                   await context
  //                       .read<QualityReportQCProvider>()
  //                       .deleteTicketById(_currentReport.id);
  //                   if (!context.mounted) return;
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );

  //   // If the user tapped "Delete", shouldDelete will be true.
  //   if (shouldDelete == true) {
  //     try {
  //       // Call your provider's delete method.
  //       if (!context.mounted) return;
  //       await context.read<QualityReportQCProvider>().deleteTicketById(
  //         _currentReport.id,
  //       );

  //       // Show a success message.
  //       if (!context.mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Report ${_currentReport.id} has been deleted.'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );

  //       // Go back to the previous screen.
  //       if (!context.mounted) return;
  //       Navigator.of(context).pop();
  //       Navigator.of(context).pop();
  //     } catch (e) {
  //       // Show an error message if something goes wrong.
  //       if (!context.mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error deleting report: $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }
}
