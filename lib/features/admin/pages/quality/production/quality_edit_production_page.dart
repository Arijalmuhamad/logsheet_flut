// quality_report_edit.dart
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/product_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_production_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/data/dao/quality_report_refinery_dao.dart';
import 'package:logsheet_app/data/remote/quality_refinery/quality_report_production_entity.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';

class QualityEditProductionPage extends StatefulWidget {
  final QualityReportProductionEntity report;

  const QualityEditProductionPage({super.key, required this.report});

  @override
  State<QualityEditProductionPage> createState() =>
      _QualityEditProductionPageState();
}

class _QualityEditProductionPageState extends State<QualityEditProductionPage> {
  // Database & DAO
  late final AppDatabase db;
  late final QualityReportRefineryDao qualityReportRefDao;

  // Data dropdown & kontrol
  late String? selectedOilType;
  late String? selectedWorkCenter;
  late String? selectedTankSource;
  late String? selectedBpToTankGroup;
  late int? selectedHour;
  late String? selectedToTankGroup;

  // Stepper state
  int currentStep = 0;
  bool isSaving = false;
  bool isLoading = false;

  // ==========================
  // Text Controllers
  // ==========================

  // CPO / CPKO (Part)
  final TextEditingController rmFlowrateController = TextEditingController();
  final TextEditingController rmTempController = TextEditingController();
  final TextEditingController rmFFAController = TextEditingController();
  final TextEditingController rmIVController = TextEditingController();
  final TextEditingController rmDOBIController = TextEditingController();
  final TextEditingController rmANVController = TextEditingController();
  final TextEditingController rmMNIController = TextEditingController();
  final TextEditingController rmPVController = TextEditingController();
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
  final TextEditingController fgMoistureController = TextEditingController();
  final TextEditingController fgImpuritiesController = TextEditingController();
  final TextEditingController fgColorRController = TextEditingController();
  final TextEditingController fgColorYController = TextEditingController();
  final TextEditingController fgColorBController = TextEditingController();
  final TextEditingController fgTankToOthersRemarkController =
      TextEditingController();

  // RFAD
  final TextEditingController bpFFAController = TextEditingController();
  final TextEditingController bpMNIController = TextEditingController();
  final TextEditingController bpToTankController = TextEditingController();

  // W SBE QC
  final TextEditingController WSBEQCController = TextEditingController();
  final TextEditingController wasteMNIController = TextEditingController();

  // Remark
  final TextEditingController remarkController = TextEditingController();

  final Color primaryRed = const Color(0xFFAB2F2B);
  final Color backgroundGrey = const Color(0xFFEFF3F9);

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    qualityReportRefDao = QualityReportRefineryDao(db);

    // Initialize dropdown values from the report
    selectedOilType = widget.report.oilTypeId;
    selectedWorkCenter = widget.report.workCenter;
    selectedTankSource = widget.report.rmTankSource;
    selectedBpToTankGroup = widget.report.bpToTank;
    selectedHour = widget.report.time?.hour;
    selectedToTankGroup = widget.report.fgTankTo;

    // Initialize all controllers with data from the existing report
    rmFlowrateController.text = widget.report.rmFlowRate.toString();
    rmTempController.text = widget.report.rmTemp.toString();
    rmFFAController.text = widget.report.rmFFA.toString();
    rmIVController.text = widget.report.rmIV.toString();
    rmPVController.text = widget.report.rmPV.toString();
    rmANVController.text = widget.report.rmAV.toString();
    rmDOBIController.text = widget.report.rmDobi.toString();
    rmMNIController.text = widget.report.rmMNI.toString();
    rmToToxController.text = widget.report.rmToTox.toString();
    rmColorRController.text = widget.report.rmColorR.toString();
    rmColorYController.text = widget.report.rmColorY.toString();
    rmColorBController.text = widget.report.rmColorB.toString();

    boColorRController.text = widget.report.boColorR.toString();
    boColorYController.text = widget.report.boColorY.toString();
    boColorBController.text = widget.report.boColorB.toString();
    boBreakTestController.text = widget.report.boBreakTest ?? '';

