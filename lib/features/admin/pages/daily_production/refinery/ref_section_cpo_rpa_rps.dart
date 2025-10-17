import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class SectionCpoRpaRps extends StatefulWidget {
  final TimeOfDay? selectedTimeAwal;
  final TimeOfDay? selectedTimeAkhir;
  final VoidCallback onTimeTapAwal;
  final VoidCallback onTimeTapAkhir;
  final TextEditingController flowRateAwalController;
  final TextEditingController flowRateAkhirController;
  final TextEditingController flowRateTotalController;
  final List<TankEntity>? dummmyTanks;
  String? selectedTank;
  final String? selectedWorkCenter;
  final Function(String?) onTankChanged;

  SectionCpoRpaRps({
    super.key,
    required this.dummmyTanks,
    required this.selectedTank,
    required this.onTankChanged,
    required this.flowRateAwalController,
    required this.flowRateAkhirController,
    required this.flowRateTotalController,
    required this.selectedTimeAwal,
    required this.selectedTimeAkhir,
    required this.onTimeTapAwal,
    required this.onTimeTapAkhir,
    required this.selectedWorkCenter,
  });

  @override
  State<SectionCpoRpaRps> createState() => _SectionCpoRpaRpsState();
}

class _SectionCpoRpaRpsState extends State<SectionCpoRpaRps> {
  String flowrateUnit = "T/H";
  double flowRateAwal = 0.0;
  double flowRateAkhir = 0.0;
  void _calculateTotalFlowRate() {
    String awalText = widget.flowRateAwalController.text;
    String akhirText = widget.flowRateAkhirController.text;

    //parse to double
    flowRateAwal = double.tryParse(awalText) ?? 0.0;
    flowRateAkhir = double.tryParse(akhirText) ?? 0.0;

    if (widget.selectedWorkCenter == "REF-01") {
      setState(() {
        flowRateAwal = flowRateAwal / 1000;
        flowRateAkhir = flowRateAkhir / 1000;
      });

      // widget.flowRateAwalController.text = flowRateAwal.toStringAsFixed(3);
      // widget.flowRateAkhirController.text = flowRateAkhir.toStringAsFixed(3);
    }
    double totalFlowRate = flowRateAkhir - flowRateAwal;

    String newTotal = totalFlowRate.toStringAsFixed(3);

    if (widget.flowRateTotalController.text != newTotal) {
      setState(() {
        widget.flowRateTotalController.text = newTotal;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    widget.flowRateAwalController.addListener(_calculateTotalFlowRate);
    widget.flowRateAkhirController.addListener(_calculateTotalFlowRate);

    _calculateTotalFlowRate();
  }

  @override
  void dispose() {
    super.dispose();

    widget.flowRateAwalController.removeListener(_calculateTotalFlowRate);
    widget.flowRateAkhirController.removeListener(_calculateTotalFlowRate);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedWorkCenter == "REF-01") {
      setState(() {
        flowrateUnit = "Kg/H";
      });
    } else {
      setState(() {
        flowrateUnit = "T/H";
      });
    }
    return Card(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSectionTitle(title: 'Raw Material'),
            const SizedBox(height: 12),
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
                  value: widget.selectedTank,
                  items:
                      provider.tankSourceList.map((tank) {
                        return DropdownMenuItem(
                          value: tank.code,
                          child: Text("${tank.code} | ${tank.name}"),
                        );
                      }).toList(),
                  onChanged: widget.onTankChanged,
                  decoration: InputDecoration(hintText: 'Pilih Tank'),
                );
              },
            ),
            const SizedBox(height: 12),
            const Text("Awal", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourMinuteField(
              selectedTime: widget.selectedTimeAwal,
              onTap: widget.onTimeTapAwal,
            ),
            // CustomHourField(
            //   selectedHour: widget.selectedHourAwal,
            //   onTap: widget.onTimeTapAwal,
            // ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: widget.flowRateAwalController,
              label: 'Flow Rate ($flowrateUnit)',
              icon: Icons.speed,
              isNumeric: true,
            ),
            if (widget.selectedWorkCenter == 'REF-01') ...[
              Text("Flow Rate: $flowRateAwal T/H"),
            ],
            const SizedBox(height: 12),
            const Text("Akhir", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourMinuteField(
              selectedTime: widget.selectedTimeAkhir,
              onTap: widget.onTimeTapAkhir,
            ),
            // CustomHourField(
            //   selectedHour: widget.selectedHourAkhir,
            //   onTap: widget.onTimeTapAkhir,
            // ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: widget.flowRateAkhirController,
              label: 'Flow Rate ($flowrateUnit)',
              icon: Icons.speed,
              isNumeric: true,
            ),
            if (widget.selectedWorkCenter == 'REF-01') ...[
              Text("Flow Rate: $flowRateAkhir T/H"),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  "Total Flowrate: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.flowRateTotalController.text.isEmpty
                      ? '0.000 T/H'
                      : '${widget.flowRateTotalController.text} T/H',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _calculateFlowrate(String awal, String akhir) {
    double flowrateAwal = double.tryParse(awal) ?? 0.0;
    double flowrateAkhir = double.tryParse(akhir) ?? 0.0;
    double flowrateTotal = flowrateAkhir - flowrateAwal;

    return flowrateTotal.toStringAsFixed(3);
  }
}

const _sectionTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Color(0xFF655F5B),
);
