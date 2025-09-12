import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';

class SectionCpoRpaRps extends StatelessWidget {
  final int? selectedHour;
  final TextEditingController flowRateController;
  final List<String> dummmyTanks;
  final String? selectedTank;
  final VoidCallback onHourTap;
  final Function(String?) onTankChanged;

  const SectionCpoRpaRps({
    super.key,
    required this.selectedHour,
    required this.flowRateController,
    required this.dummmyTanks,
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
            const CustomSectionTitle(title: 'CPO/RPA/RPS'),
            const SizedBox(height: 12),
            const Text("From Tangki", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomDropdown.fromStringItems(
              hint: 'Pilih Tank',
              prefixIcon: PrefixIconHelper.get('oil-refinery-tanks'),
              stringItems: dummmyTanks,
              value: selectedTank,
              onChanged: onTankChanged,
            ),
            const SizedBox(height: 12),
            const Text("Awal", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourField(selectedHour: selectedHour, onTap: onHourTap),
            const SizedBox(height: 12),
            CustomTextField(
              controller: flowRateController,
              label: 'Flow Rate',
              icon: Icons.speed,
              isNumeric: true,
            ),
            const SizedBox(height: 12),
            const Text("Akhir", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourField(selectedHour: selectedHour, onTap: onHourTap),
            const SizedBox(height: 12),
            CustomTextField(
              controller: flowRateController,
              label: 'Flow Rate',
              icon: Icons.speed,
              isNumeric: true,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: flowRateController,
              label: 'Total Flow Rate',
              icon: Icons.abc,
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
