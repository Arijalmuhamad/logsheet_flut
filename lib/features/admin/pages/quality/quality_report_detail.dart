import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_edit.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_refinery_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class QualityDetailPage extends StatefulWidget {
  final QualityReportRefineryEntity item;
  final bool isDisplayed;

  const QualityDetailPage({
    super.key,
    required this.item,
    this.isDisplayed = true,
  });

  @override
  State<QualityDetailPage> createState() => _QualityDetailPageState();
}

class _QualityDetailPageState extends State<QualityDetailPage> {
  final TextEditingController _remarkController = TextEditingController();

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
    if (hour >= 8 && hour < 16) {
      return '1';
    } else if (hour >= 16) {
      return '2';
    } else {
      return '3';
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
                        Provider.of<PlantProvider>(
                          context,
                          listen: false,
                        ).currentPlant?.code ??
                        "";
                    //ke provider
                    await Provider.of<QualityReportRefineryProvider>(
                      context,
                      listen: false,
                    ).sendApproveRejectReport(
                      user.username,
                      isApproved ? "Approved" : "Rejected",
                      user.role,
                      int.parse(shift),
                      _remarkController.text.isNotEmpty
                          ? _remarkController.text
                          : "",
                      widget.item.id,
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
                              ? "Number ${widget.item.id} berhasil diapprove"
                              : "Number ${widget.item.id} berhasil direject",
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
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    String formattedDate =
        widget.item.transactionDate != null
            ? DateFormat('dd MMMM yyyy').format(widget.item.transactionDate!)
            : '-';
    String formattedTime =
        widget.item.time != null
            ? DateFormat('HH:mm').format(widget.item.time!)
            : '-';
    String shift =
        widget.item.time != null ? _getShift(widget.item.time!) : '-';
    String company = widget.item.company ?? '-';
    String plant = widget.item.plant ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Quality Detail',
          style: TextStyle(
            color: Color(0xFF655F5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return QualityEditPage(report: widget.item);
                  },
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
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
              _buildDataRow('Oil Type', widget.item.oilType ?? '-'),
              _buildDataRow('Work Center', widget.item.workCenter ?? '-'),
              _buildDataRow('Tank Source', widget.item.rmTankSource ?? '-'),
              _buildDataRow('Temp (°C)', widget.item.rmTemp.toStringAsFixed(2)),
              _buildDataRow('FFA (%)', widget.item.rmFFA.toStringAsFixed(2)),
              _buildDataRow('IV', widget.item.rmIV.toStringAsFixed(2)),
              _buildDataRow('PV', widget.item.rmPV.toStringAsFixed(2)),
              _buildDataRow('AV', widget.item.rmAV.toStringAsFixed(2)),
              _buildDataRow('DOBI', widget.item.rmDobi.toStringAsFixed(2)),
              _buildDataRow('M&I (%)', widget.item.rmMNI.toStringAsFixed(2)),
            ]),

            _buildSection('Bleach Oil', [
              _buildDataRow('Color', widget.item.boColor ?? "-"),
              _buildDataRow('Break Test', widget.item.boColor ?? "-"),
            ]),

            _buildSection('Finished Goods (RPO)', [
              _buildDataRow('FFA (%)', widget.item.fgFFA.toStringAsFixed(2)),
              _buildDataRow('IV', widget.item.fgIV.toStringAsFixed(2)),
              _buildDataRow('PV', widget.item.fgPV.toStringAsFixed(2)),
              _buildDataRow('M&I (%)', widget.item.fgMNI.toStringAsFixed(2)),
              _buildDataRow('Color R', widget.item.fgColorR.toStringAsFixed(0)),
              _buildDataRow('Color Y', widget.item.fgColorY.toStringAsFixed(0)),
              _buildDataRow('Tank Destination', widget.item.fgTankTo ?? '-'),
            ]),

            _buildSection('By-Product (PFAD)', [
              _buildDataRow('FFA (%)', widget.item.bpFFA.toStringAsFixed(2)),
              _buildDataRow('M&I (%)', widget.item.bpMNI.toStringAsFixed(2)),
            ]),

            _buildSection('Waste', [
              _buildDataRow(
                'Spent Earth OIC',
                widget.item.wSBEQC.toStringAsFixed(2),
              ),
            ]),

            _buildSection('Metadata & Remarks', [
              _buildDataRow('Entry By', widget.item.entryBy ?? '-'),
              _buildDataRow(
                'Entry Date',
                widget.item.entryDate != null
                    ? DateFormat(
                      'yyyy-MM-dd HH:mm:ss',
                    ).format(widget.item.entryDate!)
                    : '-',
              ),
              _buildDataRow('Remarks', widget.item.remarks != "" ? "-" : "-"),
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
}
