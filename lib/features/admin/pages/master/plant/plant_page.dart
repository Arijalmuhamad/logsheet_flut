import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/plant_entity.dart';
import 'package:logsheet_app/features/admin/pages/master/plant/add_plant_page.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
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
        backgroundColor: Color(0xFFB91C1C),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    plantProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Provider.of<PlantProvider>(
                        context,
                        listen: false,
                      ).fetchAllPlant();
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
          );
        }

        if (plantProvider.plantList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tidak ada Plant dalam database.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Provider.of<PlantProvider>(
                        context,
                        listen: false,
                      ).fetchAllPlant();
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 88),
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
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha(25),
                  radius: 24,
                  child: Icon(
                    Icons.factory,
                    color: Theme.of(context).colorScheme.primary.withAlpha(200),
                    size: 36,
                  ),
                ),
                title: Text(
                  plant.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                          plant.isActive == 'T'
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
                      plant.isActive == 'T' ? 'Aktif' : 'Tidak Aktif',
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
                                (context) => AddPlantPage(
                                  editingPlantEntity:
                                      plantProvider.plantList[index],
                                ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFFB91C1C)),
                      onPressed: () => _deletePlant(plant, plantProvider),
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

  void _deletePlant(PlantEntity plant, PlantProvider provider) async {
    log("Icon delete plant diclick");

    bool? confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Hapus ${plant.name}?"),
            content: Text("Apakah anda yakin ingin menghapus ${plant.name}?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  "Tidak",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Ya"),
              ),
            ],
          ),
    );

    if (confirmDelete == true) {
      bool success = await provider.deletePlant(plant.code);

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Plant ${plant.name} berhasil dihapus.')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menghapus Plant ${plant.name}: ${provider.errorMessage}',
            ),
          ),
        );
      }
    }
  }
}
