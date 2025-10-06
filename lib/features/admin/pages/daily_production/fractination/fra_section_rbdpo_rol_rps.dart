import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class FraSectionRbdpoRolRps extends StatelessWidget {
  // final int? selectedHourAwal;
  // final int? selectedHourAkhir;

  final TimeOfDay? selectedTimeAwal;
  final TimeOfDay? selectedTimeAkhir;
  final VoidCallback onTimeTapAwal;
  final VoidCallback onTimeTapAkhir;
  final TextEditingController flowmeterAwalController;
  final TextEditingController flowmeterAkhirController;
  final TextEditingController flowmeterTotalController;
  final TextEditingController noController;
  final TextEditingController crController;
  final List<TankEntity> dummyTanks;
  String? selectedTank;
  final Function(String?) onTankChanged;
  FraSectionRbdpoRolRps({
    super.key,
    required this.dummyTanks,
    required this.selectedTank,
    required this.onTankChanged,
    required this.selectedTimeAwal,
    required this.selectedTimeAkhir,
    // required this.selectedHourAwal,
    // required this.selectedHourAkhir,
    required this.onTimeTapAwal,
    required this.onTimeTapAkhir,
    required this.flowmeterAwalController,
    required this.flowmeterAkhirController,
    required this.flowmeterTotalController,
    required this.noController,
    required this.crController,
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
              controller: noController,
              label: 'No',
              icon: Icons.numbers,
              isNumeric: true,
            ),
            CustomTextField(
              controller: crController,
              label: 'CR',
              icon: Icons.numbers_rounded,
              isNumeric: true,
            ),
            const Text("From Tank", style: _sectionTextStyle),
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
                  value: selectedTank,
                  items:
                      provider.tankSourceList.map((tank) {
                        return DropdownMenuItem(
                          value: tank.code,
                          child: Text("${tank.code} | ${tank.name}"),
                        );
                      }).toList(),
                  onChanged: onTankChanged,
                  decoration: InputDecoration(hintText: 'Pilih Tank'),
                );
              },
            ),
            const SizedBox(height: 12),
            const Text("Awal", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourMinuteField(
              selectedTime: selectedTimeAwal,
              onTap: onTimeTapAwal,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: flowmeterAwalController,
              label: 'Flowmeter',
              icon: Icons.speed,
              isNumeric: true,
            ),
            const SizedBox(height: 12),
            const Text("Akhir", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourMinuteField(
              selectedTime: selectedTimeAkhir,
              onTap: onTimeTapAkhir,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: flowmeterAkhirController,
              label: 'Flowmeter',
              icon: Icons.speed,
              isNumeric: true,
            ),
            const SizedBox(height: 12),
            const Text("Total", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomTextField(
              controller: flowmeterTotalController,
              label: 'Total',
              icon: Icons.functions,
              isNumeric: true,
              readOnly: true,
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
