import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/get_posting_date.dart';
import 'package:logsheet_app/core/utils/get_transaction_date.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/utils/time_picker_util.dart';
import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/admin/widgets/show_save_confirmation_dialog.dart';
import 'package:logsheet_app/providers/dry_fractionation/dry_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/product_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class DryFractionationInputPage extends StatefulWidget {
  const DryFractionationInputPage({super.key, required this.form});
  final DataFormNoEntity? form;

  @override
  State<DryFractionationInputPage> createState() =>
      _DryFractionationInputPageState();
}

class _DryFractionationInputPageState extends State<DryFractionationInputPage> {
  // Lists
  List<String> shiftList = ["1", "2", "3", "4", "5", "-"];

  // Variables for Dropdowns
  String? selectedShift,
      selectedWorkCenter,
      selectedOilType,
      selectedInitialTank;
  TimeOfDay? fillingStartTime,
      fillingEndTime,
      collingStartTime,
      crystalStartTime,
      filtrationStartTime;

  // Text Editing Controllers
  final crystalizierController = TextEditingController();
  final initialOilLevelController = TextEditingController();
  final feedIVController = TextEditingController();
  final agitatorSpeedController = TextEditingController();
  final waterPumpPresController = TextEditingController();
  final crystalTempController = TextEditingController();
  final filtrationTempController = TextEditingController();
  final filtrationCycleNumberController = TextEditingController();
  final finalOilLevelController = TextEditingController();
  final oleinIVRedController = TextEditingController();
  final oleinCloudPointController = TextEditingController();
  final stearinIVController = TextEditingController();
  final stearinSlepPointRedController = TextEditingController();
  final oleinYieldController = TextEditingController();
  final remarksController = TextEditingController();

