import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_olein_solein_sstearin.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_rbdpo_rol_rps.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_section_stearin_pmf_hstrearin.dart';

import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/section_card.dart';
import 'package:logsheet_app/providers/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
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

  String? selectedLocation;

  // Dummy data
  final List<String> dummyLocations = ['Fract. 500', 'Fract. 400'];
  List<TankEntity>? tankLists;
  final List<String> dummyParts = ['RBDPO', 'ROL', 'RPS'];
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
    flowMaterController.dispose();
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
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) async => await valueProvider.fetchAllInitialData(),
      );
    }

    tankLists = valueProvider.tankSourceList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title: 'Daily Production - Fractination (${widget.dataForm.code})',
        onRefresh: _refreshPage,
      ),
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
              hint: 'Pilih Part',
              prefixIcon: PrefixIconHelper.get('category-svgrepo-com'),
              stringItems: dummyParts,
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
                flowMaterAwalController: flowmeter1AwalController,
                flowMaterAkhirController: flowmeter1AkhirController,
                flowMaterTotalController: flowmeter1TotalController,
              ),

              // === Section:OLEIN/SUPER OLEIN/SOFT STEARIN
              FraSectionOleinSoleinSstearin(
                noController: no2Controller,
                crController: cr2Controller,
                dummyTanks: tankLists ?? [],
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
              ),
              // === Section:STEARIN/PMF/HARD STEARIN
              FraSectionStearinPmfHstrearin(
                noController: no3Controller,
                dummyTanks: tankLists ?? [],
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
              ),
              SectionCard(
                title: 'Remark',
                children: [CustomRemarkField(controller: remarksController)],
              ),
              const SizedBox(height: 24),

              // === Submit Button ===
              CustomSaveButton(onPressed: save, label: 'Submit Laporan'),
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

    try {
      final entity = DailyProductionFractionationEntity(
        id: await buildTicketNumber(),
        company: companyName,
        plant: currentPlant.code,
        transactionDate: getTransactionDate(),
        postingDate: postingDate,
        workCenter: selectedPart,
        shift: getShiftBasedOnTimeAndDate(postingDate).toString(),
        cpoTank: selected1Tank,
        oilTypeRm: selectedPart,
        oilTypeRmAwalJam: convertStringTimeToDateTime(selectedHour1Awal),
        oilTypeRmAwalFlowmeter: parseInt(flowmeter1AwalController.text),
        oilTypeRmAkhirJam: convertStringTimeToDateTime(selectedHour1Akhir),
        oilTypeRmAkhirFlowmeter: parseInt(flowmeter1AkhirController.text),
        oilTypeRmTotal: parseInt(flowmeter1TotalController.text), //TODO
        oilTypeFg: selectedPart, //TODO
        oilTypeFgAwalJam: convertStringTimeToDateTime(selectedHour2Awal),
        oilTypeFgAwalFlowmeter: parseInt(flowmeter2AwalController.text),
        oilTypeFgAkhirJam: convertStringTimeToDateTime(selectedHour2Akhir),
        oilTypeFgAkhirFlowmeter: parseInt(flowmeter2AkhirController.text),
        oilTypeFgTotal: parseInt(flowmeter2TotalController.text),
        oilTypeFgToTank: selected2Tank,
        bpAwalJam: convertStringTimeToDateTime(selectedHour3Awal),
        bpAwalFlowmeter: parseInt(flowmeter3AwalController.text),
        bpAkhirJam: convertStringTimeToDateTime(selectedHour3Akhir),
        bpAkhirFlowmeter: parseInt(flowmeter3AkhirController.text),
        bpTotal: parseInt(flowmeter3TotalController.text),
        bpToTank: null,
        beRefTank: null,
        beRefQty: null,
        beTotalBag: null,
        beTotalJenis: null,
        beLotBatchNumber: null,
        beYieldPercent: null,
        paRefTank: null,
        paRefQty: null,
        paTotal: null,
        paLotBatchNumber: null,
        paYieldPercent: null,
        uuItem: null,
        uuBudgetRefTank: null,
        uuBudgetQty: null,
        uuTotalCPO: null,
        uuTotalSteam: null,
        uuSteamCPO: null,
        uuYieldPercent: null,
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
