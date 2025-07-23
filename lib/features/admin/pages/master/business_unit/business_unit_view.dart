import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/pages/master/business_unit/add_business_unit.dart';

class MasterCompany extends StatelessWidget {
  const MasterCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Company List")),
      body: Center(child: Text("List of Companies")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          log("Tombol tambah Company diklik");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MasterAddCompany()),
          );
        },
        label: const Text("Tambah Company"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }
}
