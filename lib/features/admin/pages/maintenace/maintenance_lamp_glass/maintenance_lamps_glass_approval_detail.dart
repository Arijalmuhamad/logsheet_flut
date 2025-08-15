import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_approval_entity.dart';

class MaintenanceLampsGlassApprovalDetail extends StatelessWidget {
  final DateTime date;
  final List<LampsAndGlassApprovalEntity> checks;
  const MaintenanceLampsGlassApprovalDetail({
    super.key,
    required this.checks,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    checks.sort((a, b) => a.checkItem.compareTo(b.checkItem));
    final report = checks[0];
    return Scaffold(
      appBar: AppBar(
        // Format the date for the title, e.g., "Details for Friday, 15 August 2025"
        title: Text('Details for ${DateFormat('d MMMM yyyy').format(date)}'),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            children: [
              const SizedBox(height: 12),

              _buildInfoRow(
                context,
                icon: Icons.business_outlined,
                label: "Company",
                value: report.company,
              ),
              _buildInfoRow(
                context,
                icon: Icons.factory_outlined,
                label: "Plant",
                value: report.plant,
              ),
              _buildInfoRow(
                context,
                icon: Icons.precision_manufacturing_outlined,
                label: "Work Center",
                value: report.workCenter,
              ),
              _buildInfoRow(
                context,
                icon: Icons.calendar_today_outlined,
                label: "Check Date",
                // Formatting the date nicely!
                value: DateFormat('d MMMM yyyy').format(report.checkDate!),
              ),
              _buildInfoRow(
                context,
                icon: Icons.person_outline,
                label: "Entry By",
                value: report.entryBy,
              ),
              const SizedBox(height: 4),
              const Divider(indent: 16, endIndent: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: checks.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final item = checks[index];
                  return CheckboxListTile(
                    enabled: false,
                    value: item.statusItem == "T",
                    onChanged: (value) {},
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(item.checkItem),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
