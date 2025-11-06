import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_quality_refinery_500_mt_production/daily_quality_refinery_500_mt_production_input_page.dart';

class DailyQualityRefinery500MtProductionListPage extends StatefulWidget {
  const DailyQualityRefinery500MtProductionListPage({super.key});

  @override
  State<DailyQualityRefinery500MtProductionListPage> createState() =>
      _DailyQualityRefinery500MtProductionListPageState();
}

class _DailyQualityRefinery500MtProductionListPageState
    extends State<DailyQualityRefinery500MtProductionListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [Center(child: Text('text'))]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => DailyQualityRefinery500MtProductionInputPage(),
            ),
          );
        },
        label: const Text("Tambah Change Product"),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  
}
