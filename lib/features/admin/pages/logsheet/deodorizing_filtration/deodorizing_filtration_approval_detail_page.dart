import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/logsheet/deodorizing_filtration_entity.dart';
import 'package:logsheet_app/providers/logsheet/deodorizing_filtration_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class DeodorizingFiltrationApprovalDetailPage extends StatefulWidget {
  const DeodorizingFiltrationApprovalDetailPage({
    super.key,
    required this.reportEntities,
    required this.reportIdentifier,
  });
  final List<DeodorizingFiltrationEntity> reportEntities;
  final String reportIdentifier;

  @override
  State<DeodorizingFiltrationApprovalDetailPage> createState() =>
      DeodorizingFiltrationApprovalDetailPageState();
}

class DeodorizingFiltrationApprovalDetailPageState
    extends State<DeodorizingFiltrationApprovalDetailPage> {
  final _remarkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    log(widget.reportIdentifier);
    final Map<int?, List<DeodorizingFiltrationEntity>> groupedByShift = {};

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
                    ? 'Status: Beberapa report direject.'
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
                                  '${report.time != null ? '${report.time!.hour}:00' : 'N/A'} - ',
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
                              'Work Center: ${report.refineryMachine} | Plant: ${report.plant} \n',
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
          ],
        ),
      ),
    );
  }

  Future<dynamic> _buildBottomSheet(
    BuildContext context,
    DeodorizingFiltrationEntity report,
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
      return date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : '-';
    }

    String formatDouble(double? value) {
      return value != null ? value.toString() : '-';
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
                  _buildDetailRow('Work Center', report.refineryMachine ?? '-'),
                  _buildDetailRow('Company', report.company ?? '-'),

                  const Divider(),

                  _buildDetailRow('Ticket ID', report.id),
                  _buildDetailRow(
                    'Tanggal Transaksi',
                    formatDate(report.transactionDate),
                  ),
                  _buildDetailRow(
                    'Tanggal Posting',
                    formatDate(report.postingDate),
                  ),
                  _buildDetailRow('Shift', report.shift?.toString() ?? '-'),
                  _buildDetailRow(
                    'Jam',
                    report.time != null
                        ? DateFormat('HH:mm').format(report.time!)
                        : '-',
                  ),
                  _buildDetailRow('Work Center', report.refineryMachine ?? '-'),
                  _buildDetailRow('Plant', report.plant ?? '-'),
                  const SizedBox(height: 16),

                  _buildDetailRow(
                    'FIT 701 (BPO) - tph',
                    report.fit701?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'D701 (Vacum) - cmHg',
                    report.d701Vacum?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'D701 (T D701) - °C',
                    report.d701Td701?.toString() ?? '-',
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow('E702 - °C', report.e702?.toString() ?? '-'),
                  _buildDetailRow(
                    'Thermopac - Inlet',
                    report.thermopacInlet?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Thermopac - Outlet',
                    report.thermopacOutlet?.toString() ?? '-',
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow(
                    'D702 - Inlet - °C',
                    report.d702Inlet?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'D702 - Outlet - °C',
                    report.d702Outlet?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'D702 - Vacum - mbar',
                    report.d702Vacum?.toString() ?? '-',
                  ),
                  _buildDetailRow('Sparging A - bar', report.spargingA ?? '-'),
                  _buildDetailRow('Sparging B - bar', report.spargingB ?? '-'),
                  const SizedBox(height: 16),

                  _buildDetailRow('E 730 Inlet - °C', report.e730Inlet ?? '-'),
                  _buildDetailRow(
                    'Steam Inlet - bar',
                    report.steamInlet ?? '-',
                  ),
                  _buildDetailRow('Pish 706 - bar', report.pish706 ?? '-'),
                  _buildDetailRow('TIWH 706 - °C', report.tiwh706 ?? '-'),
                  const SizedBox(height: 16),

                  _buildDetailRow(
                    'F702 A - bar',
                    report.f702A?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'F702 B - bar',
                    report.f702B?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'F702 C - bar',
                    report.f702C?.toString() ?? '-',
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow(
                    'FIT 704 (RPO) - tph',
                    report.fit704?.toString() ?? '-',
                  ),
                  _buildDetailRow('E 704 - °C', report.e704?.toString() ?? '-'),
                  _buildDetailRow(
                    'FIT 705 (PFAD) - bar',
                    report.fit705?.toString() ?? '-',
                  ),
                  _buildDetailRow('E705 - °C', report.e705?.toString() ?? '-'),
                  _buildDetailRow('Clarity', report.clarity ?? '-'),
                  _buildDetailRow('Remarks', report.remarks ?? '-'),

                  const SizedBox(height: 16),

                  // Section: Signatories
                  _buildDetailRow(
                    'Diinput oleh',
                    '${report.entryBy ?? '-'} pada ${formatDate(report.entryDate)}',
                  ),
                  _buildDetailRow(
                    'Disiapkan oleh',
                    '${report.preparedBy ?? '-'} pada ${formatDate(report.preparedDate)}',
                  ),
                  _buildDetailRow(
                    'Status (Prepared)',
                    report.preparedStatus ?? '-',
                  ),
                  _buildDetailRow(
                    'Remarks (Prepared)',
                    report.preparedStatusRemarks ?? '-',
                  ),
                  _buildDetailRow(
                    'Diperiksa oleh',
                    '${report.checkedBy ?? '-'} pada ${formatDate(report.checkedDate)}',
                  ),
                  _buildDetailRow(
                    'Status (Checked)',
                    report.checkedStatus ?? '-',
                  ),
                  _buildDetailRow(
                    'Diupdate oleh',
                    '${report.updatedBy ?? '-'} pada ${formatDate(report.updatedDate)}',
                  ),

                  _buildDetailRow(
                    'Remark (Checked)',
                    report.checkedStatusRemarks ?? '-',
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow('Form No', report.formNo ?? '-'),
                  _buildDetailRow('Date Issued', formatDate(report.dateIssued)),
                  _buildDetailRow('Revision No', report.revisionNo.toString()),
                  _buildDetailRow(
                    'Revision Date',
                    formatDate(report.revisionDate),
                  ),
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
    DeodorizingFiltrationEntity report,
    String username,
    String role,
    Function(String) onStatusChange,
  ) {
    return Row(
      children: [
        Expanded(
          child: Consumer<DeodorizingFiltrationProvider>(
            builder: (context, provider, child) {
              return ElevatedButton.icon(
                onPressed:
                    provider.isLoading
                        ? null
                        : () async {
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
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                          ),
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
                                                onPressed: () async {
                                                  await _handleAction(
                                                    context,
                                                    report,
                                                    username,
                                                    role,
                                                    'Rejected',
                                                    onStatusChange,
                                                  );

                                                  if (!context.mounted) return;
                                                  Navigator.pop(context);
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
                        },
                icon: const Icon(Icons.close),
                label: const Text('Reject'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Consumer<DeodorizingFiltrationProvider>(
            builder: (context, provider, child) {
              return ElevatedButton.icon(
                onPressed:
                    provider.isLoading
                        ? null
                        : () async {
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
                icon:
                    provider.isLoading
                        ? SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(),
                        )
                        : Icon(Icons.check),
                label: const Text('Approve'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    DeodorizingFiltrationEntity report,
    String username,
    String role,
    String status,
    Function(String) onStatusChange,
  ) async {
    final provider = context.read<DeodorizingFiltrationProvider>();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    log("STATUS: $status");

    try {
      final result = await provider.sendApproveRejectReport(
        username,
        status,
        role,
        report.shift!,
        _remarkController.text == "" ? null : _remarkController.text,
        report.id,
        role,
        plantCode,
      );

      if (result) {
        if (!context.mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ticket ${report.id} berhasil di$status.'),
            backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
            duration: Duration(milliseconds: 500),
          ),
        );
        // Call the callback to update the UI
        onStatusChange(status);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${provider.errorMessage}'),
            backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      log("Error updating ticket: $e");
      if (!context.mounted) return;
      // Show an error message if the API call fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal Approve/Reject: $e'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
