import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/business_unit_entity.dart';
import 'package:logsheet_app/data/remote/master/plant_entity.dart';
import 'package:logsheet_app/providers/business_unit_provider.dart';
import 'package:logsheet_app/providers/plant_provider.dart';
import 'package:provider/provider.dart';

class AddPlantPage extends StatefulWidget {
  final PlantEntity? editingPlantEntity;
  const AddPlantPage({super.key, this.editingPlantEntity});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final TextEditingController plantCodeController = TextEditingController();
  final TextEditingController plantNameController = TextEditingController();

  bool _isEditing = false;
  bool _isActive = true;
  String buCode = 'null';
  String isActive = 'T';
  List<BusinessUnitEntity> businessUnits = [];
  @override
  void initState() {
    super.initState();

    if (widget.editingPlantEntity != null) {
      final plant = widget.editingPlantEntity!;
      plantCodeController.text = plant.code;
      plantNameController.text = plant.name;
      isActive = plant.isActive;

      // _isActive = isActive == 'T' ? true : false;

      log('the current plant is ${plant.isActive}');
      _isEditing = true;
      buCode = plant.buCode;
    } else {
      isActive = 'T';
      _isEditing = false;
      buCode = "null";
    }

    _isActive = isActive == 'T' ? true : false;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>
          Provider.of<BusinessUnitProvider>(
            context,
            listen: false,
          ).fetchAllBusinessUnits(),
    );
  }

  @override
  void dispose() {
    super.dispose();

    plantCodeController.dispose();
    plantNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(), body: buildBody());
  }

  AppBar buildAppBar() =>
      AppBar(title: Text(_isEditing ? "Edit Plant" : "Tambah Plant"));

  Widget buildBody() {
    return Consumer<BusinessUnitProvider>(
      builder: (context, provider, child) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  _isEditing ? "Edit Plant" : "Tambah Plant",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF655F5B),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: plantCodeController,
                  enabled: !_isEditing,
                  decoration: InputDecoration(
                    hintText: 'Plant Code',
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: !_isEditing ? Colors.grey[500] : Colors.black,
                    ),
                    filled: true,
                    fillColor:
                        _isEditing ? Colors.grey[300] : Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: plantNameController,
                  enabled: !_isEditing,
                  decoration: InputDecoration(
                    hintText: 'Plant Name',
                    prefixIcon: Icon(
                      Icons.forest_rounded,
                      color: !_isEditing ? Colors.grey[500] : Colors.black,
                    ),
                    filled: true,
                    fillColor:
                        _isEditing ? Colors.grey[300] : Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  onChanged:
                      (value) => setState(() {
                        buCode = value!;
                      }),
                  value: buCode.isNotEmpty ? buCode : null,
                  // decoration: InputDecoration(
                  //   hintText: 'Business Units',
                  //   prefixIcon: Icon(Icons.business),
                  // ),
                  items: [
                    DropdownMenuItem(
                      value: "null",
                      child: const Text("Business Units"),
                    ),
                    ...provider.listBusinessUnits.map((bu) {
                      return DropdownMenuItem<String>(
                        value: bu.buCode,
                        child: Text("${bu.buCode} - ${bu.buName}"),
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 12),

                //Checkbox
                SwitchListTile(
                  title: const Text('Status Aktif'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = !_isActive;
                    });
                  },
                  contentPadding: const EdgeInsets.only(
                    left: 0.0,
                    right: 160.0,
                  ),
                ),

                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAB2F2B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _savePlant,
                    child: Text(_isEditing ? "Edit Plant" : "Add Plant"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _savePlant() async {
    final plantCode = plantCodeController.text.trim();
    final plantName = plantNameController.text.trim();
    final isActive = _isActive ? "T" : "F";

    if (plantCode.isEmpty || plantName.isEmpty || buCode.isEmpty) {
      _showSnackBar('Mohon isi semua fields.');
      return;
    }

    if (!_isActive && !_isEditing) {
      _showSnackBar('Plant harus aktif terlebih dahulu.');
      return;
    }

    log(
      "Plant Code: $plantCode, Plant Name: $plantName, Biz. Code: $buCode, isActive: $isActive",
    );

    if (isActive != "T" && !_isEditing) {
      _showSnackBar('Plant Harus Aktif.');
      return;
    }

    final plantProvider = Provider.of<PlantProvider>(context, listen: false);

    final plantEntity = PlantEntity(
      code: plantCode,
      name: plantName,
      buCode: buCode,
      isActive: isActive,
    );

    bool? success;

    if (_isEditing) {
      // success = await plantProvider;
      success = await plantProvider.editPlant(plantEntity);
      log("Edit success $success");
    } else {
      success = await plantProvider.createPlant(plantEntity);
    }

    switch (success) {
      case null:
        _showSnackBar('Terjadi error: ${plantProvider.errorMessage}');
        break;
      case false:
        _showSnackBar(
          _isEditing
              ? 'Edit plant gagal: ${plantProvider.errorMessage}'
              : 'Registrasi plant gagal: ${plantProvider.errorMessage}',
        );
        break;
      case true:
        _showSnackBar(
          _isEditing ? 'Edit plant berhasil.' : 'Registrasi Plant berhasil.',
        );
        plantProvider.fetchAllPlant();
        if (mounted) Navigator.pop(context);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
