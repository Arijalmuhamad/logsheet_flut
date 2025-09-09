import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/quality_refinery/quality_refinery_entity.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_production_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_qc_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

import 'package:logsheet_app/core/database/app_database.dart';
import '../../../../../providers/master/user_provider.dart';

class QualityReportInputQCPage extends StatefulWidget {
  final String userName;

  const QualityReportInputQCPage({super.key, required this.userName});

  @override
  State<QualityReportInputQCPage> createState() =>
      _QualityReportInputQCPageState();
}

class _QualityReportInputQCPageState extends State<QualityReportInputQCPage> {
  // Database & DAO

  // Data dropdown & kontrol
  String? selectedTankSource;
  String? selectedPartSource;

  // late Future<void> _fetchOilTypes;
  String? selectedOilType;
  String? selectedWorkCenter;
  int? selectedHour;
  String? selectedToTankGroup;
  String? selectedBpToTank;
  // String? selectedPart;
  String? selectedCcat;
  String? selectedBcat;
  String? selectedRcat;
  String? selectedFPcat;

  String? entryBy;
  String? checkedBy;

  int currentStep = 0;
  bool isLoading = false;
  // bool isOthersSelected = false;

  // List data utama
  List<TQualityReportRefineryData> qualityReportsRefinery = [];
  TQualityReportRefineryData? editingQualityReportsRefinery;

  // ==========================
  // Text Controllers
  // ==========================

  final TextEditingController dateEntryController = TextEditingController();
  final TextEditingController fgTankToOthersRemarkController =
      TextEditingController();

  // CPO / CPKO (Part) ✅
  final TextEditingController rmFlowRateController = TextEditingController();
  final TextEditingController rmTempController = TextEditingController();
  final TextEditingController rmFFAController = TextEditingController();
  final TextEditingController rmIVController = TextEditingController();
  final TextEditingController rmDOBIController = TextEditingController();
  final TextEditingController rmMNIController = TextEditingController();
  final TextEditingController rmPVController = TextEditingController();
  final TextEditingController rmANVController = TextEditingController();
  final TextEditingController rmToToxController = TextEditingController();
  final TextEditingController rmColorRController = TextEditingController();
  final TextEditingController rmColorYController = TextEditingController();
  final TextEditingController rmColorBController = TextEditingController();

  // BPO
  final TextEditingController boColorRController = TextEditingController();
  final TextEditingController boColorYController = TextEditingController();
  final TextEditingController boColorBController = TextEditingController();
  final TextEditingController boBreakTestController = TextEditingController();

  // RPO
  final TextEditingController fgFFAController = TextEditingController();
  final TextEditingController fgIVController = TextEditingController();
  final TextEditingController fgPVController = TextEditingController();
  final TextEditingController fgMoisture = TextEditingController();
  final TextEditingController fgImpurities = TextEditingController();
  final TextEditingController fgColorRController = TextEditingController();
  final TextEditingController fgColorYController = TextEditingController();
  final TextEditingController fgColorBController = TextEditingController();

  // RFAD
  final TextEditingController bpFFAController = TextEditingController();
  final TextEditingController bpMNIController = TextEditingController();
  final TextEditingController bpToTankController = TextEditingController();

  // W SBE QC
  // ignore: non_constant_identifier_names
  final TextEditingController WOCQCController = TextEditingController();
  final TextEditingController wasteMNIController = TextEditingController();

  // Remark
  final TextEditingController remarkController = TextEditingController();

  final logger = Logger();

  DataFormNoEntity? formData;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<ValueProvider>().fetchAllInitialData();
    // });

    rmFlowRateController.addListener(() {
      log('FlowRate changed: ${rmFlowRateController.text}');
    });

