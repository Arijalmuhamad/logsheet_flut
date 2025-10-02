import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; // Added Svg import
import 'package:intl/intl.dart'; // Added DateFormat import

import 'package:logsheet_app/data/remote/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/data/remote/master/value_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_olein_solein_sstearin.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_rbdpo_rol_rps.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_stearin_pmf_hstrearin.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';

import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart'; // Added CustomSectionTitle import
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart'; // Added CustomTextField import
import 'package:logsheet_app/features/admin/widgets/section_card.dart';
import 'package:logsheet_app/providers/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

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
  bool isUtillityUsageActive = false; // Synchronized state
  String? steamItem = "Steam (Ton/Ton CPO)"; // Synchronized state
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
  String? selectedMachine; // Changed from selectedRefineryMachine
  DateTime selectedTransactionDate = DateTime.now(); // Synchronized state
  String? budgetValue; // Synchronized state

  // Dummy data (Used for budget calculation on input page)
  Map<String, double> utilityBudget = {'FRAC-02': 0.06, 'FRAC-01': 0.05};
  List<TankEntity>? tankLists;
  List<MasterValueEntity>? oilLists;

  // Controllers for flowmeters
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

  // Controllers for section inputs (No/CR)
  final TextEditingController no1Controller = TextEditingController();
  final TextEditingController no2Controller = TextEditingController();
  final TextEditingController no3Controller = TextEditingController();
  final TextEditingController cr1Controller = TextEditingController();
  final TextEditingController cr2Controller = TextEditingController();

  // Controller for remarks
  final TextEditingController remarksController = TextEditingController();

  // Controllers for Utility Usage (uu) - Synchronized
  final TextEditingController uuFlowmeterBefore = TextEditingController();
  final TextEditingController uuFlowmeterAfter = TextEditingController();
  final TextEditingController uuFlowmeterTotal = TextEditingController();
  final TextEditingController uuYieldController = TextEditingController();
  final TextEditingController uuListrikController = TextEditingController();
  final TextEditingController uuAirController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final valueProvider = context.read<ValueProvider>();
    if (valueProvider.tankSourceList.isEmpty ||
        valueProvider.oilTypeLists.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await valueProvider.fetchAllInitialData();
      });
    }

    // Initialize listeners for flowmeter calculation
    flowmeter1AwalController.addListener(_calculateTotalFlowmeter);
    flowmeter1AkhirController.addListener(_calculateTotalFlowmeter);
    flowmeter2AwalController.addListener(_calculateTotalFlowmeter);
    flowmeter2AkhirController.addListener(_calculateTotalFlowmeter);
    flowmeter3AwalController.addListener(_calculateTotalFlowmeter);
    flowmeter3AkhirController.addListener(_calculateTotalFlowmeter);
    uuFlowmeterBefore.addListener(
      _calculateTotalFlowmeter,
    ); // Added UU listener
    uuFlowmeterAfter.addListener(_calculateTotalFlowmeter); // Added UU listener

    // Set initial list values
    tankLists = valueProvider.tankSourceList;
    oilLists = valueProvider.oilTypeLists;

    // Prepopulate data
    _prepopulateData();
  }

  @override
  void dispose() {
    // Remove listeners
    flowmeter1AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter1AkhirController.removeListener(_calculateTotalFlowmeter);
    flowmeter2AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter2AkhirController.removeListener(_calculateTotalFlowmeter);
    flowmeter3AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter3AkhirController.removeListener(_calculateTotalFlowmeter);
    uuFlowmeterBefore.removeListener(_calculateTotalFlowmeter);
    uuFlowmeterAfter.removeListener(_calculateTotalFlowmeter);

    // Dispose controllers
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
    remarksController.dispose();

    // Dispose UU controllers
    uuFlowmeterBefore.dispose();
    uuFlowmeterAfter.dispose();
    uuFlowmeterTotal.dispose();
    uuYieldController.dispose();
    uuListrikController.dispose();
    uuAirController.dispose();

    super.dispose();
  }

  void _calculateTotalFlowmeter() {
    // This logic is now synchronized with the input page
    final String awal1Text = flowmeter1AwalController.text;
    final String akhir1Text = flowmeter1AkhirController.text;

    final String awal2Text = flowmeter2AwalController.text;
    final String akhir2Text = flowmeter2AkhirController.text;

    final String awal3Text = flowmeter3AwalController.text;
    final String akhir3Text = flowmeter3AkhirController.text;

    final String awal4Text = uuFlowmeterBefore.text;
    final String akhir4Text = uuFlowmeterAfter.text;

    if (awal1Text != '' && akhir1Text != '') {
      // Coba parse nilai ke integer
      final int awal = int.parse(awal1Text);
      final int akhir = int.parse(akhir1Text);

      log("AWAL $awal AKHIR $akhir");

      // Hitung total: Akhir - Awal
      final int total = akhir - awal;
      flowmeter1TotalController.text = total.toString();
    } else {
      // Kosongkan total jika ada input yang tidak valid
      flowmeter1TotalController.text = '';
    }

    if (awal2Text != '' && akhir2Text != '') {
      // Coba parse nilai ke integer
      final int awal = int.parse(awal2Text);
      final int akhir = int.parse(akhir2Text);

      log("AWAL $awal AKHIR $akhir");

      // Hitung total: Akhir - Awal
      final int total = akhir - awal;
      flowmeter2TotalController.text = total.toString();
    } else {
      // Kosongkan total jika ada input yang tidak valid
      flowmeter2TotalController.text = '';
    }

    if (awal3Text != '' && akhir3Text != '') {
      // Coba parse nilai ke integer
      final int awal = int.parse(awal3Text);
      final int akhir = int.parse(akhir3Text);

      log("AWAL $awal AKHIR $akhir");

      // Hitung total: Akhir - Awal
      final int total = akhir - awal;
      flowmeter3TotalController.text = total.toString();
    } else {
      // Kosongkan total jika ada input yang tidak valid
      flowmeter3TotalController.text = '';
    }

    if (awal4Text != '' && akhir4Text != '') {
      // Coba parse nilai ke integer
      final int awal = int.parse(awal4Text);
      final int akhir = int.parse(akhir4Text);

      log("AWAL $awal AKHIR $akhir");

      // Hitung total: Akhir - Awal
      final int total = akhir - awal;
      uuFlowmeterTotal.text = total.toString();
    } else {
      // Kosongkan total jika ada input yang tidak valid
      uuFlowmeterTotal.text = '';
    }
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
            },
          ),
    );
  }

  Future<void> _selectTransactionDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedTransactionDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedTransactionDate) {
      setState(() {
        selectedTransactionDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Budget calculation logic synchronized
    budgetValue =
        selectedMachine != null && utilityBudget.containsKey(selectedMachine)
            ? selectedMachine == 'FRAC-02'
                ? '${utilityBudget['FRAC-02']}'
                : '${utilityBudget['FRAC-01']}'
            : 'N/A';

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title:
            'Daily Production - Edit Fractionation (${widget.dataForm.code})',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === Dropdown: Work Center (Machine) ===
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                // Simplified loading/empty state for brevity in this edit page.
                // It should mirror the input page's logic closely.
                // Assuming data is loaded in initState or will load.

                // Use the loaded list or an empty list if null/loading
                final List<MasterValueEntity> workCenterList =
                    provider.workCenterFractLists;

                return DropdownButtonFormField<String>(
                  value: selectedMachine,
                  items:
                      workCenterList.map((machine) {
                        return DropdownMenuItem<String>(
                          value: machine.code,
                          child: Text(
                            "${machine.code} | ${machine.name}",
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMachine = value;
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

            // === Transaction Date ===
            GestureDetector(
              onTap: _selectTransactionDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF0ECE9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Pilih Tanggal Transaksi',
                  labelText: 'Tanggal Transaksi',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.calendar_today),
                  ),
                ),
                child: Text(
                  DateFormat('dd MMMM yyyy').format(selectedTransactionDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // === Oil Type Dropdown (RM) ===
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                final List<MasterValueEntity> oilTypeLists =
                    provider.oilTypeLists;

                return DropdownButtonFormField<String>(
                  value: selectedOilRm,
                  items:
                      oilTypeLists.map((oil) {
                        return DropdownMenuItem<String>(
                          value: oil.code,
                          child: Text(oil.name, style: TextStyle(fontSize: 14)),
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
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.oil_barrel_rounded),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
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
                oilList: oilLists ?? [], // Use actual oilLists
                selectedOil: selectedOilFg, // Use selectedOilFg
                onOilFgChanged:
                    (oil) => setState(() {
                      selectedOilFg = oil;
                    }),
              ),
              // === Section:STEARIN/PMF/HARD STEARIN
              FraSectionStearinPmfHstrearin(
                noController: no3Controller,
                tanksList: tankLists ?? [],
                onTankChanged: (value) => setState(() => selected3Tank = value),
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
                oilList: oilLists ?? [], // Use actual oilLists
                selectedOil: selectedOilBp, // Use selectedOilBp
                onOilFgChanged:
                    (oil) => setState(() {
                      selectedOilBp = oil;
                    }),
              ),

              // === Utillity Usage Section (Synchronized) ===
              CheckboxListTile(
                value: isUtillityUsageActive,
                title: Text("Input Utillity Usage"),
                onChanged: (value) {
                  setState(() {
                    isUtillityUsageActive = !isUtillityUsageActive;
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
                          controller: uuFlowmeterBefore,
                          label: 'Flowmeter Before',
                          icon: Icons.functions,
                        ),
                        CustomTextField(
                          controller: uuFlowmeterAfter,
                          label: 'Flowmeter After',
                          icon: Icons.functions,
                        ),
                        CustomTextField(
                          controller: uuFlowmeterTotal,
                          label: 'Total',
                          icon: Icons.functions,
                          readOnly: true,
                        ),
                        CustomTextField(
                          controller: uuYieldController,
                          label: 'Yield %',
                          icon: Icons.functions,
                        ),
                        CustomTextField(
                          controller: uuListrikController,
                          label: 'Listrik',
                          icon: Icons.electric_bolt_rounded,
                        ),
                        CustomTextField(
                          controller: uuAirController,
                          label: 'Air',
                          icon: Icons.water_drop_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              // === Remark Section ===
              SectionCard(
                title: 'Remark',
                children: [CustomRemarkField(controller: remarksController)],
              ),
              const SizedBox(height: 24),

              // === Submit Button ===
              CustomSaveButton(
                onPressed:
                    () => showSaveConfirmationDialog(
                      context,
                      onConfirm: () async => await _updateReport(),
                    ),
                label: 'Update Laporan',
              ),
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
    selectedMachine = entity.workCenter?.trim();
    selectedOilRm = entity.oilTypeRm?.trim();
    selectedOilFg = entity.oilTypeFgs?.trim(); // Added
    selectedOilBp = entity.oilTypeFgh?.trim(); // Added
    selectedTransactionDate = entity.transactionDate ?? DateTime.now(); // Added

    // --- Section 1: RBDPO/ROL/RPS Data ---
    // Note: cpoTank is missing in the entity for Section 1, using oilTypeRmFromTank
    selected1Tank = entity.oilTypeRmFromTank;
    selectedHour1Awal = _parseHour(entity.oilTypeRmAwalJam);
    selectedHour1Akhir = _parseHour(entity.oilTypeRmAkhirJam);
    no1Controller.text = entity.oilTypeRmNo?.toString() ?? ''; // Added
    cr1Controller.text = entity.oilTypeRmCr?.toString() ?? ''; // Added
    flowmeter1AwalController.text =
        entity.oilTypeRmAwalFlowmeter?.toString() ?? '';
    flowmeter1AkhirController.text =
        entity.oilTypeRmAkhirFlowmeter?.toString() ?? '';
    flowmeter1TotalController.text = entity.oilTypeRmTotal?.toString() ?? '';

    // --- Section 2: OLEIN/SUPER OLEIN/SOFT STEARIN Data ---
    selected2Tank = entity.oilTypeFgsToTank;
    selectedHour2Awal = _parseHour(entity.oilTypeFgsAwalJam);
    selectedHour2Akhir = _parseHour(entity.oilTypeFgsAkhirJam);
    no2Controller.text = entity.oilTypeFgsNo?.toString() ?? ''; // Added
    cr2Controller.text = entity.oilTypeFgsCr?.toString() ?? ''; // Added
    flowmeter2AwalController.text =
        entity.oilTypeFgsAwalFlowmeter?.toString() ?? '';
    flowmeter2AkhirController.text =
        entity.oilTypeFgsAkhirFlowmeter?.toString() ?? '';
    flowmeter2TotalController.text = entity.oilTypeFgsTotal?.toString() ?? '';

    // --- Section 3: STEARIN/PMF/HARD STEARIN Data ---
    selected3Tank = entity.oilTypeFghToTank; // Corrected to FghToTank
    selectedHour3Awal = _parseHour(entity.oilTypeFghAwalJam);
    selectedHour3Akhir = _parseHour(entity.oilTypeFghAkhirJam);
    no3Controller.text = entity.oilTypeFghNo?.toString() ?? ''; // Added

    flowmeter3AwalController.text =
        entity.oilTypeFghAwalFlowmeter?.toString() ?? '';
    flowmeter3AkhirController.text =
        entity.oilTypeFghAkhirFlowmeter?.toString() ?? '';
    flowmeter3TotalController.text = entity.oilTypeFghTotal?.toString() ?? '';

    final hasUuData =
        entity.uuFlowmeterBefore != null ||
        entity.uuFlowmeterAfter != null ||
        entity.uuFlowmeterTotal != null ||
        entity.uuYieldPercent != null ||
        entity.uuListrik != null ||
        entity.uuAir != null;

    if (hasUuData) {
      isUtillityUsageActive = true;
    }

    steamItem = entity.uuItem ?? "Steam (Ton/Ton CPO)";

    uuFlowmeterBefore.text = entity.uuFlowmeterBefore?.toString() ?? '';
    uuFlowmeterAfter.text = entity.uuFlowmeterAfter?.toString() ?? '';
    uuFlowmeterTotal.text = entity.uuFlowmeterTotal?.toString() ?? '';
    uuYieldController.text = entity.uuYieldPercent?.toString() ?? '';
    uuListrikController.text = entity.uuListrik?.toString() ?? '';
    uuAirController.text = entity.uuAir?.toString() ?? '';

    // --- Remarks ---
    remarksController.text = entity.remarks ?? '';

    // Trigger state update to reflect prepopulated data in UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Future<void> showSaveConfirmationDialog(
    BuildContext context, {
    required Future<void> Function() onConfirm,
  }) async {
    bool isLoading =
        Provider.of<DailyProductionFractionationProvider>(
          context,
          listen: false,
        ).isLoading;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Konfirmasi Update"),
              content: const Text(
                "Apakah anda yakin ingin mengubah tiket ini?",
              ),
              actions: [
                TextButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            Navigator.of(context).pop();
                          },
                  child: const Text("Tidak"),
                ),
                isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : TextButton(
                      onPressed: () async {
                        await onConfirm();
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: const Text("Ya"),
                    ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  DateTime _getTransactionDate() {
    final DateTime now = selectedTransactionDate;
    return DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
  }

  DateTime _getPostingDate() {
    final DateTime now = _getTransactionDate();
    final int hour = now.hour;

    // Logic for determining posting date based on time, mirroring input page
    if (hour <= 7) {
      final DateTime previousDay = now.subtract(const Duration(days: 1));
      return DateTime(
        previousDay.year,
        previousDay.month,
        previousDay.day,
        previousDay.hour,
        previousDay.minute,
        previousDay.second,
      );
    } else {
      return now;
    }
  }

  int _getShiftBasedOnTimeAndDate(DateTime time) {
    int hour = time.hour;
    int day = time.weekday;
    log("Day: $day, Hour: $hour");

    // Logic for determining shift, mirroring input page
    if (day >= DateTime.friday) {
      if (hour >= 8 && hour < 20) {
        return 4;
      } else {
        return 5;
      }
    } else {
      if (hour >= 8 && hour <= 15) {
        return 1;
      } else if (hour >= 16 && hour <= 23) {
        return 2;
      } else {
        return 3;
      }
    }
  }

  int? _parseInt(String value) {
    final text = value.trim();
    return text.isEmpty ? null : int.tryParse(text);
  }

  double? _parseDouble(TextEditingController c) {
    final text = c.text.trim();
    // Use tryParse to handle potential non-double inputs gracefully
    final double? parsed = double.tryParse(text);
    return text.isEmpty || parsed == null
        ? null
        : double.parse(parsed.toStringAsFixed(4));
  }

  String? _convertStringTimeToDateTime(int? hour) {
    try {
      if (hour == null) {
        return null;
      }

      if (hour < 0 || hour > 23) {
        throw FormatException("Hour must be between 0 and 23, but was $hour.");
      }
      final formattedHour = "${hour.toString().padLeft(2, '0')}:00";

      return formattedHour;
    } on FormatException catch (e) {
      log("Error processing time string '$hour': $e");
      rethrow;
    }
  }

  Future<void> _updateReport() async {
    final provider = context.read<DailyProductionFractionationProvider>();
    final currentUser = context.read<UserProvider>().currentUser;
    final currentPlant = context.read<PlantProvider>().currentPlant;
    final plantCode = currentPlant!.code;
    final companyName =
        context.read<BusinessUnitProvider>().currentBusinessUnit?.buName;

    if (!context.mounted) return;

    final dataForm = widget.dataForm;
    final postingDate = _getPostingDate();

    // The existing ticket ID is used for update, not generating a new one.
    final existingTicketId = widget.entity.id;

    try {
      final entity = DailyProductionFractionationEntity(
        // Use existing ID and company information
        id: existingTicketId,
        company: companyName, // Use current company from provider
        plant: currentPlant.code,
        transactionDate: widget.entity.transactionDate,
        postingDate: widget.entity.postingDate,
        workCenter: selectedMachine, // Use selectedMachine from state
        shift: _getShiftBasedOnTimeAndDate(postingDate).toString(),

        // Section 1: RBDPO/ROL/RPS
        oilTypeRm: selectedOilRm,
        oilTypeRmNo: _parseInt(no1Controller.text),
        oilTypeRmCr: _parseInt(cr1Controller.text),
        oilTypeRmFromTank: selected1Tank,
        oilTypeRmAwalJam: _convertStringTimeToDateTime(selectedHour1Awal),
        oilTypeRmAwalFlowmeter: _parseInt(flowmeter1AwalController.text),
        oilTypeRmAkhirJam: _convertStringTimeToDateTime(selectedHour1Akhir),
        oilTypeRmAkhirFlowmeter: _parseInt(flowmeter1AkhirController.text),
        oilTypeRmTotal: _parseInt(flowmeter1TotalController.text),

        // Section 2: OLEIN/SUPER OLEIN/SOFT STEARIN
        oilTypeFgs: selectedOilFg,
        oilTypeFgsNo: _parseInt(no2Controller.text),
        oilTypeFgsCr: _parseInt(cr2Controller.text),
        oilTypeFgsAwalJam: _convertStringTimeToDateTime(selectedHour2Awal),
        oilTypeFgsAwalFlowmeter: _parseInt(flowmeter2AwalController.text),
        oilTypeFgsAkhirJam: _convertStringTimeToDateTime(selectedHour2Akhir),
        oilTypeFgsAkhirFlowmeter: _parseInt(flowmeter2AkhirController.text),
        oilTypeFgsTotal: _parseInt(flowmeter2TotalController.text),
        oilTypeFgsToTank: selected2Tank,

        // Section 3: STEARIN/PMF/HARD STEARIN
        oilTypeFgh: selectedOilBp,
        oilTypeFghNo: _parseInt(no3Controller.text),
        oilTypeFghAwalJam: _convertStringTimeToDateTime(selectedHour3Awal),
        oilTypeFghAwalFlowmeter: _parseDouble(flowmeter3AwalController),
        oilTypeFghAkhirJam: _convertStringTimeToDateTime(selectedHour3Akhir),
        oilTypeFghAkhirFlowmeter: _parseDouble(flowmeter3AkhirController),
        oilTypeFghTotal: _parseDouble(flowmeter3TotalController),
        oilTypeFghToTank: selected3Tank,

        // Utility Usage (Conditional)
        uuItem: isUtillityUsageActive ? steamItem : null,
        uuBudgetRefQty: isUtillityUsageActive ? selectedMachine : null,
        uuFlowmeterBefore:
            isUtillityUsageActive ? _parseInt(uuFlowmeterBefore.text) : null,
        uuFlowmeterAfter:
            isUtillityUsageActive ? _parseInt(uuFlowmeterAfter.text) : null,
        uuFlowmeterTotal:
            isUtillityUsageActive ? _parseInt(uuFlowmeterTotal.text) : null,
        uuListrik:
            isUtillityUsageActive ? _parseInt(uuListrikController.text) : null,
        uuAir: isUtillityUsageActive ? _parseInt(uuAirController.text) : null,
        uuYieldPercent:
            isUtillityUsageActive ? _parseDouble(uuYieldController) : null,

        // Audit/Log data
        remarks: remarksController.text,
        flag: widget.entity.flag,
        entryBy: widget.entity.entryBy,
        entryDate: widget.entity.entryDate,
        preparedBy: widget.entity.preparedBy,
        preparedDate: widget.entity.preparedDate,
        preparedStatus: widget.entity.preparedStatus,
        preparedStatusRemarks: widget.entity.preparedStatusRemarks,

        // Form No data
        formNo: widget.dataForm.code,
        dateIssued: widget.dataForm.dateIssued,
        revisionNo: widget.dataForm.revisionNo,
        revisionDate: widget.dataForm.revisionDate,

        // Keep existing verification/check fields as they are unless process requires reset
        verifiedBy: widget.entity.verifiedBy,
        verifiedDate: widget.entity.verifiedDate,
        verifiedStatus: widget.entity.verifiedStatus,
        verifiedStatusRemarks: widget.entity.verifiedStatusRemarks,
        checkedBy: widget.entity.checkedBy,
        checkedDate: widget.entity.checkedDate,
        checkedStatus: widget.entity.checkedStatus,
        checkedStatusRemarks: widget.entity.checkedStatusRemarks,
      );

      // Call the update method from the provider
      bool? success = await provider.updateReport(
        entity,
        currentUser?.username ?? "",
        currentUser?.role ?? "",
        plantCode,
      );

      log("is update success? $success");
      if (success == true) {
        if (!mounted) return;
        // Refresh the list view after update
        context.read<DailyProductionFractionationProvider>().fetchAllTickets(
          null,
          null,
          currentUser?.username ?? "",
          currentUser?.role ?? "",
          plantCode,
        );
        _showSnackBar('Laporan berhasil diubah.');
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        _showSnackBar('Gagal mengubah laporan.');
      }
    } catch (e) {
      log("Gagal mengupdate laporan: $e");
      _showSnackBar("Gagal mengupdate laporan: $e");
    }
  }
}
