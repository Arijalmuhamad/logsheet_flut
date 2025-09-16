import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_section_auxiliary_material.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
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
  String? selectedOilTypeFgToTank;
  int? selectedHour1Awal;
  int? selectedHour1Akhir;
  int? selectedHour2Awal;
  int? selectedHour2Akhir;
  int? selectedHour3Awal;
  int? selectedHour3Akhir;
  String? selectedPart;
  String? selectedRefineryMachine;

  // final List<String>? dummyLocations = ['Refinery', 'Fractination'];
  List<TankEntity>? tankLists;
  final List<String> parts = ['CPO', 'RPA', 'RPS'];
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
    super.dispose();
  }

  // void _showHourPicker(BuildContext context, int? selectedHour) {
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
  //             setState(() => selectedHour = hour);
  //           },
  //         ),
  //   );
  // }

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
      });
    }

    tankLists = context.read<ValueProvider>().tankSourceList;
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
            CustomDropdown.fromStringItems(
              hint: 'Pilih Part',
              prefixIcon: PrefixIconHelper.get('category-svgrepo-com'),
              stringItems: parts,
              value: selectedPart,
              onChanged: (value) => setState(() => selectedPart = value),
            ),
            const SizedBox(height: 16),

            if (selectedPart == null) ...[
              const Center(
                child: Text(
                  'Silakan pilih part terlebih dahulu',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ] else ...[
              // === Section: CPO RPA RPS ===
              SectionCpoRpaRps(
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
                dummmyTanks: tankLists,
                selectedTank: selected2Tank,
                onTankChanged: (value) => setState(() => selected2Tank = value),
                flowRateAwalController: flowRate2AwalController,
                flowRateAkhirController: flowRate2AkhirController,
                flowRateTotalController: flowRate2TotalController,
              ),
              const SizedBox(height: 16),

              // === Section: RFAD ===
              SectionRfad(
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
                tankLists: tankLists,
                selectedTank: selected3Tank,
                onTankChanged: (value) => setState(() => selected3Tank = value),
                flowRateAwalController: flowRate3AwalController,
                flowRateAkhirController: flowRate3AkhirController,
                flowRateTotalController: flowRate3TotalController,
              ),
              const SizedBox(height: 16),

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
                onRef500BleachingChanged:
                    (value) => setState(() => ref500Bleaching = value!),
                onRef150BleachingChanged:
                    (value) => setState(() => ref150Bleaching = value!),
                onPhosphoricShiftChanged:
                    (value) => setState(() => selectedShiftPhosphoric = value),
                onRef500PhosphoricChanged:
                    (value) => setState(() => ref500Phosphoric = value!),
                onRef150PhosphoricChanged:
                    (value) => setState(() => ref150Phosphoric = value!),
              ),
              const SizedBox(height: 16),

              // === Section: Remark ===
              SectionCard(
                title: 'Remark',
                children: [CustomRemarkField(controller: remarksController)],
              ),
              const SizedBox(height: 24),

              // === Submit Button ===
              CustomSaveButton(
                onPressed: () async => await submitReport(context),
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
    final oilTypeFg =
        context
            .read<ValueProvider>()
            .oilTypeLists
            .where((oil) => oil.code == selectedPart)
            .first;

    oilTypefgController.text = oilTypeFg.outputOilType!;

    try {
      final entity = DailyProductionRefineryEntity(
        id: await buildTicketNumber(),
        company: companyName,
        plant: currentPlant.code,
        transactionDate: getTransactionDate(),
        postingDate: postingDate,
        refineryMachine: selectedRefineryMachine,
        shift: getShiftBasedOnTimeAndDate(postingDate).toString(),
        cpoTank: selected1Tank,
        oilTypeRm: selectedPart,
        oilTypeRmAwalJam: convertStringTimeToDateTime(selectedHour1Awal),
        oilTypeRmAwalFlowmeter: parseInt(flowRate1AwalController.text),
        oilTypeRmAkhirJam: convertStringTimeToDateTime(selectedHour1Akhir),
        oilTypeRmAkhirFlowmeter: parseInt(flowRate1AkhirController.text),
        oilTypeRmTotal: parseInt(oilTypeRmTotalController.text),
        oilTypeFg: oilTypefgController.text,
        oilTypeFgAwalJam: convertStringTimeToDateTime(selectedHour2Awal),
        oilTypeFgAwalFlowmeter: parseInt(flowRate2AwalController.text),
        oilTypeFgAkhirJam: convertStringTimeToDateTime(selectedHour2Akhir),
        oilTypeFgAkhirFlowmeter: parseInt(flowRate2AkhirController.text),
        oilTypeFgTotal: parseInt(oilTypefgTotalController.text),
        oilTypeFgToTank: selected2Tank,
        bpAwalJam: convertStringTimeToDateTime(selectedHour3Awal),
        bpAwalFlowmeter: parseInt(flowRate3AwalController.text),
        bpAkhirJam: convertStringTimeToDateTime(selectedHour3Akhir),
        bpAkhirFlowmeter: parseInt(flowRate3AkhirController.text),
        bpTotal: parseInt(flowRate3TotalController.text),
        bpToTank: null,
        beRefTank: null,
        beRefQty: null,
        beTotalBag: null,
        beTotalJenis: beTotalJenisController.text,
        beLotBatchNumber: parseInt(beLotBatchNumberController.text),
        beYieldPercent: null,
        paRefTank: null,
        paRefQty: null,
        paTotal: null,
        paLotBatchNumber: null,
        paYieldPercent: null,
        remarks: null,
        uuItem: null,
        uuBudgetRefTank: null,
        uuBudgetQty: null,
        uuTotalCpo: null,
        uuTotalSteam: null,
        uuSteamCpo: null,
        uuYieldPercent: null,
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
        _showSnackBar('Input Ticket berhasil.');
        Navigator.pop(context);
      } else {
        log('insert to QC Table is not successful.');
        _showSnackBar('Input Report gagal: ${provider.errorMessage}.');
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
