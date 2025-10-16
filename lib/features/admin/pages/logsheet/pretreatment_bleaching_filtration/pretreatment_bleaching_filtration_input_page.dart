import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/logsheet/pretreatment_bleaching_filtration_entity.dart';
import 'package:logsheet_app/providers/logsheet/pretreatment_bleaching_filtration_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class FiltrationPerformInputPage extends StatefulWidget {
  const FiltrationPerformInputPage({super.key});

  @override
  State<FiltrationPerformInputPage> createState() =>
      _FiltrationPerformInputPageState();
}

class _FiltrationPerformInputPageState
    extends State<FiltrationPerformInputPage> {
  String? selectedFilter;
  int? selectedHour;
  int currentStep = 0;
  String? selectedWorkCenter;
  String? selectedOilType;
  DataFormNoEntity? formData;
  // final List<String> filterOptions = [
  //   'Niagara Filter',
  //   'Sleeve Filter',
  //   'BPO - Cartridge Filter',
  // ];

  // final Map<String, List<String>> niagaraFilters = {
  //   'FL621': ['pressure', 'step', 'clarity'],
  //   'FL622': ['pressure', 'step', 'clarity'],
  //   'FL623': ['pressure', 'step', 'clarity'],
  // };

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
  final TextEditingController fbF604AController = TextEditingController();
  final TextEditingController fbF604BController = TextEditingController();
  final TextEditingController fbF604CController = TextEditingController();

  // Filter Bag
  final TextEditingController fcF605AController = TextEditingController();
  final TextEditingController fcF605BController = TextEditingController();

  // Clarity
  final TextEditingController clarityController = TextEditingController();

  // Remarks
  final TextEditingController remarksController = TextEditingController();

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
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    final controllers = [
      cleanlinessController,
      tekananAwalController,
      tekananAkhirController,
      tekananSleeveController,
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
      fbF604AController,
      fbF604BController,
      fbF604CController,
      fcF605AController,
      fcF605BController,
      clarityController,
      remarksController,
    ];

    for (var controller in pressureControllers.values) {
      controller.dispose();
    }
    for (var c in controllers) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final valueProvider = context.read<ValueProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await valueProvider.fetchWorkCenterLists();

      if (valueProvider.oilTypeLists.isEmpty) {
        await valueProvider.fetchOilTypes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: _buildBody(context),
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

  void _refreshPage() async {
    if (!mounted) return;
    context.read<PretreatmentBleachingFiltrationProvider>().setLoadingReset(
      true,
    );

    log("Refresh button clicked");
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      log("Refreshing form state");
      currentStep = 0;
      selectedWorkCenter = null;
      selectedHour = null;
      selectedOilType = null;
      final controllers = [
        cleanlinessController,
        tekananAwalController,
        tekananAkhirController,
        tekananSleeveController,
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
        fbF604AController,
        fbF604BController,
        fbF604CController,
        fcF605AController,
        fcF605BController,
        clarityController,
        remarksController,
      ];

      for (var c in controllers) {
        c.clear();
      }
    });
    if (!mounted) return;
    context.read<PretreatmentBleachingFiltrationProvider>().setLoadingReset(
      false,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
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

              Consumer<ValueProvider>(
                builder: (context, provider, child) {
                  if (provider.isWorkCenterLoading) {
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
                        hintText: 'Work Center tidak ditemukan.',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.warning_amber_rounded),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            provider.fetchWorkCenterLists();
                          },
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

              const SizedBox(height: 6),
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
              const SizedBox(height: 6),
              // OIL TYPE DROPDOWN
              Consumer<ValueProvider>(
                builder: (context, provider, child) {
                  if (provider.isOilTypeLoading) {
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
                            provider.fetchOilTypes();
                          },
                        ),
                      ),
                    );
                  }

                  return DropdownButtonFormField(
                    value: selectedOilType,
                    items:
                        provider.oilTypeLists.map((oil) {
                          return DropdownMenuItem<String>(
                            value: oil.code,
                            child: Text(oil.name),
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
              if (selectedWorkCenter != null &&
                  selectedHour != null &&
                  selectedOilType != null) ...[
                // Step indicator
                SizedBox(height: 40),
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
              ] else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      'Silakan pilih Work Center, Oil Type, dan Jam Input.',
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

        Consumer<PretreatmentBleachingFiltrationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingReset) {
              return Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
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

  double? parseDouble(TextEditingController c) {
    final text = c.text.trim();
    return text.isEmpty || text == "-" || double.parse(text) == 0
        ? null
        : double.tryParse(text);
  }

  DateTime getPostingDate() {
    final DateTime now = DateTime.now();
    final int hour = selectedHour ?? now.hour;

    if (hour <= 7) {
      final DateTime previousDay = now.subtract(const Duration(days: 1));
      return DateTime(previousDay.year, previousDay.month, previousDay.day);
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
    return DateTime.now();
  }

  // Calculates the shift number based on the day and hour.
  int getShiftBasedOnTimeAndDate(DateTime time) {
    int hour = time.hour;
    int day = time.weekday;
    log("Day: $day, Hour: $hour");

    // Friday has special shift timings
    if (day >= DateTime.friday) {
      if (hour >= 8 && hour < 20) {
        return 4; // Shift 4 for Friday day
      } else {
        return 5; // Shift 5 for Friday night
      }
    } else {
      // Regular weekday shifts
      if (hour >= 8 && hour <= 15) {
        return 1;
      } else if (hour >= 16 && hour <= 23) {
        return 2;
      } else {
        return 3;
      }
    }
  }

  // Shows a confirmation dialog before saving the data.
  void _showAlertDialog(BuildContext context) {
    log("Show Dialog function");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        bool isLoading =
            context.watch<PretreatmentBleachingFiltrationProvider>().isLoading;

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
              onPressed:
                  isLoading
                      ? null
                      : () async {
                        await _save();
                        Future.delayed(Duration(milliseconds: 300));
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
              child: Consumer<PretreatmentBleachingFiltrationProvider>(
                builder: (context, provider, child) {
                  // You'll need to add 'isLoading' to your provider for this indicator
                  if (provider.isLoading) {
                    return const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(color: Colors.red),
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

  Future<String> buildTicketNumber() async {
    final provider = context.read<PretreatmentBleachingFiltrationProvider>();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    if (plantCode.isEmpty) {
      _showSnackBar("Error: Plant code is not available.");
      return "";
    }

    final latestTicketIdFromProvider = await provider.fetchLatestId(plantCode);

    if (latestTicketIdFromProvider == null ||
        latestTicketIdFromProvider.length < 9) {
      _showSnackBar(
        "Error: Could not fetch the latest ticket number for this plant.",
      );
      log("ID from provider is null or invalid: $latestTicketIdFromProvider");
      return "";
    }

    log("Latest Ticket ID: $latestTicketIdFromProvider");

    // Increment the numeric part of the ID
    int digit = (int.parse((latestTicketIdFromProvider.substring(9))) + 1);

    // Update the counter in the database via the provider
    final updateSuccess = await provider.updateAutoNumber(plantCode, digit);

    if (!updateSuccess) {
      log("Failed to update the auto number counter.");
      _showSnackBar("Error: Could not update the ticket number sequence.");
      return "";
    }

    String lastDigit = digit.toString().padLeft(6, '0');
    String ticketPrefix = latestTicketIdFromProvider.substring(0, 9);

    log("New Ticket Number: ${ticketPrefix + lastDigit}");
    return ticketPrefix + lastDigit;
  }

  Future<void> _save() async {
    log("Save button logsheet pretreatment clicked");
    final provider = context.read<PretreatmentBleachingFiltrationProvider>();
    final userProvider = context.read<UserProvider>();
    final buProvider = context.read<BusinessUnitProvider>();
    final plantProvider = context.read<PlantProvider>();

    if (selectedWorkCenter == null ||
        selectedHour == null ||
        selectedOilType == null) {
      _showSnackBar('Mohon lengkapi Work Center, Oil Type, dan Jam Input.');
      return;
    }

    try {
      final postingDate = getPostingDate();
      final transactionDate = getTransactionDate();
      final formattedTime = '${selectedHour.toString().padLeft(2, '0')}:00:00';
      final fullDateTimeForShift = DateTime(
        postingDate.year,
        postingDate.month,
        postingDate.day,
        selectedHour!,
      );

      final shift = getShiftBasedOnTimeAndDate(fullDateTimeForShift);

      final businessUnitCode = buProvider.currentBusinessUnit?.buCode ?? "";
      final plantCode = plantProvider.currentPlant?.code ?? "";
      final currentUser = userProvider.currentUser;
      final ticketId = await buildTicketNumber();

      if (ticketId == "") {
        return;
      }

      final entity = PretreatmentBleachingFiltrationEntity(
        id: ticketId,
        company: businessUnitCode,
        plant: plantCode,
        transactionDate: transactionDate,
        postingDate: postingDate,
        refineryMachine: selectedWorkCenter,
        time: DateFormat('HH:mm:ss').parse(formattedTime),
        shift: shift,

        //Pretreatment
        oilType: selectedOilType,
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

        // Filter Bag
        fb604a: parseDouble(fbF604AController),
        fb604b: parseDouble(fbF604BController),
        fb604c: parseDouble(fbF604CController),

        // Catridge Filters
        fc605a: parseDouble(fcF605AController),
        fc605b: parseDouble(fcF605BController),

        clarity: clarityController.text,
        remarks: remarksController.text,
        flag: "T",

        entryBy: currentUser?.username,
        entryDate: DateTime.now(),

        preparedBy: null,
        preparedDate: null,
        preparedStatus: null,
        preparedStatusRemarks: null,

        updatedBy: null,
        updatedDate: null,

        checkedBy: null,
        checkedDate: null,
        checkedStatus: null,
        checkedStatusRemarks: null,

        formNo: formData?.code,
        dateIssued: formData?.dateIssued,
        revisionNo: formData?.revisionNo,
        revisionDate: formData?.revisionDate,
      );

      bool? success;

      log("attemp to insert deodorizing ticket $ticketId");
      success = await provider.insert(entity);

      if (success) {
        // fetch all reports
        if (!mounted) return;
        final username = context.read<UserProvider>().currentUser?.username;
        final role = context.read<UserProvider>().currentUser?.role;
        final plantCode =
            context.read<PlantProvider>().currentPlant?.code ?? "";
        await provider.fetchAllTicket(
          null,
          null,
          username ?? "",
          role ?? "",
          plantCode,
        );

        _showSnackBar('Input berhasil');
        log('Insert successful');
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      log("Gagal menyimpan laporan: $e");
      _showSnackBar("Terjadi kesalahan: $e");
    } finally {
      //
    }
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return Column(
          children: [
            _buildTextField(
              controller: ptFit001Controller,
              label: 'FIT001 ($selectedOilType)',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai FIT001 (Tph)',
            ),
            _buildTextField(
              controller: ptE001aInletController,
              label: 'E001A INLET $selectedOilType',
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
              controller: fbF604AController,
              label: 'F604A',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai F604A (bar)',
            ),
            _buildTextField(
              controller: fbF604BController,
              label: 'F604B',
              icon: Icons.bubble_chart,
              isNumeric: true,
              hintText: 'Masukkan nilai F604B (bar)',
            ),
            _buildTextField(
              controller: fbF604CController,
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
                ? const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                )
                : TextInputType.text,
        inputFormatters:
            isNumeric
                ? [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*'))]
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

  AppBar _buildAppBar() {
    try {
      formData = context.read<DataFormNoProvider>().dataFormNoList.firstWhere(
        (form) => form.isMenu == "Logsheet_Pretreatment_Bleaching_Filtration",
      );
    } catch (e) {
      log(
        "Form data for 'Logsheet_Pretreatment_Bleaching_Filtration' not found. Using defaults.",
      );
      // Handle case where form data might not be found
      formData = null;
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: Text(
        'PBF - ${formData?.code}',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshPage),
      ],
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
            label: Text(currentStep == 7 ? 'Save' : 'Next'),
          ),
        ),
      ],
    );
  }
}
