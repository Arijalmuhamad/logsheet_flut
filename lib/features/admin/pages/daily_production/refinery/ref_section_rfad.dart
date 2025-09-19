import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class SectionRfad extends StatelessWidget {
  final int? selectedHourAwal;
  final int? selectedHourAkhir;
  final VoidCallback onHourTapAwal;
  final VoidCallback onHourTapAkhir;
  final TextEditingController flowRateAwalController;
  final TextEditingController flowRateAkhirController;
  final TextEditingController flowRateTotalController;
  final List<TankEntity>? tankLists;
  final List<String> oilList;
  String? selectedOil;
  String? selectedTank;
  final Function(String?) onTankChanged;
  final Function(String?) onOilBpChanged;

  SectionRfad({
    super.key,
    required this.tankLists,
    required this.selectedTank,
    required this.onTankChanged,
    required this.flowRateAwalController,
    required this.flowRateAkhirController,
    required this.flowRateTotalController,
    required this.selectedHourAwal,
    required this.selectedHourAkhir,
    required this.onHourTapAwal,
    required this.onHourTapAkhir,
    required this.oilList,
    required this.selectedOil,
    required this.onOilBpChanged,
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
            const CustomSectionTitle(title: 'RFAD'),
            CustomDropdown.fromStringItems(
              hint: 'Pilih Oil Type',
              prefixIcon: PrefixIconHelper.get('category-svgrepo-com'),
              stringItems: oilList,
              value: selectedOil,
              onChanged: onOilBpChanged,
            ),
            const SizedBox(height: 12),
            const Text("Awal", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourField(
              selectedHour: selectedHourAwal,
              onTap: onHourTapAwal,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: flowRateAwalController,
              label: 'Flow Rate',
              icon: Icons.speed,
              isNumeric: true,
            ),
            const SizedBox(height: 12),
            const Text("Akhir", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourField(
              selectedHour: selectedHourAkhir,
              onTap: onHourTapAkhir,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: flowRateAkhirController,
              label: 'Flow Rate',
              icon: Icons.speed,
              isNumeric: true,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: flowRateTotalController,
              label: 'Total Flow Rate',
              icon: Icons.functions,
              isNumeric: true,
            ),
            const SizedBox(height: 12),
            const Text("To Tangki", style: _sectionTextStyle),
            const SizedBox(height: 10),
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return DropdownButtonFormField<String>(
                    value: null,
                    items: [],
                    onChanged: null, // Disable the dropdown
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Loading Tanks...',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  );
                }
                if (provider.tankSourceList.isEmpty) {
                  return TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Tank List tidak ditemukan.',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.warning_amber_rounded),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await context
                              .read<ValueProvider>()
                              .fetchTankSourceLists();
                        },
                      ),
                    ),
                  );
                }
                return DropdownButtonFormField(
                  items:
                      provider.tankSourceList.map((tank) {
                        return DropdownMenuItem(
                          value: tank.code,
                          child: Text("${tank.code} | ${tank.name}"),
                        );
                      }).toList(),
                  onChanged: onTankChanged,
                );
              },
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
