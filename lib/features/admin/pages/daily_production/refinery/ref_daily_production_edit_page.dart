import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/data/remote/master/value_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_section_auxiliary_material.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_section_cpo_rpa_rps.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_section_rbdpo_rrbdpo_rps.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_section_rfad.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/admin/widgets/section_card.dart';
import 'package:logsheet_app/providers/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class RefDailyProductionEditPage extends StatefulWidget {
  const RefDailyProductionEditPage({
    super.key,
    required this.dataForm,
    required this.entity,
  });
  final DataFormNoEntity dataForm;
  final DailyProductionRefineryEntity entity;

  @override
  State<RefDailyProductionEditPage> createState() =>
      _RefDailyProductionEditPageState();
}

class _RefDailyProductionEditPageState
    extends State<RefDailyProductionEditPage> {
  // Flags
  bool isBahanPenolongActive = false;
  bool isUtillityUsageActive = false;

  // Dropdown selections
  String? selected1Tank;
  String? selected2Tank;
  String? selected3Tank;
  String? selectedOilRm;
  String? selectedOilFg;
  String? selectedOilBp;
  String? selectedRefineryMachine;

  // Time selections
  TimeOfDay? selectedTime1Awal;
  TimeOfDay? selectedTime1Akhir;
  TimeOfDay? selectedTime2Awal;
  TimeOfDay? selectedTime2Akhir;
  TimeOfDay? selectedTime3Awal;
  TimeOfDay? selectedTime3Akhir;

  // Data lists
  List<TankEntity>? tankLists;
  List<MasterValueEntity>? oilTypeLists;
  final List<String> dummyShiftOptions = ['1', '2', '3', '4', '5'];

  // Utility values
  String? budgetValue;
  String? paValue;
  String? steamItem;
  Map<String, double> utilityBudget = {'REF-02': 0.13, 'REF-01': 0.27};
  Map<String, double> paValues = {'REF-02': 3.70, 'REF-01': 2.13};

  // --- Text Editing Controllers ---

  // Section 1: CPO/RPA/RPS
  final TextEditingController flowmeter1AwalController =
      TextEditingController();
  final TextEditingController flowmeter1AkhirController =
      TextEditingController();
  final TextEditingController flowmeter1TotalController =
      TextEditingController();

  // Section 2: RBDPO/RRBDPO/RPS
  final TextEditingController flowmeter2AwalController =
      TextEditingController();
  final TextEditingController flowmeter2AkhirController =
      TextEditingController();
  final TextEditingController flowmeter2TotalController =
      TextEditingController();

  // Section 3: RFAD
  final TextEditingController flowmeter3AwalController =
      TextEditingController();
  final TextEditingController flowmeter3AkhirController =
      TextEditingController();
  final TextEditingController flowmeter3TotalController =
      TextEditingController();

  // Section 4: Auxiliary Material (Bahan Penolong)
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
  final TextEditingController phosphoricTotalController =
      TextEditingController();
  final TextEditingController phosphoricBatchController =
      TextEditingController();
  final TextEditingController phosphoricYieldController =
      TextEditingController();

  // Section 5: Utility Usage
  final TextEditingController totalOilController = TextEditingController();
  final TextEditingController totalSteamController = TextEditingController();
  final TextEditingController steamOilTypeController = TextEditingController();
  final TextEditingController yieldPercentController = TextEditingController();

  // Section 6: Remarks
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch initial data if not already loaded
    final valueProvider = context.read<ValueProvider>();
    if (valueProvider.tankSourceList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await context.read<ValueProvider>().fetchAllInitialData();
        tankLists = valueProvider.tankSourceList;
      });
    } else {
      tankLists = valueProvider.tankSourceList;
    }

    // Pre-populate form with existing data
    _prepopulateData();

    // Add listeners for automatic total calculation
    flowmeter1AwalController.addListener(_calculateTotalFlowmeter);
    flowmeter1AkhirController.addListener(_calculateTotalFlowmeter);
    flowmeter2AwalController.addListener(_calculateTotalFlowmeter);
    flowmeter2AkhirController.addListener(_calculateTotalFlowmeter);
    flowmeter3AwalController.addListener(_calculateTotalFlowmeter);
    flowmeter3AkhirController.addListener(_calculateTotalFlowmeter);
  }

  @override
  void dispose() {
    // Remove listeners to prevent memory leaks
    flowmeter1AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter1AkhirController.removeListener(_calculateTotalFlowmeter);
    flowmeter2AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter2AkhirController.removeListener(_calculateTotalFlowmeter);
    flowmeter3AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter3AkhirController.removeListener(_calculateTotalFlowmeter);

    // Dispose all controllers
    flowmeter1AwalController.dispose();
    flowmeter1AkhirController.dispose();
    flowmeter1TotalController.dispose();
    flowmeter2AwalController.dispose();
    flowmeter2AkhirController.dispose();
    flowmeter2TotalController.dispose();
    flowmeter3AwalController.dispose();
    flowmeter3AkhirController.dispose();
    flowmeter3TotalController.dispose();
    bleachingBagController.dispose();
    bleachingTypeController.dispose();
    bleachingBatchController.dispose();
    phosphoricTotalController.dispose();
    phosphoricBatchController.dispose();
    phosphoricYieldController.dispose();
    totalOilController.dispose();
    totalSteamController.dispose();
    steamOilTypeController.dispose();
    yieldPercentController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  void _calculateTotalFlowmeter() {
    final String awal1Text = flowmeter1AwalController.text;
    final String akhir1Text = flowmeter1AkhirController.text;

    final String awal2Text = flowmeter2AwalController.text;
    final String akhir2Text = flowmeter2AkhirController.text;

    final String awal3Text = flowmeter3AwalController.text;
    final String akhir3Text = flowmeter3AkhirController.text;

    if (awal1Text != '' && akhir1Text != '') {
      // Coba parse nilai ke integer
      final double awal = double.parse(awal1Text);
      final double akhir = double.parse(akhir1Text);

      log("AWAL $awal AKHIR $akhir");

      // Hitung total: Akhir - Awal
      final double total = akhir - awal;
      flowmeter1TotalController.text = total.toString();
    } else {
      // Kosongkan total jika ada input yang tidak valid
      flowmeter1TotalController.text = '';
    }

    if (awal2Text != '' && akhir2Text != '') {
      // Coba parse nilai ke integer
      final double awal = double.parse(awal2Text);
      final double akhir = double.parse(akhir2Text);

      log("AWAL $awal AKHIR $akhir");

      // Hitung total: Akhir - Awal
      final double total = akhir - awal;
      flowmeter2TotalController.text = total.toString();
    } else {
      // Kosongkan total jika ada input yang tidak valid
      flowmeter2TotalController.text = '';
    }

    if (awal3Text != '' && akhir3Text != '') {
      // Coba parse nilai ke integer
      final double awal = double.parse(awal3Text);
      final double akhir = double.parse(akhir3Text);

      log("AWAL $awal AKHIR $akhir");

      // Hitung total: Akhir - Awal
      final double total = akhir - awal;
      flowmeter3TotalController.text = total.toString();
    } else {
      // Kosongkan total jika ada input yang tidak valid
      flowmeter3TotalController.text = '';
    }
  }

  void _showHourPickerAndUpdateState(
    TimeOfDay? selectedTime,
    Function(TimeOfDay) onTimeSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => CustomHourMinutePicker(
            selectedTime: selectedTime,
            onTimeSelected: (time) {
              onTimeSelected(time);
            },
          ),
    );
  }

  Future<void> _refreshPage() async {
    // Simple refresh mechanism
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically set utility values based on machine selection
    steamItem = 'Steam (Ton/Ton ${selectedOilRm ?? 'CPO'})';
    budgetValue =
        selectedRefineryMachine != null &&
                utilityBudget.containsKey(selectedRefineryMachine)
            ? utilityBudget[selectedRefineryMachine].toString()
            : 'N/A';
    paValue =
        selectedRefineryMachine != null &&
                paValues.containsKey(selectedRefineryMachine)
            ? '${paValues[selectedRefineryMachine]} cm'
            : 'N/A';

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title: 'Edit Daily Production\nRefinery (${widget.entity.id})',
        onRefresh: _refreshPage,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Work Center Dropdown ---
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return DropdownButtonFormField<String>(
                  value: selectedRefineryMachine,
                  items:
                      provider.workCenterLists.map((machine) {
                        return DropdownMenuItem<String>(
                          value: machine.code,
                          child: Text(
                            "${machine.code} | ${machine.name}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRefineryMachine = value;
                      if (selectedRefineryMachine == "REF-02") {
                        ref500Bleaching = true;
                        ref150Bleaching = false;
                        ref500Phosphoric = true;
                        ref150Phosphoric = false;
                      } else {
                        ref500Bleaching = false;
                        ref150Bleaching = true;
                        ref500Phosphoric = false;
                        ref150Phosphoric = true;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Pilih Work Center',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/icons/oil-refinery-tanks.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // --- Oil Type Dropdown ---
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isOilTypeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return DropdownButtonFormField<String>(
                  value: selectedOilRm,
                  items:
                      provider.oilTypeLists.map((oil) {
                        return DropdownMenuItem<String>(
                          value: oil.code,
                          child: Text(
                            oil.name,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOilRm = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Pilih Oil Type',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.oil_barrel_rounded),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // --- Form Sections ---
            if (selectedOilRm == null) ...[
              const Center(
                child: Text(
                  'Silakan pilih part terlebih dahulu',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ] else ...[
              // Section 1: CPO RPA RPS
              SectionCpoRpaRps(
                selectedTimeAwal: selectedTime1Awal,
                selectedTimeAkhir: selectedTime1Akhir,
                selectedWorkCenter: selectedRefineryMachine,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      selectedTime1Awal,
                      (time) => setState(() => selectedTime1Awal = time),
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      selectedTime1Akhir,
                      (time) => setState(() => selectedTime1Akhir = time),
                    ),
                dummmyTanks: tankLists,
                selectedTank: selected1Tank,
                onTankChanged: (value) => setState(() => selected1Tank = value),
                flowRateAwalController: flowmeter1AwalController,
                flowRateAkhirController: flowmeter1AkhirController,
                flowRateTotalController: flowmeter1TotalController,
              ),
              const SizedBox(height: 16),

              // Section 2: RBDPO RRBDPO RPS
              SectionRbdpoRrbdpoRps(
                selectedTimeAwal: selectedTime2Awal,
                selectedTimeAkhir: selectedTime2Akhir,
                selectedWorkCenter: selectedRefineryMachine,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      selectedTime2Awal,
                      (time) => setState(() => selectedTime2Awal = time),
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      selectedTime2Akhir,
                      (time) => setState(() => selectedTime2Akhir = time),
                    ),
                tankList: tankLists,
                selectedTank: selected2Tank,
                onTankChanged: (value) => setState(() => selected2Tank = value),
                flowRateAwalController: flowmeter2AwalController,
                flowRateAkhirController: flowmeter2AkhirController,
                flowRateTotalController: flowmeter2TotalController,
                selectedOil: selectedOilFg,
                onOilFgChanged:
                    (oilFg) => setState(() => selectedOilFg = oilFg),
              ),
              const SizedBox(height: 16),

              // Section 3: RFAD
              SectionRfad(
                selectedTimeAwal: selectedTime3Awal,
                selectedTimeAkhir: selectedTime3Akhir,
                selectedOil: selectedOilBp,
                selectedWorkCenter: selectedRefineryMachine,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      selectedTime3Awal,
                      (time) => setState(() => selectedTime3Awal = time),
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      selectedTime3Akhir,
                      (time) => setState(() => selectedTime3Akhir = time),
                    ),
                tankLists: tankLists,
                selectedTank: selected3Tank,
                onTankChanged: (value) => setState(() => selected3Tank = value),
                flowRateAwalController: flowmeter3AwalController,
                flowRateAkhirController: flowmeter3AkhirController,
                flowRateTotalController: flowmeter3TotalController,
                onOilBpChanged: (oil) => setState(() => selectedOilBp = oil),
              ),
              const SizedBox(height: 16),

              // Section 4: Auxiliary Material (Checkbox + Card)
              CheckboxListTile(
                value: isBahanPenolongActive,
                title: const Text("Edit Pemakaian Bahan Penolong"),
                onChanged: (value) {
                  setState(() {
                    isBahanPenolongActive = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (isBahanPenolongActive) ...[
                SectionAuxiliaryMaterial(
                  shiftOptions: dummyShiftOptions,
                  selectedShiftBleaching: selectedShiftBleaching,
                  selectedShiftPhosphoric: selectedShiftPhosphoric,
                  bleachingBagController: bleachingBagController,
                  bleachingTypeController: bleachingTypeController,
                  bleachingBatchController: bleachingBatchController,
                  ref500Bleaching: ref500Bleaching,
                  ref150Bleaching: ref150Bleaching,
                  phosphoricWeightController:
                      TextEditingController(), // Not used, can be removed from widget
                  phosphoricVolumeController:
                      TextEditingController(), // Not used
                  phosphoricYieldController: phosphoricYieldController,
                  phosphoricBatchController: phosphoricBatchController,
                  phosporicTotalController: phosphoricTotalController,
                  ref500Phosphoric: ref500Phosphoric,
                  ref150Phosphoric: ref150Phosphoric,
                  onBleachingShiftChanged:
                      (value) => setState(() => selectedShiftBleaching = value),
                  onPhosphoricShiftChanged:
                      (value) =>
                          setState(() => selectedShiftPhosphoric = value),
                  selectedRefineryMachine: selectedRefineryMachine,
                  paValue: paValue,
                ),
              ],
              const SizedBox(height: 16),

              // Section 5: Utility Usage (Checkbox + Card)
              CheckboxListTile(
                value: isUtillityUsageActive,
                title: const Text("Edit Utillity Usage"),
                onChanged: (value) {
                  setState(() {
                    isUtillityUsageActive = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (isUtillityUsageActive) ...[
                Card(
                  color: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomSectionTitle(title: 'Utillty Usage'),
                        // ... (UI structure from input page)
                        // This part is identical to the input page, so we reuse it
                        Row(
                          children: [
                            const Text(
                              "Item: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                steamItem ?? '-',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text(
                              "Budget: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              budgetValue ?? "-",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: totalOilController,
                          label: 'Total $selectedOilRm',
                          icon: Icons.functions,
                        ),
                        CustomTextField(
                          controller: totalSteamController,
                          label: 'Total Steam',
                          icon: Icons.functions,
                        ),
                        CustomTextField(
                          controller: steamOilTypeController,
                          label: 'Steam: $selectedOilRm',
                          icon: Icons.functions,
                        ),
                        CustomTextField(
                          controller: yieldPercentController,
                          label: 'Yield %',
                          icon: Icons.functions,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Section 6: Remark
              SectionCard(
                title: 'Remark',
                children: [CustomRemarkField(controller: remarksController)],
              ),
              const SizedBox(height: 24),

              // --- Submit Button ---
              CustomSaveButton(
                onPressed:
                    () => showUpdateConfirmationDialog(
                      context,
                      onConfirm: () async {
                        await _updateReport(context);
                      },
                    ),
                label: 'Update Laporan',
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _prepopulateData() {
    final entity = widget.entity;

    // Set top-level dropdowns and values
    selectedRefineryMachine = entity.workCenter;
    selectedOilRm = entity.oilTypeRm?.trim();
    selectedShiftBleaching = entity.shift;
    selectedShiftPhosphoric = entity.shift;

    // Section 1: CPO / RPA / RPS
    selected1Tank = entity.cpoTank;
    selectedTime1Awal = entity.oilTypeRmAwalJam;
    selectedTime1Akhir = entity.oilTypeRmAkhirJam;
    // flowmeter1AwalController.text =
    //     entity.oilTypeRmAwalFlowmeter?.toString() ?? '';
    // flowmeter1AkhirController.text =
    //     entity.oilTypeRmAkhirFlowmeter?.toString() ?? '';

    // Section 2: RBDPO / RRBDPO / RRPS
    selectedOilFg = entity.oilTypeFg?.trim();
    selected2Tank = entity.oilTypeFgToTank;
    selectedTime2Awal = entity.oilTypeFgAwalJam;
    selectedTime2Akhir = entity.oilTypeFgAkhirJam;
    // flowmeter2AwalController.text =
    //     entity.oilTypeFgAwalFlowmeter?.toString() ?? '';
    // flowmeter2AkhirController.text =
    //     entity.oilTypeFgAkhirFlowmeter?.toString() ?? '';

    // Section 3: PFAD
    selectedOilBp = "PFAD"; // Default value for By-Product
    selected3Tank = entity.bpToTank;
    selectedTime3Awal = entity.bpAwalJam;
    selectedTime3Akhir = entity.bpAkhirJam;
    // flowmeter3AwalController.text = entity.bpAwalFlowmeter?.toString() ?? '';
    // flowmeter3AkhirController.text = entity.bpAkhirFlowmeter?.toString() ?? '';

    if (entity.workCenter == "REF-01") {
      flowmeter1AwalController.text =
          ((entity.oilTypeRmAwalFlowmeter ?? 0.0) * 1000).toString();
      flowmeter1AkhirController.text =
          ((entity.oilTypeRmAkhirFlowmeter ?? 0.0) * 1000).toString();

      flowmeter2AwalController.text =
          ((entity.oilTypeFgAwalFlowmeter ?? 0.0) * 1000).toString();
      flowmeter2AkhirController.text =
          ((entity.oilTypeFgAkhirFlowmeter ?? 0.0) * 1000).toString();

      flowmeter2AwalController.text =
          ((entity.oilTypeFgAwalFlowmeter ?? 0.0) * 1000).toString();
      flowmeter2AkhirController.text =
          ((entity.oilTypeFgAkhirFlowmeter ?? 0.0) * 1000).toString();

      flowmeter3AwalController.text =
          ((entity.bpAwalFlowmeter ?? 0.0) * 1000).toString();
      flowmeter3AkhirController.text =
          ((entity.bpAkhirFlowmeter ?? 0.0) * 1000).toString();
    } else {
      flowmeter1AwalController.text =
          (entity.oilTypeRmAwalFlowmeter).toString();
      flowmeter1AkhirController.text =
          (entity.oilTypeRmAkhirFlowmeter).toString();

      flowmeter2AwalController.text =
          (entity.oilTypeFgAwalFlowmeter).toString();
      flowmeter2AkhirController.text =
          (entity.oilTypeFgAkhirFlowmeter).toString();

      flowmeter2AwalController.text =
          (entity.oilTypeFgAwalFlowmeter).toString();
      flowmeter2AkhirController.text =
          (entity.oilTypeFgAkhirFlowmeter).toString();

      flowmeter3AwalController.text = (entity.bpAwalFlowmeter).toString();
      flowmeter3AkhirController.text = (entity.bpAkhirFlowmeter).toString();
    }

    // Section 4: Auxiliary Material
    if (entity.beTotalBag != null || entity.paTotal != null) {
      isBahanPenolongActive = true;
      // Bleaching Earth
      bleachingBagController.text = entity.beTotalBag ?? '';
      bleachingTypeController.text = entity.beTotalJenis ?? '';
      bleachingBatchController.text = entity.beLotBatchNumber?.toString() ?? '';
      if (entity.beRefTank != null) {
        ref500Bleaching = entity.beRefTank!.contains('REF-02');
        ref150Bleaching = entity.beRefTank!.contains('REF-01');
      }
      // Phosphoric Acid
      phosphoricTotalController.text = entity.paTotal ?? '';
      phosphoricYieldController.text = entity.paYieldPercent?.toString() ?? '';
      phosphoricBatchController.text =
          entity.paLotBatchNumber?.toString() ?? '';
      if (entity.paRefTank != null) {
        ref500Phosphoric = entity.paRefTank!.contains('REF-02');
        ref150Phosphoric = entity.paRefTank!.contains('REF-01');
      }
    }

    // Section 5: Utility Usage
    if (entity.uuTotalCpo != null) {
      isUtillityUsageActive = true;
      totalOilController.text = entity.uuTotalCpo?.toString() ?? '';
      totalSteamController.text = entity.uuTotalSteam?.toString() ?? '';
      steamOilTypeController.text = entity.uuSteamCpo ?? '';
      yieldPercentController.text = entity.uuYieldPercent?.toString() ?? '';
    }

    // Section 6: Remarks
    remarksController.text = entity.remarks ?? '';

    // Manually trigger calculation after populating
    _calculateTotalFlowmeter();
  }

  Future<void> showUpdateConfirmationDialog(
    BuildContext context, {
    required Future<void> Function() onConfirm,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Perubahan"),
          content: const Text("Apakah Anda yakin ingin menyimpan perubahan?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                await onConfirm();
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text("Ya, Simpan"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateReport(BuildContext context) async {
    final provider = context.read<DailyProductionRefineryProvider>();
    final currentUser = context.read<UserProvider>().currentUser;
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    void showSnackBar(String message, {bool isError = false}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }

    int? parseInt(String value) {
      return int.tryParse(value.trim());
    }

    double? parseDouble(TextEditingController c) {
      final text = c.text.trim();
      return text.isEmpty ? null : double.tryParse(text);
    }

    double? flow1Awal, flow1Akhir, flow2Awal, flow2Akhir, flow3Awal, flow3Akhir;

    if (selectedRefineryMachine == "REF-01") {
      flow1Awal = parseDouble(flowmeter1AwalController)! / 1000;
      flow1Akhir = parseDouble(flowmeter1AkhirController)! / 1000;

      flow2Awal = parseDouble(flowmeter2AwalController)! / 1000;
      flow2Akhir = parseDouble(flowmeter2AkhirController)! / 1000;

      flow3Awal = parseDouble(flowmeter3AwalController)! / 1000;
      flow3Akhir = parseDouble(flowmeter3AkhirController)! / 1000;
    } else {
      flow1Awal = parseDouble(flowmeter1AwalController);
      flow1Akhir = parseDouble(flowmeter1AkhirController);

      flow2Awal = parseDouble(flowmeter2AwalController);
      flow2Akhir = parseDouble(flowmeter2AkhirController);

      flow3Awal = parseDouble(flowmeter3AwalController);
      flow3Akhir = parseDouble(flowmeter3AkhirController);
    }

    log(
      "${flowmeter1AwalController.text} ${flowmeter1AkhirController.text} ${flowmeter2AwalController.text} ${flowmeter2AkhirController.text} ${flowmeter3AwalController.text} ${flowmeter3AkhirController.text}",
    );
    log("$flow1Awal $flow1Akhir $flow2Awal $flow2Akhir $flow3Awal $flow3Akhir");

    try {
      final updatedEntity = widget.entity.copyWith(
        workCenter: selectedRefineryMachine,
        shift: selectedShiftBleaching,
        cpoTank: selected1Tank,
        oilTypeRm: selectedOilRm,
        oilTypeRmAwalJam: selectedTime1Awal,
        oilTypeRmAwalFlowmeter: flow1Awal,
        oilTypeRmAkhirJam: selectedTime1Akhir,
        oilTypeRmAkhirFlowmeter: flow1Akhir,
        oilTypeRmTotal: parseDouble(flowmeter1TotalController),
        oilTypeFg: selectedOilFg,
        oilTypeFgAwalJam: selectedTime2Awal,
        oilTypeFgAwalFlowmeter: flow2Awal,
        oilTypeFgAkhirJam: selectedTime2Akhir,
        oilTypeFgAkhirFlowmeter: flow2Akhir,
        oilTypeFgTotal: parseDouble(flowmeter2TotalController),
        oilTypeFgToTank: selected2Tank,
        bpAwalJam: selectedTime3Awal,
        bpAwalFlowmeter: flow3Awal,
        bpAkhirJam: selectedTime3Akhir,
        bpAkhirFlowmeter: flow3Akhir,
        bpTotal: parseDouble(flowmeter3TotalController),
        bpToTank: selected3Tank,
        beRefTank: isBahanPenolongActive ? selectedRefineryMachine : null,
        beTotalBag: isBahanPenolongActive ? bleachingBagController.text : null,
        beTotalJenis:
            isBahanPenolongActive ? bleachingTypeController.text : null,
        beLotBatchNumber:
            isBahanPenolongActive
                ? parseInt(bleachingBatchController.text)
                : null,
        paRefTank: isBahanPenolongActive ? selectedRefineryMachine : null,
        paTotal: isBahanPenolongActive ? phosphoricTotalController.text : null,
        paLotBatchNumber:
            isBahanPenolongActive
                ? parseInt(phosphoricBatchController.text)
                : null,
        paYieldPercent:
            isBahanPenolongActive
                ? parseDouble(phosphoricYieldController)
                : null,
        remarks: remarksController.text,
        uuItem: isUtillityUsageActive ? steamItem : null,
        uuBudgetRefTank: isUtillityUsageActive ? selectedRefineryMachine : null,
        uuBudgetQty: isUtillityUsageActive ? budgetValue : null,
        uuTotalCpo:
            isUtillityUsageActive ? parseInt(totalOilController.text) : null,
        uuTotalSteam:
            isUtillityUsageActive ? parseInt(totalSteamController.text) : null,
        uuSteamCpo: isUtillityUsageActive ? steamOilTypeController.text : null,
        uuYieldPercent:
            isUtillityUsageActive ? parseDouble(yieldPercentController) : null,
      );

      log("Attempting to update ticket ID: ${updatedEntity.id}");
      final success = await provider.updateReport(
        updatedEntity,
        currentUser?.username ?? "",
        currentUser?.role ?? "",
        plantCode,
      );

      if (success) {
        if (!context.mounted) return;
        showSnackBar('Laporan berhasil diperbarui.');
        // Refresh the list on the previous screen
        // context.read<DailyProductionRefineryProvider>().fetchAllTickets(
        //   null,
        //   null,
        //   currentUser?.username ?? "",
        //   currentUser?.role ?? "",
        //   updatedEntity.plant ?? "",
        // );
        Navigator.pop(context); // Go back to the list page
        Navigator.pop(context);
      } else {
        showSnackBar(
          'Gagal memperbarui laporan: ${provider.errorMessage}',
          isError: true,
        );
      }
    } catch (e) {
      log("Error updating report: $e");
      showSnackBar("Terjadi kesalahan: $e", isError: true);
    }
  }
}
