import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MasterAddBusinessUnitCard extends StatefulWidget {
  final MBusinessUnitData? editingBusinessUnit;

  final Function(MBusinessUnitCompanion) onSave;

  const MasterAddBusinessUnitCard({
    super.key,
    required this.editingBusinessUnit,
    required this.onSave,
  });

  @override
  State<MasterAddBusinessUnitCard> createState() =>
      _MasterAddBusinessUnitCardState();
}

class _MasterAddBusinessUnitCardState extends State<MasterAddBusinessUnitCard> {
  final comCodeController = TextEditingController();
  final comNameController = TextEditingController();
  final plantCodeController = TextEditingController();
  final plantNameController = TextEditingController();

  String? selectedIsActive;
  String? selectedParent;
  bool isOtherFieldsEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.editingBusinessUnit != null) {
      final bu = widget.editingBusinessUnit!;
      comCodeController.text = bu.companyCode;
      comNameController.text = bu.companyName;
      plantCodeController.text = bu.plantCode ?? '';
      plantNameController.text = bu.plantName ?? '';

      selectedIsActive = bu.isactive;
      selectedParent = bu.parent;

      isOtherFieldsEnabled = bu.parent == '2';
    }
  }

  @override
  void dispose() {
    comCodeController.dispose();
    comNameController.dispose();
    plantCodeController.dispose();
    plantNameController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> onSave() async {
    final comCode = comCodeController.text.trim();
    final comName = comNameController.text.trim();
    final plantCode = plantCodeController.text.trim();
    final plantName = plantNameController.text.trim();
    final isActive = selectedIsActive;
    final parentValue = selectedParent ?? (isOtherFieldsEnabled ? '2' : '1');

    if (comCode.isEmpty || comName.isEmpty) {
      _showSnackbar('❗ Company code dan company name wajib diisi');
      return;
    }

    if (isActive == null) {
      _showSnackbar('❗ Status aktif dan parent wajib dipilih');
      return;
    }

    // if (entryBy == null) {
    //   _showSnackbar('❗ Entry by wajib dipilih');
    //   return;
    // }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final uuid = Uuid();

    final businessUnitCompanion = MBusinessUnitCompanion(
      id: drift.Value(widget.editingBusinessUnit?.id ?? uuid.v4()),
      companyCode: drift.Value(comCode),
      companyName: drift.Value(comName),
      plantCode:
          plantCode.isEmpty
              ? const drift.Value.absent()
              : drift.Value(plantCode),
      plantName:
          plantName.isEmpty
              ? const drift.Value.absent()
              : drift.Value(plantName),
      isactive: drift.Value(isActive),
      entryBy: drift.Value(userProvider.userName),
      entryDate: drift.Value(DateTime.now()),
      parent: drift.Value(parentValue),
    );

    widget.onSave(businessUnitCompanion);
  }

  @override
  Widget build(BuildContext context) {
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
              controller: comCodeController,
              decoration: InputDecoration(
                hintText: 'Enter your company code',
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
              controller: comNameController,
              decoration: InputDecoration(
                hintText: 'Enter your company name',
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
            DropdownButtonFormField<String>(
              value: selectedIsActive,
              decoration: InputDecoration(
                hintText: 'Select active status',
                prefixIcon: const Icon(Icons.check_circle_outline),
                filled: true,
                fillColor: const Color(0xFFF0ECE9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'T', child: Text('Aktif')),
                DropdownMenuItem(value: 'F', child: Text('Tidak Aktif')),
              ],
              onChanged:
                  (value) => setState(() {
                    selectedIsActive = value;
                  }),
            ),

            const SizedBox(height: 20),

            // Checkbox untuk enable/disable fields lain
            Row(
              children: [
                Checkbox(
                  value: isOtherFieldsEnabled,
                  onChanged: (value) {
                    setState(() {
                      isOtherFieldsEnabled = value ?? false;

                      // Autofill selectedParent berdasarkan status checkbox
                      selectedParent = isOtherFieldsEnabled ? '2' : '1';

                      // Hilangkan focus jika disable
                      if (!isOtherFieldsEnabled) {
                        FocusScope.of(
                          context,
                        ).unfocus(); // ⬅ Fokus hilang saat nonaktif
                      }
                    });
                  },
                ),
                const Text('Enable other fields'),
              ],
            ),

            const SizedBox(height: 10),

            // TextField
            Opacity(
              opacity: isOtherFieldsEnabled ? 1.0 : 0.5,
              child: AbsorbPointer(
                absorbing: !isOtherFieldsEnabled,
                child: TextField(
                  controller: plantCodeController,
                  decoration: InputDecoration(
                    hintText: 'Enter your plant code',
                    prefixIcon: const Icon(Icons.lock),
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  readOnly: false,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Opacity(
              opacity:
                  isOtherFieldsEnabled ? 1.0 : 0.5, // lebih samar saat disabled
              child: AbsorbPointer(
                absorbing: !isOtherFieldsEnabled, // mencegah interaksi
                child: TextField(
                  controller: plantNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your company plant',
                    prefixIcon: const Icon(Icons.lock),
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
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
                onPressed: onSave,
                child: Text(
                  widget.editingBusinessUnit == null
                      ? 'Add Business Unit'
                      : 'Update Business Unit',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
