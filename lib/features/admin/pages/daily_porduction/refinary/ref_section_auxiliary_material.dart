import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';

class SectionAuxiliaryMaterial extends StatelessWidget {
  final List<String> shiftOptions;
  final String? selectedShiftBleaching;
  final String? selectedShiftPhosphoric;

  final TextEditingController bleachingBagController;
  final TextEditingController bleachingTypeController;
  final TextEditingController bleachingBatchController;

  final bool ref500Bleaching;
  final bool ref150Bleaching;

  final TextEditingController phosphoricWeightController;
  final TextEditingController phosphoricVolumeController;
  final TextEditingController phosphoricYieldController;
  final TextEditingController phosphoricBatchController;

  final bool ref500Phosphoric;
  final bool ref150Phosphoric;

  final void Function(String?) onBleachingShiftChanged;
  final void Function(bool?) onRef500BleachingChanged;
  final void Function(bool?) onRef150BleachingChanged;

  final void Function(String?) onPhosphoricShiftChanged;
  final void Function(bool?) onRef500PhosphoricChanged;
  final void Function(bool?) onRef150PhosphoricChanged;

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
    required this.onRef500BleachingChanged,
    required this.onRef150BleachingChanged,
    required this.onPhosphoricShiftChanged,
    required this.onRef500PhosphoricChanged,
    required this.onRef150PhosphoricChanged,
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
              label: 'Jenis (SSA)',
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
                Checkbox(
                  value: ref500Bleaching,
                  onChanged: onRef500BleachingChanged,
                ),
                const Text('Ref 500'),
                const SizedBox(width: 20),
                Checkbox(
                  value: ref150Bleaching,
                  onChanged: onRef150BleachingChanged,
                ),
                const Text('Ref 150'),
              ],
            ),

            // === PHOSPHORIC ACID ===
            const SizedBox(height: 30),
            const Text('Phosphoric Acid', style: _sectionTextStyle),
            const SizedBox(height: 12),

            CustomDropdown.fromStringItems(
              hint: 'Shift',
              value: selectedShiftPhosphoric,
              stringItems: shiftOptions,
              onChanged: onPhosphoricShiftChanged,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: phosphoricWeightController,
                    label: 'Berat (kg)',
                    icon: Icons.monitor_weight,
                    isNumeric: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: phosphoricVolumeController,
                    label: 'Volume (cm³)',
                    icon: Icons.compress,
                    isNumeric: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: phosphoricYieldController,
                    label: 'Yield (%)',
                    icon: Icons.percent,
                    isNumeric: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: phosphoricBatchController,
              label: 'Lot Batch Number',
              icon: Icons.numbers,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Checkbox(
                  value: ref500Phosphoric,
                  onChanged: onRef500PhosphoricChanged,
                ),
                const Text('Ref 500'),
                const SizedBox(width: 20),
                Checkbox(
                  value: ref150Phosphoric,
                  onChanged: onRef150PhosphoricChanged,
                ),
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
