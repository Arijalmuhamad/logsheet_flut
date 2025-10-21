import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class MaintenanceChangeProductReportListDetailPage extends StatefulWidget {
  const MaintenanceChangeProductReportListDetailPage({super.key});

  @override
  State<MaintenanceChangeProductReportListDetailPage> createState() =>
      _MaintenanceChangeProductReportListDetailPageState();
}

class _MaintenanceChangeProductReportListDetailPageState
    extends State<MaintenanceChangeProductReportListDetailPage> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().currentUser;
    // Dummy data
    final formattedDate = '21 Oct 2025';
    final formattedTime = '14:30';
    final shift = 'Shift A';
    final company = 'PT. Example Industries';
    final plant = 'Plant 1 - Jakarta';
    final finishedGoodsTitle = 'Finished Goods ABC';
    String formatDate(DateTime? date) =>
        date != null ? '${date.day}/${date.month}/${date.year}' : '-';
    return Scaffold(
      appBar: AppBar(title: Text('Report Detail')),
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
    String _isNull(double? value) {
      if (value == null) {
        return '-';
      } else {
        return value.toString();
      }
    }

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

            _buildSection('ID', [_buildDataRow('Ticket ID', "Filled With ID")]),

            _buildSection('Company & Plant', [
              _buildDataRow('Company', company),
              _buildDataRow('Plant', plant),
            ]),
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
}
