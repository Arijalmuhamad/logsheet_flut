import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/data/remote/master/value_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_section_auxiliary_material.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/admin/widgets/section_card.dart';
import 'package:logsheet_app/providers/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

import 'ref_section_cpo_rpa_rps.dart';
import 'ref_section_rbdpo_rrbdpo_rps.dart';
import 'ref_section_rfad.dart';

class DailyProductionRefineryInputPage extends StatefulWidget {
  final String userName;
  final DataFormNoEntity dataForm;
  const DailyProductionRefineryInputPage({
    super.key,
    required this.userName,
    required this.dataForm,
  });

  @override
  State<DailyProductionRefineryInputPage> createState() =>
      _DailyProductionPageState();
}

class _DailyProductionPageState
    extends State<DailyProductionRefineryInputPage> {
  bool isLoading = true;
  String? selected1Tank;
  String? selected2Tank;
  String? selected3Tank;

  DateTime selectedPostingDate = DateTime.now();

  String? selectedOilTypeFgToTank;

  // int? selectedHour1Awal;
  // int? selectedHour1Akhir;
  // int? selectedHour2Awal;
  // int? selectedHour2Akhir;
  // int? selectedHour3Awal;
  // int? selectedHour3Akhir;

  TimeOfDay? selectedTime1Awal;
  TimeOfDay? selectedTime1Akhir;
  TimeOfDay? selectedTime2Awal;
  TimeOfDay? selectedTime2Akhir;
  TimeOfDay? selectedTime3Awal;
  TimeOfDay? selectedTime3Akhir;

  String? selectedOilRm;
  String? selectedOilFg;
  String? selectedOilBp;
  String? selectedRefineryMachine;
  String? budgetValue;
  String? paValue;

  // Utility Usage fixed values based on machine
  Map<String, double> utilityBudget = {'REF-02': 0.13, 'REF-01': 0.27};
  Map<String, double> paValues = {'REF-02': 3.70, 'REF-01': 2.18};

  bool isBahanPenolongActive = false;
  bool isUtillityUsageActive = false;

  // final List<String>? dummyLocations = ['Refinery', 'Fractination'];
  List<TankEntity>? tankLists;
  List<MasterValueEntity>? oilTypeLists;
  // final List<String> oilTypeRm = ['CPO', 'RPA', 'RPS'];
  // final List<String> oilTypeFg = ['RBDPO', 'RRBDPO', 'RRPS'];
  // final List<String> oilTypeBp = ['PFAD'];
  final List<String> dummyShiftOptions = ['1', '2', '3', "4", "5"];

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

  final oilTypeRmTotalController = TextEditingController();
  final oilTypefgController = TextEditingController();
  final oilTypefgTotalController = TextEditingController();

  final beTotalBagController = TextEditingController();
  final beTotalJenisController = TextEditingController();
  final beLotBatchNumberController = TextEditingController();

  final paTotalController = TextEditingController();
  final paLotBatchNumberController = TextEditingController();
  final paYieldPercentageController = TextEditingController();

  final totalOilController = TextEditingController();
  final totalSteamController = TextEditingController();
  final steamOilTypeController = TextEditingController();
  final yieldPercentController = TextEditingController();

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
  String? steamItem;
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
  final TextEditingController phosphoricTotalController =
      TextEditingController();

  final TextEditingController remarksController = TextEditingController();

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
    oilTypeRmTotalController.dispose();
    oilTypefgController.dispose();
    oilTypefgTotalController.dispose();
    beTotalBagController.dispose();
    beTotalJenisController.dispose();
    beLotBatchNumberController.dispose();
    paTotalController.dispose();
    paLotBatchNumberController.dispose();
    paYieldPercentageController.dispose();
    bleachingBagController.dispose();
    bleachingTypeController.dispose();
    bleachingBatchController.dispose();
    phosphoricWeightController.dispose();
    phosphoricVolumeController.dispose();
    phosphoricYieldController.dispose();
    phosphoricBatchController.dispose();

    totalOilController.dispose();
    totalSteamController.dispose();
    steamOilTypeController.dispose();
    yieldPercentController.dispose();

    flowmeter1AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter1AkhirController.removeListener(_calculateTotalFlowmeter);

    flowmeter2AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter2AkhirController.removeListener(_calculateTotalFlowmeter);

    flowmeter3AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter3AkhirController.removeListener(_calculateTotalFlowmeter);
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

  Future<void> _selectPostingDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedPostingDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedPostingDate) {
      setState(() {
        selectedPostingDate = picked;
      });
    }
  }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    final valueProvider = context.read<ValueProvider>();
    if (valueProvider.tankSourceList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await context.read<ValueProvider>().fetchAllInitialData();
        oilTypeLists = valueProvider.oilTypeListsDailyProduction;
      });
    }

    tankLists = context.read<ValueProvider>().tankSourceList;

    flowmeter1AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter1AkhirController.removeListener(_calculateTotalFlowmeter);

    flowmeter2AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter2AkhirController.removeListener(_calculateTotalFlowmeter);

    flowmeter3AwalController.removeListener(_calculateTotalFlowmeter);
    flowmeter3AkhirController.removeListener(_calculateTotalFlowmeter);
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
  }

  Future<void> showSaveConfirmationDialog(
    BuildContext context, {
    required Future<void> Function() onConfirm,
  }) async {
    bool isLoading =
        Provider.of<DailyProductionRefineryProvider>(
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
              title: const Text("Konfirmasi input"),
              content: const Text("Apakah anda yakin?"),
              actions: [
                TextButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            Navigator.of(context).pop();
                          },
                  child: const Text("Cancel"),
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
                      child: const Text("Yes"),
                    ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    steamItem = 'Steam (Ton/Ton ${selectedOilRm ?? 'CPO'})';
    budgetValue =
        selectedRefineryMachine != null &&
                utilityBudget.containsKey(selectedRefineryMachine)
            ? selectedRefineryMachine == 'REF-01'
                ? '${utilityBudget['REF-01']}'
                : '${utilityBudget['REF-02']}'
            : 'N/A';

    paValue =
        selectedRefineryMachine != null &&
                paValues.containsKey(selectedRefineryMachine)
            ? selectedRefineryMachine == 'REF-01'
                ? '${paValues['REF-01']} cm'
                : '${paValues['REF-02']} cm'
            : 'N/A';

    // Determine current shift based on local time for display
    final currentShift = getShiftBasedOnTimeAndDate(DateTime.now()).toString();
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title: 'Daily Production - \nRefinery (${widget.dataForm.code})',
        onRefresh: _refreshPage,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return DropdownButtonFormField<String>(
                    value: null,
                    items: [],
                    onChanged: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Loading Work Center...',
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
                if (provider.workCenterLists.isEmpty) {
                  return TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Refinery Machine tidak ditemukan.',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.warning_amber_rounded),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await context
                              .read<ValueProvider>()
                              .fetchWorkCenterLists();
                        },
                      ),
                    ),
                  );
                }
                return DropdownButtonFormField<String>(
                  value: selectedRefineryMachine,
                  items:
                      provider.workCenterLists.map((machine) {
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
            GestureDetector(
              onTap: _selectPostingDate,
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
                  DateFormat('dd MMMM yyyy').format(selectedPostingDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // === Dropdown: Part ===
            // CustomDropdown.fromStringItems(
            //   hint: 'Pilih Oil Type',
            //   prefixIcon: PrefixIconHelper.get('category-svgrepo-com'),
            //   stringItems: oilTypeRm,
            //   value: selectedOilRm,
            //   onChanged: (value) => setState(() => selectedOilRm = value),
            // ),

            // Oil Type Dropdown
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isOilTypeLoading) {
                  // Return a disabled dropdown with a loading indicator or message
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
                      hintText: 'Loading Oil Types...',
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

                if (provider.oilTypeListsDailyProduction.isEmpty) {
                  return TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Oil Types tidak ditemukan.',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.warning_amber_rounded),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await context
                              .read<ValueProvider>()
                              .fetchOilTypesDailyProd();
                        },
                      ),
                    ),
                  );
                }
                return DropdownButtonFormField<String>(
                  value: selectedOilRm,
                  items:
                      provider.oilTypeListsDailyProduction.map((oil) {
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
            const SizedBox(height: 16),

            if (selectedOilRm == null) ...[
              const Center(
                child: Text(
                  'Silakan pilih part terlebih dahulu',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ] else ...[
              // === Section: CPO RPA RPS ===
              SectionCpoRpaRps(
                selectedTimeAwal: selectedTime1Awal,
                selectedTimeAkhir: selectedTime1Akhir,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      selectedTime1Awal,
                      (hour) => setState(() {
                        // selectedHour1Awal = hour;
                        selectedTime1Awal = hour;
                      }),
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      selectedTime1Akhir,
                      (hour) => setState(() {
                        selectedTime1Akhir = hour;
                      }),
                    ),
                dummmyTanks: tankLists,
                selectedTank: selected1Tank,
                onTankChanged: (value) => setState(() => selected1Tank = value),
                flowRateAwalController: flowmeter1AwalController,
                flowRateAkhirController: flowmeter1AkhirController,
                flowRateTotalController: flowmeter1TotalController,
              ),
              const SizedBox(height: 16),

              // === Section: RBDPO RRBDPO RPS ===
              SectionRbdpoRrbdpoRps(
                selectedTimeAwal: selectedTime2Awal,
                selectedTimeAkhir: selectedTime2Akhir,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      selectedTime2Awal,
                      (hour) => setState(() {
                        selectedTime2Awal = hour;
                      }),
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      selectedTime2Akhir,
                      (hour) => setState(() {
                        selectedTime2Akhir = hour;
                      }),
                    ),
                tankList: tankLists,
                selectedTank: selected2Tank,
                onTankChanged: (value) => setState(() => selected2Tank = value),
                flowRateAwalController: flowmeter2AwalController,
                flowRateAkhirController: flowmeter2AkhirController,
                flowRateTotalController: flowmeter2TotalController,
                selectedOil: selectedOilFg,
                onOilFgChanged:
                    (oilFg) => setState(() {
                      selectedOilFg = oilFg;
                    }),
              ),
              const SizedBox(height: 16),

              // === Section: RFAD ===
              SectionRfad(
                selectedTimeAwal: selectedTime3Awal,
                selectedTimeAkhir: selectedTime3Akhir,
                selectedOil: selectedOilBp,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      selectedTime3Awal,
                      (hour) => setState(() {
                        selectedTime3Awal = hour;
                      }),
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      selectedTime3Akhir,
                      (hour) => setState(() {
                        selectedTime3Akhir = hour;
                      }),
                    ),
                tankLists: tankLists,
                selectedTank: selected3Tank,
                onTankChanged: (value) => setState(() => selected3Tank = value),
                flowRateAwalController: flowmeter3AwalController,
                flowRateAkhirController: flowmeter3AkhirController,
                flowRateTotalController: flowmeter3TotalController,
                onOilBpChanged:
                    (oil) => setState(() {
                      selectedOilBp = oil;
                    }),
              ),
              const SizedBox(height: 16),

              // CheckBox to activate the bahan penolong card
              CheckboxListTile(
                value: isBahanPenolongActive,
                title: Text("Input Pemakaian Bahan Penolong"),
                onChanged: (value) {
                  setState(() {
                    isBahanPenolongActive = !isBahanPenolongActive;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              if (isBahanPenolongActive) ...[
                // === Section: Auxiliary Material ===
                SectionAuxiliaryMaterial(
                  shiftOptions: dummyShiftOptions,
                  selectedShiftBleaching: selectedShiftBleaching,
                  selectedShiftPhosphoric: selectedShiftPhosphoric,
                  bleachingBagController: bleachingBagController,
                  bleachingTypeController: bleachingTypeController,
                  bleachingBatchController: bleachingBatchController,
                  ref500Bleaching: ref500Bleaching,
                  ref150Bleaching: ref150Bleaching,
                  phosphoricWeightController: phosphoricWeightController,
                  phosphoricVolumeController: phosphoricVolumeController,
                  phosphoricYieldController: phosphoricYieldController,
                  phosphoricBatchController: phosphoricBatchController,
                  ref500Phosphoric: ref500Phosphoric,
                  ref150Phosphoric: ref150Phosphoric,
                  onBleachingShiftChanged:
                      (value) => setState(() => selectedShiftBleaching = value),
                  onPhosphoricShiftChanged:
                      (value) =>
                          setState(() => selectedShiftPhosphoric = value),
                  selectedRefineryMachine: selectedRefineryMachine,
                  paValue: paValue,
                  phosporicTotalController: phosphoricTotalController,
                ),
              ],
              const SizedBox(height: 16),

              // CheckBox to activate the bahan penolong card
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
                // === Section: Utillity Usage ===
                Card(
                  color: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
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
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text(
                              "Shift: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              selectedShiftBleaching ?? currentShift,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Row(children: [Text("Shift: "), Text("I")]),
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

              // === Section: Remark ===
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
                      onConfirm: () async => await submitReport(context),
                    ),
                label: 'Submit Laporan',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> submitReport(BuildContext context) async {
    final provider = context.read<DailyProductionRefineryProvider>();
    final currentUser = context.read<UserProvider>().currentUser;
    final currentPlant = context.read<PlantProvider>().currentPlant;
    final plantCode = currentPlant!.code;
    final companyName =
        context.read<BusinessUnitProvider>().currentBusinessUnit?.buName;
    DateTime getTransactionDate() {
      final DateTime now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
        now.second,
      );
    }

    DateTime getPostingDate() {
      final DateTime now = DateTime.now();

      final int hour = now.hour;

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
        return DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
          now.second,
        );
      }
    }

    double? parseDouble(TextEditingController c) {
      final text = c.text.trim();
      return text.isEmpty || text == "-"
          ? null
          : double.parse(double.parse(text).toStringAsFixed(4));
    }

    final latestTicketIdFromProvider = await context
        .read<DailyProductionRefineryProvider>()
        .fetchLatestId(plantCode);

    Future<String> buildTicketNumber() async {
      log("TICKET NUMBER FROM PROVIDER: $latestTicketIdFromProvider");
      if (latestTicketIdFromProvider == null) {
        // return error snackbar saying plant code is not registered.
        log("id is null");
        return "";
      }
      log("lastDigit: ${latestTicketIdFromProvider.substring(9)}");
      int digit = (int.parse((latestTicketIdFromProvider.substring(9))) + 1);
      final update = await context
          .read<DailyProductionRefineryProvider>()
          .updateAutoNumber(plantCode, digit);
      String lastDigit = digit.toString().padLeft(6, '0');
      if (lastDigit == "") {
        lastDigit = "1";
      }
      log("Last Digit: $lastDigit, is update successful: $update");
      String ticketPrefixQc = latestTicketIdFromProvider.substring(0, 9);
      log(ticketPrefixQc + lastDigit);

      return ticketPrefixQc + lastDigit;
    }

    int? parseInt(String value) {
      final text = value.trim();
      return text.isEmpty ? null : int.tryParse(text);
    }

    void showSnackBar(String message) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    final postingDate = getPostingDate();

    if (!context.mounted) return;

    final dataForm = widget.dataForm;
    final oilTypeFg =
        context
            .read<ValueProvider>()
            .oilTypeListsDailyProduction
            .where((oil) => oil.code == selectedOilRm)
            .first;

    oilTypefgController.text = oilTypeFg.outputOilType!;

    final ticketId = await buildTicketNumber();

    if (ticketId == "") {
      return;
    }

    try {
      final entity = DailyProductionRefineryEntity(
        id: ticketId,
        company: companyName,
        plant: currentPlant.code,
        transactionDate: getTransactionDate(),
        postingDate: postingDate,
        workCenter: selectedRefineryMachine,
        shift:
            selectedShiftBleaching ??
            getShiftBasedOnTimeAndDate(postingDate).toString(),
        cpoTank: selected1Tank,
        oilTypeRm: selectedOilRm,
        oilTypeRmAwalJam: selectedTime1Awal,
        oilTypeRmAwalFlowmeter: parseInt(flowmeter1AwalController.text),
        oilTypeRmAkhirJam: selectedTime1Akhir,
        oilTypeRmAkhirFlowmeter: parseInt(flowmeter1AkhirController.text),
        oilTypeRmTotal:
            (parseInt(flowmeter1AkhirController.text) ?? 0) -
            (parseInt(flowmeter1AwalController.text) ?? 0),
        oilTypeFg: selectedOilFg,
        oilTypeFgAwalJam: selectedTime2Awal,
        oilTypeFgAwalFlowmeter: parseInt(flowmeter2AwalController.text),
        oilTypeFgAkhirJam: selectedTime2Akhir,
        oilTypeFgAkhirFlowmeter: parseInt(flowmeter2AkhirController.text),
        oilTypeFgTotal:
            (parseInt(flowmeter2AkhirController.text) ?? 0) -
            (parseInt(flowmeter2AwalController.text) ?? 0),
        oilTypeFgToTank: selected2Tank,
        bpAwalJam: selectedTime3Awal,
        bpAwalFlowmeter: parseInt(flowmeter3AwalController.text),
        bpAkhirJam: selectedTime3Akhir,
        bpAkhirFlowmeter: parseInt(flowmeter3AkhirController.text),
        bpTotal:
            (parseInt(flowmeter3AkhirController.text) ?? 0) -
            (parseInt(flowmeter3AwalController.text) ?? 0),
        bpToTank: selected3Tank,
        beRefTank: selectedRefineryMachine,
        beRefQty: "1 Bag (1000 Kg)",
        beTotalBag: bleachingBagController.text,
        beTotalJenis: bleachingTypeController.text,
        beLotBatchNumber: parseInt(bleachingBagController.text),
        beYieldPercent: parseDouble(yieldPercentController),
        paRefTank: selectedRefineryMachine,
        paRefQty: paValue,
        paTotal: phosphoricTotalController.text,
        paLotBatchNumber: parseInt(phosphoricBatchController.text),
        paYieldPercent: parseDouble(phosphoricYieldController),
        remarks: remarksController.text,
        flag: 'T',
        uuItem: steamItem,
        uuBudgetRefTank: selectedRefineryMachine,
        uuBudgetQty: budgetValue,
        uuTotalCpo: parseInt(totalOilController.text),
        uuTotalSteam: parseInt(totalSteamController.text),
        uuSteamCpo: steamOilTypeController.text,
        uuYieldPercent: parseDouble(yieldPercentController),
        entryBy: currentUser?.username,
        entryDate: DateTime.now(),
        preparedBy: null,
        preparedDate: null,
        preparedStatus: null,
        verifiedBy: null,
        verifiedDate: null,
        verifiedStatus: null,
        checkedBy: null,
        checkedDate: null,
        checkedStatus: null,
        checkedStatusRemarks: null,
        formNo: dataForm.code,
        dateIssued: dataForm.dateIssued,
        revisionNo: dataForm.revisionNo,
        revisionDate: dataForm.revisionDate,
      );
      bool? success;

      log("Attempt to insert Daily Production.");
      success = await provider.insertTicket(entity);

      log("is success? $success");

      if (success) {
        if (!context.mounted) return;
        context.read<DailyProductionRefineryProvider>().fetchAllTickets(
          null,
          null,
          currentUser?.username ?? "",
          currentUser?.role ?? "",
          plantCode,
        );
        showSnackBar('Input Ticket berhasil.');
        Navigator.pop(context);
      } else {
        log('insert to QC Table is not successful.');
        showSnackBar('Input Report gagal: ${provider.errorMessage}.');
      }
    } catch (e) {
      log("Gagal menyimpan laporan: $e");
      showSnackBar("Gagal menyimpan laporan: $e");
    }
  }

  int getShiftBasedOnTimeAndDate(DateTime time) {
    int hour = time.hour;
    int day = time.weekday;
    log("Day: $day, Hour: $hour");

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
}
