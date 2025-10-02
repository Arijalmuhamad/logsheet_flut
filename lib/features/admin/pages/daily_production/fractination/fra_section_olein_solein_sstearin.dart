import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/data/remote/master/value_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class FraSectionOleinSoleinSstearin extends StatelessWidget {
  final int? selectedHourAwal;
  final int? selectedHourAkhir;
  final VoidCallback onHourTapAwal;
  final VoidCallback onHourTapAkhir;
  final TextEditingController flowmeterAwalController;
  final TextEditingController flowmeterAkhirController;
  final TextEditingController flowmeterTotalController;
  final TextEditingController noController;
  final TextEditingController crController;
  final List<TankEntity> tankLists;
  final List<MasterValueEntity> oilList;
  String? selectedOil;
  String? selectedTank;
  final Function(String?) onTankChanged;
  final Function(String?) onOilFgChanged;

  FraSectionOleinSoleinSstearin({
    super.key,
    required this.tankLists,
    required this.selectedTank,
    required this.onTankChanged,
    required this.selectedHourAwal,
    required this.selectedHourAkhir,
    required this.onHourTapAwal,
    required this.onHourTapAkhir,
    required this.flowmeterAwalController,
    required this.flowmeterAkhirController,
    required this.flowmeterTotalController,
    required this.noController,
    required this.crController,
    required this.oilList,
    required this.selectedOil,
    required this.onOilFgChanged,
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
            const CustomSectionTitle(title: 'OLEIN/SUPER OLEIN/SOFT STEARIN'),
            // CustomDropdown.fromStringItems(
            //   hint: 'Pilih Oil Type',
            //   prefixIcon: PrefixIconHelper.get('category-svgrepo-com'),
            //   stringItems: oilList,
            //   value: selectedOil,
            //   onChanged: onOilFgChanged,
            // ),
            DropdownButtonFormField<MasterValueEntity>(
              value:
                  selectedOil != null &&
                          oilList.any((oil) => oil.code == selectedOil)
                      ? oilList.firstWhere((oil) => oil.code == selectedOil)
                      : null,
              items:
                  oilList.map((oil) {
                    return DropdownMenuItem<MasterValueEntity>(
                      value: oil,
                      child: Text(" ${oil.name}"),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onOilFgChanged(value.code); // simpan code-nya saja
                }
              },
              decoration: InputDecoration(
                hintText: 'Pilih Oil Type',
                filled: true,
                fillColor: const Color(0xFFF0ECE9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.category),
              ),
            ),
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
            CustomHourField(
              selectedHour: selectedHourAwal,
              onTap: onHourTapAwal,
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
            CustomHourField(
              selectedHour: selectedHourAkhir,
              onTap: onHourTapAkhir,
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
