import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/quality_refinery/quality_refinery_entity.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_qc_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class QualityApprovalDetailQCScreen extends StatefulWidget {
  final List<QualityRefineryEntity> reportEntities;
  final String reportIdentifier;

  const QualityApprovalDetailQCScreen({
    super.key,
    required this.reportEntities,
    required this.reportIdentifier,
  });

  @override
  State<QualityApprovalDetailQCScreen> createState() =>
      _QualityApprovalDetailQCScreenState();
}

class _QualityApprovalDetailQCScreenState
    extends State<QualityApprovalDetailQCScreen> {
  final _remarkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // The detail screen is now only accessible if the report is complete.
    // The validation logic has been moved to the list screen.
    // final provider = Provider.of<QualityReportRefineryProvider>(
    //   context,
    //   listen: false,
    // );
    log(widget.reportIdentifier);
    // Group the entities by shift to display them
    final Map<int?, List<QualityRefineryEntity>> groupedByShift = {};
    for (var report in widget.reportEntities) {
      if (!groupedByShift.containsKey(report.shift)) {
        groupedByShift[report.shift] = [];
      }
      groupedByShift[report.shift]!.add(report);
    }

    final sortedShifts = groupedByShift.keys.toList()..sort();

    final allTilesAreApproved = widget.reportEntities.every(
      (report) => report.checkedStatus == 'Approved',
    );
    final anyTilesAreRejected = widget.reportEntities.every(
      (report) => report.checkedStatus == 'Rejected',
    );

    return Scaffold(
      appBar: AppBar(title: Text('Report: ${widget.reportIdentifier}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              color: allTilesAreApproved ? Colors.green[100] : Colors.blue[100],
              child: Text(
                allTilesAreApproved
                    ? 'Status: Semua Shift telah diapproved.'
                    : anyTilesAreRejected
                    ? "Status: Beberapa report direject."
                    : 'Status: Semua shift siap diapprove.',
                style: TextStyle(
                  color:
                      allTilesAreApproved
                          ? Colors.green[800]
                          : anyTilesAreRejected
                          ? Colors.red[800]
                          : Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: sortedShifts.length,
                itemBuilder: (context, shiftIndex) {
                  final shiftNumber = sortedShifts[shiftIndex];
                  final entitiesForShift = groupedByShift[shiftNumber]!;
                  return ExpansionTile(
                    title: Text('Shift $shiftNumber (8 jam)'),
                    children:
                        entitiesForShift.map((report) {
                          final isApproved = report.checkedStatus == "Approved";
                          final isRejected = report.checkedStatus == "Rejected";

                          IconData trailingIcon;
                          Color iconColor;
                          if (isApproved) {
                            trailingIcon = Icons.check_rounded;
                            iconColor = Colors.green;
                          } else if (isRejected) {
                            trailingIcon = Icons.close_rounded;
                            iconColor = Colors.red;
                          } else {
                            trailingIcon = Icons.arrow_forward_ios;
                            iconColor = Colors.grey;
                          }

                          return ListTile(
                            title: Row(
                              children: [
                                const Icon(Icons.schedule_rounded),
                                Text(
                                  ' ${report.time != null ? '${report.time!.hour}:00' : 'N/A'} - ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  report.id,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'Work Center: ${report.workCenter} | Plant: ${report.plant}\n'
                              'Tank Source: ${report.rmTankSource} | To Tank: ${report.fgTankTo}\n Oil Type: ${report.oilType}',
                            ),
                            trailing: Icon(trailingIcon, color: iconColor),
                            onTap: () {
                              final currentUser =
                                  context.read<UserProvider>().currentUser;
                              _buildBottomSheet(
                                context,
                                report,
                                currentUser?.username ?? "",
                                currentUser?.role ?? "",
                              );
                            },
                          );
                        }).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // The approval button is always enabled here because we only reach this screen if validation passes.
            // Row(
            //   children: [
            //     Expanded(
            //       child: SizedBox(
            //         height: 70,
            //         child: ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor:
            //                 allTilesAreApproved ? Colors.red[800] : Colors.grey,
            //           ),
            //           onPressed:
            //               allTilesAreApproved
            //                   ? () {
            //                     // You would implement a provider method here to approve all entities
            //                     // for the given date.
            //                     // Example:
            //                     // provider.approveReportsByDate(reportIdentifier, reportEntities);
            //                     Navigator.of(context).pop();
            //                   }
            //                   : null,

            //           child: const Text('Approve All Hours'),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _buildBottomSheet(
    BuildContext context,
    QualityRefineryEntity report,
    String username,
    String role,
  ) {
    Color getStatusColor(String? status) {
      if (status == 'Approved') {
        return Colors.green;
      }
      if (status == 'Rejected') return Colors.red;
      if (status == 'Prepared') {
        return Colors.blue;
      }
      return Colors.grey;
    }

    String getStatusText(String? status) {
      if (status == 'Approved') return 'Approved';
      if (status == 'Rejected') return 'Rejected';
      if (status == 'Prepared') return 'Prepared';
      return 'Submitted';
    }

    // Helper to format dates or return a default string
    String formatDate(DateTime? date) {
      return date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : 'N/A';
    }

    final isApproved = report.checkedStatus == 'Approved';
    final isRejected = report.checkedStatus == 'Rejected';
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(25)),
      ),
      builder:
          (context) => Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Detail Report - ${report.time != null ? DateFormat('HH:mm').format(report.time!) : 'N/A'}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(report.checkedStatus),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          getStatusText(report.checkedStatus),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //
                  const Divider(height: 24),
                  _buildDetailRow(
                    'Tanggal Transaksi',
                    report.transactionDate.toString(),
                  ),
                  _buildDetailRow(
                    'Tanggal Posting',
                    report.postingDate.toString(),
                  ),
                  _buildDetailRow('Shift', report.shift.toString()),
                  const Divider(),
                  _buildDetailRow('Ticket ID', report.id),
                  _buildDetailRow('Work Center', report.workCenter ?? 'N/A'),
                  _buildDetailRow('Oil Type', report.oilType ?? 'N/A'),
                  const Divider(),
                  _buildDetailRow('Flow Rate', report.rmFlowRate.toString()),
                  _buildDetailRow('RM Temp', report.rmTemp.toString()),
                  _buildDetailRow('RM FFA', report.rmFFA.toString()),
                  _buildDetailRow('RM IV', report.rmIV.toString()),
                  _buildDetailRow('RM PV', report.rmPV.toString()),
                  _buildDetailRow('RM Dobi', report.rmDobi.toString()),
                  _buildDetailRow('RM M&I', report.rmMNI.toString()),
                  _buildDetailRow('RM Totox', report.rmToTox.toString()),
                  _buildDetailRow('RM Color R', report.rmColorR.toString()),
                  _buildDetailRow('RM Color Y', report.rmColorY.toString()),
                  _buildDetailRow('RM Color B', report.rmColorB.toString()),
                  const Divider(),
                  _buildDetailRow('Bo Color R', report.boColorR.toString()),
                  _buildDetailRow('Bo Color Y', report.boColorY.toString()),
                  _buildDetailRow('Bo Color B', report.boColorB.toString()),
                  _buildDetailRow('Bo Break Test', report.boBreakTest ?? 'N/A'),
                  const Divider(),
                  _buildDetailRow('FG FFA', report.fgFFA.toString()),
                  _buildDetailRow('FG IV', report.fgIV.toString()),
                  _buildDetailRow('FG PV', report.fgPV.toString()),
                  _buildDetailRow('FG Moisture', report.fgMoisture.toString()),
                  _buildDetailRow(
                    'FG Impurities',
                    report.fgImpurities.toString(),
                  ),
                  _buildDetailRow('FG Color R', report.fgColorR.toString()),
                  _buildDetailRow('FG Color Y', report.fgColorY.toString()),
                  _buildDetailRow('FG Tank To', report.fgTankTo ?? 'N/A'),
                  _buildDetailRow(
                    'FG Tank Others Remarks',
                    report.fgTankToOthersRemarks ?? 'N/A',
                  ),
                  const Divider(),
                  _buildDetailRow('BP FFA', report.bpFFA.toString()),
                  _buildDetailRow('BP M&I', report.bpMNI.toString()),
                  _buildDetailRow('BP To Tank', report.bpToTank.toString()),
                  _buildDetailRow('OC', report.wSBEQC.toString()),
                  _buildDetailRow('Waste M&I', report.wasteMNI.toString()),
                  const Divider(),
                  _buildDetailRow('Remarks', report.remarks ?? 'N/A'),
                  _buildDetailRow('Entry By', report.entryBy ?? 'N/A'),
                  _buildDetailRow('Entry Date', formatDate(report.entryDate)),
                  const Divider(),
                  _buildDetailRow('Prepared By', report.preparedBy ?? 'N/A'),
                  _buildDetailRow(
                    'Prepared Status',
                    report.preparedStatus ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Prepared Status Remarks',
                    report.preparedStatusRemarks ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Prepared Date',
                    formatDate(report.preparedDate),
                  ),
                  const Divider(),
                  _buildDetailRow('Checked By', report.checkedBy ?? 'N/A'),
                  _buildDetailRow(
                    'Checked Status',
                    report.checkedStatus ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Checked Status Remarks',
                    report.checkedStatusRemarks ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Checked Date',
                    formatDate(report.checkedDate),
                  ),
                  const Divider(),
                  _buildDetailRow('Updated By', report.updatedBy ?? 'N/A'),
                  _buildDetailRow(
                    'Updated Date',
                    formatDate(report.updatedDate),
                  ),
                  const Divider(),
                  _buildDetailRow('Form No', report.formNo ?? 'N/A'),
                  _buildDetailRow('Date Issued', formatDate(report.dateIssued)),
                  _buildDetailRow('Revision No', report.revisionNo.toString()),
                  const SizedBox(height: 24),
                  if (!isApproved && !isRejected)
                    _buildApprovalButtonRow(context, report, username, role, (
                      status,
                    ) {
                      // Update the state of the individual item
                      setState(() {
                        report.checkedStatus = status;
                      });
                    }),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildApprovalButtonRow(
    BuildContext context,
    QualityRefineryEntity report,
    String username,
    String role,
    Function(String) onStatusChange,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              return showModalBottomSheet(
                context: context,
                builder:
                    (context) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _remarkController,
                            maxLines: 7,
                            decoration: InputDecoration(
                              labelText: "Remark untuk Reject",
                              labelStyle: const TextStyle(
                                color: Color(0xFF655F5B),
                                fontWeight: FontWeight.w500,
                              ),
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 14),
                          if (_remarkController.text.trim() == "")
                            Text(
                              "Mohon isi remark.",
                              style: TextStyle(color: Colors.red),
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 55,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        _remarkController.text.trim() == ""
                                            ? null
                                            : () async {
                                              await _handleAction(
                                                context,
                                                report,
                                                username,
                                                role,
                                                'Rejected',
                                                onStatusChange,
                                              );
                                            },
                                    icon: const Icon(Icons.close),
                                    label: const Text('Reject'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
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
              // Handle Reject logic
              // await _handleAction(
              //   context,
              //   report,
              //   username,
              //   role,
              //   'Rejected'
              //   onStatusChange,
              // );
            },
            icon: const Icon(Icons.close),
            label: const Text('Reject'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              // Handle Approve logic
              await _handleAction(
                context,
                report,
                username,
                role,
                'Approved',
                onStatusChange,
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Approve'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    QualityRefineryEntity report,
    String username,
    String role,
    String status,
    Function(String) onStatusChange,
  ) async {
    final provider = context.read<QualityReportQCProvider>();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    await provider.sendApproveRejectReport(
      username,
      status,
      role,
      report.shift!,
      _remarkController.text == "" ? null : _remarkController.text,
      report.id,
      role,
      plantCode,
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report ${report.id} berhasil di$status.'),
        backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
        duration: Duration(milliseconds: 500),
      ),
    );

    // Call the callback to update the UI
    onStatusChange(status);

    Navigator.of(context).pop(); // Dismiss the bottom sheet
  }
}
