import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/data/remote/master/value_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_olein_solein_sstearin.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_rbdpo_rol_rps.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_stearin_pmf_hstrearin.dart';

import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/admin/widgets/section_card.dart';
import 'package:logsheet_app/providers/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/product_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionFractinationInputPage extends StatefulWidget {
  final String userName;
  final DataFormNoEntity dataForm;

  const DailyProductionFractinationInputPage({
    super.key,
    required this.userName,
    required this.dataForm,
  });

  @override
  State<DailyProductionFractinationInputPage> createState() =>
      _DailyProductionFractionPageState();
}

class _DailyProductionFractionPageState
    extends State<DailyProductionFractinationInputPage> {
  bool isLoading = true;
  bool isUtillityUsageActive = false;
  String? steamItem = "Steam (Ton/Ton CPO)";
  String? selected1Tank;
  String? selected2Tank;
  String? selected3Tank;
  String? selectedOilRm;
  String? selectedOilFg;
  String? selectedOilBp;
  String? selectedOilTypeFgToTank;
  TimeOfDay? selectedTime1Awal;
  TimeOfDay? selectedTime1Akhir;
  TimeOfDay? selectedTime2Awal;
  TimeOfDay? selectedTime2Akhir;
  TimeOfDay? selectedTime3Awal;
  TimeOfDay? selectedTime3Akhir;

  // String? selectedMachine;

  DateTime selectedTransactionDate = DateTime.now();

  String? selectedWorkCenter;
  String? budgetValue;

  // Dummy data
  Map<String, double> utilityBudget = {'FRAC-02': 0.06, 'FRAC-01': 0.05};

  List<TankEntity>? tankLists;
  List<MasterValueEntity>? oilLists;
  // final List<String> oilTypeFg = ['OLEIN', 'SUPER OLEIN', 'SOFT STEARIN'];
  // final List<String> oilTypeRm = ['RBDPO', 'ROL', 'RPS'];
  // final List<String> oilTypeBp = ['STEARIN', 'PMF', 'HARD STEARIN'];
  final List<String> dummyShiftOptions = ['1', '2', '3', '4', '5'];

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

  final TextEditingController flowMeterController = TextEditingController();
  final TextEditingController no1Controller = TextEditingController();
  final TextEditingController no2Controller = TextEditingController();
  final TextEditingController no3Controller = TextEditingController();
  final TextEditingController cr1Controller = TextEditingController();
  final TextEditingController cr2Controller = TextEditingController();

  String? selectedShiftBleaching;

  final TextEditingController remarksController = TextEditingController();
  final uuFlowmeterBefore = TextEditingController();
  final uuFlowmeterAfter = TextEditingController();
  final uuFlowmeterTotal = TextEditingController();
  final uuYieldController = TextEditingController();
  final uuListrikController = TextEditingController();
  final uuAirController = TextEditingController();

  @override
  void dispose() {
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
    flowMeterController.dispose();
    uuFlowmeterBefore.dispose();
    uuFlowmeterAfter.dispose();
    uuFlowmeterTotal.dispose();
    uuYieldController.dispose();
    uuListrikController.dispose();
    uuAirController.dispose();

    super.dispose();

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
    Function(TimeOfDay) onTimeSelected,
    TimeOfDay? selectedTime,
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
      // builder:
      //     (context) => CustomHourPicker(
      //       selectedHour: selectedHour,
      //       onHourSelected: (hour) {
      //         onHourSelected(hour);
      //         // Navigator.pop(context);
      //       },
      //     ),
    );
  }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => isLoading = false);
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
  void initState() {
    super.initState();
    final valueProvider = context.read<ValueProvider>();
    final productProvider = context.read<ProductProvider>();

    if (valueProvider.tankSourceList.isEmpty ||
        productProvider.productFractionationList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await valueProvider.fetchAllInitialData();
        await productProvider.fetchProducts();
        tankLists = valueProvider.tankSourceList;
      });
    }

    flowmeter1AwalController.addListener(_calculateTotalFlowmeter);
    flowmeter1AkhirController.addListener(_calculateTotalFlowmeter);

    flowmeter2AwalController.addListener(_calculateTotalFlowmeter);
    flowmeter2AkhirController.addListener(_calculateTotalFlowmeter);

    flowmeter3AwalController.addListener(_calculateTotalFlowmeter);
    flowmeter3AkhirController.addListener(_calculateTotalFlowmeter);

    uuFlowmeterBefore.addListener(_calculateTotalFlowmeter);
    uuFlowmeterAfter.addListener(_calculateTotalFlowmeter);
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
    budgetValue =
        selectedWorkCenter != null &&
                utilityBudget.containsKey(selectedWorkCenter)
            ? selectedWorkCenter == 'FRAC-02'
                ? '${utilityBudget['FRAC-02']}'
                : '${utilityBudget['FRAC-01']}'
            : 'N/A';
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title: 'Daily Production - Fractionation (${widget.dataForm.code})',
        onRefresh: _refreshPage,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === Dropdown: Plant ===
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isWorkCenterFractLoading) {
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
                if (provider.workCenterFractLists.isEmpty) {
                  return TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Fract. Machine tidak ditemukan.',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.warning_amber_rounded),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await context
                              .read<ValueProvider>()
                              .fetchWorkCenterFractLists();
                        },
                      ),
                    ),
                  );
                }
                return DropdownButtonFormField<String>(
                  value: selectedWorkCenter,
                  items:
                      provider.workCenterFractLists.map((machine) {
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
                      selectedWorkCenter = value;
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

            // Oil Type Dropdown
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
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

                if (provider.productFractionationList.isEmpty) {
                  log(
                    "FRACTIONATION LIST LENGTH: ${provider.productFractionationList.length}",
                  );
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
                          await provider.fetchProducts();
                        },
                      ),
                    ),
                  );
                }
                log(
                  "FRACTIONATION LIST LENGTH: ${provider.productFractionationList.length}",
                );
                return DropdownButtonFormField<String>(
                  value: selectedOilRm,
                  items:
                      provider.productFractionationList.map((oil) {
                        return DropdownMenuItem<String>(
                          value: oil.id,
                          child: Text(
                            oil.rawMaterial!,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOilRm = value;

                      selectedOilFg =
                          provider.productFractionationList
                              .firstWhere((item) => item.id == selectedOilRm)
                              .id;

                      selectedOilBp =
                          provider.productFractionationList
                              .firstWhere((item) => item.id == selectedOilRm)
                              .id;
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
                selectedTimeAwal: selectedTime1Awal,
                selectedTimeAkhir: selectedTime1Akhir,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedTime1Awal = hour;
                      }),
                      selectedTime1Awal,
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedTime1Akhir = hour;
                      }),
                      selectedTime1Akhir,
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
                selectedTimeAwal: selectedTime2Awal,
                selectedTimeAkhir: selectedTime2Akhir,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedTime2Awal = hour;
                      }),
                      selectedTime2Awal,
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedTime2Akhir = hour;
                      }),
                      selectedTime2Akhir,
                    ),
                flowmeterAwalController: flowmeter2AwalController,
                flowmeterAkhirController: flowmeter2AkhirController,
                flowmeterTotalController: flowmeter2TotalController,
                selectedOil: selectedOilFg,
                onOilFgChanged:
                    (oil) => setState(() {
                      selectedOilFg = oil;
                    }),
              ),
              // === Section:STEARIN/PMF/HARD STEARIN
              FraSectionStearinPmfHstrearin(
                noController: no3Controller,
                tanksList: tankLists ?? [],
                onTankChanged: (value) => setState(() => selected2Tank = value),
                selectedTank: selected3Tank,
                selectedTimeAwal: selectedTime3Awal,
                selectedTimeAkhir: selectedTime3Akhir,
                onTimeTapAwal:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedTime3Awal = hour;
                      }),
                      selectedTime3Awal,
                    ),
                onTimeTapAkhir:
                    () => _showHourPickerAndUpdateState(
                      (hour) => setState(() {
                        selectedTime3Akhir = hour;
                      }),
                      selectedTime3Akhir,
                    ),
                flowmeterAwalController: flowmeter3AwalController,
                flowmeterAkhirController: flowmeter3AkhirController,
                flowmeterTotalController: flowmeter3TotalController,
                selectedOil: selectedOilBp,
                onOilFgChanged:
                    (oil) => setState(() {
                      selectedOilBp = oil;
                    }),
              ),

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
                      onConfirm: () async => await save(),
                    ),
                label: 'Submit Laporan',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> save() async {
    final provider = context.read<DailyProductionFractionationProvider>();
    final currentUser = context.read<UserProvider>().currentUser;
    final currentPlant = context.read<PlantProvider>().currentPlant;
    final plantCode = currentPlant!.code;
    final companyName =
        context.read<BusinessUnitProvider>().currentBusinessUnit?.buName;

    DateTime getTransactionDate() {
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

    DateTime getPostingDate() {
      final DateTime now = selectedTransactionDate;

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
        .read<DailyProductionFractionationProvider>()
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
          .read<DailyProductionFractionationProvider>()
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

    void _showSnackBar(String message) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    String? convertStringTimeToDateTime(int? hour) {
      try {
        log("$hour");
        if (hour == null) {
          return null;
        }

        if (hour < 0 || hour > 23) {
          throw FormatException(
            "Hour must be between 0 and 23, but was $hour.",
          );
        }
        final formattedHour = "${hour.toString().padLeft(2, '0')}:00";

        return formattedHour;
      } on FormatException catch (e) {
        log("Error processing time string '$hour': $e");
        rethrow;
      }
    }

    final postingDate = getPostingDate();

    if (!context.mounted) return;

    final dataForm = widget.dataForm;

    final ticketId = await buildTicketNumber();

    if (ticketId == "") {
      return;
    }
    // log("${convertStringTimeToDateTime(selectedTime1Awal)}");
    // log("${convertStringTimeToDateTime(selectedHour2Awal)}");
    // log("${convertStringTimeToDateTime(selectedHour3Awal)}");
    log('SELECTED TIME 1 AWAL: $selectedTime1Awal');

    try {
      final entity = DailyProductionFractionationEntity(
        id: ticketId,
        company: companyName,
        plant: currentPlant.code,
        transactionDate: getTransactionDate(),
        postingDate: postingDate,
        workCenter: selectedWorkCenter,
        shift: getShiftBasedOnTimeAndDate(postingDate).toString(),
        // cpoTank: selected1Tank,
        oilTypeRmId: selectedOilRm,
        oilTypeRmNo: parseInt(no1Controller.text),
        oilTypeRmCr: parseInt(cr1Controller.text),
        oilTypeRmFromTank: selected1Tank,
        oilTypeRmAwalJam: selectedTime1Awal,
        oilTypeRmAwalFlowmeter: parseInt(flowmeter1AwalController.text),
        oilTypeRmAkhirJam: selectedTime1Akhir,
        oilTypeRmAkhirFlowmeter: parseInt(flowmeter1AkhirController.text),
        oilTypeRmTotal: parseInt(flowmeter1TotalController.text),
        oilTypeFgsId: selectedOilFg,
        oilTypeFgsNo: parseInt(no2Controller.text),
        oilTypeFgsCr: parseInt(cr2Controller.text),
        oilTypeFgsAwalJam: selectedTime2Awal,
        oilTypeFgsAwalFlowmeter: parseInt(flowmeter2AwalController.text),
        oilTypeFgsAkhirJam: selectedTime2Akhir,
        oilTypeFgsAkhirFlowmeter: parseInt(flowmeter2AkhirController.text),
        oilTypeFgsTotal: parseInt(flowmeter2TotalController.text),
        oilTypeFgsToTank: selected2Tank,
        oilTypeFghId: selectedOilBp,
        oilTypeFghNo: parseInt(no3Controller.text),
        oilTypeFghAwalJam: selectedTime3Awal,
        oilTypeFghAwalFlowmeter: parseDouble(flowmeter3AwalController),
        oilTypeFghAkhirJam: selectedTime3Akhir,
        oilTypeFghAkhirFlowmeter: parseDouble(flowmeter3AkhirController),
        oilTypeFghTotal: parseDouble(flowmeter3TotalController),
        oilTypeFghToTank: selected3Tank,
        uuItem: steamItem,
        uuBudgetRefQty: budgetValue,
        uuFlowmeterBefore: parseInt(uuFlowmeterBefore.text),
        uuFlowmeterAfter: parseInt(uuFlowmeterAfter.text),
        uuFlowmeterTotal: parseInt(uuFlowmeterTotal.text),
        uuListrik: parseInt(uuListrikController.text),
        uuAir: parseInt(uuAirController.text),
        uuYieldPercent: parseDouble(uuYieldController),
        remarks: remarksController.text,
        flag: 'T',
        entryBy: currentUser?.username,
        entryDate: DateTime.now(),
        preparedBy: null,
        preparedDate: null,
        preparedStatus: null,
        preparedStatusRemarks: null,
        verifiedBy: null,
        verifiedDate: null,
        verifiedStatus: null,
        verifiedStatusRemarks: null,
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

      success = await provider.insertTicket(entity);

      log("is success? $success");
      if (success) {
        if (!mounted) return;
        context.read<DailyProductionFractionationProvider>().fetchAllTickets(
          null,
          null,
          currentUser?.username ?? "",
          currentUser?.role ?? "",
          plantCode,
        );
        _showSnackBar('Input berhasil.');
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        _showSnackBar('Error Input.');
      }
    } catch (e) {
      log("Gagal menyimpan laporan: $e");
      _showSnackBar("Gagal menyimpan laporan: $e");
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
