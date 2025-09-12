import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';

class FraSectionRbdpoRolRps extends StatelessWidget {
  final int? selectedHour;
  final TextEditingController flowMaterController;
  final List<String> dummyTanks;
  final String? selectedTank;
  final VoidCallback onHourTap;
  final Function(String?) onTankChanged;
  const FraSectionRbdpoRolRps({
    super.key,
    required this.selectedHour,
    required this.flowMaterController,
    required this.dummyTanks,
    required this.selectedTank,
    required this.onHourTap,
    required this.onTankChanged,
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
            const CustomSectionTitle(title: 'RBDPO/ROL/RPS'),

            const SizedBox(height: 12),
            CustomTextField(
              controller: flowMaterController,
              label: 'No',
              icon: Icons.numbers,
              isNumeric: true,
            ),
            CustomTextField(
              controller: flowMaterController,
              label: 'CR',
              icon: Icons.numbers_rounded,
              isNumeric: true,
            ),
            const Text("From Tank", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomDropdown.fromStringItems(
              hint: 'Select Tank',
              prefixIcon: PrefixIconHelper.get('oil-refinery-tanks'),
              stringItems: dummyTanks,
              value: selectedTank,
              onChanged: onTankChanged,
            ),
            const SizedBox(height: 12),
            const Text("Start", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourField(selectedHour: selectedHour, onTap: onHourTap),
            const SizedBox(height: 12),
            CustomTextField(
              controller: flowMaterController,
              label: 'Flow Mater',
              icon: Icons.speed,
              isNumeric: true,
            ),
            const SizedBox(height: 12),
            const Text("Akhir", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourField(selectedHour: selectedHour, onTap: onHourTap),
            const SizedBox(height: 12),
            CustomTextField(
              controller: flowMaterController,
              label: 'Flow Mater',
              icon: Icons.speed,
              isNumeric: true,
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