    fgFFAController.text = widget.report.fgFFA.toString();
    fgIVController.text = widget.report.fgIV.toString();
    fgPVController.text = widget.report.fgPV.toString();
    fgMoistureController.text = widget.report.fgMoisture.toString();
    fgImpuritiesController.text = widget.report.fgImpurities.toString();
    fgColorRController.text = widget.report.fgColorR.toString();
    fgColorYController.text = widget.report.fgColorY.toString();
    fgColorBController.text = widget.report.fgColorB.toString();
    fgTankToOthersRemarkController.text =
        widget.report.fgTankToOthersRemarks ?? '';

    bpFFAController.text = widget.report.bpFFA.toString();
    bpMNIController.text = widget.report.bpMNI.toString();
    bpToTankController.text = widget.report.bpToTank.toString();

    WSBEQCController.text = widget.report.wSBEQC.toString();
    wasteMNIController.text = widget.report.wasteMNI.toString();

    remarkController.text = widget.report.remarks ?? '';

    // Fetch dropdown data similar to the input page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ValueProvider>().fetchAllInitialData();
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    final controllers = [
      rmFlowrateController,
      rmTempController,
      rmFFAController,
      rmIVController,
      rmPVController,
      rmToToxController,
      rmANVController,
      rmDOBIController,
      rmMNIController,
      rmColorRController,
      rmColorYController,
      rmColorBController,
      boColorRController,
      boColorYController,
      boColorBController,
      boBreakTestController,
      fgFFAController,
      fgIVController,
      fgPVController,
      fgMoistureController,
      fgImpuritiesController,
      fgColorRController,
      fgColorYController,
      fgColorBController,
      fgTankToOthersRemarkController,
      bpFFAController,
      bpMNIController,
      bpToTankController,
      WSBEQCController,
      wasteMNIController,
      remarkController,
    ];

    for (var c in controllers) {
      c.dispose();
    }

