import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/logsheet/pretreatment_bleaching_filtration_entity.dart';
import 'package:logsheet_app/providers/logsheet/pretreatment_bleaching_filtration_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class LogsheetPretreatmentBleachingFiltrationEditPage extends StatefulWidget {
  final PretreatmentBleachingFiltrationEntity logsheet;
  const LogsheetPretreatmentBleachingFiltrationEditPage({
    super.key,
    required this.logsheet,
  });

  @override
  State<LogsheetPretreatmentBleachingFiltrationEditPage> createState() =>
      _LogsheetPretreatmentBleachingFiltrationEditPageState();
}

class _LogsheetPretreatmentBleachingFiltrationEditPageState
    extends State<LogsheetPretreatmentBleachingFiltrationEditPage> {
  String? selectedFilter;
  int? selectedHour;
  int currentStep = 0;
  String? selectedWorkCenter;
  DataFormNoEntity? formData;

  final Map<String, TextEditingController> pressureControllers = {};
  final Map<String, int> stepValues = {};
  final Map<String, bool> clarityValues = {};

  final TextEditingController cleanlinessController = TextEditingController();
  final TextEditingController tekananAwalController = TextEditingController();
  final TextEditingController tekananAkhirController = TextEditingController();
  final TextEditingController tekananSleeveController = TextEditingController();

  // Pretreatment
  final TextEditingController ptFit001Controller = TextEditingController();
  final TextEditingController ptE001aInletController = TextEditingController();
  final TextEditingController ptFit0012Controller = TextEditingController();
  final TextEditingController ptH3PO4Controller = TextEditingController();
  final TextEditingController ptBEController = TextEditingController();

  // Bleach
  final TextEditingController blVacumController = TextEditingController();
  final TextEditingController blTInletController = TextEditingController();
  final TextEditingController blTB602Controller = TextEditingController();
  final TextEditingController blSpurgeController = TextEditingController();

  // Pump
  final TextEditingController pAController = TextEditingController();
  final TextEditingController pBController = TextEditingController();
  final TextEditingController pCController = TextEditingController();

  // Filter Niagara
  final TextEditingController fnF601Controller = TextEditingController();
  final TextEditingController fnF602Controller = TextEditingController();
  final TextEditingController fnF603Controller = TextEditingController();
  final TextEditingController fnF604AController = TextEditingController();
  final TextEditingController fnF604BController = TextEditingController();
  final TextEditingController fnF604CController = TextEditingController();

  // Filter Bag

  final TextEditingController fcF605AController = TextEditingController();
  final TextEditingController fcF605BController = TextEditingController();

  // Clarity
  final TextEditingController clarityController = TextEditingController();

  // Remarks
  final TextEditingController remarksController = TextEditingController();

  void _populateFields() {
    final logsheet = widget.logsheet;
    selectedWorkCenter = logsheet.refineryMachine;
    selectedHour = logsheet.time?.hour;

    // Pretreatment
    ptFit001Controller.text = logsheet.ptFit001?.toString() ?? '';
    ptE001aInletController.text = logsheet.ptE001aInlet?.toString() ?? '';
    ptFit0012Controller.text = logsheet.ptF0012?.toString() ?? '';
    ptH3PO4Controller.text = logsheet.ptH3po4?.toString() ?? '';
    ptBEController.text = logsheet.ptBe?.toString() ?? '';

    // Bleaching
    blVacumController.text = logsheet.blVacum?.toString() ?? '';
    blTInletController.text = logsheet.blTInlet?.toString() ?? '';
    blTB602Controller.text = logsheet.blTB602?.toString() ?? '';
    blSpurgeController.text = logsheet.blSpurge?.toString() ?? '';

    // Pump
    pAController.text = logsheet.pA?.toString() ?? '';
    pBController.text = logsheet.pB?.toString() ?? '';
    pCController.text = logsheet.pC?.toString() ?? '';

    // Niagara Filter
    fnF601Controller.text = logsheet.fnF601?.toString() ?? '';
    fnF602Controller.text = logsheet.fnF602?.toString() ?? '';
    fnF603Controller.text = logsheet.fnF603?.toString() ?? '';
    fnF604AController.text = logsheet.fb604a?.toString() ?? '';
    fnF604BController.text = logsheet.fb604b?.toString() ?? '';
    fnF604CController.text = logsheet.fb604c?.toString() ?? '';

    // Catridge Filters
    fcF605AController.text = logsheet.fc605a?.toString() ?? '';
    fcF605BController.text = logsheet.fc605b?.toString() ?? '';

    clarityController.text = logsheet.clarity ?? '';
    remarksController.text = logsheet.remarks ?? '';
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => context.read<ValueProvider>().fetchWorkCenterLists(),
    );

    _populateFields();
  }

  @override
  void dispose() {
    final controllers = [
      ptFit001Controller,
      ptE001aInletController,
      ptFit0012Controller,
      ptH3PO4Controller,
      ptBEController,
      blVacumController,
      blTInletController,
      blTB602Controller,
      blSpurgeController,
      pAController,
      pBController,
      pCController,
      fnF601Controller,
      fnF602Controller,
      fnF603Controller,
      fnF604AController,
      fnF604BController,
      fnF604CController,
      fcF605AController,
      fcF605BController,
      clarityController,
      remarksController,
    ];
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryRed = const Color(0xFFAB2F2B);
    final Color backgroundGrey = const Color(0xFFEFF3F9);
    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    try {
      formData = context.read<DataFormNoProvider>().dataFormNoList.firstWhere(
        (form) => form.isMenu == "Logsheet_Pretreatment_Bleaching_Filtration",
      );
    } catch (e) {
      log(
        "Form data for 'Logsheet_Pretreatment_Bleaching_Filtration' not found. Using defaults.",
      );
      formData = null;
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: Text(
        'Edit PBF - ${formData?.code}',
        style: const TextStyle(
          color: Color(0xFF655F5B),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Transaction Date: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat(
                  'yyyy-MM-dd',
                ).format(widget.logsheet.transactionDate ?? DateTime.now()),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Consumer<ValueProvider>(
            builder: (context, provider, child) {
              if (provider.workCenterLists.isEmpty) {
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

              return DropdownButtonFormField(
                value: selectedWorkCenter,
                items:
                    provider.workCenterLists.map((machine) {
                      return DropdownMenuItem<String>(
                        value: machine.code,
                        child: Text("${machine.code} - ${machine.name}"),
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
                prefixIcon: const Icon(
                  Icons.access_time,
                  color: Color(0xFF655F5B),
                ),
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

          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(8, (index) {
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
                            isSelected ? Colors.white : const Color(0xFF655F5B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
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
          _navigationButton(context),
        ],
      ),
    );
  }

  void _nextStep() {
    // if (_validateCurrentStep()) {
    if (currentStep < 7) setState(() => currentStep++);
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

  String getStepTitle() {
    switch (currentStep) {
      case 0:
        return "Pretreatment";
      case 1:
        return "Bleacher";
      case 2:
        return "Pump";
      case 3:
        return "Niagara Filter";
      case 4:
        return "Filter Bag";
      case 5:
        return "Catridge Filter";
      case 6:
        return "Clarity";
      case 7:
        return "Remarks";
      default:
        return "Step";
    }
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return Column(
          children: [
            _buildTextField(
              controller: ptFit001Controller,
              label: 'FIT001 (CPO)',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai FIT001 (Tph)',
            ),
            _buildTextField(
              controller: ptE001aInletController,
              label: 'E001A INLET CPO',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai E001A INLET CPO (°C)',
            ),
            _buildTextField(
              controller: ptFit0012Controller,
              label: 'FIT001/2 Str.',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai FIT001/2 Str. (bar)',
            ),
            _buildTextField(
              controller: ptH3PO4Controller,
              label: 'H3PO4',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai FFA (0.05-0.08)',
            ),
            _buildTextField(
              controller: ptBEController,
              label: 'BE',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai BE (0.6 - 1.5)',
            ),
          ],
        );

      case 1:
        return Column(
          children: [
            _buildTextField(
              controller: blVacumController,
              label: 'Vacum',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai Vacum (mmHg)',
            ),
            _buildTextField(
              controller: blTInletController,
              label: 'T-Inlet',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai T-Inlet(°C)',
            ),
            _buildTextField(
              controller: blTB602Controller,
              label: 'T B602',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai T B602 (°C)',
            ),
            _buildTextField(
              controller: blSpurgeController,
              label: 'Spurge',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai Spurge (bar)',
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            _buildTextField(
              controller: pAController,
              label: 'Pump A',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai Pump A (bar)',
            ),
            _buildTextField(
              controller: pBController,
              label: 'Pump B',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai Pump B (bar)',
            ),
            _buildTextField(
              controller: pCController,
              label: 'Pump C',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai Pump C (bar)',
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            _buildTextField(
              controller: fnF601Controller,
              label: 'F601',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai F601 (bar)',
            ),
            _buildTextField(
              controller: fnF602Controller,
              label: 'F602',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai F602 (bar)',
            ),
            _buildTextField(
              controller: fnF603Controller,
              label: 'F603',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai F603 (bar)',
            ),
          ],
        );
      case 4:
        return Column(
          children: [
            _buildTextField(
              controller: fnF604AController,
              label: 'F604A',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai F604A (bar)',
            ),
            _buildTextField(
              controller: fnF604BController,
              label: 'F604B',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai F604B (bar)',
            ),
            _buildTextField(
              controller: fnF604CController,
              label: 'F604C',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai F604C (bar)',
            ),
          ],
        );
      case 5:
        return Column(
          children: [
            _buildTextField(
              controller: fcF605AController,
              label: 'F605A',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai F605A (bar)',
            ),
            _buildTextField(
              controller: fcF605BController,
              label: 'F605B',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai F605B (bar)',
            ),
          ],
        );
      case 6:
        return Column(
          children: [
            _buildTextField(
              controller: clarityController,
              label: 'Clarity',
              icon: Icons.bubble_chart,
              hintText: 'Masukkan Clarity (Clear/Not Clear)',
            ),
          ],
        );
      case 7:
        return Column(
          children: [
            _buildTextField(
              controller: remarksController,
              label: 'Remarks',
              icon: Icons.bubble_chart,
              hintText: 'Masukkan Remarks',
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
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
            icon: Icon(currentStep == 7 ? Icons.save : Icons.arrow_forward),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAB2F2B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed:
                currentStep == 7 ? () => _showAlertDialog(context) : _nextStep,
            label: Text(currentStep == 7 ? 'Update' : 'Next'),
          ),
        ),
      ],
    );
  }

  // Shows a confirmation dialog before saving the data.
  void _showAlertDialog(BuildContext context) {
    log("Show Dialog function");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Input"),
          content: const Text("Apakah data yang anda masukkan sudah sesuai?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tidak", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first
                _update(); // Then call the save function
              },
              child: Consumer<PretreatmentBleachingFiltrationProvider>(
                builder: (context, provider, child) {
                  // You'll need to add 'isLoading' to your provider for this indicator
                  if (provider.isLoading) {
                    return const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    );
                  }
                  return const Text("Ya");
                },
              ),
            ),
          ],
        );
      },
    );
  }

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

  void _showHourPicker(BuildContext context) {
    int initialHour = selectedHour ?? TimeOfDay.now().hour;
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
                        style: const TextStyle(color: Color(0xFF655F5B)),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text(
                  'Pilih',
                  style: TextStyle(color: Color(0xFFAB2F2B)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _update() async {
    log("Update button logsheet pretreatment clicked");
    final provider = context.read<PretreatmentBleachingFiltrationProvider>();
    final userProvider = context.read<UserProvider>();

    try {
      final updatedEntity = PretreatmentBleachingFiltrationEntity(
        id: widget.logsheet.id,

        // Pretreatment
        ptFit001: parseDouble(ptFit001Controller),
        ptE001aInlet: parseDouble(ptE001aInletController),
        ptF0012: parseDouble(ptFit0012Controller),
        ptH3po4: parseDouble(ptH3PO4Controller),
        ptBe: parseDouble(ptBEController),

        // Bleaching
        blVacum: blVacumController.text,
        blTInlet: parseDouble(blTInletController),
        blTB602: parseDouble(blTB602Controller),
        blSpurge: parseDouble(blSpurgeController),

        // Pump
        pA: parseDouble(pAController),
        pB: parseDouble(pBController),
        pC: parseDouble(pCController),

        // Niagara Filter
        fnF601: parseDouble(fnF601Controller),
        fnF602: parseDouble(fnF602Controller),
        fnF603: parseDouble(fnF603Controller),
        fb604a: parseDouble(fnF604AController),
        fb604b: parseDouble(fnF604BController),
        fb604c: parseDouble(fnF604CController),

        // Catridge Filters
        fc605a: parseDouble(fcF605AController),
        fc605b: parseDouble(fcF605BController),

        clarity: clarityController.text,
        remarks: remarksController.text,
        flag: widget.logsheet.flag,
        company: widget.logsheet.company,
        plant: widget.logsheet.plant,
        transactionDate: widget.logsheet.transactionDate,
        postingDate: widget.logsheet.postingDate,
        refineryMachine: widget.logsheet.refineryMachine,
        time: widget.logsheet.time,
        shift: widget.logsheet.shift,
        entryBy: widget.logsheet.entryBy,
        entryDate: widget.logsheet.entryDate,
        preparedBy: null,
        preparedDate: null,
        preparedStatus: null,
        preparedStatusRemarks: null,
        checkedBy: null,
        checkedDate: null,
        checkedStatus: null,
        checkedStatusRemarks: null,
        updatedBy: userProvider.currentUser?.username,
        updatedDate: DateTime.now(),
        formNo: widget.logsheet.formNo,
        dateIssued: widget.logsheet.dateIssued,
        revisionNo: widget.logsheet.revisionNo,
        revisionDate: widget.logsheet.revisionDate,
      );

      bool success = await provider.updateTicket(updatedEntity);

      if (success) {
        if (!mounted) return;
        final username = context.read<UserProvider>().currentUser?.username;
        final role = context.read<UserProvider>().currentUser?.role;
        final plantCode =
            context.read<PlantProvider>().currentPlant?.code ?? "";
        provider.fetchAllTicket(
          null,
          null,
          username ?? "",
          role ?? "",
          plantCode,
        );
        _showSnackBar('Update berhasil');
        if (mounted) Navigator.pop(context, updatedEntity);
      } else {
        _showSnackBar('Gagal memperbarui data');
      }
    } catch (e) {
      log("Gagal menyimpan perubahan: $e");
      _showSnackBar("Terjadi kesalahan: $e");
    }
  }

  double? parseDouble(TextEditingController c) {
    final text = c.text.trim();
    return text.isEmpty || text == "-"
        ? null
        : double.parse(double.parse(text).toStringAsFixed(4));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
