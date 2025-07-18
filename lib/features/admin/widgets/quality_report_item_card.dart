import 'package:flutter/material.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_data.dart';

class QualityReportItemCard extends StatelessWidget {
  final TQualityReportRefineryData report;
  final int index;

  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const QualityReportItemCard({
    super.key,
    required this.report,
    required this.index,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final report = this.report;

    return SizedBox(
      width: double.infinity,
      // height: 155,
      child: InkWell(
        onTap: () {
          var snackBar = SnackBar(
            content: Text('${report.tanggal}, ${report.time}'),
          );

          onTap();

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 8,
              top: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${report.tanggal}, ${report.time}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        this.report.checked_by != null
                            ? 'Checked'
                            : (this.report.approved_by != null
                                ? 'Approved'
                                : 'Pending'),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.opacity, size: 14, color: Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        'Tank ${report.p_tank_source} - ${report.p_cat ?? ''}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.person, size: 14, color: Colors.black),
                      Text(
                        report.entry_by ?? 'N/A',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 35,
                      child: TextButton.icon(
                        onPressed: () => onEdit,
                        label: const Text('Edit'),
                        icon: const Icon(Icons.edit, size: 16),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: TextButton.icon(
                        onPressed: () => onDelete,
                        label: const Text('Delete'),
                        icon: const Icon(Icons.delete, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
