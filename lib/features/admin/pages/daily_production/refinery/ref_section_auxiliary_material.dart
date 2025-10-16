import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';

class SectionAuxiliaryMaterial extends StatelessWidget {
  final List<String> shiftOptions;
  final String? selectedShiftBleaching;
  final String? selectedShiftPhosphoric;
  final String? selectedRefineryMachine;
  final String? paValue;

  final TextEditingController bleachingBagController;
  final TextEditingController bleachingTypeController;
  final TextEditingController bleachingBatchController;

  final bool ref500Bleaching;
  final bool ref150Bleaching;

  final TextEditingController phosphoricWeightController;
  final TextEditingController phosphoricVolumeController;
  final TextEditingController phosphoricYieldController;
  final TextEditingController phosphoricBatchController;
  final TextEditingController phosporicTotalController;

  final bool ref500Phosphoric;
  final bool ref150Phosphoric;

  final void Function(String?) onBleachingShiftChanged;

  final void Function(String?) onPhosphoricShiftChanged;

  const SectionAuxiliaryMaterial({
    super.key,
    required this.shiftOptions,
    required this.selectedShiftBleaching,
    required this.selectedShiftPhosphoric,
    required this.bleachingBagController,
    required this.bleachingTypeController,
    required this.bleachingBatchController,
    required this.ref500Bleaching,
    required this.ref150Bleaching,
    required this.phosphoricWeightController,
    required this.phosphoricVolumeController,
    required this.phosphoricYieldController,
    required this.phosphoricBatchController,
    required this.ref500Phosphoric,
    required this.ref150Phosphoric,
    required this.onBleachingShiftChanged,
    required this.onPhosphoricShiftChanged,
    required this.selectedRefineryMachine,
    required this.paValue,
    required this.phosporicTotalController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSectionTitle(title: 'Pemakaian Bahan Penolong'),

            // === BLEACHING EARTH ===
            const SizedBox(height: 20),
            const Text('Bleaching Earth', style: _sectionTextStyle),

            const Text('1 Bag = 1000 Kg'),

            const SizedBox(height: 12),
            CustomDropdown.fromStringItems(
              hint: 'Shift',
              value: selectedShiftBleaching,
              stringItems: shiftOptions,
              onChanged: onBleachingShiftChanged,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: bleachingBagController,
              label: 'Jumlah (Bag)',
              icon: Icons.local_mall,
              isNumeric: true,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: bleachingTypeController,
              label: 'Jenis',
              icon: Icons.category,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: bleachingBatchController,
              label: 'Lot Batch Number',
              icon: Icons.numbers,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Checkbox(value: ref500Bleaching, onChanged: null),
                const Text('Ref 500'),
                const SizedBox(width: 20),
                Checkbox(value: ref150Bleaching, onChanged: null),
                const Text('Ref 150'),
              ],
            ),

            // === PHOSPHORIC ACID ===
            const SizedBox(height: 30),
            const Text('Phosphoric Acid', style: _sectionTextStyle),
            const SizedBox(height: 2),
            Text("Value: $paValue"),
            const SizedBox(height: 12),

            CustomDropdown.fromStringItems(
              hint: 'Shift',
              value: selectedShiftBleaching,
              stringItems: shiftOptions,
              onChanged: onPhosphoricShiftChanged,
            ),
            const SizedBox(height: 12),
            const SizedBox(width: 12),
            CustomTextField(
              controller: phosporicTotalController,
              label: 'Total',
              icon: Icons.functions_rounded,
              isNumeric: true,
            ),
            CustomTextField(
              controller: phosphoricBatchController,
              label: 'Lot Batch Number',
              icon: Icons.numbers,
            ),
            const SizedBox(width: 12),
            CustomTextField(
              controller: phosphoricYieldController,
              label: 'Yield (%)',
              icon: Icons.percent,
              isNumeric: true,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Checkbox(value: ref500Phosphoric, onChanged: null),
                const Text('Ref 500'),
                const SizedBox(width: 20),
                Checkbox(value: ref150Phosphoric, onChanged: null),
                const Text('Ref 150'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

const _sectionTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Color(0xFF655F5B),
);
