import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/business_unit_entity.dart';
import 'package:logsheet_app/features/admin/pages/master/business_unit/add_business_unit.dart';
import 'package:logsheet_app/providers/business_unit_provider.dart';
import 'package:provider/provider.dart';

class BusinessUnitPage extends StatefulWidget {
  const BusinessUnitPage({super.key});

  @override
  State<BusinessUnitPage> createState() => _BusinessUnitPageState();
}

class _BusinessUnitPageState extends State<BusinessUnitPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>
          Provider.of<BusinessUnitProvider>(
            context,
            listen: false,
          ).fetchAllBusinessUnits(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
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

  Widget buildBody(BuildContext context) {
    return Consumer<BusinessUnitProvider>(
      builder: (context, businessUnitProvider, child) {
        if (businessUnitProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (businessUnitProvider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error: ${businessUnitProvider.errorMessage!}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (businessUnitProvider.listBusinessUnits.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tidak ada Business Unit dalam database.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: businessUnitProvider.listBusinessUnits.length,
          itemBuilder: (context, index) {
            final businessUnit = businessUnitProvider.listBusinessUnits[index];
            return Card(
              elevation: 4,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: const Icon(
                  Icons.business,
                  color: Color(0xFF6B7280),
                  size: 40,
                ),
                title: Text(
                  businessUnit.buName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF655F5B),
                  ),
                ),
                subtitle: Text(
                  'Active: ${businessUnit.isActive == 'T' ? 'Aktif' : 'Tidak Aktif'}',
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: Wrap(
                  spacing: 12,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF6B7280)),
                      onPressed: () => _editBusinessUnit(businessUnit),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFFB91C1C)),
                      onPressed: () => _deleteBusinessUnit(businessUnit.buCode),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  AppBar buildAppBar() => AppBar(title: Text("Company List"));

  void _editBusinessUnit(BusinessUnitEntity businessUnit) {
    //TODO: use the provider to edit
  }

  void _deleteBusinessUnit(String buCode) {
    //TODO: use the provider to delete
  }
}
