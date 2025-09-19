import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_olein_solein_sstearin.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_rbdpo_rol_rps.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_stearin_pmf_hstrearin.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/section_card.dart';

class FraDailyProductionEditPage extends StatefulWidget {
  final DataFormNoEntity dataForm;
  final DailyProductionFractionationEntity entity;
  const FraDailyProductionEditPage({
    super.key,
    required this.dataForm,
    required this.entity,
  });

  @override
  State<FraDailyProductionEditPage> createState() =>
      _FraDailyProductionEditPageState();
}

class _FraDailyProductionEditPageState
    extends State<FraDailyProductionEditPage> {
  bool isLoading = true;
  String? selected1Tank;
  String? selected2Tank;
  String? selected3Tank;
  String? selectedOilTypeFgToTank;
  int? selectedHour1Awal;
  int? selectedHour1Akhir;
  int? selectedHour2Awal;
  int? selectedHour2Akhir;
  int? selectedHour3Awal;
  int? selectedHour3Akhir;

  String? selectedOilRm;
  String? selectedOilFg;
  String? selectedOilBp;
  String? selectedRefineryMachine;

  String? selectedLocation;

  // Dummy data
  final List<String> dummyLocations = ['Fract. 500', 'Fract. 400'];
  final List<String> oilTypeFg = ['OLEIN', 'SUPER OLEIN', 'SOFT STEARIN'];
  final List<String> oilTypeRm = ['RBDPO', 'ROL', 'RPS'];
  final List<String> oilTypeBp = ['STEARIN', 'PMF', 'HARD STEARIN'];

  List<TankEntity>? tankLists;
  final List<String> dummyShiftOptions = ['I', 'II', 'III'];

  final TextEditingController flowmeter1AwalController =
      TextEditingController();
  final TextEditingController flowmeter1AkhirController =
      TextEditingController();
  final TextEditingController flowmeter1TotalController =
      TextEditingController();

  final TextEditingController flowmeter2AwalController =
      TextEditingController();
  final TextEditingController flowmeter2AkhirController =
      TextEditingController();
  final TextEditingController flowmeter2TotalController =
      TextEditingController();

  final TextEditingController flowmeter3AwalController =
      TextEditingController();
  final TextEditingController flowmeter3AkhirController =
      TextEditingController();
  final TextEditingController flowmeter3TotalController =
      TextEditingController();

  final TextEditingController flowMaterController = TextEditingController();
  final TextEditingController no1Controller = TextEditingController();
  final TextEditingController no2Controller = TextEditingController();
  final TextEditingController no3Controller = TextEditingController();
  final TextEditingController cr1Controller = TextEditingController();
  final TextEditingController cr2Controller = TextEditingController();

  // Bleaching Earth
  String? selectedShiftBleaching;
  bool ref500Bleaching = false;
  bool ref150Bleaching = false;
  final TextEditingController bleachingBagController = TextEditingController();
  final TextEditingController bleachingTypeController = TextEditingController();
  final TextEditingController bleachingBatchController =
      TextEditingController();

  // Phosphoric Acid
  String? selectedShiftPhosphoric;
  bool ref500Phosphoric = false;
  bool ref150Phosphoric = false;
  final TextEditingController phosphoricWeightController =
      TextEditingController();
  final TextEditingController phosphoricVolumeController =
      TextEditingController();
  final TextEditingController phosphoricYieldController =
      TextEditingController();
  final TextEditingController phosphoricBatchController =
      TextEditingController();

  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prepopulateData();
  }

  @override
  void dispose() {
    super.dispose();
    flowmeter1AwalController.dispose();
    flowmeter1AkhirController.dispose();
    flowmeter1TotalController.dispose();
    flowmeter2AwalController.dispose();
    flowmeter2AkhirController.dispose();
    flowmeter2TotalController.dispose();
    flowmeter3AwalController.dispose();
    flowmeter3AkhirController.dispose();
    flowmeter3TotalController.dispose();
    no1Controller.dispose();
    no2Controller.dispose();
    no3Controller.dispose();
    cr1Controller.dispose();
    cr2Controller.dispose();
    flowMaterController.dispose();
    bleachingBagController.dispose();
    bleachingTypeController.dispose();
    bleachingBatchController.dispose();
    phosphoricWeightController.dispose();
    phosphoricVolumeController.dispose();
    phosphoricYieldController.dispose();
    phosphoricBatchController.dispose();
  }

  void _showHourPickerAndUpdateState(
    Function(int) onHourSelected,
    int? selectedHour,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => CustomHourPicker(
            selectedHour: selectedHour,
            onHourSelected: (hour) {
              onHourSelected(hour);
              // Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(title: 'Daily Production - Edit Fractionation'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === Dropdown: Plant ===
            CustomDropdown.fromStringItems(
              hint: 'Pilih Plant',
              prefixIcon: PrefixIconHelper.get('location'),
              stringItems: dummyLocations,
              value: selectedLocation,
              onChanged: (value) => setState(() => selectedLocation = value),
            ),
            const SizedBox(height: 8),

            // === Dropdown: Part ===
            CustomDropdown.fromStringItems(
              hint: 'Pilih Oil Type',
              prefixIcon: PrefixIconHelper.get('category-svgrepo-com'),
              stringItems: oilTypeRm,
              value: selectedOilRm,
              onChanged: (value) => setState(() => selectedOilRm = value),
            ),
            const SizedBox(height: 16),
            if (selectedOilRm == null) ...[
              const Center(
                child: Text(
                  'Silakan pilih part terlebih dahulu',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ] else ...[
              // === Section: RBDPO/ROL/RPS ===
              FraSectionRbdpoRolRps(
                noController: no1Controller,
                crController: cr1Controller,
                dummyTanks: tankLists ?? [],
                selectedTank: selected1Tank,
                onTankChanged: (value) => setState(() => selected1Tank = value),
                selectedHourAwal: selectedHour1Awal,
                selectedHourAkhir: selectedHour1Akhir,
                onHourTapAwal:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedHour1Awal = hour;
                      }),
                      selectedHour1Awal,
                    ),
                onHourTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedHour1Akhir = hour;
                      }),
                      selectedHour1Akhir,
                    ),
                flowmeterAwalController: flowmeter1AwalController,
                flowmeterAkhirController: flowmeter1AkhirController,
                flowmeterTotalController: flowmeter1TotalController,
              ),

              // === Section:OLEIN/SUPER OLEIN/SOFT STEARIN
              FraSectionOleinSoleinSstearin(
                noController: no2Controller,
                crController: cr2Controller,
                tankLists: tankLists ?? [],
                selectedTank: selected2Tank,
                onTankChanged: (value) => setState(() => selected2Tank = value),
                selectedHourAwal: selectedHour2Awal,
                selectedHourAkhir: selectedHour2Akhir,
                onHourTapAwal:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedHour2Awal = hour;
                      }),
                      selectedHour2Awal,
                    ),
                onHourTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedHour2Akhir = hour;
                      }),
                      selectedHour2Akhir,
                    ),
                flowmeterAwalController: flowmeter2AwalController,
                flowmeterAkhirController: flowmeter2AkhirController,
                flowmeterTotalController: flowmeter2TotalController,
                oilList: oilTypeRm,
                selectedOil: selectedOilRm,
                onOilFgChanged:
                    (oil) => setState(() {
                      selectedOilRm = oil;
                    }),
              ),
              // === Section:STEARIN/PMF/HARD STEARIN
              FraSectionStearinPmfHstrearin(
                noController: no3Controller,
                tanksList: tankLists ?? [],
                onTankChanged: (value) => setState(() => selected2Tank = value),
                selectedTank: selected3Tank,
                selectedHourAwal: selectedHour3Awal,
                selectedHourAkhir: selectedHour3Akhir,
                onHourTapAwal:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedHour3Awal = hour;
                      }),
                      selectedHour3Awal,
                    ),
                onHourTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedHour3Akhir = hour;
                      }),
                      selectedHour3Akhir,
                    ),
                flowmeterAwalController: flowmeter3AwalController,
                flowmeterAkhirController: flowmeter3AkhirController,
                flowmeterTotalController: flowmeter3TotalController,
                oilList: oilTypeFg,
                selectedOil: selectedOilFg,
                onOilFgChanged:
                    (oil) => setState(() {
                      selectedOilFg = oil;
                    }),
              ),
              SectionCard(
                title: 'Remark',
                children: [CustomRemarkField(controller: remarksController)],
              ),
              const SizedBox(height: 24),

              // === Submit Button ===
              CustomSaveButton(onPressed: () {}, label: 'Submit Laporan'),
            ],
          ],
        ),
      ),
    );
  }

  int? _parseHour(String? timeString) {
    if (timeString == null || !timeString.contains(':')) return null;
    return int.tryParse(timeString.split(':')[0]);
  }

  void _prepopulateData() {
    final entity = widget.entity;

    // Set dropdown and simple state values
    selectedLocation = entity.workCenter?.trim();
    selectedOilRm = entity.oilTypeRm?.trim();

    // Section 1: RBDPO/ROL/RPS Data
    selected1Tank = entity.cpoTank;
    selectedHour1Awal = _parseHour(entity.oilTypeRmAwalJam);
    selectedHour1Akhir = _parseHour(entity.oilTypeRmAkhirJam);
    flowmeter1AwalController.text =
        entity.oilTypeRmAwalFlowmeter?.toString() ?? '';
    flowmeter1AkhirController.text =
        entity.oilTypeRmAkhirFlowmeter?.toString() ?? '';
    flowmeter1TotalController.text = entity.oilTypeRmTotal?.toString() ?? '';

    // Section 2: OLEIN/SUPER OLEIN/SOFT STEARIN Data
    selected2Tank = entity.oilTypeFgToTank;
    selectedHour2Awal = _parseHour(entity.oilTypeFgAwalJam);
    selectedHour2Akhir = _parseHour(entity.oilTypeFgAkhirJam);
    flowmeter2AwalController.text =
        entity.oilTypeFgAwalFlowmeter?.toString() ?? '';
    flowmeter2AkhirController.text =
        entity.oilTypeFgAkhirFlowmeter?.toString() ?? '';
    flowmeter2TotalController.text = entity.oilTypeFgTotal?.toString() ?? '';

    // Section 3: STEARIN/PMF/HARD STEARIN Data
    selected3Tank = entity.bpToTank?.toString();
    selectedHour3Awal = _parseHour(entity.bpAwalJam);
    selectedHour3Akhir = _parseHour(entity.bpAkhirJam);
    flowmeter3AwalController.text = entity.bpAwalFlowmeter?.toString() ?? '';
    flowmeter3AkhirController.text = entity.bpAkhirFlowmeter?.toString() ?? '';
    flowmeter3TotalController.text = entity.bpTotal?.toString() ?? '';

    // Bleaching Earth Data
    bleachingBagController.text = entity.beTotalBag ?? '';
    bleachingTypeController.text = entity.beTotalJenis ?? '';
    bleachingBatchController.text = entity.beLotBatchNumber?.toString() ?? '';
    // You can add logic for the ref checkboxes here if needed
    // e.g., if (entity.beRefTank == 'REF-500') ref500Bleaching = true;

    // Phosphoric Acid Data
    phosphoricWeightController.text = entity.paTotal ?? '';
    phosphoricYieldController.text = entity.paYieldPercent?.toString() ?? '';
    phosphoricBatchController.text = entity.paLotBatchNumber?.toString() ?? '';
    // You can add logic for the ref checkboxes here as well

    // Remarks
    remarksController.text = entity.remarks ?? '';

    // TODO: Some controllers like no1Controller, cr1Controller, etc., do not have
    // a clear mapping in the entity file and have been left empty.
  }
}
