import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:logsheet_app/providers/dry_fractionation/dry_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class DryFractionationApprovalDetailPage extends StatefulWidget {
  const DryFractionationApprovalDetailPage({
    super.key,
    required this.reportEntities,
    required this.reportIdentifier,
  });
  final List<DryFractionationEntity> reportEntities;
  final String reportIdentifier;

  @override
  State<DryFractionationApprovalDetailPage> createState() =>
      _DryFractionationApprovalDetailPageState();
}

class _DryFractionationApprovalDetailPageState
    extends State<DryFractionationApprovalDetailPage> {
  final _remarkController = TextEditingController();

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sort reports by transaction date for a consistent order
    widget.reportEntities.sort(
      (a, b) => a.transactionDate!.compareTo(b.transactionDate!),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Approve: ${widget.reportIdentifier}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: widget.reportEntities.length,
          itemBuilder: (context, index) {
            final report = widget.reportEntities[index];
            final isApproved = report.checkedStatus == "Approved";
            final isRejected = report.checkedStatus == "Rejected";
            final transactionTime =
                report.transactionDate != null
                    ? DateFormat('HH:mm').format(report.transactionDate!)
                    : 'N/A';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                title: Text('Time: $transactionTime'),
                subtitle: Text('Ticket ID: ${report.id}'),
                trailing: Icon(
                  isApproved
                      ? Icons.check_circle_rounded
                      : isRejected
                      ? Icons.cancel_rounded
                      : Icons.keyboard_arrow_right_rounded,
                  color:
                      isApproved
                          ? Colors.green
                          : isRejected
                          ? Colors.red
                          : Colors.grey,
                ),
                onTap: () {
                  final currentUser = context.read<UserProvider>().currentUser;
                  _buildBottomSheet(
                    context,
                    report,
                    currentUser?.username ?? "",
                    currentUser?.role ?? "",
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // --- Bottom Sheet for Detailed View and Actions ---
  Future<void> _buildBottomSheet(
    BuildContext context,
    DryFractionationEntity report,
    String username,
    String role,
  ) {
    // Helper functions for formatting
    String formatDate(DateTime? date) =>
        date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : '-';
    String formatTime(TimeOfDay? time) =>
        time != null
            ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
            : '-';

    final bool isActionable =
        report.checkedStatus != 'Approved' &&
        report.checkedStatus != 'Rejected';

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Report - ${report.id}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Divider(height: 24),

                  // --- General Information ---
                  _buildSectionHeader("General Information"),
                  _buildDetailRow(
                    'Transaction Date',
                    formatDate(report.transactionDate),
                  ),
                  _buildDetailRow(
                    'Posting Date',
                    formatDate(report.postingDate),
                  ),
                  _buildDetailRow('Work Center', report.workCenter ?? '-'),
                  _buildDetailRow('Shift', report.shift ?? '-'),
                  _buildDetailRow('Oil Type', report.oilType ?? '-'),

                  const Divider(),
                  _buildSectionHeader("Filling & Cooling"),
                  _buildDetailRow('Crystalizier', report.crystalizier ?? '-'),
                  _buildDetailRow(
                    'Filling Start Time',
                    formatTime(report.fillingStartTime),
                  ),
                  _buildDetailRow(
                    'Filling End Time',
                    formatTime(report.fillingEndTime),
                  ),
                  _buildDetailRow(
                    'Cooling Start Time',
                    formatTime(report.collingStartTime),
                  ),
                  _buildDetailRow(
                    'Initial Oil Level',
                    report.initialOilLevel?.toString() ?? '-',
                  ),
                  _buildDetailRow('Initial Tank', report.initialTank ?? '-'),
                  _buildDetailRow('Feed IV', report.feedIV?.toString() ?? '-'),
                  _buildDetailRow(
                    'Agitator Speed',
                    report.agitatorSpeed ?? '-',
                  ),
                  _buildDetailRow(
                    'Water Pump Press',
                    report.waterPumpPress?.toString() ?? '-',
                  ),

                  const Divider(),
                  _buildSectionHeader("Crystallization & Filtration"),
                  _buildDetailRow(
                    'Crystal Start Time',
                    formatTime(report.crystalStartTime),
                  ),
                  _buildDetailRow('Crystal Temp', report.crystalTemp ?? '-'),
                  _buildDetailRow(
                    'Filtration Start Time',
                    formatTime(report.filtrationStartTime),
                  ),
                  _buildDetailRow(
                    'Filtration Temp',
                    report.filtrationTemp ?? '-',
                  ),
                  _buildDetailRow(
                    'Filtration Cycle No',
                    report.filtrationCycleNo?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Filtration Oil Level',
                    report.filtrationOilLevel ?? '-',
                  ),

                  const Divider(),
                  _buildSectionHeader("Analysis Results"),
                  _buildDetailRow(
                    'Olein IV Red',
                    report.oleinIVRed?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Olein Cloud Point',
                    report.oleinCloudPoint?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Stearin IV',
                    report.stearinIV?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Stearin Slep Point Red',
                    report.stearinSlepPointRed?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Olein Yield',
                    report.oleinYield?.toString() ?? '-',
                  ),
                  _buildDetailRow('Remarks', report.remarks ?? '-'),

                  const Divider(),
                  _buildSectionHeader("Approval Status"),
                  _buildDetailRow(
                    'Input by',
                    '${report.entryBy ?? '-'} on ${formatDate(report.entryDate)}',
                  ),
                  _buildDetailRow(
                    'Prepared by',
                    '${report.preparedBy ?? '-'} on ${formatDate(report.preparedDate)}',
                  ),
                  _buildDetailRow(
                    'Prepared Status',
                    report.preparedStatus ?? '-',
                  ),
                  _buildDetailRow(
                    'Prepared Remarks',
                    report.preparedStatusRemarks ?? '-',
                  ),
                  _buildDetailRow(
                    'Checked by',
                    '${report.checkedBy ?? '-'} on ${formatDate(report.checkedDate)}',
                  ),
                  _buildDetailRow(
                    'Checked Status',
                    report.checkedStatus ?? '-',
                  ),
                  _buildDetailRow(
                    'Checked Remarks',
                    report.checkedStatusRemarks ?? '-',
                  ),

                  const Divider(),
                  _buildSectionHeader("Form Info"),
                  _buildDetailRow('Form No', report.formNo ?? '-'),
                  _buildDetailRow('Date Issued', formatDate(report.dateIssued)),
                  _buildDetailRow(
                    'Revision No',
                    report.revisionNo?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Revision Date',
                    formatDate(report.revisionDate),
                  ),

                  const SizedBox(height: 24),

                  if (isActionable)
                    _buildApprovalButtonRow(context, report, username, role, (
                      status,
                    ) {
                      setState(() => report.checkedStatus = status);
                    }),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Text(": "),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildApprovalButtonRow(
    BuildContext context,
    DryFractionationEntity report,
    String username,
    String role,
    Function(String) onStatusChange,
  ) {
    final provider = context.watch<DryFractionationProvider>();
    final isLoading = provider.isLoadingApproval;

    return Row(
      children: [
        // Reject Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
                isLoading
                    ? null
                    : () => _showRejectDialog(
                      context,
                      report,
                      username,
                      role,
                      onStatusChange,
                    ),
            icon: const Icon(Icons.close),
            label: const Text('Reject'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Approve Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
                isLoading
                    ? null
                    : () => _handleAction(
                      context,
                      report,
                      username,
                      role,
                      'Approved',
                      onStatusChange,
                    ),
            icon:
                provider.isLoadingApproval
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.check),
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

  void _showRejectDialog(
    BuildContext context,
    DryFractionationEntity report,
    String username,
    String role,
    Function(String) onStatusChange,
  ) {
    _remarkController.clear();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Reject Report"),
            content: TextFormField(
              controller: _remarkController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Rejection Remark",
                hintText: "Please provide a reason for rejection.",
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) =>
                      (value == null || value.trim().isEmpty)
                          ? "Remark is required"
                          : null,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_remarkController.text.trim().isNotEmpty) {
                    Navigator.pop(context); // Close dialog first
                    _handleAction(
                      context,
                      report,
                      username,
                      role,
                      'Rejected',
                      onStatusChange,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Confirm Reject"),
              ),
            ],
          ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    DryFractionationEntity report,
    String username,
    String role,
    String status,
    Function(String) onStatusChange,
  ) async {
    final provider = context.read<DryFractionationProvider>();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    try {
      final result = await provider.sendApproveRejectReport(
        username,
        status,
        role,
        _remarkController.text.isEmpty ? null : _remarkController.text,
        report.id,
        plantCode,
      );

      if (!context.mounted) return;

      if (result) {
        Navigator.of(context).pop(); // Close the bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ticket ${report.id}  di$status.'),
            backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
          ),
        );
        onStatusChange(status);
      } else if (mounted) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${provider.errorMessage}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      log("Error handling action: $e");
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
