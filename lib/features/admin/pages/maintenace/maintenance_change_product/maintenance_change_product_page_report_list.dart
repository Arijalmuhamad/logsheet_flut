import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';

class MaintenanceChangeProductPageReportlist extends StatefulWidget {
  const MaintenanceChangeProductPageReportlist({super.key});

  @override
  State<MaintenanceChangeProductPageReportlist> createState() =>
      _MaintenanceChangeProductPageReportlistState();
}

class _MaintenanceChangeProductPageReportlistState
    extends State<MaintenanceChangeProductPageReportlist> {
  final TextEditingController dateEntryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: Text(
        'Quality Report List',
        style: TextStyle(
          color: Color(0xFF655F5B),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () {})],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildFilterSection(context),
        Expanded(child: Card(child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView(
            children: [ 
              _changeProductsCardItem(),
              _changeProductsCardItem(),
              _changeProductsCardItem(),
               _changeProductsCardItem(),
              _changeProductsCardItem(),
              _changeProductsCardItem(),
               _changeProductsCardItem(),
              _changeProductsCardItem(),
              _changeProductsCardItem(),
            ]),
        ))),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomDateField(
              controller: dateEntryController,
              label: 'Tanggal',
              icon: Icons.event,
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                // _fetchReports();
              });
            },
            icon: const Icon(Icons.search),
            label: const Text('Cari'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAB2F2B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _changeProductsCardItem(){
    return Card(
      child: ListTile(
        title: Text("Product A"),
        subtitle: Text("Changed on 01-01-2024"),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Handle tap event
        },
      ),
    );
  }
}
