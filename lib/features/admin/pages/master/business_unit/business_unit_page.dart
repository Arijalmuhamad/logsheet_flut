import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/business_unit_entity.dart';
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
          log("Tombol tambah Business Unit diklik");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBusinessUnit()),
          );
        },
        label: const Text(
          "Tambah Business Unit",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Consumer<BusinessUnitProvider>(
      builder: (context, businessUnitProvider, child) {
        if (businessUnitProvider.isLoading) {
          return Center(child: const CircularProgressIndicator());
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
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: businessUnitProvider.listBusinessUnits.length,
          itemBuilder: (context, index) {
            final businessUnit = businessUnitProvider.listBusinessUnits[index];
            return Card(
              elevation: 4,
              color: Theme.of(context).cardTheme.color,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha(25),
                  radius: 24,
                  child: Icon(
                    Icons.business,
                    color: Theme.of(context).colorScheme.primary.withAlpha(200),
                    size: 36,
                  ),
                ),
                title: Text(
                  businessUnit.buName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF655F5B),
                  ),
                ),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                      child:
                          businessUnit.isActive == 'T'
                              ? Icon(
                                Icons.check_circle_rounded,
                                size: 17,
                                color: Colors.green,
                              )
                              : Icon(
                                Icons.cancel_rounded,
                                size: 17,
                                color: Theme.of(context).colorScheme.error,
                              ),
                    ),
                    Text(
                      businessUnit.isActive == 'T' ? 'Aktif' : 'Tidak Aktif',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                trailing: Wrap(
                  spacing: 12,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF6B7280)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AddBusinessUnit(
                                  editingBusinessUnit: businessUnit,
                                ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () async {
                        log('Icon delete diklik');

                        bool? confirmDelete = await showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text('Hapus ${businessUnit.buName}?'),
                                content: Text(
                                  'Apakah anda yakin ingin menghapus ${businessUnit.buName}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text("Ya"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text(
                                      "Tidak",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                        );
                        if (confirmDelete == true) {
                          bool success = await businessUnitProvider
                              .deleteBusinessUnit(businessUnit.buCode);
                          if (success) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'User ${businessUnit.buName} berhasil dihapus.',
                                ),
                              ),
                            );
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Gagal menghapus user ${businessUnit.buName}: ${businessUnitProvider.errorMessage}',
                                ),
                              ),
                            );
                          }
                        }
                      },
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

  AppBar buildAppBar() => AppBar(title: Text("Business Units"));
}
