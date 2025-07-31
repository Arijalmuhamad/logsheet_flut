// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/providers/quality_report_refinery_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/data/dao/mastervalue_dao.dart';
import 'package:logsheet_app/data/dao/quality_report_refinery_dao.dart';
import '../../../../providers/user_provider.dart';

class QualityReportRefineryPage extends StatefulWidget {
  final String userName;

  const QualityReportRefineryPage({super.key, required this.userName});

  @override
  State<QualityReportRefineryPage> createState() =>
      _QualityReportRefineryPageState();
}

class _QualityReportRefineryPageState extends State<QualityReportRefineryPage> {
  // Database & DAO
  late final AppDatabase db;
  late final QualityReportRefineryDao qualityReportRefDao;
  late MastervalueDao mastervalueDao;

  // Data dropdown & kontrol
  double? selectedTankSource;
  String? selectedPartSource;
  List<MMastervalue> tankList = [
    MMastervalue(
      id: '1',
      code: '1',
      name: '1',
      group: '1',
      number: 1,
      isactive: 'T',
      entryBy: '1',
      entryDate: DateTime.now(),
    ),
    MMastervalue(
      id: '2',
      code: '2',
      name: '2',
      group: '2',
      number: 2,
      isactive: 'T',
      entryBy: '2',
      entryDate: DateTime.now(),
    ),
  ];
  List<MMastervalue> partList = [
    MMastervalue(
      id: '1',
      code: '1',
      name: '1',
      group: '1',
      number: 1,
      isactive: 'T',
      entryBy: '1',
      entryDate: DateTime.now(),
    ),
    MMastervalue(
      id: '2',
      code: '2',
      name: '2',
      group: '2',
      number: 2,
      isactive: 'T',
      entryBy: '2',
      entryDate: DateTime.now(),
    ),
  ];

  int? selectedHour;
  // String? selectedPart;
  String? selectedCcat;
  String? selectedBcat;
  String? selectedRcat;
  String? selectedFPcat;

  String? entryBy;
  String? checkedBy;

  int currentStep = 0;
  bool isLoading = false;

  // List data utama
  List<TQualityReportRefineryData> qualityReportsRefinery = [];
  TQualityReportRefineryData? editingQualityReportsRefinery;

  // ==========================
  // Text Controllers
  // ==========================

  // CPO / CPKO (Part)
  final TextEditingController pflowRateController = TextEditingController();
  final TextEditingController pffaController = TextEditingController();
  final TextEditingController pivController = TextEditingController();
  final TextEditingController ppvController = TextEditingController();
  final TextEditingController panVController = TextEditingController();
  final TextEditingController pdobiController = TextEditingController();
  final TextEditingController pcaroteneController = TextEditingController();
  final TextEditingController pmnIController = TextEditingController();
  final TextEditingController pcolorController = TextEditingController();

  // Chemical
  final TextEditingController chempaController = TextEditingController();
  final TextEditingController chembeController = TextEditingController();

  // BPO
  final TextEditingController bpocolorRController = TextEditingController();
  final TextEditingController bpocolorYController = TextEditingController();
  final TextEditingController bpobtController = TextEditingController();

  // RPO
  final TextEditingController rpoffaController = TextEditingController();
  final TextEditingController rpocolorRController = TextEditingController();
  final TextEditingController rpocolorYController = TextEditingController();
  final TextEditingController rpocolorBController = TextEditingController();
  final TextEditingController rpopvController = TextEditingController();
  final TextEditingController rpomnIController = TextEditingController();
  final TextEditingController rpoproductController =
      TextEditingController(); // dari mastervalue

  // RFAD
  final TextEditingController pfadpurityController = TextEditingController();
  final TextEditingController pfadproductController =
      TextEditingController(); // dari mastervalue

  // Spent Earth
  final TextEditingController spenoicController = TextEditingController();

