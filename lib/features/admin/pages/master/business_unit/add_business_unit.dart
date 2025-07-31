import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/business_unit_entity.dart';
import 'package:logsheet_app/providers/business_unit_provider.dart';
import 'package:provider/provider.dart';

class AddBusinessUnit extends StatefulWidget {
  final BusinessUnitEntity? editingBusinessUnit;

  const AddBusinessUnit({super.key, this.editingBusinessUnit});

  @override
  State<AddBusinessUnit> createState() => _AddBusinessUnitState();
}

class _AddBusinessUnitState extends State<AddBusinessUnit> {
  final businessUnitNameController = TextEditingController();
  final businessUnitCodeController = TextEditingController();

  bool _isActive = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    if (widget.editingBusinessUnit != null) {
      businessUnitCodeController.text = widget.editingBusinessUnit!.buCode;
      businessUnitNameController.text = widget.editingBusinessUnit!.buName;
      _isEditing = true;
      // is active
    } else {
      _isActive = true;
      _isEditing = false;
    }
  }

  @override
  void dispose() {
    businessUnitCodeController.dispose();
    businessUnitNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Edit Business Unit" : "Tambah Business Unit"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.editingBusinessUnit == null
                  ? 'Tambah Business Unit'
                  : 'Edit Business Unit',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF655F5B),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: businessUnitCodeController,
              enabled: !_isEditing,
              decoration: InputDecoration(
                hintText: 'Enter your Business Unit code',
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: const Color(0xFFF0ECE9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              readOnly: false,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: businessUnitNameController,
              enabled: !_isEditing,
              decoration: InputDecoration(
                hintText: 'Enter your Business Unit name',
                prefixIcon: const Icon(Icons.lock),
                filled: true,
                fillColor: const Color(0xFFF0ECE9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            //checkbox
            SwitchListTile(
              title: const Text('Status Aktif'),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = !_isActive;
                });
              },
              contentPadding: const EdgeInsets.only(left: 0.0, right: 160.0),
            ),
            const SizedBox(height: 20),
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
                onPressed: _saveBusinessUnit,
                child: Text(
                  !_isEditing ? 'Add Business Unit' : 'Edit Business Unit',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _saveBusinessUnit() async {
    final buCode = businessUnitCodeController.text.trim();
    final buName = businessUnitNameController.text.trim();
    final isActive = _isActive ? 'T' : 'F';

    if (buCode.isEmpty || buName.isEmpty) {
      _showSnackBar('Mohon isi semua fields.');
      return;
    }

    if (!_isActive) {
      _showSnackBar('Business Unit harus aktif terlebih dahulu.');
      return;
    }

    final businessUnitProvider = Provider.of<BusinessUnitProvider>(
      context,
      listen: false,
    );

    final businessUnit = BusinessUnitEntity(
      buCode: buCode,
      buName: buName,
      isActive: isActive,
    );

    bool? success;
    if (_isEditing) {
      success = await businessUnitProvider.updateBusinessUnit(businessUnit);
      businessUnitProvider.fetchAllBusinessUnits();
    } else {
      success = await businessUnitProvider.createBusinessUnit(businessUnit);
    }
    switch (success) {
      case null:
        _showSnackBar('Terjadi error: ${businessUnitProvider.errorMessage}');
        break;
      case false:
        _showSnackBar(
          'Registrasi Business Unit gagal: ${businessUnitProvider.errorMessage}',
        );
        break;
      case true:
        _showSnackBar(
          _isEditing
              ? 'Edit Business Unit Berhasil.'
              : 'Registrasi Business Unit berhasil.',
        );
        if (mounted) Navigator.pop(context);
    }
  }
}
