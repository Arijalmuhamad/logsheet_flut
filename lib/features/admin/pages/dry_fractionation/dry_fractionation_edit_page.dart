import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/utils/time_picker_util.dart';
import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/providers/dry_fractionation/dry_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class DryFractionationEditPage extends StatefulWidget {
  final DryFractionationEntity entity;
  const DryFractionationEditPage({super.key, required this.entity});

  @override
  State<DryFractionationEditPage> createState() =>
      _DryFractionationEditPageState();
}

class _DryFractionationEditPageState extends State<DryFractionationEditPage> {
  // Lists
  final List<String> shiftList = ["1", "2", "3", "4", "5", "-"];

  // Variables for Dropdowns
  String? selectedShift,
      selectedWorkCenter,
      selectedOilType,
      selectedInitialTank;

  // Variables for Time Pickers
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

  void _populateFields() {
    final entity = widget.entity;
    // Dropdowns & Time Pickers
    selectedShift = entity.shift;
    selectedWorkCenter = entity.workCenter;
    selectedOilType = entity.oilType;
    selectedInitialTank = entity.initialTank;
    fillingStartTime = entity.fillingStartTime;

    fillingEndTime = entity.fillingEndTime;
    collingStartTime = entity.collingStartTime;
    crystalStartTime = entity.crystalStartTime;
    filtrationStartTime = entity.filtrationStartTime;

    // Text Controllers
    crystalizierController.text = entity.crystalizier ?? '';
    initialOilLevelController.text = entity.initialOilLevel?.toString() ?? '';
    feedIVController.text = entity.feedIV?.toString() ?? '';
    agitatorSpeedController.text = entity.agitatorSpeed ?? '';
    waterPumpPresController.text = entity.waterPumpPress?.toString() ?? '';
    crystalTempController.text = entity.crystalTemp ?? '';
    filtrationTempController.text = entity.filtrationTemp ?? '';
    filtrationCycleNumberController.text =
        entity.filtrationCycleNo?.toString() ?? '';
    finalOilLevelController.text = entity.filtrationOilLevel ?? '';
    oleinIVRedController.text = entity.oleinIVRed?.toString() ?? '';
    oleinCloudPointController.text = entity.oleinCloudPoint?.toString() ?? '';
    stearinIVController.text = entity.stearinIV?.toString() ?? '';
    stearinSlepPointRedController.text =
        entity.stearinSlepPointRed?.toString() ?? '';
    oleinYieldController.text = entity.oleinYield?.toString() ?? '';
    remarksController.text = entity.remarks ?? '';
  }

  @override
  void initState() {
    super.initState();
    final valueProvider = context.read<ValueProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Fetch necessary dropdown data
      await valueProvider.fetchWorkCenterFractLists();
      if (valueProvider.oilTypeLists.isEmpty) {
        await valueProvider.fetchOilTypes();
      }

      if (valueProvider.toTankGroupLists.isEmpty) {
        await valueProvider.fetchToTankGroupLists();
      }
      // Populate form fields with existing data
      setState(() {
        _populateFields();
      });
    });
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Edit Dry Fract. (${widget.entity.id})"),
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                ).format(widget.entity.transactionDate ?? DateTime.now()),
              ),
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
                setState(() {
                  selectedShift = value;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isWorkCenterFractLoading) {
                  return _buildLoadingDropdown('Loading Work Center...');
                }
                if (provider.workCenterFractLists.isEmpty) {
                  return _buildEmptyDropdown('Work Center tidak ditemukan.');
                }
                return DropdownButtonFormField<String>(
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
                  decoration: _buildDropdownDecoration(
                    hintText: 'Pilih Work Center',
                    svgIconPath: 'assets/icons/oil-refinery-tanks.svg',
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isOilTypeLoading) {
                  return _buildLoadingDropdown('Loading Oil Types...');
                }
                if (provider.oilTypeLists.isEmpty) {
                  return _buildEmptyDropdown('Oil Types tidak ditemukan.');
                }
                return DropdownButtonFormField<String>(
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
                  decoration: _buildDropdownDecoration(
                    hintText: 'Pilih Oil Type',
                    icon: Icons.oil_barrel_rounded,
                  ),
                );
              },
            ),
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
                          return _buildLoadingDropdown('Loading Tanks...');
                        }
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedInitialTank,
                          items:
                              provider.toTankGroupLists.map((tank) {
                                return DropdownMenuItem<String>(
                                  value: tank.code,
                                  child: Text(
                                    tank.code,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedInitialTank = value;
                            });
                          },
                          decoration: _buildDropdownDecoration(
                            hintText: 'Initial Tank',
                            svgIconPath: 'assets/icons/oil-refinery-tanks.svg',
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
              onPressed: () => _showAlertDialog(context),
              label: "Update Ticket",
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Update"),
          content: const Text("Apakah data yang anda ubah sudah sesuai?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Tidak", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                _update(); // Call update function
              },
              child: Consumer<DryFractionationProvider>(
                builder: (context, provider, child) {
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

  void _update() async {
    // This is where you will add your update logic.
    log("Update button clicked. Ready to implement the update function.");
    final provider = context.read<DryFractionationProvider>();
    final currentUser = context.read<UserProvider>().currentUser;
    final currentPlant = context.read<PlantProvider>().currentPlant;
    final plantCode = currentPlant!.code;
    final companyName =
        context.read<BusinessUnitProvider>().currentBusinessUnit?.buName;

    try {
      final updatedEntity = widget.entity.copyWith(
        shift: selectedShift,
        oilType: selectedOilType,
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
        updatedBy: currentUser?.username ?? "",
        updatedDate: DateTime.now(),
      );

      log("Attempting to update ticket ID: ${updatedEntity.id}");

      final success = await provider.updateTicket(
        updatedEntity,
        currentUser?.username ?? "",
        currentUser?.role ?? "",
        plantCode,
      );

      if (success) {
        if (!mounted) return;
        showSnackBar('Laporan berhasil diperbarui', context);
        Navigator.of(context).pop(); // Close dialog
        Navigator.pop(context, updatedEntity);
      }
    } catch (e) {
      log("Error updating report: $e");
      if (!mounted) return;
      showSnackBar("Terjadi kesalahan: $e", context);
    }
  }

  // Helper Widgets for cleaner build method
  Widget _buildLoadingDropdown(String hint) {
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
        hintText: hint,
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

  Widget _buildEmptyDropdown(String hint) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF0ECE9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        prefixIcon: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(Icons.warning_amber_rounded),
        ),
      ),
    );
  }

  InputDecoration _buildDropdownDecoration({
    required String hintText,
    String? svgIconPath,
    IconData? icon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF0ECE9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintText: hintText,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            svgIconPath != null
                ? SvgPicture.asset(svgIconPath, height: 24, width: 24)
                : Icon(icon),
      ),
    );
  }
}