  // Remark
  final TextEditingController remarkController = TextEditingController();

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    qualityReportRefDao = QualityReportRefineryDao(db);
    mastervalueDao = MastervalueDao(db);
    // _loadTankList();
    // _loadPartList();
  }

  Future<void> _loadTankList() async {
    final tanks = await mastervalueDao.getActiveTanks();
    //dummy data tank
    final tanksDummy = [
      MMastervalue(
        id: '1',
        code: '1',
        name: 'a',
        group: 'a',
        number: 1,
        isactive: 'T',
        entryBy: 'admin',
        entryDate: DateTime.now(),
      ),
    ];
    setState(() => tankList = tanksDummy);
  }

  Future<void> _loadPartList() async {
    final parts = await mastervalueDao.getActiveParts();
    final partsDummy = [
      MMastervalue(
        id: '1',
        code: '1',
        name: 'a',
        group: 'a',
        number: 1,
        isactive: 'T',
        entryBy: 'admin',
        entryDate: DateTime.now(),
      ),
    ];
    setState(() => partList = partsDummy);
  }

  void _resetForm() {
    selectedTankSource = null;
    selectedPartSource = null;
    selectedHour = null;
    // selectedPart = null;
    selectedCcat = null;
    selectedBcat = null;
    selectedRcat = null;
    selectedFPcat = null;

    // Part input
    for (var c in [
      pflowRateController,
      pffaController,
      pivController,
      ppvController,
      panVController,
      pdobiController,
      pcaroteneController,
      pmnIController,
      pcolorController,
    ]) {
      c.clear();
    }

    // Chemical
    chempaController.clear();
    chembeController.clear();

    // BPO
    bpocolorRController.clear();
    bpocolorYController.clear();
    bpobtController.clear();

    // RPO
    for (var c in [
      rpoffaController,
      rpocolorRController,
      rpocolorYController,
      rpocolorBController,
      rpopvController,
      rpomnIController,
      rpoproductController,
    ]) {
      c.clear();
    }

    // PFAD
    pfadpurityController.clear();
    pfadproductController.clear();

    // Spent Earth
    spenoicController.clear();

    // Remarks
    remarkController.clear();
  }

  @override
  void dispose() {
    final controllers = [
      // Part
      pflowRateController, pffaController, pivController, ppvController,
      panVController, pdobiController, pcaroteneController, pmnIController,
      pcolorController,
      // Chemical
      chempaController, chembeController,
      // BPO
      bpocolorRController, bpocolorYController, bpobtController,
      // RPO
      rpoffaController, rpocolorRController, rpocolorYController,
      rpocolorBController,
      rpopvController,
      rpomnIController,
      rpoproductController,
      // PFAD
      pfadpurityController, pfadproductController,
      // Spent Earth
      spenoicController,
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (entryBy == null && userProvider.userName.isNotEmpty) {
      setState(() => entryBy = userProvider.userName);
    }
  }

  // bool _validateCurrentStep() {
  //   String? errorMessage;

  //   if (selectedTankSource == null || selectedHour == null) {
  //     errorMessage = "Mohon lengkapi Tank Source dan Jam Input";
  //   } else {
  //     switch (currentStep) {
  //       case 0: // Parameters
  //         if (pflowRateController.text.isEmpty ||
  //             pffaController.text.isEmpty ||
  //             pivController.text.isEmpty ||
  //             ppvController.text.isEmpty ||
  //             panVController.text.isEmpty ||
  //             pdobiController.text.isEmpty ||
  //             pcaroteneController.text.isEmpty ||
  //             pmnIController.text.isEmpty ||
  //             pcolorController.text.isEmpty) {
  //           errorMessage = 'Mohon lengkapi semua input pada Parameters.';
  //         }
  //         break;
  //       case 1: // Chemicals
  //         if (chempaController.text.isEmpty || chembeController.text.isEmpty) {
  //           errorMessage = 'Mohon lengkapi semua input Chemical.';
  //         }
  //         break;
  //       case 2: // BPO / BPKO
  //         if (bpocolorRController.text.isEmpty ||
  //             bpocolorYController.text.isEmpty ||
  //             bpobtController.text.isEmpty) {
  //           errorMessage = 'Mohon lengkapi semua input BPO / BPKO.';
  //         }
  //         break;
  //       case 3: // RPO
  //         if (rpoffaController.text.isEmpty ||
  //             rpocolorRController.text.isEmpty ||
  //             rpocolorYController.text.isEmpty ||
  //             rpocolorBController.text.isEmpty ||
  //             rpopvController.text.isEmpty ||
  //             rpomnIController.text.isEmpty ||
  //             rpoproductController.text.isEmpty) {
  //           errorMessage = 'Mohon lengkapi semua input RPO';
  //         }
  //         break;
  //       case 4: // PFAD
  //         if (pfadpurityController.text.isEmpty ||
  //             pfadproductController.text.isEmpty) {
  //           errorMessage = 'Mohon lengkapi semua input PFAD';
  //         }
  //         break;
  //       case 5:
  //         break;
  //     }
  //   }

  //   if (errorMessage != null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
  //     );
  //     return false;
  //   }
  //   return true;
  // }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _resetForm();
    currentStep = 0;
    setState(() => isLoading = false);
  }

  // Navigasi Stepper
  void _nextStep() {
    // if (_validateCurrentStep()) {
    if (currentStep < 5) setState(() => currentStep++);
    // }
  }

  void _prevStep() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  void _goToStep(int step) {
    if (step < currentStep) {
      setState(() => currentStep = step);
    } else {
      // For jumping forward, validate current step
      // if (_validateCurrentStep()) {
      setState(() => currentStep = step);
      // }
    }
  }

  // Save Data
  bool isSaving = false;

  Future<void> _saveQualityReport() async {
    if (isSaving) return;

    log('Save report button clicked.');

    // if (!_validateCurrentStep()) {
    //   // validate before saving
    //   return;
    // }
    setState(() => isSaving = true);

    final tanksource = selectedTankSource;
    // final ppart = selectedPart;
    final partsource = selectedPartSource;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final uuid = Uuid();

    log('Alleged Null check opeator.');
    final String formattedTime =
        selectedHour != null
            ? '${selectedHour.toString().padLeft(2, '0')}:00:00'
            : '';
    log('Alleged Null check opeator Done. $formattedTime');
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
      return text.isEmpty ? null : double.tryParse(text);
    }

    double? parseDoubleString(String c) {
      return c.isEmpty ? null : double.tryParse(c);
    }

    int? parseInt(String value) {
      final text = value.trim();
      return text.isEmpty ? null : int.tryParse(text);
    }

    try {
      final reportId = editingQualityReportsRefinery?.id ?? uuid.v4();

      final bpocolorR = bpocolorRController.text.trim();
      final bpocolorY = bpocolorYController.text.trim();

      final rpocolorR = rpocolorRController.text.trim();
      final rpocolorY = rpocolorYController.text.trim();
      final rpocolorB = rpocolorBController.text.trim();
      final rpopv = rpopvController.text.trim();
      final rpomni = rpomnIController.text.trim();

      final provider = Provider.of<QualityReportRefineryProvider>(
        context,
        listen: false,
      );

      final entity = QualityReportRefineryEntity(
        id: reportId,
        reportDate: DateTime.now(),
        time: DateFormat('HH:mm:ss').parse(formattedTime),
        pCat: partsource,
        pTankSource: tanksource,
        pFlowRate: parseDouble(pflowRateController),
        pFFA: parseDouble(pffaController),
        pIV: parseDouble(pivController),
        pPV: parseDouble(ppvController),
        pANV: parseDouble(panVController),
        pDobi: parseDouble(pdobiController),
        pCarotene: parseDouble(pcaroteneController),
        pMNI: parseDouble(pmnIController),
        pColor: pcolorController.text.trim(),
        cCat: null,
        cPA: parseDouble(chempaController),
        cBE: parseDouble(chembeController),
        bCat: null,
        bColorR: parseDoubleString(bpocolorR),
        bColorY: parseDoubleString(bpocolorY),
        bBreakTest: bpobtController.text.trim(),
        rCat: null,
        rFFA: parseDouble(rpoffaController),
        rColorR: parseDoubleString(rpocolorR),
        rColorY: parseDoubleString(rpocolorY),
        rColorB: parseDoubleString(rpocolorB),
        rPV: parseDoubleString(rpopv),
        rMNI: parseDoubleString(rpomni),
        rProductTankNo: parseDoubleString(rpoproductController.text.trim()),
        fpCat: null,
        fpPurity: parseDouble(pfadpurityController),
        fpProductTankNumber: parseDoubleString(
          pfadproductController.text.toString(),
        ),
        pic: userProvider.userName,
        spentEarthOIC: parseDouble(spenoicController),
        remarks: (remarkController.text.toString()),
        checkedBy: checkedBy,
        checkedDate: null,
        checkedTime: null,
        approvedBy: null,
        approvedDate: null,
        approvedTime: null,
        flag: 'T',
        company: null,
        plant: null,
        entryBy: entryBy,
        entryDate: DateTime.now(),
      );

      bool? success;

      log('attemp to insert');
      success = await provider.insert(entity);

      if (success) {
        _showSnackBar('Input Report berhasil.');

        log('insert successful.');
        if (mounted) Navigator.pop(context);
      } else {
        log('insert is not successful.');
        _showSnackBar('Input Report gagal: ${userProvider.errorMessage}');
      }

      // final qualityreport = TQualityReportRefineryCompanion(
      //   id: drift.Value(reportId),
      //   report_date: drift.Value(DateTime.now()),
      //   time: drift.Value(formattedTime),

      //   // CPO
      //   p_cat: drift.Value(partsource),
      //   p_tank_source: drift.Value(tanksource),
      //   p_flowrate: drift.Value(parseDouble(pflowRateController)),
      //   p_ffa: drift.Value(parseDouble(pffaController)),
      //   p_iv: drift.Value(parseDouble(pivController)),
      //   p_pv: drift.Value(parseDouble(ppvController)),
      //   p_anv: drift.Value(parseDouble(panVController)),
      //   p_dobi: drift.Value(parseDouble(pdobiController)),
      //   p_carotene: drift.Value(parseDouble(pcaroteneController)),
      //   p_m_i: drift.Value(parseDouble(pmnIController)),
      //   p_color: drift.Value(pcolorController.text.trim()),

      //   // Chemical
      //   c_cat: drift.Value(null),
      //   c_pa: drift.Value(parseDouble(chempaController)),
      //   c_be: drift.Value(parseDouble(chembeController)),

      //   // BPO
      //   b_color_r:
      //       bpocolorR.isEmpty
      //           ? const drift.Value.absent()
      //           : drift.Value(parseInt(bpocolorR) ?? 0),
      //   b_color_y:
      //       bpocolorY.isEmpty
      //           ? const drift.Value.absent()
      //           : drift.Value(parseInt(bpocolorY) ?? 0),
      //   b_break_test: drift.Value(bpobtController.text.trim()),

      //   // RPO
      //   r_cat: drift.Value(null),
      //   r_ffa: drift.Value(parseDouble(rpoffaController)),
      //   r_color_r:
      //       rpocolorR.isEmpty
      //           ? const drift.Value.absent()
      //           : drift.Value(parseInt(rpocolorR)),
      //   r_color_y:
      //       rpocolorY.isEmpty
      //           ? const drift.Value.absent()
      //           : drift.Value(parseInt(rpocolorY)),
      //   r_color_b:
      //       rpocolorB.isEmpty
      //           ? const drift.Value.absent()
      //           : drift.Value(parseInt(rpocolorB)),
      //   r_pv:
      //       rpopv.isEmpty
      //           ? const drift.Value.absent()
      //           : drift.Value(parseInt(rpopv)),
      //   r_m_i:
      //       rpomni.isEmpty
      //           ? const drift.Value.absent()
      //           : drift.Value(parseInt(rpomni)),
      //   r_product_tank_no: drift.Value(parseDouble(rpoproductController)),

      //   // PFAD
      //   fp_cat: drift.Value(null),
      //   fp_purity: drift.Value(parseDouble(pfadpurityController)),
      //   fp_product_tank_no: drift.Value(parseDouble(pfadproductController)),

      //   // Spent Earth
      //   spent_earth_oic: drift.Value(parseDouble(spenoicController)),

      //   // Meta
      //   pic: drift.Value(userProvider.userName),
      //   remarks: drift.Value(remarkController.text.trim()),
      //   checked_by:
      //       checkedBy == null
      //           ? const drift.Value.absent()
      //           : drift.Value(checkedBy),
      //   checked_date: drift.Value(null),
      //   checked_time: drift.Value(null),
      //   approved_by: drift.Value(null),
      //   approved_date: drift.Value(null),
      //   approved_time: drift.Value(null),

      //   // Sistem
      //   flag: drift.Value('T'),
      //   company: drift.Value(null),
      //   plant: drift.Value(null),
      //   entry_by: drift.Value(userProvider.userName),
      //   entry_date: drift.Value(DateTime.now()),
      // );

      // await qualityReportRefDao.insertQualityReportRefinery(qualityreport);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Laporan berhasil disimpan ✅')),
      // );

      // Navigator.pop(context); // Atau bisa direset form
    } catch (e) {
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
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
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
        if (selectedPartSource != null) {
          return '${selectedPartSource!} Parameters';
        }
        return 'Parameters'; // fallback jika null

      case 1:
        return 'Chemical';

      case 2:
        return 'BPO / BPKO';

      case 3:
        return 'RPO';

      case 4:
        return 'PFAD';

      case 5:
        return 'Spent Earth & remark';

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
              controller: pflowRateController,
              label: 'Flow Rate',
              icon: Icons.speed,
              isNumeric: true,
              hintText: 'Masukkan nilai Flow Rate (MT)',
            ),
            _buildTextField(
              controller: pffaController,
              label: 'FFA',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai FFA (%)',
            ),
            _buildTextField(
              controller: pivController,
              label: 'IV',
              icon: Icons.scale,
              isNumeric: true,
              hintText: 'Masukkan nilai IV (g/mg)',
            ),
            _buildTextField(
              controller: ppvController,
              label: 'PV',
              icon: Icons.energy_savings_leaf,
              isNumeric: true,
              hintText: 'Masukkan nilai PV (meq/kg)',
            ),
            _buildTextField(
              controller: panVController,
              label: 'AnV',
              icon: Icons.fact_check,
              isNumeric: true,
              hintText: 'Masukkan nilai AnV',
            ),
            _buildTextField(
              controller: pdobiController,
              label: 'DOBI',
              icon: Icons.opacity,
              isNumeric: true,
              hintText: 'Masukkan nilai DOBI',
            ),
            _buildTextField(
              controller: pcaroteneController,
              label: 'Carotene',
              icon: Icons.lens,
              isNumeric: true,
              hintText: 'Masukkan nilai Carotene',
            ),
            _buildTextField(
              controller: pmnIController,
              label: 'M&I',
              icon: Icons.opacity,
              isNumeric: true,
              hintText: 'Masukkan nilai M&I (%)',
            ),
            _buildTextField(
              controller: pcolorController,
              label: 'Color R/Y/B',
              icon: Icons.color_lens,
              hintText: 'Masukkan nilai Color',
            ),
          ],
        );

      case 1:
        return Column(
          children: [
            _buildTextField(
              controller: chempaController,
              label: 'PA',
              icon: Icons.science_outlined,
              isNumeric: true,
              hintText: 'Masukkan nilai PA (%)',
            ),
            _buildTextField(
              controller: chembeController,
              label: 'BE',
              icon: Icons.bubble_chart_outlined,
              isNumeric: true,
              hintText: 'Masukkan nilai BE (%)',
            ),
          ],
        );

      case 2:
        return Column(
          children: [
            _buildTextField(
              controller: bpocolorRController,
              label: 'Color R',
              icon: Icons.color_lens,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (R)',
            ),
            _buildTextField(
              controller: bpocolorYController,
              label: 'Color Y',
              icon: Icons.color_lens,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (Y)',
            ),
            _buildTextField(
              controller: bpobtController,
              label: 'Break Test',
              icon: Icons.color_lens,
              hintText: 'Masukkan nilai Break Test',
            ),
          ],
        );

      case 3:
        return Column(
          children: [
            _buildTextField(
              controller: rpoffaController,
              label: 'FFA',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai FFA (%)',
            ),
            _buildTextField(
              controller: rpocolorRController,
              label: 'Color R',
              icon: Icons.color_lens,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (R)',
            ),
            _buildTextField(
              controller: rpocolorYController,
              label: 'Color Y',
              icon: Icons.color_lens,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (Y)',
            ),
            _buildTextField(
              controller: rpocolorBController,
              label: 'Color B',
              icon: Icons.color_lens,
              isNumeric: true,
              hintText: 'Masukkan nilai Color (B)',
            ),
            _buildTextField(
              controller: rpopvController,
              label: 'PV',
              icon: Icons.speed,
              isNumeric: true,
              hintText: 'Masukkan nilai PV (meq/kg)',
            ),
            _buildTextField(
              controller: rpomnIController,
              label: 'M&I',
              icon: Icons.science,
              isNumeric: true,
              hintText: 'Masukkan nilai M&I (%)',
            ),
            _buildTextField(
              controller: rpoproductController,
              label: 'Product',
              icon: Icons.local_gas_station,
              isNumeric: true,
              hintText: 'Masukkan nilai Tank No',
            ),
          ],
        );

      case 4:
        return Column(
          children: [
            _buildTextField(
              controller: pfadpurityController,
              label: 'Purity',
              icon: Icons.water_drop,
              isNumeric: true,
              hintText: 'Masukkan nilai Purity (%)',
            ),
            _buildTextField(
              controller: pfadproductController,
              label: 'Product',
              icon: Icons.local_gas_station,
              isNumeric: true,
              hintText: 'Masukkan nilai Tank No',
            ),
          ],
        );

      case 5:
        return Column(
          children: [
            _buildTextField(
              controller: spenoicController,
              label: 'Spent Earth',
              icon: Icons.public,
              isNumeric: true,
              hintText: 'Masukkan nilai Spent Earth OIC (%)',
            ),
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
      appBar: buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tank Source Dropdown
                DropdownButtonFormField<double>(
                  value: selectedTankSource,
                  isExpanded: true,
                  items:
                      tankList.map((tank) {
                        final value = double.tryParse(tank.code) ?? 0.0;
                        return DropdownMenuItem<double>(
                          value: value,
                          child: Text('Tank ${tank.code} - ${tank.name}'),
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
                const SizedBox(height: 8),

                // Part Dropdown
                DropdownButtonFormField<String>(
                  value: selectedPartSource,
                  isExpanded: true,
                  items:
                      partList.map((part) {
                        return DropdownMenuItem<String>(
                          value: part.code,
                          child: Text('${part.code} - ${part.name}'),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => selectedPartSource = value);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Pilih Part',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/icons/category-svgrepo-com.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                if (selectedPartSource != null) ...[
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
                            backgroundColor: const Color(0xFFAB2F2B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                              currentStep == 5 ? _saveQualityReport : _nextStep,
                          label: Text(currentStep == 5 ? 'Save' : 'Next'),
                        ),
                      ),
                    ],
                  ),
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
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: const Text(
        'Quality Report - Refinery',
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
}