    super.dispose();
  }

  // Navigasi Stepper
  void _nextStep() {
    if (currentStep < 5) setState(() => currentStep++);
  }

  void _prevStep() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  void _goToStep(int step) {
    setState(() => currentStep = step);
  }

  // Save Data
  Future<void> _saveData() async {
    if (isSaving) return;
    setState(() => isSaving = true);

    // Helper function to parse doubles and handle empty strings
    double? parseDouble(TextEditingController c) {
      final text = c.text.trim();
      return text.isEmpty ? null : double.tryParse(text);
    }

    // double? parseDoubleString(String c) {
    //   return c.isEmpty ? null : double.tryParse(c);
    // }

    final userName = context.read<UserProvider>().currentUser?.username;

    final role = context.read<UserProvider>().currentUser?.role;
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    final String formattedTime =
        selectedHour != null
            ? '${selectedHour.toString().padLeft(2, '0')}:00:00'
            : '';
    final time = DateFormat('HH:mm:ss').parse(formattedTime);
    try {
      selectedBpToTankGroup = bpToTankController.text.trim();
      final updatedItem = QualityReportProductionEntity(
        id: widget.report.id,
        idFk: widget.report.idFk,
        company: widget.report.company,
        plant: widget.report.plant,
        transactionDate: widget.report.transactionDate,
        postingDate: widget.report.postingDate,
        workCenter: selectedWorkCenter,
        oilTypeId: selectedOilType,
        time: time,
        shift: getShiftBasedOnDate(time),
        rmFlowRate: parseDouble(rmFlowrateController),
        rmTankSource: selectedTankSource,
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
        fgIV: parseDouble(fgIVController),
        fgPV: parseDouble(fgPVController),
        fgMoisture: parseDouble(fgMoistureController),
        fgImpurities: parseDouble(fgImpuritiesController),
        fgColorR: parseDouble(fgColorRController),
        fgColorY: parseDouble(fgColorYController),
        fgColorB: parseDouble(fgColorBController),
        fgTankTo: selectedToTankGroup,
        fgTankToOthersRemarks: fgTankToOthersRemarkController.text.trim(),

        bpFFA: parseDouble(bpFFAController),
        bpMNI: parseDouble(bpMNIController),
        wSBEQC: parseDouble(WSBEQCController),
        wasteMNI: parseDouble(wasteMNIController),
        remarks: remarkController.text.trim(),

        flag: widget.report.flag,
        entryBy: widget.report.entryBy,
        entryDate: widget.report.entryDate,
        preparedBy: widget.report.preparedBy,
        preparedDate: widget.report.preparedDate,
        preparedStatus: widget.report.preparedStatus,
        preparedStatusRemarks: widget.report.preparedStatusRemarks,
        checkedBy: widget.report.checkedBy,
        checkedDate: widget.report.checkedDate,
        checkedStatus: widget.report.checkedStatus,
        checkedStatusRemarks: widget.report.checkedStatusRemarks,
        updatedBy: userName ?? "Unknown",
        updatedDate: DateTime.now(),
        bpToTank: selectedBpToTankGroup,
        formNo: widget.report.formNo,
        dateIssued: widget.report.dateIssued,
        revisionNo: widget.report.revisionNo,
        revisionDate: widget.report.revisionDate,
      );

      bool? success;

      log("PROD ID: ${updatedItem.id}, QC ID: ${updatedItem.idFk}");

      if (!mounted) return;
      final currentUser = context.read<UserProvider>().currentUser;

      success = await context
          .read<QualityReportProductionProvider>()
          .updateReport(
            updatedItem,
            userName ?? "",
            role ?? "",
            plantCode,
            currentUser!,
          );

      if (success) {
        _showSnackBar('Data berhasil diperbarui ✅');
        if (!mounted) return;
        final user = context.read<UserProvider>().currentUser;
        context.read<QualityReportProductionProvider>().fetchAllTickets(
          null,
          null,
          userName!,
          user!.role,
          plantCode,
        );

        if (!mounted) return;
        Navigator.pop(context, updatedItem);
      } else {
        _showSnackBar('Edit Gagal');
      }
    } catch (e) {
      _showSnackBar('Gagal memperbarui laporan: $e');
    } finally {
      setState(() => isSaving = false);
    }
  }

  // Hour Picker
  void _showHourPicker(BuildContext context) {
    int initialHour = selectedHour ?? TimeOfDay.now().hour;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
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
                    backgroundColor: primaryRed,
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
    bool isEnabled = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        enabled: isEnabled,
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
          prefixIcon: Icon(icon, color: const Color(0xFF655F5B)),
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
        return 'Raw Material';
      case 1:
        return 'Bleach Oil';
      case 2:
        final finishedGoods =
            context
                .read<ProductProvider>()
                .productRefineryList
                .where((element) => element.id == selectedOilType)
                .toList();
        return 'Finished Goods (${finishedGoods[0].rawMaterial})';
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
              controller: rmFlowrateController,
              label: 'Flowrate',
              icon: Icons.thermostat,
              hintText: 'Masukkan nilai Flowrate',
              isNumeric: true,
            ),
            _buildTextField(
              controller: rmTempController,
              label: 'Temp (°C)',
              icon: Icons.thermostat,
              hintText: 'Masukkan nilai Temperatur (°C)',
              isNumeric: true,
              isEnabled: true,
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
              icon: Icons.opacity,
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
              icon: Icons.color_lens,
              hintText: 'Masukkan nilai Color (R)',
              isNumeric: true,
            ),
            _buildTextField(
              controller: boColorYController,
              label: 'Color (Y)',
              icon: Icons.color_lens,
              hintText: 'Masukkan nilai Color (Y)',
              isNumeric: true,
            ),
            _buildTextField(
              controller: boColorBController,
              label: 'Color (B)',
              icon: Icons.color_lens,
              hintText: 'Masukkan nilai Color (B)',
              isNumeric: true,
            ),
            _buildTextField(
              controller: boBreakTestController,
              label: 'Break Test',
              icon: Icons.science,
              hintText: 'Masukkan nilai Break Test',
            ),
          ],
        );

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
              controller: fgMoistureController,
              label: 'Moisture',
              icon: Icons.science,
              isNumeric: true,
              hintText: 'Masukkan nilai Moisture',
            ),
            _buildTextField(
              controller: fgImpuritiesController,
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
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                return DropdownButtonFormField<String>(
                  value: selectedToTankGroup,
                  items: [
                    ...provider.toTankGroupLists.map((tank) {
                      return DropdownMenuItem<String>(
                        value: tank.code,
                        child: Text(
                          "${tank.code} - ${tank.name}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }),
                    DropdownMenuItem<String>(
                      value: "Others",
                      child: Text("Others", style: TextStyle(fontSize: 14)),
                    ),
                  ],
                  onChanged: null,
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
            if (selectedToTankGroup == "Others")
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildTextField(
                  controller: fgTankToOthersRemarkController,
                  label: 'Remark (Others)',
                  icon: Icons.comment,
                  hintText: 'Masukkan keterangan lainnya',
                ),
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
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                return DropdownButtonFormField<String>(
                  value: selectedBpToTankGroup,
                  items: [
                    ...provider.toTankGroupLists.map((tank) {
                      return DropdownMenuItem<String>(
                        value: tank.code,
                        child: Text(
                          "${tank.code} - ${tank.name}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }),
                    DropdownMenuItem<String>(
                      value: "Others",
                      child: Text("Others", style: TextStyle(fontSize: 14)),
                    ),
                  ],
                  onChanged: null,
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
            if (selectedBpToTankGroup == "Others")
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildTextField(
                  controller: bpToTankController,
                  label: 'Remark (Others)',
                  icon: Icons.comment,
                  hintText: 'Masukkan keterangan lainnya',
                ),
              ),
          ],
        );
      case 4:
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "W SBE QC",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF655F5B),
                  ),
                ),
              ),
            ),
            _buildTextField(
              controller: WSBEQCController,
              label: 'SBE',
              icon: Icons.high_quality,
              hintText: 'Masukkan Waste SBE',
              isNumeric: true,
            ),
            _buildTextField(
              controller: wasteMNIController,
              label: 'M&I',
              icon: Icons.opacity,
              hintText: 'Masukkan Waste M&I',
              isNumeric: true,
            ),
          ],
        );
      case 5:
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Remark",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF655F5B),
                  ),
                ),
              ),
            ),
            _buildTextField(
              controller: remarkController,
              label: 'Remark',
              icon: Icons.note,
              hintText: 'Masukkan remark tambahan',
              isEnabled: true,
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
      backgroundColor: backgroundGrey,
      appBar: buildAppBar(),
      body: _buildBody(context),
    );
  }

  Stack _buildBody(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Refinery Dropdown
              Consumer<ValueProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonFormField<String>(
                    value: selectedWorkCenter,
                    items:
                        provider.workCenterLists.map((machine) {
                          return DropdownMenuItem<String>(
                            value: machine.code,
                            child: Text(
                              "${machine.code} - ${machine.name}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                    onChanged: null,
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
              Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonFormField<String>(
                    value: selectedOilType,
                    items:
                        provider.productRefineryList.map((oil) {
                          return DropdownMenuItem<String>(
                            value: oil.id,
                            child: Text(
                              "${oil.rawMaterial}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                    onChanged: null,
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
              const SizedBox(height: 8),
              // Tank Source Dropdown
              Consumer<ValueProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonFormField<String>(
                    value: selectedTankSource,
                    isExpanded: true,
                    items:
                        provider.tankSourceList.map((tank) {
                          return DropdownMenuItem<String>(
                            value: tank.code,
                            child: Text(
                              "${tank.code} - ${tank.name}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                    onChanged: null,
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
                onTap: null,
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
                        color: isSelected ? primaryRed : Colors.grey.shade300,
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
              Row(
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
                      icon: Icon(
                        currentStep == 5 ? Icons.save : Icons.arrow_forward,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: currentStep == 5 ? _saveData : _nextStep,
                      label: Text(currentStep == 5 ? 'Save' : 'Next'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Loading Overlay
        if (isSaving)
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: const Text(
        'Edit Quality Report - Refinery',
        style: TextStyle(
          color: Color(0xFF655F5B),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  int getShiftBasedOnDate(DateTime time) {
    int hour = time.hour;
    if (hour >= 8 && hour <= 15) {
      return 1;
    } else if (hour >= 16 && hour <= 23) {
      return 2;
    } else {
      return 3;
    }
  }
}
