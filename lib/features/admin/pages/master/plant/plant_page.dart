import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/plant_entity.dart';
import 'package:logsheet_app/features/admin/pages/master/plant/add_plant_page.dart';
import 'package:logsheet_app/providers/plant_provider.dart';
import 'package:provider/provider.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlantProvider>(context, listen: false).fetchAllPlant();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          log("Tombol tambah Plant diklik");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPlantPage()),
          );
        },
        label: const Text("Tambah Plant"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget buildBody() {
    return Consumer<PlantProvider>(
      builder: (context, plantProvider, child) {
        if (plantProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (plantProvider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                plantProvider.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (plantProvider.plantList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tidak ada Plant dalam database.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: plantProvider.plantList.length,
          itemBuilder: (context, index) {
            final plant = plantProvider.plantList[index];
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
                  Icons.factory,
                  color: Color(0xFF6B7280),
                  size: 40,
                ),
                title: Text(
                  plant.plantName ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF655F5B),
                  ),
                ),
                subtitle: Text(
                  'Active: ${plant.isActive == 'T' ? 'Aktif' : 'Tidak Aktif'}',
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: Wrap(
                  spacing: 12,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF6B7280)),
                      onPressed: () => _editPlant(plant),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFFB91C1C)),
                      onPressed: () => _deletePlant(plant.plantCode),
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

  AppBar buildAppBar() => AppBar(title: const Text("Plants"));

  void _editPlant(PlantEntity plant) {}

  void _deletePlant(String plantCode) {}
}
