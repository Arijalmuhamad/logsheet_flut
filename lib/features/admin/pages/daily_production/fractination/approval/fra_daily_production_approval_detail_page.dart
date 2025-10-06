import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/providers/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionFractionationApprovalDetailPage extends StatefulWidget {
  const DailyProductionFractionationApprovalDetailPage({
    super.key,
    required this.reportEntities,
    required this.reportIdentifier,
  });
  final List<DailyProductionFractionationEntity> reportEntities;
  final String reportIdentifier;

  @override
  State<DailyProductionFractionationApprovalDetailPage> createState() =>
      _DailyProductionFractionationApprovalDetailPageState();
}

class _DailyProductionFractionationApprovalDetailPageState
    extends State<DailyProductionFractionationApprovalDetailPage> {
  final _remarkController = TextEditingController();

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Group reports by shift
    final Map<String?, List<DailyProductionFractionationEntity>>
    groupedByShift = {};
    for (var report in widget.reportEntities) {
      groupedByShift.putIfAbsent(report.shift, () => []).add(report);
    }
    final sortedShifts =
        groupedByShift.keys.toList()..sort((a, b) => a!.compareTo(b!));

    return Scaffold(
      appBar: AppBar(title: Text('Approve: ${widget.reportIdentifier}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: sortedShifts.length,
          itemBuilder: (context, index) {
            final shiftNumber = sortedShifts[index];
            final entitiesForShift = groupedByShift[shiftNumber]!;

            // Sort reports within a shift by transaction date
            entitiesForShift.sort(
              (a, b) => a.transactionDate!.compareTo(b.transactionDate!),
            );

            return ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                'Shift $shiftNumber',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children:
                  entitiesForShift.map((report) {
                    final isApproved = report.checkedStatus == "Approved";
                    final isRejected = report.checkedStatus == "Rejected";
                    final transactionTime =
                        report.transactionDate != null
                            ? DateFormat(
                              'HH:mm',
                            ).format(report.transactionDate!)
                            : 'N/A';

                    return ListTile(
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
    );
  }

  // --- Bottom Sheet for Detailed View and Actions ---
  Future<void> _buildBottomSheet(
    BuildContext context,
    DailyProductionFractionationEntity report,
    String username,
    String role,
  ) {
    // Helper to format dates or return a default string
    String formatDate(DateTime? date) =>
        date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : '-';
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
                  const Divider(),

                  // --- Raw Material (RM) ---
                  _buildSectionHeader("Raw Material"),
                  _buildDetailRow('Oil Type', report.oilTypeRm ?? '-'),
                  _buildDetailRow(
                    'From Tank',
                    report.oilTypeRmFromTank?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Start Time',
                    report.oilTypeRmAwalJam != null
                        ? "${report.oilTypeRmAwalJam!.hour}: ${report.oilTypeRmAwalJam!.minute}"
                        : '-',
                  ),
                  _buildDetailRow(
                    'Start Flowmeter',
                    report.oilTypeRmAwalFlowmeter?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'End Time',
                    report.oilTypeRmAkhirJam != null
                        ? "${report.oilTypeRmAkhirJam!.hour}: ${report.oilTypeRmAkhirJam!.minute}"
                        : '-',
                  ),
                  _buildDetailRow(
                    'End Flowmeter',
                    report.oilTypeRmAkhirFlowmeter?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Total',
                    report.oilTypeRmTotal?.toString() ?? '-',
                  ),
                  const Divider(),

                  // --- Finished Goods (FG) ---
                  _buildSectionHeader("Finished Goods"),
                  _buildDetailRow('Oil Type', report.oilTypeFgs ?? '-'),
                  _buildDetailRow(
                    'Start Time',
                    report.oilTypeFgsAwalJam != null
                        ? "${report.oilTypeFgsAwalJam!.hour}: ${report.oilTypeFgsAwalJam!.minute}"
                        : '-',
                  ),
                  _buildDetailRow(
                    'Start Flowmeter',
                    report.oilTypeFgsAwalFlowmeter?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'End Time',
                    report.oilTypeFgsAkhirJam != null
                        ? "${report.oilTypeFgsAkhirJam!.hour}: ${report.oilTypeFgsAkhirJam!.minute}"
                        : '-',
                  ),
                  _buildDetailRow(
                    'End Flowmeter',
                    report.oilTypeFgsAkhirFlowmeter?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Total',
                    report.oilTypeFgsTotal?.toString() ?? '-',
                  ),
                  _buildDetailRow('To Tank', report.oilTypeFgsToTank ?? '-'),
                  const Divider(),

                  // --- By Product (BP) ---
                  _buildSectionHeader("By Product"),
                  _buildDetailRow(
                    'Start Time',
                    report.oilTypeFghAwalJam != null
                        ? "${report.oilTypeFghAwalJam!.hour}: ${report.oilTypeFghAwalJam!.minute}"
                        : '-',
                  ),
                  _buildDetailRow(
                    'Start Flowmeter',
                    report.oilTypeFghAwalFlowmeter?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'End Time',
                    report.oilTypeFghAkhirJam != null
                        ? "${report.oilTypeFghAkhirJam!.hour}: ${report.oilTypeFghAkhirJam!.minute}"
                        : '-',
                  ),
                  _buildDetailRow(
                    'End Flowmeter',
                    report.oilTypeFghAkhirFlowmeter?.toString() ?? '-',
                  ),
                  _buildDetailRow(
                    'Total',
                    report.oilTypeFghTotal?.toString() ?? '-',
                  ),
                  _buildDetailRow('To Tank', report.oilTypeFghToTank ?? '-'),
                  const Divider(),

                  // --- Signatories & Status ---
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
    DailyProductionFractionationEntity report,
    String username,
    String role,
    Function(String) onStatusChange,
  ) {
    return Row(
      children: [
        // Reject Button
        Expanded(
          child: Consumer<DailyProductionFractionationProvider>(
            builder:
                (context, provider, child) => ElevatedButton.icon(
                  onPressed:
                      provider.isLoading
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
        ),
        const SizedBox(width: 16),
        // Approve Button
        Expanded(
          child: Consumer<DailyProductionFractionationProvider>(
            builder:
                (context, provider, child) => ElevatedButton.icon(
                  onPressed:
                      provider.isLoading
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
                      provider.isLoading
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
        ),
      ],
    );
  }

  void _showRejectDialog(
    BuildContext context,
    DailyProductionFractionationEntity report,
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
    DailyProductionFractionationEntity report,
    String username,
    String role,
    String status,
    Function(String) onStatusChange,
  ) async {
    final provider = context.read<DailyProductionFractionationProvider>();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    final shiftNumber = int.tryParse(report.shift ?? '');
    if (shiftNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid shift number.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final result = await provider.sendApproveRejectReport(
        username,
        status,
        role,
        shiftNumber,
        _remarkController.text.isEmpty ? null : _remarkController.text,
        report.id,
        plantCode,
      );

      if (result && context.mounted) {
        Navigator.of(context).pop(); // Close the bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ticket ${report.id} has been successfully updated to $status.',
            ),
            backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
        onStatusChange(status); // Update UI in the list
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed: ${provider.errorMessage ?? "Unknown error"}',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      log("Error handling action: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
