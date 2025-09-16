import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class FraSectionStearinPmfHstrearin extends StatefulWidget {
  final int? selectedHourAwal;
  final int? selectedHourAkhir;
  final VoidCallback onHourTapAwal;
  final VoidCallback onHourTapAkhir;
  final TextEditingController flowmeterAwalController;
  final TextEditingController flowmeterAkhirController;
  final TextEditingController flowmeterTotalController;
  final TextEditingController noController;
  final List<TankEntity> dummyTanks;
  final String? selectedTank;
  final Function(String?) onTankChanged;
  const FraSectionStearinPmfHstrearin({
    super.key,
    required this.dummyTanks,
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
  });

  @override
  State<FraSectionStearinPmfHstrearin> createState() =>
      _FraSectionStearinPmfHstrearinState();
}

class _FraSectionStearinPmfHstrearinState
    extends State<FraSectionStearinPmfHstrearin> {
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
            const CustomSectionTitle(title: 'STEARIN/PMF/HARD STEARIN'),

            const SizedBox(height: 12),
            CustomTextField(
              controller: widget.noController,
              label: 'No',
              icon: Icons.numbers,
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
                  onChanged: widget.onTankChanged,
                );
              },
            ),
            const SizedBox(height: 12),
            const Text("Start", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourField(
              selectedHour: widget.selectedHourAwal,
              onTap: widget.onHourTapAwal,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: widget.flowmeterAwalController,
              label: 'Flowmeter',
              icon: Icons.speed,
              isNumeric: true,
            ),
            const SizedBox(height: 12),
            const Text("Akhir", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourField(
              selectedHour: widget.selectedHourAkhir,
              onTap: widget.onHourTapAkhir,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: widget.flowmeterAkhirController,
              label: 'Flowmeter',
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