    rmTempController.addListener(() {
      log('Temp changed: ${rmTempController.text}');
    });
  }

  Future<void> _resetForm() async {
    selectedTankSource = null;
    selectedPartSource = null;
    selectedHour = null;
    selectedOilType = null;
    // selectedPart = null;
    selectedCcat = null;
    selectedBcat = null;
    selectedRcat = null;
    selectedFPcat = null;
    selectedWorkCenter = null;
    selectedBpToTank = null;

    // Part input
    for (var c in [
      rmFlowRateController,
      rmTempController,
      rmFFAController,
      rmIVController,
      rmPVController,
      rmANVController,
      rmToToxController,
      rmColorRController,
      rmColorYController,
      rmColorBController,
      rmDOBIController,
      rmMNIController,
    ]) {
      c.clear();
    }

    // BPO
    boColorRController.clear();
    boColorYController.clear();
    boColorBController.clear();
    boBreakTestController.clear();

    // RPO
    for (var c in [
      fgFFAController,
      fgColorRController,
      fgColorYController,
      fgColorBController,
      fgIVController,
      fgPVController,
      fgMoisture,
      fgImpurities,
    ]) {
      c.clear();
    }

    // PFAD
    bpFFAController.clear();
    bpMNIController.clear();
    bpToTankController.clear();

    //WSBEQC
    WOCQCController.clear();
    wasteMNIController.clear();

    // Remarks
    remarkController.clear();

    await context.read<ValueProvider>().fetchAllInitialData();
  }

  @override
  void dispose() {
    final controllers = [
      rmFlowRateController,
      // Part
      rmTempController,
      rmFFAController, rmIVController, rmPVController,
      rmANVController,
      rmToToxController,
      rmColorRController,
      rmColorYController,
      rmColorBController,
      rmDOBIController,
      rmMNIController,

      // BPO
      boColorRController,
      boColorYController,
      boColorBController,
      boBreakTestController,
      // RPO
      fgFFAController,
      fgColorRController,
      fgColorYController,
      fgColorBController,
      fgIVController,
      fgPVController,
      fgMoisture, fgImpurities,
      // PFAD
      bpFFAController, bpMNIController, bpToTankController,

      //WSBEQC
      WOCQCController, wasteMNIController,
      // Remarks
      remarkController,
    ];

    for (var c in controllers) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = context.read<UserProvider>();
    if (entryBy == null && userProvider.userName.isNotEmpty) {
      setState(() => entryBy = userProvider.userName);
    }
  }

  bool _validateCurrentStep() {
    String? errorMessage;

    if (selectedTankSource == null ||
        selectedHour == null ||
        selectedOilType == null ||
        selectedWorkCenter == null) {
      errorMessage =
          "Mohon lengkapi Work Center, Oil Type, Tank Source dan Jam Input.";
    } else {
      switch (currentStep) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          if (selectedToTankGroup == null) {
            errorMessage = "Mohon isi To Tank Group.";
          }
          break;
        case 3:
          if (selectedToTankGroup == null) {
            errorMessage = "Mohon isi To Tank Group.";
          }
          break;
        case 4:
          if (selectedToTankGroup == null) {
            errorMessage = "Mohon isi To Tank Group.";
          }
          break;
        case 5:
          if (selectedToTankGroup == null) {
            errorMessage = "Mohon isi To Tank Group.";
          }
          break;
      }
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red[700],
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    await _resetForm();
    currentStep = 0;
    setState(() => isLoading = false);
  }

  // Navigasi Stepper
  void _nextStep() {
    if (_validateCurrentStep()) {
      if (currentStep < 5) setState(() => currentStep++);
    }
  }

  void _prevStep() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  void _goToStep(int step) {
    if (step < currentStep) {
      setState(() => currentStep = step);
    } else {
      // For jumping forward, validate current step
      if (_validateCurrentStep()) {
        setState(() => currentStep = step);
      }
    }
  }

  // Save Data
  bool isSaving = false;

  void _showAlertDialog(BuildContext context) {
    log("Show Dialog function");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        bool isLoading = context.watch<QualityReportQCProvider>().isLoading;
        return AlertDialog(
          title: const Text("Konfirmasi Input"),
          content: Text("Apakah data yang anda masukkan sudah sesuai?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tidak", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed:
                  isLoading
                      ? null
                      : () async {
                        await _saveQualityReport();
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
              child: Consumer<QualityReportQCProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return SizedBox(
                      width: 6,
                      height: 6,
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  }
                  return Text("Ya");
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveQualityReport() async {
    final reportProvider = context.read<QualityReportQCProvider>();
    final userProvider = context.read<UserProvider>();
    final plantProvider = context.read<PlantProvider>();
    log('Save report button clicked.');

    if (!_validateCurrentStep()) {
      // validate before saving
      return;
    }
    setState(() => isSaving = true);

    final tanksource = selectedTankSource;
    // final ppart = selectedPart;
    // final partsource = selectedPartSource;
    // Provider.of<UserProvider>(context, listen: false)
    // Provider.of<PlantProvider>(context, listen: false)

    final businessUnitCode =
        context.read<BusinessUnitProvider>().currentBusinessUnit?.buCode ?? "";
    final plantCode = plantProvider.currentPlant?.code ?? "";

    final latestTicketIdFromProvider = await reportProvider.fetchLatestId(
      plantCode,
    );

    log("Business Unit: $businessUnitCode, Plant Code: $plantCode");

    final String formattedTime =
        selectedHour != null
            ? '${selectedHour.toString().padLeft(2, '0')}:00:00'
            : '';
    // Validasi input wajib
    // if (tanksource == null || formattedTime.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Mohon lengkapi Tank Source dan Jam Input'),
    //     ),
    //   );
    //   setState(() => isSaving = false);
    //   return;
    // }

    // Fungsi bantu untuk parsing angka
    double? parseDouble(TextEditingController c) {
      final text = c.text.trim();
      return text.isEmpty || text == "-"
          ? null
          : double.parse(double.parse(text).toStringAsFixed(4));
    }

    // double parseDoubleString(String c) {
    //   return c.isEmpty ? 0.0 : double.parse(double.parse(c).toStringAsFixed(2));
    // }

    // int? parseInt(String value) {
    //   final text = value.trim();
    //   return text.isEmpty ? null : int.tryParse(text);
    // }

    DateTime getPostingDate() {
      final DateTime now = DateTime.now();

      final int hour = selectedHour ?? now.hour;

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
          .read<QualityReportQCProvider>()
          .updateAutoNumber(plantCode, digit);
      String lastDigit = digit.toString().padLeft(6, '0');
      if (lastDigit == "") {
        lastDigit = "1";
      }
      log("Last Digit: $lastDigit, is update successful: $update");
      String ticketPrefix = latestTicketIdFromProvider.substring(0, 9);
      log(ticketPrefix + lastDigit);

      return ticketPrefix + lastDigit;
    }

    try {
      final time = DateFormat('HH:mm:ss').parse(formattedTime);

      if (!mounted) return;
      final providerQC = context.read<QualityReportQCProvider>();
      final providerProd = context.read<QualityReportProductionProvider>();

      final currentUser = context.read<UserProvider>().currentUser;

      log("current user: ${currentUser?.username}");
      if (bpToTankController.text.trim() != "") {
        selectedBpToTank = bpToTankController.text;
      }
      final postingDate = getPostingDate();
      final fullDateTimeForShift = DateTime(
        postingDate.year,
        postingDate.month,
        postingDate.day,
        selectedHour!,
      );

      log("Form ID: ${formData!.code}");
      final entity = QualityRefineryEntity(
        id: await buildTicketNumber(),
        transactionDate: getTransactionDate(),
        postingDate: postingDate,
        time: time,
        shift: getShiftBasedOnTimeAndDate(fullDateTimeForShift),
        rmTankSource: tanksource,
        rmFlowRate: parseDouble(rmFlowRateController),
        rmTemp: parseDouble(rmTempController),
        rmFFA: parseDouble(rmFFAController),
        rmIV: parseDouble(rmIVController),
        rmPV: parseDouble(rmPVController),
        rmAV: parseDouble(rmANVController),
        rmDobi: parseDouble(rmDOBIController),
        rmMNI: parseDouble(rmMNIController),
        rmToTox: parseDouble(rmToToxController),
        rmColorR: parseDouble(rmColorRController),
        rmColorY: parseDouble(rmColorYController),
        rmColorB: parseDouble(rmColorBController),
        boColorR: parseDouble(boColorRController),
        boColorY: parseDouble(boColorYController),
        boColorB: parseDouble(boColorBController),
        boBreakTest: boBreakTestController.text.trim(),
        fgFFA: parseDouble(fgFFAController),
        fgColorR: parseDouble(fgColorRController),
        fgColorY: parseDouble(fgColorYController),
        fgColorB: parseDouble(fgColorBController),
        fgIV: parseDouble(fgIVController),
        fgMoisture: parseDouble(fgMoisture),
        fgImpurities: parseDouble(fgImpurities),
        fgTankToOthersRemarks: fgTankToOthersRemarkController.text,
        bpFFA: parseDouble(bpFFAController),
        bpMNI: parseDouble(bpMNIController),
        bpToTank: selectedBpToTank,
        wSBEQC: parseDouble(WOCQCController),
        wasteMNI: parseDouble(wasteMNIController),
        remarks: (remarkController.text),
        checkedBy: null,
        checkedDate: null,
        preparedBy: null,
        preparedDate: null,
        preparedStatusRemarks: null,
        company: businessUnitCode,
        plant: plantCode,
        flag: "T",
        entryBy: currentUser?.username,
        entryDate: DateTime.now(),
        oilType: selectedOilType,
        fgTankTo: selectedToTankGroup,

        fgPV: parseDouble(fgPVController),
        preparedStatus: null,
        checkedStatus: null,
        checkedStatusRemarks: null,
        workCenter: selectedWorkCenter,
        updatedBy: null,
        updatedDate: null,
        formNo: formData!.code,
        dateIssued: formData!.dateIssued,
        revisionNo: formData!.revisionNo,
        revisionDate: formData!.revisionDate,
      );

      bool? success;

      log('attempt to insert');
      success = await providerQC.insertTicket(entity);

      log("is success? $success");

      if (success) {
        QualityRefineryEntity prodEntity = entity;
        prodEntity.remarks = null;
        final prodSuccess = await providerProd.insertTicket(prodEntity);

        if (prodSuccess) {
          if (!mounted) return;
          context.read<QualityReportQCProvider>().fetchAllTickets(
            null,
            null,
            userProvider.currentUser?.username ?? "",
            userProvider.currentUser?.role ?? "",
            plantProvider.currentPlant?.code ?? "",
          );
          _showSnackBar('Input Report berhasil.');

          log('insert successful.');
          if (mounted) Navigator.pop(context);
        } else {
          log('insert to Production Table is not successful.');
          _showSnackBar('Input Report gagal: ${providerProd.errorMessage}.');
        }
      } else {
        log('insert to QC Table is not successful.');
        _showSnackBar('Input Report gagal: ${providerQC.errorMessage}.');
      }
    } catch (e) {
      log("Gagal menyimpan laporan: $e");
      _showSnackBar("Gagal menyimpan laporan: $e");
    } finally {
      setState(() => isSaving = false);
    }
  }

  // Hour Picker
  void _showHourPicker(BuildContext context) {
    int initialHour = selectedHour ?? TimeOfDay.now().hour;

    // Set default selectedHour sebelum picker tampil
    selectedHour = initialHour;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 300,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Pilih Jam Input',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF655F5B),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: initialHour,
                    ),
                    onSelectedItemChanged: (int value) {
                      selectedHour = value;
                    },
                    children: List.generate(
                      24,
                      (index) => Center(
                        child: Text(
                          '${index.toString().padLeft(2, '0')}:00',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF655F5B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Refresh UI
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAB2F2B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Pilih', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // TextField Builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    bool isNumeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType:
            isNumeric
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
        inputFormatters:
            isNumeric
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                : [],
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: const TextStyle(
            color: Color(0xFF655F5B),
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Color(0xFF655F5B)),
          filled: true,
          fillColor: const Color(0xFFF0ECE9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Color(0xFF655F5B), fontSize: 16),
      ),
    );
  }

  // Step title
  String getStepTitle() {
    switch (currentStep) {
      case 0:
        // if (selectedPartSource != null) {
        //   return '${selectedPartSource!} Parameters';
        // }
        return 'Raw Material';

      case 1:
        return 'Bleach Oil';

      case 2:
        final finishedGoods =
            context
                .read<ValueProvider>()
                .oilTypeLists
                .where((element) => element.code == selectedOilType)
                .toList();
        return 'Finished Goods (${finishedGoods[0].outputOilType})';

      case 3:
        return 'By Product';

      case 4:
        return 'Waste';

      case 5:
        return 'Remark';

      default:
        return 'Parameters'; // fallback default
    }
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return Column(
          children: [
            _buildTextField(
              controller: rmFlowRateController,
              label: 'Flow Rate',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai FFA (%)',
            ),
            _buildTextField(
              controller: rmTempController,
              label: 'Temp (°C)',
              icon: Icons.thermostat,
              hintText: 'Masukkan nilai Temperatur (°C)',
            ),
            _buildTextField(
              controller: rmFFAController,
              label: 'FFA',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai FFA (%)',
            ),
            _buildTextField(
              controller: rmIVController,
              label: 'IV',
              icon: Icons.scale,
              isNumeric: true,
              hintText: 'Masukkan nilai IV (g/mg)',
            ),
            _buildTextField(
              controller: rmPVController,
              label: 'PV',
              icon: Icons.energy_savings_leaf,
              isNumeric: true,
              hintText: 'Masukkan nilai PV (meq/kg)',
            ),
            _buildTextField(
              controller: rmANVController,
              label: 'AnV',
              icon: Icons.fact_check,
              isNumeric: true,
              hintText: 'Masukkan nilai AnV',
            ),
            _buildTextField(
              controller: rmDOBIController,
              label: 'DOBI',
              icon: Icons.opacity,
              isNumeric: true,
              hintText: 'Masukkan nilai DOBI',
            ),
            _buildTextField(
              controller: rmMNIController,
              label: 'M&I',
              icon: Icons.opacity,
              isNumeric: true,
              hintText: 'Masukkan nilai M&I (%)',
            ),
            _buildTextField(
              controller: rmToToxController,
              label: 'Totox',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai Totox',
            ),
            _buildTextField(
              controller: rmColorRController,
              label: 'Color (R)',
              icon: Icons.color_lens_rounded,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (R)',
            ),
            _buildTextField(
              controller: rmColorYController,
              label: 'Color (Y)',
              icon: Icons.color_lens_rounded,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (Y)',
            ),
            _buildTextField(
              controller: rmColorBController,
              label: 'Color (B)',
              icon: Icons.color_lens_rounded,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (B)',
            ),
          ],
        );

      case 1:
        return Column(
          children: [
            _buildTextField(
              controller: boColorRController,
              label: 'Color (R)',
              icon: Icons.color_lens_rounded,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (R)',
            ),
            _buildTextField(
              controller: boColorYController,
              label: 'Color (Y)',
              icon: Icons.color_lens_rounded,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (Y)',
            ),
            _buildTextField(
              controller: boColorBController,
              label: 'Color (B)',
              icon: Icons.color_lens_rounded,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (B)',
            ),
            _buildTextField(
              controller: boBreakTestController,
              label: 'Break Test',
              icon: Icons.color_lens_rounded,
              hintText: 'Masukkan nilai Break Test',
            ),
          ],
        );
      // return Column(children: [

      //   ],
      // );

      case 2:
        return Column(
          children: [
            _buildTextField(
              controller: fgFFAController,
              label: 'FFA',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai FFA (%)',
            ),
            _buildTextField(
              controller: fgIVController,
              label: 'IV',
              icon: Icons.speed,
              isNumeric: true,
              hintText: 'Masukkan nilai IV',
            ),
            _buildTextField(
              controller: fgPVController,
              label: 'PV',
              icon: Icons.energy_savings_leaf,
              isNumeric: true,
              hintText: 'Masukkan nilai PV',
            ),
            _buildTextField(
              controller: fgMoisture,
              label: 'Moisture',
              icon: Icons.science,
              isNumeric: true,
              hintText: 'Masukkan nilai Moisture',
            ),
            _buildTextField(
              controller: fgImpurities,
              label: 'Impurities',
              icon: Icons.science,
              isNumeric: true,
              hintText: 'Masukkan nilai Impurities',
            ),
            _buildTextField(
              controller: fgColorRController,
              label: 'Color R',
              icon: Icons.color_lens,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (R)',
            ),
            _buildTextField(
              controller: fgColorYController,
              label: 'Color Y',
              icon: Icons.color_lens,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (Y)',
            ),
            _buildTextField(
              controller: fgColorBController,
              label: 'Color B',
              icon: Icons.color_lens,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (B)',
            ),
            // Tank To Dropdown
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Consumer<ValueProvider>(
                builder: (context, provider, child) {
                  if (provider.toTankGroupLists.isEmpty) {
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
                        hintText: 'Loading Tank To...',
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
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedToTankGroup,
                    items: [
                      ...provider.toTankGroupLists.map((tank) {
                        return DropdownMenuItem<String>(
                          value: tank.code,
                          child: Text(
                            tank.code,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }),
                      DropdownMenuItem<String>(
                        value: "Others",
                        child: Text("Others", style: TextStyle(fontSize: 14)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedToTankGroup = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Pilih To Tank Group',
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
            ),

            if (selectedToTankGroup == "Others")
              _buildTextField(
                controller: fgTankToOthersRemarkController,
                label: 'Remark',
                icon: Icons.comment, // Using a different icon for remark
                isNumeric: false, // Remark is likely text, not numeric
                hintText: 'Masukkan keterangan lainnya',
              ),
          ],
        );
      case 3:
        return Column(
          children: [
            _buildTextField(
              controller: bpFFAController,
              label: 'FFA',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai FFA (%)',
            ),
            _buildTextField(
              controller: bpMNIController,
              label: 'M&I',
              icon: Icons.opacity,
              isNumeric: true,
              hintText: 'Masukkan nilai M&I (%)',
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Consumer<ValueProvider>(
                builder: (context, provider, child) {
                  if (provider.toTankGroupLists.isEmpty) {
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
                        hintText: 'Loading Tank To...',
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
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedBpToTank,
                    items: [
                      ...provider.toTankGroupLists.map((tank) {
                        return DropdownMenuItem<String>(
                          value: tank.code,
                          child: Text(
                            tank.code,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }),
                      DropdownMenuItem<String>(
                        value: "Others",
                        child: Text("Others", style: TextStyle(fontSize: 14)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedBpToTank = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Pilih To Tank Group',
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
            ),

            if (selectedBpToTank == "Others")
              _buildTextField(
                controller: bpToTankController,
                label: 'Remark',
                icon: Icons.comment, // Using a different icon for remark
                isNumeric: false, // Remark is likely text, not numeric
                hintText: 'Masukkan keterangan lainnya',
              ),
          ],
        );
      case 4:
        return Column(
          children: [
            _buildTextField(
              controller: WOCQCController,
              label: 'OC',
              icon: Icons.high_quality,
              hintText: 'Masukkan OC',
            ),
            _buildTextField(
              controller: wasteMNIController,
              label: 'M&I',
              icon: Icons.opacity,
              hintText: 'Masukkan Waste M&I',
            ),
          ],
        );
      case 5:
        return Column(
          children: [
            _buildTextField(
              controller: remarkController,
              label: 'Remark',
              icon: Icons.note,
              hintText: 'Masukkan remark tambahan',
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Transaction Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Refinery Dropdown
                  Consumer<ValueProvider>(
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
                            hintText: 'Loading Work Center...',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
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
                            hintText: 'Work Center tidak ditemukan.',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(Icons.warning_amber_rounded),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                context
                                    .read<ValueProvider>()
                                    .fetchWorkCenterLists();
                              },
                            ),
                          ),
                        );
                      }
                      return DropdownButtonFormField<String>(
                        value: selectedWorkCenter,
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

                  // Oil Type Dropdown
                  Consumer<ValueProvider>(
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
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
                        value: selectedOilType,
                        items:
                            provider.oilTypeLists.map((oil) {
                              return DropdownMenuItem<String>(
                                value: oil.code,
                                child: Text(
                                  oil.code,
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedOilType = value;
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

                  // Tank Source Dropdown
                  Consumer<ValueProvider>(
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
                            hintText: 'Loading Tank Source...',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
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
                            hintText: 'Tank Sources tidak ditemukan.',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(Icons.warning_amber_rounded),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                context
                                    .read<ValueProvider>()
                                    .fetchTankSourceLists();
                              },
                            ),
                          ),
                        );
                      }
                      return DropdownButtonFormField<String>(
                        value: selectedTankSource,
                        isExpanded: true,
                        items:
                            provider.tankSourceList.map((tank) {
                              return DropdownMenuItem<String>(
                                value: tank.code,
                                child: Text(
                                  tank.code,
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() => selectedTankSource = value);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF0ECE9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Pilih tank source',
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

                  // Jam Input
                  InkWell(
                    onTap: () => _showHourPicker(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF0ECE9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.access_time),
                      ),
                      child: Text(
                        selectedHour != null
                            ? '${selectedHour.toString().padLeft(2, '0')}:00'
                            : 'Pilih jam input',
                        style: TextStyle(
                          color:
                              selectedHour != null
                                  ? const Color(0xFF655F5B)
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (selectedHour != null &&
                      selectedWorkCenter != null &&
                      selectedOilType != null &&
                      selectedTankSource != null) ...[
                    // Step Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        final isSelected = currentStep == index;
                        return InkWell(
                          onTap: () => _goToStep(index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFFAB2F2B)
                                      : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : const Color(0xFF655F5B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    // Step Form
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
                            Text(
                              getStepTitle(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildStepContent(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Navigation Buttons
                    _navigationButton(context),
                    const SizedBox(height: 16),
                  ] else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: Text(
                          'Silakan pilih Part terlebih dahulu.',
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Loading Overlay
            if (isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _navigationButton(BuildContext context) {
    return Row(
      children: [
        if (currentStep > 0)
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _prevStep,
              label: const Text('Back'),
            ),
          )
        else
          const Spacer(),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: Consumer<QualityReportQCProvider>(
              builder: (context, provider, child) {
                return Icon(
                  currentStep == 5 ? Icons.save : Icons.arrow_forward,
                );
              },
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAB2F2B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed:
                currentStep == 5 ? () => _showAlertDialog(context) : _nextStep,
            label: Text(currentStep == 5 ? 'Save' : 'Next'),
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) => form.isMenu == "Quality_Report" && form.isActive == "T",
            )
            .first;

    log("${formData!.code}");
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: Text(
        'Quality Report - ${formData!.code}',
        style: TextStyle(
          color: Color(0xFF655F5B),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshPage),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