  @override
  void dispose() {
    final controllers = [
      crystalizierController,
      initialOilLevelController,
      feedIVController,
      agitatorSpeedController,
      waterPumpPresController,
      crystalTempController,
      filtrationTempController,
      filtrationCycleNumberController,
      finalOilLevelController,
      oleinIVRedController,
      oleinCloudPointController,
      stearinIVController,
      stearinSlepPointRedController,
      oleinYieldController,
      remarksController,
    ];

    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final valueProvider = context.read<ValueProvider>();
    final productProvider = context.read<ProductProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await valueProvider.fetchWorkCenterFractLists();
      if (productProvider.productFractionationList.isEmpty) {
        await productProvider.fetchProducts();
      }

      if (valueProvider.toTankGroupLists.isEmpty) {
        await valueProvider.fetchToTankGroupLists();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: CustomDropdown.fromStringItems(
                  hint: 'Shift',
                  value: selectedShift,
                  stringItems: shiftList,
                  onChanged: (value) {
                    selectedShift = value;
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Consumer<ValueProvider>(
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
                          provider.workCenterFractLists.map((machine) {
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
              ),
              const SizedBox(height: 8),
              // OIL TYPE LIST
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Consumer<ProductProvider>(
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

                    if (provider.productFractionationList.isEmpty) {
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
                          provider.productFractionationList.map((oil) {
                            return DropdownMenuItem<String>(
                              value: oil.id,
                              child: Text("${oil.rawMaterial}"),
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
              ),

              if (selectedOilType == null ||
                  selectedShift == null ||
                  selectedWorkCenter == null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      'Silakan pilih Work Center, Oil Processed, dan Shift.',
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ] else ...[
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
                        CustomTextField(
                          controller: crystalizierController,
                          label: 'Crystalizier (Batch #)',
                          icon: Icons.numbers_rounded,
                        ),
                        CustomHourMinuteField(
                          selectedTime: fillingStartTime,
                          hint: "Filling Start Time",
                          onTap:
                              () => showHourPickerAndUpdateState(
                                context: context,
                                selectedTime: fillingStartTime,
                                onTimeSelected: (value) {
                                  setState(() {
                                    fillingStartTime = value;
                                  });
                                },
                              ),
                        ),
                        CustomHourMinuteField(
                          selectedTime: fillingEndTime,
                          hint: "Filling End Time",
                          onTap:
                              () => showHourPickerAndUpdateState(
                                context: context,
                                selectedTime: fillingEndTime,
                                onTimeSelected: (value) {
                                  setState(() {
                                    fillingEndTime = value;
                                  });
                                },
                              ),
                        ),
                        CustomHourMinuteField(
                          selectedTime: collingStartTime,
                          hint: "Colling Start Time",
                          onTap:
                              () => showHourPickerAndUpdateState(
                                context: context,
                                selectedTime: collingStartTime,
                                onTimeSelected: (value) {
                                  setState(() {
                                    collingStartTime = value;
                                  });
                                },
                              ),
                        ),
                        CustomTextField(
                          controller: initialOilLevelController,
                          label: 'Initial Oil Level (%)',
                          icon: Icons.oil_barrel_rounded,
                          isNumeric: true,
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
                                    hintText: 'Loading Tanks...',
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
                              return DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: selectedInitialTank,
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
                                  // DropdownMenuItem<String>(
                                  //   value: "Others",
                                  //   child: Text(
                                  //     "Others",
                                  //     style: TextStyle(fontSize: 14),
                                  //   ),
                                  // ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedInitialTank = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF0ECE9),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Initial Tank',
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
                        CustomTextField(
                          controller: feedIVController,
                          label: 'Feed IV',
                          icon: Icons.input,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: agitatorSpeedController,
                          label: 'Agitator Speed(Hz)',
                          icon: Icons.autorenew,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: waterPumpPresController,
                          label: 'Water Pump Pres (bar)',
                          icon: Icons.compress,
                          isNumeric: true,
                        ),
                        CustomHourMinuteField(
                          selectedTime: crystalStartTime,
                          hint: "Crystal Start Time",
                          onTap:
                              () => showHourPickerAndUpdateState(
                                context: context,
                                selectedTime: crystalStartTime,
                                onTimeSelected: (value) {
                                  setState(() {
                                    crystalStartTime = value;
                                  });
                                },
                              ),
                        ),
                        CustomTextField(
                          controller: crystalTempController,
                          label: 'Crystal Temp (°C)',
                          icon: Icons.thermostat_rounded,
                          isNumeric: true,
                        ),
                        CustomHourMinuteField(
                          selectedTime: filtrationStartTime,
                          hint: "Filtration Start Time",
                          onTap:
                              () => showHourPickerAndUpdateState(
                                context: context,
                                selectedTime: filtrationStartTime,
                                onTimeSelected: (value) {
                                  setState(() {
                                    filtrationStartTime = value;
                                  });
                                },
                              ),
                        ),
                        CustomTextField(
                          controller: filtrationTempController,
                          label: 'Filtration Temp (°C)',
                          icon: Icons.thermostat_rounded,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: filtrationCycleNumberController,
                          label: 'Filtration Cycle Number',
                          icon: Icons.repeat,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: finalOilLevelController,
                          label: 'Final Oil Level (%)',
                          icon: Icons.oil_barrel_rounded,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: oleinIVRedController,
                          label: 'Olein IV RED',
                          icon: Icons.oil_barrel_rounded,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: oleinCloudPointController,
                          label: 'Olein Cloud Point (°C)',
                          icon: Icons.wb_cloudy_rounded,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: stearinIVController,
                          label: 'Stearin IV RED',
                          icon: Icons.oil_barrel_rounded,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: stearinSlepPointRedController,
                          label: 'Stearin Slep Point (°C) RED',
                          icon: Icons.oil_barrel_rounded,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: oleinYieldController,
                          label: 'Olein Yield (%)',
                          icon: Icons.trending_up_rounded,
                          isNumeric: true,
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: CustomSaveButton(
                    onPressed: () async {
                      await showSaveConfirmationDialog<
                        DryFractionationProvider
                      >(
                        context,
                        providerSelector: (provider) => provider.isLoading,
                        onConfirm: () async => await submitReport(context),
                      );
                    },
                    label: "Submit Ticket",
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar() =>
      AppBar(title: Text("Dry Fract. Input (${widget.form?.code})"));

  Future<String> buildTicketNumber() async {
    final provider = context.read<DryFractionationProvider>();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    if (plantCode.isEmpty) {
      showSnackBar("Error: Plant code is not available.", context);
      return "";
    }

    final latestTicketIdFromProvider = await provider.fetchLatestId(plantCode);

    if (latestTicketIdFromProvider == null ||
        latestTicketIdFromProvider.length < 9) {
      if (!mounted) return "";
      showSnackBar(
        "Error: Could not fetch the latest ticket number for this plant.",
        context,
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
      if (!mounted) return "";
      showSnackBar(
        "Error: Could not update the ticket number sequence.",
        context,
      );
      return "";
    }

    String lastDigit = digit.toString().padLeft(6, '0');
    String ticketPrefix = latestTicketIdFromProvider.substring(0, 9);

    log("New Ticket Number: ${ticketPrefix + lastDigit}");
    return ticketPrefix + lastDigit;
  }

  Future<void> submitReport(BuildContext context) async {
    final provider = context.read<DryFractionationProvider>();
    final currentUser = context.read<UserProvider>().currentUser;
    final currentPlant = context.read<PlantProvider>().currentPlant;
    final plantCode = currentPlant!.code;
    final companyName =
        context.read<BusinessUnitProvider>().currentBusinessUnit?.buName;

    final form = widget.form;

    if (selectedWorkCenter == null ||
        selectedShift == null ||
        selectedOilType == null) {
      showSnackBar(
        'Mohon lengkapi Work Center, Oil Type, dan Jam Input.',
        context,
      );
      return;
    }

    try {
      final postingDate = getPostingDate();
      final transactionDate = getTransactionDate();
      final ticketId = await buildTicketNumber();

      if (ticketId == "") {
        return;
      }
      final entity = DryFractionationEntity(
        id: ticketId,
        company: companyName,
        plant: plantCode,
        transactionDate: transactionDate,
        postingDate: postingDate,
        workCenter: selectedWorkCenter,
        shift: selectedShift,
        oilTypeId: selectedOilType,
        crystalizier: crystalizierController.text,
        fillingStartTime: fillingStartTime,
        fillingEndTime: fillingEndTime,
        collingStartTime: collingStartTime,
        initialOilLevel: parseDouble(initialOilLevelController.text),
        initialTank: selectedInitialTank,
        feedIV: parseDouble(feedIVController.text),
        agitatorSpeed: agitatorSpeedController.text,
        waterPumpPress: parseDouble(waterPumpPresController.text),
        crystalStartTime: crystalStartTime,
        crystalTemp: crystalTempController.text,
        filtrationStartTime: filtrationStartTime,
        filtrationTemp: filtrationTempController.text,
        filtrationCycleNo: parseInt(filtrationCycleNumberController.text),
        filtrationOilLevel: finalOilLevelController.text,
        oleinIVRed: parseDouble(oleinIVRedController.text),
        oleinCloudPoint: parseDouble(oleinCloudPointController.text),
        stearinIV: parseDouble(stearinIVController.text),
        stearinSlepPointRed: parseDouble(stearinSlepPointRedController.text),
        oleinYield: parseDouble(oleinYieldController.text),
        remarks: remarksController.text == "" ? null : remarksController.text,
        flag: "T",
        entryBy: currentUser?.username,
        entryDate: DateTime.now(),
        preparedBy: null,
        preparedDate: null,
        preparedStatus: null,
        preparedStatusRemarks: null,
        checkedBy: null,
        checkedDate: null,
        checkedStatus: null,
        checkedStatusRemarks: null,
        updatedBy: null,
        updatedDate: null,
        formNo: form?.code,
        dateIssued: form?.dateIssued,
        revisionNo: form?.revisionNo,
        revisionDate: form?.revisionDate,
      );

      bool? success;

      log("attemp to insert deodorizing ticket $ticketId");
      success = await provider.insertTicket(entity);

      if (success) {
        final username = currentUser?.username;
        final role = currentUser?.role;

        await provider.fetchAllTickets(
          null,
          null,
          username ?? "",
          role ?? "",
          plantCode,
        );
        if (!context.mounted) return;
        showSnackBar('Input berhasil', context);
        log('Insert successful');
        Navigator.pop(context);
      }
    } catch (e) {
      log("Gagal menyimpan laporan: $e");
      if (!context.mounted) return;
      showSnackBar("Error: $e", context);
    }
  }
}
