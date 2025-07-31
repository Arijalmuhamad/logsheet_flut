import 'package:flutter/material.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_data.dart';

class QualityDetailPage extends StatelessWidget {
  final QualityReportRefineryEntity item;

  const QualityDetailPage({super.key, required this.item});

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFAB2F2B),
        borderRadius: BorderRadius.circular(20),
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
                fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                  Expanded(
                    flex: 2,
                    child: _buildInfoCard('Tanggal', item.entryDate.toString()),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: _buildInfoCard(
                      'Jam',
                      item.time == null
                          ? "${item.time}"
                          : item.time!.toIso8601String(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(flex: 1, child: _buildInfoCard('Shift', "null")),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: _buildInfoCard(
                      'Tank',
                      item.pTankSource?.toStringAsFixed(1) ?? '-',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildSection('Product', [
              _buildDataRow('Part', item.pCat ?? '-'),
              _buildDataRow(
                'Flowrate',
                item.pFlowRate?.toStringAsFixed(2) ?? '-',
              ),
              _buildDataRow('FFA', item.pFFA?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('IV', item.pIV?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('PV', item.pPV?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('AnV', item.pANV?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('DOBI', item.pDobi?.toStringAsFixed(2) ?? '-'),
              _buildDataRow(
                'Carotene',
                item.pCarotene?.toStringAsFixed(2) ?? '-',
              ),
              _buildDataRow('M & I', item.pMNI?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('Color', item.pColor ?? '-'),
            ]),

            _buildSection('Chemical', [
              _buildDataRow('Category', item.cCat ?? '-'),
              _buildDataRow('PA', item.cPA?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('BE', item.cBE?.toStringAsFixed(2) ?? '-'),
            ]),

            _buildSection('BPO', [
              _buildDataRow('Category', item.bCat ?? '-'),
              _buildDataRow('Color R', item.bColorR?.toString() ?? '-'),
              _buildDataRow('Color Y', item.bColorY?.toString() ?? '-'),
              _buildDataRow('Break Test', item.bBreakTest ?? '-'),
            ]),

            _buildSection('RPO', [
              _buildDataRow('Category', item.rCat?.toString() ?? '-'),
              _buildDataRow(
                'FFA',
                item.rFFA is num ? (item.rFFA as num).toStringAsFixed(2) : '-',
              ),
              _buildDataRow(
                'Color R',
                item.rColorR is num
                    ? (item.rColorR as num).toStringAsFixed(2)
                    : '-',
              ),
              _buildDataRow(
                'Color Y',
                item.rColorY is num
                    ? (item.rColorY as num).toStringAsFixed(2)
                    : '-',
              ),
              _buildDataRow(
                'Color B',
                item.rColorB is num
                    ? (item.rColorB as num).toStringAsFixed(2)
                    : '-',
              ),
              _buildDataRow(
                'PV',
                item.rPV is num ? (item.rPV as num).toStringAsFixed(2) : '-',
              ),
              _buildDataRow(
                'M & I',
                item.rMNI is num ? (item.rMNI as num).toStringAsFixed(2) : '-',
              ),
              _buildDataRow('Tank No', item.rProductTankNo?.toString() ?? '-'),
            ]),

            _buildSection('FRAD', [
              _buildDataRow('Category', item.fpCat?.toString() ?? '-'),
              _buildDataRow(
                'Purity',
                item.fpPurity is num
                    ? (item.fpPurity as num).toStringAsFixed(2)
                    : '-',
              ),
              _buildDataRow(
                'Tank No',
                item.fpProductTankNumber?.toString() ?? '-',
              ),
            ]),

            _buildSection('Spent Earth', [
              _buildDataRow(
                'Spent Earth OIC',
                item.spentEarthOIC?.toString() ?? '-',
              ),
            ]),

            _buildSection('PIC & Remarks', [
              _buildDataRow('PIC', item.pic ?? '-'),
              _buildDataRow('Remark', item.remarks ?? '-'),
            ]),
          ],
        ),
      ),
    );
  }
}
