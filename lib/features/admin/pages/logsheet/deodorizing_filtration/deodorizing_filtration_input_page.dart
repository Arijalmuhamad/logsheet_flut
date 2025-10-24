import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/logsheet/deodorizing_filtration_entity.dart';
import 'package:logsheet_app/providers/logsheet/deodorizing_filtration_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/product_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class DeodorizingFiltrationInputPage extends StatefulWidget {
  const DeodorizingFiltrationInputPage({super.key});

  @override
  State<DeodorizingFiltrationInputPage> createState() =>
      _DeodorizingFiltrationInputPageState();
}

class _DeodorizingFiltrationInputPageState
    extends State<DeodorizingFiltrationInputPage> {
  int? selectedHour;
  String? selectedWorkCenter;
  String? selectedOilType;
  String? selectedOilTypeNameFg;
  String? selectedOilTypeFg;
  String? selectedOilTypeNameBp;
  String? selectedOilTypeBp;
  int currentStep = 0;
  DataFormNoEntity? formData;

  // Controllers for Deodorizing Filtration inputs
  final fit701BpoController = TextEditingController();
  final d701VacumController = TextEditingController();
  final d701Td701Controller = TextEditingController();
  final e702Controller = TextEditingController();
  final thermopacInletController = TextEditingController();
  final thermopacOutletController = TextEditingController();
  final d702InletController = TextEditingController();
  final d702OutletController = TextEditingController();
  final d702VacumController = TextEditingController();
  final spargingAController = TextEditingController();
  final spargingBController = TextEditingController();
  final e730InletController = TextEditingController();
  final steamInletController = TextEditingController();
  final pish706Controller = TextEditingController();
  final tiwh706Controller = TextEditingController();
  final f702AController = TextEditingController();
  final f702BController = TextEditingController();
  final f702CController = TextEditingController();
  final fit704RpoController = TextEditingController();
  final e704Controller = TextEditingController();
  final fit705PfadController = TextEditingController();
  final e705Controller = TextEditingController();
  final clarityController = TextEditingController();
  final remarksController = TextEditingController();

  @override
  void initState() {
    final valueProvider = context.read<ValueProvider>();
    final productProvider = context.read<ProductProvider>();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await valueProvider.fetchWorkCenterLists();

      if (valueProvider.oilTypeLists.isEmpty) {
        await valueProvider.fetchOilTypes();
      }

      if (productProvider.productList.isEmpty) {
        await productProvider.fetchProducts();
      }
    });
  }

  @override
  void dispose() {
    final controllers = [
      fit701BpoController,
      d701VacumController,
      d701Td701Controller,
      e702Controller,
      thermopacInletController,
      thermopacOutletController,
      d702InletController,
      d702OutletController,
      d702VacumController,
      spargingAController,
      spargingBController,
      e730InletController,
      steamInletController,
      pish706Controller,
      tiwh706Controller,
      f702AController,
      f702BController,
      f702CController,
      fit704RpoController,
      e704Controller,
      fit705PfadController,
      e705Controller,
      clarityController,
      remarksController,
    ];

    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
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
                    onSelectedItemChanged: (int value) => selectedHour = value,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  void _nextStep() {
    if (currentStep < 7) setState(() => currentStep++);
  }

  void _prevStep() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  void _goToStep(int step) {
    setState(() => currentStep = step);
  }

  void _refreshPage() async {
    if (!mounted) return;
    // Assuming the provider has a similar loading state
    context.read<DeodorizingFiltrationProvider>().setLoadingReset(true);

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      currentStep = 0;
      selectedWorkCenter = null;
      selectedHour = null;
      selectedOilType = null;
      selectedOilTypeFg = null;
      selectedOilTypeBp = null;
      final controllers = [
        fit701BpoController,
        d701VacumController,
        d701Td701Controller,
        e702Controller,
        thermopacInletController,
        thermopacOutletController,
        d702InletController,
        d702OutletController,
        d702VacumController,
        spargingAController,
        spargingBController,
        e730InletController,
        steamInletController,
        pish706Controller,
        tiwh706Controller,
        f702AController,
        f702BController,
        f702CController,
        fit704RpoController,
        e704Controller,
        fit705PfadController,
        e705Controller,
        clarityController,
        remarksController,
      ];

      for (var c in controllers) {
        c.clear();
      }
    });
    if (!mounted) return;
    context.read<DeodorizingFiltrationProvider>().setLoadingReset(false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
              Text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
            ],
          ),
          const SizedBox(height: 8),

          // Work Center Dropdown
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
                onChanged: (value) async {
                  setState(() => selectedWorkCenter = value);
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

          // Hour Picker
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
          Consumer<ProductProvider>(
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
                    hintText: 'Loading Oil Type...',
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

              if (provider.productRefineryList.isEmpty) {
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

              return DropdownButtonFormField(
                value: selectedOilType,
                items:
                    provider.productRefineryList.map((oil) {
                      return DropdownMenuItem<String>(
                        value: oil.id,
                        child: Text(oil.rawMaterial!),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOilType = value;
                    selectedOilTypeFg =
                        provider.productRefineryList
                            .firstWhere((item) => item.id == selectedOilType)
                            .id;

                    selectedOilTypeNameFg =
                        provider.productRefineryList
                            .firstWhere((item) => item.id == selectedOilType)
                            .finishGood;

                    selectedOilTypeBp =
                        provider.productRefineryList
                            .firstWhere((item) => item.id == selectedOilType)
                            .id;

                    selectedOilTypeNameBp =
                        provider.productRefineryList
                            .firstWhere((item) => item.id == selectedOilType)
                            .byProduct;
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
            const SizedBox(height: 40),
            // Step indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(8, (index) {
                return InkWell(
                  onTap: () => _goToStep(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color:
                          currentStep == index
                              ? const Color(0xFFAB2F2B)
                              : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color:
                              currentStep == index
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

            // Form Card
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
                  'Silakan pilih Work Center dan Jam Input.',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String getStepTitle() {
    switch (currentStep) {
      case 0:
        return "FIT 701 & D701";
      case 1:
        return "E702 & Thermopac";
      case 2:
        return "D702 & Sparging";
      case 3:
        return "Steam & Pish";
      case 4:
        return "Filter F702";
      case 5:
        return "FIT 704 & FIT 705";
      case 6:
        return "E704 & E705";
      case 7:
        return "Clarity & Remarks";
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
    final now = DateTime.now();
    final hour = selectedHour ?? now.hour;
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

  DateTime getTransactionDate() => DateTime.now();

  int getShiftBasedOnTimeAndDate(DateTime time) {
    int hour = time.hour;
    int day = time.weekday;
    if (day >= DateTime.friday) {
      return (hour >= 8 && hour < 20) ? 4 : 5;
    } else {
      if (hour >= 8 && hour <= 15) return 1;
      if (hour >= 16 && hour <= 23) return 2;
      return 3;
    }
  }

  void _showAlertDialog(BuildContext context) {
    log("Show Dialog function");
    showDialog(
      context: context,
      builder: (context) {
        bool isLoading =
            context.watch<DeodorizingFiltrationProvider>().isLoading;

        return AlertDialog(
          title: const Text("Konfirmasi Input"),
          content: const Text("Apakah data yang anda masukkan sudah sesuai?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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

              child: Consumer<DeodorizingFiltrationProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const SizedBox(
                      width: 6,
                      height: 6,
                      child: CircularProgressIndicator(color: Colors.white),
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

  // NEW: Function to build the ticket number
  Future<String> buildTicketNumber() async {
    final provider = context.read<DeodorizingFiltrationProvider>();
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
    final provider = context.read<DeodorizingFiltrationProvider>();
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
      final fullDateTimeForShift = DateTime(
        postingDate.year,
        postingDate.month,
        postingDate.day,
        selectedHour!,
      );
      final shift = getShiftBasedOnTimeAndDate(fullDateTimeForShift);
      final formattedTime = '${selectedHour.toString().padLeft(2, '0')}:00:00';
      final newId = await buildTicketNumber();

      if (newId.isEmpty) {
        return;
      }

      final entity = DeodorizingFiltrationEntity(
        // UPDATED: Call the ticket number generation function
        id: newId,
        company: buProvider.currentBusinessUnit?.buCode,
        plant: plantProvider.currentPlant?.code,
        transactionDate: getTransactionDate(),
        postingDate: postingDate,
        refineryMachine: selectedWorkCenter,
        time: DateFormat('HH:mm:ss').parse(formattedTime),
        oilTypeId: selectedOilType,
        shift: shift,
        fit701: parseDouble(fit701BpoController),
        d701Vacum: parseDouble(d701VacumController),
        d701Td701: parseDouble(d701Td701Controller),
        e702: parseDouble(e702Controller),
        thermopacInlet: parseDouble(thermopacInletController),
        thermopacOutlet: parseDouble(thermopacOutletController),
        d702Inlet: parseDouble(d702InletController),
        d702Outlet: parseDouble(d702OutletController),
        d702Vacum: parseDouble(d702VacumController),
        spargingA: spargingAController.text,
        spargingB: spargingBController.text,
        e730Inlet: e730InletController.text,
        steamInlet: steamInletController.text,
        pish706: pish706Controller.text,
        tiwh706: tiwh706Controller.text,
        f702A: parseDouble(f702AController),
        f702B: parseDouble(f702BController),
        f702C: parseDouble(f702CController),
        oilTypeFgId: selectedOilTypeFg,
        fit704: parseDouble(fit704RpoController),
        e704: parseDouble(e704Controller),
        oilTypeBpId: selectedOilTypeBp,
        fit705: parseDouble(fit705PfadController),
        e705: parseDouble(e705Controller),
        clarity: clarityController.text,
        remarks: remarksController.text,
        entryBy: userProvider.currentUser?.username,
        entryDate: DateTime.now(),
        preparedBy: null,
        preparedDate: null,
        checkedBy: null,
        checkedDate: null,
        formNo: formData?.code,
        dateIssued: formData?.dateIssued,
        revisionNo: formData?.revisionNo,
        revisionDate: formData?.revisionDate,
        flag: 'T',
        preparedStatus: null,
        preparedStatusRemarks: null,
        checkedStatus: null,
        checkedStatusRemarks: null,
        updatedDate: null,
        updatedBy: null,
      );

      bool success = await provider.insert(entity); // Assuming insert exists

      if (success) {
        if (!mounted) return;
        _showSnackBar('Input berhasil');
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
        if (!mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      log("Gagal menyimpan laporan: $e");
      _showSnackBar("Terjadi kesalahan: $e");
    }
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return Column(
          children: [
            _buildTextField(
              controller: fit701BpoController,
              label: 'FIT 701 ($selectedOilType) - tph',
              isNumeric: true,
            ),
            _buildTextField(
              controller: d701VacumController,
              label: 'D701 (Vacum) - cmHg',
              isNumeric: true,
            ),
            _buildTextField(
              controller: d701Td701Controller,
              label: 'D701 (T D701) - °C',
              isNumeric: true,
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            _buildTextField(
              controller: e702Controller,
              label: 'E702 - °C',
              isNumeric: true,
            ),
            _buildTextField(
              controller: thermopacInletController,
              label: 'Thermopac - Inlet',
              isNumeric: true,
            ),
            _buildTextField(
              controller: thermopacOutletController,
              label: 'Thermopac - Outlet',
              isNumeric: true,
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            _buildTextField(
              controller: d702InletController,
              label: 'D702 - Inlet - °C',
              isNumeric: true,
            ),
            _buildTextField(
              controller: d702OutletController,
              label: 'D702 - Outlet - °C',
              isNumeric: true,
            ),
            _buildTextField(
              controller: d702VacumController,
              label: 'D702 - Vacum - mbar',
              isNumeric: true,
            ),
            _buildTextField(
              controller: spargingAController,
              label: 'Sparging A - bar',
            ),
            _buildTextField(
              controller: spargingBController,
              label: 'Sparging B - bar',
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            _buildTextField(
              controller: e730InletController,
              label: 'E 730 Inlet - °C',
            ),
            _buildTextField(
              controller: steamInletController,
              label: 'Steam Inlet - bar',
            ),
            _buildTextField(
              controller: pish706Controller,
              label: 'Pish 706 - bar',
            ),
            _buildTextField(
              controller: tiwh706Controller,
              label: 'TIWH 706 - °C',
            ),
          ],
        );
      case 4:
        return Column(
          children: [
            _buildTextField(
              controller: f702AController,
              label: 'F702 A - bar',
              isNumeric: true,
            ),
            _buildTextField(
              controller: f702BController,
              label: 'F702 B - bar',
              isNumeric: true,
            ),
            _buildTextField(
              controller: f702CController,
              label: 'F702 C - bar',
              isNumeric: true,
            ),
          ],
        );
      case 5:
        return Column(
          children: [
            // OIL TYPE DROPDOWN
            Consumer<ProductProvider>(
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
                      hintText: 'Loading Oil Type...',
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

                if (provider.productRefineryList.isEmpty) {
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

                return DropdownButtonFormField(
                  value: selectedOilTypeFg,
                  items:
                      provider.productRefineryList.map((oil) {
                        return DropdownMenuItem<String>(
                          value: oil.id,
                          child: Text(oil.finishGood!),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOilTypeFg = value;
                      selectedOilTypeNameFg =
                          provider.productRefineryList
                              .firstWhere(
                                (item) => item.id == selectedOilTypeFg,
                              )
                              .finishGood;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    labelText: 'FIT 704',
                    hintText: 'Pilih Oil Type FIT 704',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.oil_barrel_rounded),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),

            _buildTextField(
              controller: fit704RpoController,
              label:
                  selectedOilTypeFg == null
                      ? 'FIT 704 - tph'
                      : 'FIT 704 ($selectedOilTypeNameFg) - tph',
              isNumeric: true,
            ),
            // OIL TYPE DROPDOWN
            Consumer<ProductProvider>(
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
                      hintText: 'Loading Oil Type...',
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

                if (provider.productRefineryList.isEmpty) {
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

                return DropdownButtonFormField(
                  value: selectedOilTypeBp,
                  items:
                      provider.productRefineryList.map((oil) {
                        return DropdownMenuItem<String>(
                          value: oil.id,
                          child: Text(oil.byProduct!),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOilTypeBp = value;
                      selectedOilTypeNameBp =
                          provider.productRefineryList
                              .firstWhere(
                                (item) => item.id == selectedOilTypeBp,
                              )
                              .byProduct;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    labelText: 'FIT 705',
                    hintText: 'Pilih Oil Type FIT 705',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.oil_barrel_rounded),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),

            _buildTextField(
              controller: fit705PfadController,
              label:
                  selectedOilTypeBp == null
                      ? 'FIT 705 - tph'
                      : 'FIT 705 ($selectedOilTypeNameBp) - tph',
              isNumeric: true,
            ),
          ],
        );
      case 6:
        return Column(
          children: [
            _buildTextField(
              controller: e704Controller,
              label: 'E 704 - °C',
              isNumeric: true,
            ),
            _buildTextField(
              controller: e705Controller,
              label: 'E705 - °C',
              isNumeric: true,
            ),
          ],
        );
      case 7:
        return Column(
          children: [
            _buildTextField(controller: clarityController, label: 'Clarity'),
            _buildTextField(controller: remarksController, label: 'Remarks'),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
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
          labelStyle: const TextStyle(
            color: Color(0xFF655F5B),
            fontWeight: FontWeight.w500,
          ),
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
        (form) =>
            form.isMenu ==
            "Logsheet_Deodorizing_Filtration", // Changed menu name
      );
    } catch (e) {
      log("Form data for 'Logsheet_Deodorizing_Filtration' not found.");
      formData = null;
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: Text(
        'Deodorizing- ${formData?.code ?? "New Input"}', // Changed Title Prefix
        style: const TextStyle(
          color: Color(0xFF655F5B),
          fontWeight: FontWeight.bold,
        ),
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
