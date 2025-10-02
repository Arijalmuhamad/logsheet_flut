import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/data/remote/master/value_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_section_cpo_rpa_rps.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_section_rbdpo_rrbdpo_rps.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_section_rfad.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/section_card.dart';
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
  bool isLoading = true;
  String? selected1Tank;
  String? selected2Tank;
  String? selected3Tank;

  String? selectedOilTypeFgToTank;

  // int? selectedHour1Awal;
  // int? selectedHour1Akhir;
  // int? selectedHour2Awal;
  // int? selectedHour2Akhir;
  // int? selectedHour3Awal;
  // int? selectedHour3Akhir;

  TimeOfDay? selectedHour1Awal;
  TimeOfDay? selectedHour1Akhir;
  TimeOfDay? selectedHour2Awal;
  TimeOfDay? selectedHour2Akhir;
  TimeOfDay? selectedHour3Awal;
  TimeOfDay? selectedHour3Akhir;

  String? selectedOilRm;
  String? selectedOilFg;
  String? selectedOilBp;
  String? selectedRefineryMachine;

  List<TankEntity>? tankLists;
  List<MasterValueEntity>? oilTypeLists;
  // final List<String> oilTypeRm = ['CPO', 'RPA', 'RPS'];
  // final List<String> oilTypeFg = ['RBDPO', 'RRBDPO', 'RRPS'];
  // final List<String> oilTypeBp = ['PFAD'];
  final List<String> dummyShiftOptions = ['I', 'II', 'III'];

  final TextEditingController flowRate1AwalController = TextEditingController();
  final TextEditingController flowRate1AkhirController =
      TextEditingController();
  final TextEditingController flowRate1TotalController =
      TextEditingController();

  final TextEditingController flowRate2AwalController = TextEditingController();
  final TextEditingController flowRate2AkhirController =
      TextEditingController();
  final TextEditingController flowRate2TotalController =
      TextEditingController();

  final TextEditingController flowRate3AwalController = TextEditingController();
  final TextEditingController flowRate3AkhirController =
      TextEditingController();
  final TextEditingController flowRate3TotalController =
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
  void dispose() {
    super.dispose();
    flowRate1AwalController.dispose();
    flowRate1AkhirController.dispose();
    flowRate1TotalController.dispose();
    flowRate2AwalController.dispose();
    flowRate2AkhirController.dispose();
    flowRate2TotalController.dispose();
    flowRate3AwalController.dispose();
    flowRate3AkhirController.dispose();
    flowRate3TotalController.dispose();
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
  }

  // void _showHourPickerAndUpdateState(
  //   Function(int) onHourSelected,
  //   int? selectedHour,
  // ) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder:
  //         (context) => CustomHourPicker(
  //           selectedHour: selectedHour,
  //           onHourSelected: (hour) {
  //             onHourSelected(hour);
  //           },
  //         ),
  //   );
  // }

  void _showHourPickerAndUpdateState(
    // Function(int) onHourSelected,
    // int? selectedHour,
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
          // (context) => CustomHourPicker(
          //   selectedHour: selectedHour,
          //   onHourSelected: (hour) {
          //     onHourSelected(hour);
          //     Navigator.pop(context);
          //   },
          // ),
          (context) => CustomHourMinutePicker(
            selectedTime: selectedTime,
            onTimeSelected: (time) {
              onTimeSelected(time);
            },
          ),
    );
  }

  Future<void> _refreshPage() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  void initState() {
    super.initState();
    final valueProvider = context.read<ValueProvider>();
    if (valueProvider.tankSourceList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await context.read<ValueProvider>().fetchAllInitialData();
      });
    }

    tankLists = context.read<ValueProvider>().tankSourceList;

    _prepopulateData();
  }

  @override
  Widget build(BuildContext context) {
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
                      hintText: 'Loading Refinery Machine...',
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
            // === Dropdown: Part ===
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

                if (provider.oilTypeLists.isEmpty) {
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
                        onPressed: () {
                          context.read<ValueProvider>().fetchOilTypes();
                        },
                      ),
                    ),
                  );
                }
                return DropdownButtonFormField<String>(
                  value: selectedOilRm,
                  items:
                      provider.oilTypeLists.map((oil) {
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
                selectedTimeAwal: selectedHour1Awal,
                selectedTimeAkhir: selectedHour1Akhir,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      selectedHour1Awal,
                      (hour) => setState(() {
                        selectedHour1Awal = hour;
                      }),
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      selectedHour1Akhir,
                      (hour) => setState(() {
                        selectedHour1Akhir = hour;
                      }),
                    ),
                dummmyTanks: tankLists,
                selectedTank: selected1Tank,
                onTankChanged: (value) => setState(() => selected1Tank = value),
                flowRateAwalController: flowRate1AwalController,
                flowRateAkhirController: flowRate1AkhirController,
                flowRateTotalController: flowRate1TotalController,
              ),
              const SizedBox(height: 16),

              // === Section: RBDPO RRBDPO RPS ===
              SectionRbdpoRrbdpoRps(
                selectedTimeAwal: selectedHour2Awal,
                selectedTimeAkhir: selectedHour2Akhir,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      selectedHour2Awal,
                      (hour) => setState(() {
                        selectedHour2Awal = hour;
                      }),
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      selectedHour2Akhir,
                      (hour) => setState(() {
                        selectedHour2Akhir = hour;
                      }),
                    ),
                tankList: tankLists,
                selectedTank: selected2Tank,
                onTankChanged: (value) => setState(() => selected2Tank = value),
                flowRateAwalController: flowRate2AwalController,
                flowRateAkhirController: flowRate2AkhirController,
                flowRateTotalController: flowRate2TotalController,
                oilList: oilTypeLists ?? [],
                selectedOil: selectedOilFg,
                onOilFgChanged:
                    (oilFg) => setState(() {
                      selectedOilFg = oilFg;
                    }),
              ),
              const SizedBox(height: 16),

              // === Section: RFAD ===
              SectionRfad(
                selectedTimeAwal: selectedHour3Awal,
                selectedTimeAkhir: selectedHour3Akhir,
                oilList: oilTypeLists ?? [],
                selectedOil: selectedOilBp,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      selectedHour3Awal,
                      (hour) => setState(() {
                        selectedHour3Awal = hour;
                      }),
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      selectedHour3Akhir,
                      (hour) => setState(() {
                        selectedHour3Akhir = hour;
                      }),
                    ),
                tankLists: tankLists,
                selectedTank: selected3Tank,
                onTankChanged: (value) => setState(() => selected3Tank = value),
                flowRateAwalController: flowRate3AwalController,
                flowRateAkhirController: flowRate3AkhirController,
                flowRateTotalController: flowRate3TotalController,
                onOilBpChanged:
                    (oil) => setState(() {
                      selectedOilBp = oil;
                    }),
              ),
              const SizedBox(height: 16),

              // === Section: Auxiliary Material ===
              // TODO: FIX AUXILIARY MATERIAL EDIT
              // SectionAuxiliaryMaterial(
              //   shiftOptions: dummyShiftOptions,
              //   selectedShiftBleaching: selectedShiftBleaching,
              //   selectedShiftPhosphoric: selectedShiftPhosphoric,
              //   bleachingBagController: bleachingBagController,
              //   bleachingTypeController: bleachingTypeController,
              //   bleachingBatchController: bleachingBatchController,
              //   ref500Bleaching: ref500Bleaching,
              //   ref150Bleaching: ref150Bleaching,
              //   phosphoricWeightController: phosphoricWeightController,
              //   phosphoricVolumeController: phosphoricVolumeController,
              //   phosphoricYieldController: phosphoricYieldController,
              //   phosphoricBatchController: phosphoricBatchController,
              //   ref500Phosphoric: ref500Phosphoric,
              //   ref150Phosphoric: ref150Phosphoric,
              //   onBleachingShiftChanged:
              //       (value) => setState(() => selectedShiftBleaching = value),
              //   onRef500BleachingChanged:
              //       (value) => setState(() => ref500Bleaching = value!),
              //   onRef150BleachingChanged:
              //       (value) => setState(() => ref150Bleaching = value!),
              //   onPhosphoricShiftChanged:
              //       (value) => setState(() => selectedShiftPhosphoric = value),
              //   onRef500PhosphoricChanged:
              //       (value) => setState(() => ref500Phosphoric = value!),
              //   onRef150PhosphoricChanged:
              //       (value) => setState(() => ref150Phosphoric = value!),
              // ),
              const SizedBox(height: 16),

              // === Section: Remark ===
              SectionCard(
                title: 'Remark',
                children: [CustomRemarkField(controller: remarksController)],
              ),
              const SizedBox(height: 24),

              // === Submit Button ===
              CustomSaveButton(
                onPressed: () async {
                  // return await submitReport(context);
                },
                label: 'Submit Laporan',
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _prepopulateData() {
    //TODO: CHECK EDIT DATA
    // final entity = widget.entity;

    // // Set top-level dropdowns
    // selectedRefineryMachine = entity.refineryMachine;
    // selectedOilRm = entity.oilTypeRm?.trim();
    // // selected =
    // //     entity.shift; // Used for both Bleaching and Phosphoric sections

    // // Section 1: CPO / RPA / RPS (Raw Material)
    // selected1Tank = entity.cpoTank;
    // selectedHour1Awal = _parseHour(entity.oilTypeRmAwalJam);
    // selectedHour1Akhir = _parseHour(entity.oilTypeRmAkhirJam);
    // flowRate1AwalController.text =
    //     entity.oilTypeRmAwalFlowmeter?.toString() ?? '';
    // flowRate1AkhirController.text =
    //     entity.oilTypeRmAkhirFlowmeter?.toString() ?? '';
    // flowRate1TotalController.text = entity.oilTypeRmTotal?.toString() ?? '';

    // // Section 2: RBDPO / RRBDPO / RRPS (Finished Good)
    // selectedOilFg = entity.oilTypeFg?.trim();
    // selected2Tank = entity.oilTypeFgToTank;
    // selectedHour2Awal = _parseHour(entity.oilTypeFgAwalJam);
    // selectedHour2Akhir = _parseHour(entity.oilTypeFgAkhirJam);
    // flowRate2AwalController.text =
    //     entity.oilTypeFgAwalFlowmeter?.toString() ?? '';
    // flowRate2AkhirController.text =
    //     entity.oilTypeFgAkhirFlowmeter?.toString() ?? '';
    // flowRate2TotalController.text = entity.oilTypeFgTotal?.toString() ?? '';

    // // Section 3: PFAD (By-Product)
    // // selectedOilBp =
    // //     oilTypeBp.isNotEmpty ? oilTypeBp.first : null; // Default to PFAD
    // selectedOilBp = "PFAD"; // Default to PFAD
    // selected3Tank = entity.bpToTank?.toString();
    // selectedHour3Awal = _parseHour(entity.bpAwalJam);
    // selectedHour3Akhir = _parseHour(entity.bpAkhirJam);
    // flowRate3AwalController.text = entity.bpAwalFlowmeter?.toString() ?? '';
    // flowRate3AkhirController.text = entity.bpAkhirFlowmeter?.toString() ?? '';
    // flowRate3TotalController.text = entity.bpTotal?.toString() ?? '';

    // // Section 4: Auxiliary Material
    // // Bleaching Earth
    // selectedShiftBleaching = entity.shift;
    // bleachingBagController.text = entity.beTotalBag ?? '';
    // bleachingTypeController.text = entity.beTotalJenis ?? '';
    // bleachingBatchController.text = entity.beLotBatchNumber?.toString() ?? '';
    // if (entity.beRefTank != null) {
    //   ref500Bleaching = entity.beRefTank!.contains('500');
    //   ref150Bleaching = entity.beRefTank!.contains('150');
    // }

    // // Phosphoric Acid
    // selectedShiftPhosphoric = entity.shift;
    // phosphoricWeightController.text = entity.paTotal ?? '';
    // phosphoricYieldController.text = entity.paYieldPercent?.toString() ?? '';
    // phosphoricBatchController.text = entity.paLotBatchNumber?.toString() ?? '';
    // if (entity.paRefTank != null) {
    //   ref500Phosphoric = entity.paRefTank!.contains('500');
    //   ref150Phosphoric = entity.paRefTank!.contains('150');
    // }

    // // Section 5: Remarks
    // remarksController.text = entity.remarks ?? '';
  }
}
