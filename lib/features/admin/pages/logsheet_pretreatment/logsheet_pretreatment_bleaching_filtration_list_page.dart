import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/pages/logsheet_pretreatment/logsheet_pretreatment_bleaching_filtration_input_page.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:provider/provider.dart';

class LogsheetPretreatmentBleachingFiltrationListPage extends StatefulWidget {
  const LogsheetPretreatmentBleachingFiltrationListPage({super.key});

  @override
  State<LogsheetPretreatmentBleachingFiltrationListPage> createState() =>
      _LogsheetPretreatmentBleachingFiltrationListPageState();
}

class _LogsheetPretreatmentBleachingFiltrationListPageState
    extends State<LogsheetPretreatmentBleachingFiltrationListPage> {
  DataFormNoEntity? formQualityRefinery;
  @override
  Widget build(BuildContext context) {
    formQualityRefinery =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Logsheet_Pretreatment_Bleaching_Filtration",
            )
            .first;
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          log("Tombol tambah PBE logsheet diklik");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FiltrationPerformInputPage(),
            ),
          );
        },
        label: const Text("Tambah Quality Report"),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() =>
      AppBar(title: Text("PBF List (${formQualityRefinery?.code})"));
}
