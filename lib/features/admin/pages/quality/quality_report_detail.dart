import 'package:flutter/material.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_data.dart';

class QualityDetailPage extends StatelessWidget {
  final TQualityReportRefineryData item;

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
                    child: _buildInfoCard('Tanggal', item.tanggal),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: _buildInfoCard(
                      'Jam',
                      item.time?.substring(0, 5) ?? '-',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(flex: 1, child: _buildInfoCard('Shift', item.shift)),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: _buildInfoCard(
                      'Tank',
                      item.p_tank_source?.toStringAsFixed(1) ?? '-',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildSection('Product', [
              _buildDataRow('Part', item.p_cat ?? '-'),
              _buildDataRow(
                'Flowrate',
                item.p_flowrate?.toStringAsFixed(2) ?? '-',
              ),
              _buildDataRow('FFA', item.p_ffa?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('IV', item.p_iv?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('PV', item.p_pv?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('AnV', item.p_anv?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('DOBI', item.p_dobi?.toStringAsFixed(2) ?? '-'),
              _buildDataRow(
                'Carotene',
                item.p_carotene?.toStringAsFixed(2) ?? '-',
              ),
              _buildDataRow('M & I', item.p_m_i?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('Color', item.p_color ?? '-'),
            ]),

            _buildSection('Chemical', [
              _buildDataRow('Category', item.c_cat ?? '-'),
              _buildDataRow('PA', item.c_pa?.toStringAsFixed(2) ?? '-'),
              _buildDataRow('BE', item.c_be?.toStringAsFixed(2) ?? '-'),
            ]),

            _buildSection('BPO', [
              _buildDataRow('Category', item.b_cat ?? '-'),
              _buildDataRow('Color R', item.b_color_r?.toString() ?? '-'),
              _buildDataRow('Color Y', item.b_color_y?.toString() ?? '-'),
              _buildDataRow('Break Test', item.b_break_test ?? '-'),
            ]),

            _buildSection('RPO', [
              _buildDataRow('Category', item.r_cat?.toString() ?? '-'),
              _buildDataRow(
                'FFA',
                item.r_ffa is num
                    ? (item.r_ffa as num).toStringAsFixed(2)
                    : '-',
              ),
              _buildDataRow(
                'Color R',
                item.r_color_r is num
                    ? (item.r_color_r as num).toStringAsFixed(2)
                    : '-',
              ),
              _buildDataRow(
                'Color Y',
                item.r_color_y is num
                    ? (item.r_color_y as num).toStringAsFixed(2)
                    : '-',
              ),
              _buildDataRow(
                'Color B',
                item.r_color_b is num
                    ? (item.r_color_b as num).toStringAsFixed(2)
                    : '-',
              ),
              _buildDataRow(
                'PV',
                item.r_pv is num ? (item.r_pv as num).toStringAsFixed(2) : '-',
              ),
              _buildDataRow(
                'M & I',
                item.r_m_i is num
                    ? (item.r_m_i as num).toStringAsFixed(2)
                    : '-',
              ),
              _buildDataRow(
                'Tank No',
                item.r_product_tank_no?.toString() ?? '-',
              ),
            ]),

            _buildSection('FRAD', [
              _buildDataRow('Category', item.fp_cat?.toString() ?? '-'),
              _buildDataRow(
                'Purity',
                item.fp_purity is num
                    ? (item.fp_purity as num).toStringAsFixed(2)
                    : '-',
              ),
              _buildDataRow(
                'Tank No',
                item.fp_product_tank_no?.toString() ?? '-',
              ),
            ]),

            _buildSection('Spent Earth', [
              _buildDataRow(
                'Spent Earth OIC',
                item.spent_earth_oic?.toString() ?? '-',
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
