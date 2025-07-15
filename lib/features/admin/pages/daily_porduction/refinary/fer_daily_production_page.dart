import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/pages/daily_porduction/refinary/ref_section_auxiliary_material.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/section_card.dart';

import 'ref_section_cpo_rpa_rps.dart';
import 'ref_section_rbdpo_rrbdpo_rps.dart';
import 'ref_section_rfad.dart';

class DailyProductionRefineryPage extends StatefulWidget {
  final String userName;
  const DailyProductionRefineryPage({super.key, required this.userName});

  @override
  State<DailyProductionRefineryPage> createState() =>
      _DailyProductionPageState();
}

class _DailyProductionPageState extends State<DailyProductionRefineryPage> {
  bool isLoading = true;
  String? selectedLocation;
  String? selectedTank;
  int? selectedHour;
  String? selectedPart;

  // Dummy data
  final List<String> dummyLocations = ['Refinery', 'Fractination'];
  final List<String> dummyTanks = ['Tank 1', 'Tank 2', 'Tank 3', 'Tank 4'];
  final List<String> dummyParts = ['CPO', 'RPA', 'RPS'];
  final List<String> dummyShiftOptions = ['I', 'II', 'III'];

  final TextEditingController flowRateController = TextEditingController();

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

  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    flowRateController.dispose();
    bleachingBagController.dispose();
    bleachingTypeController.dispose();
    bleachingBatchController.dispose();
    phosphoricWeightController.dispose();
    phosphoricVolumeController.dispose();
    phosphoricYieldController.dispose();
    phosphoricBatchController.dispose();
    super.dispose();
  }

  void _showHourPicker(BuildContext context) {
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
              setState(() => selectedHour = hour);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title: 'Daily Production - Refinary',
        onRefresh: _refreshPage,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
              // === Section: CPO RPA RPS ===
              SectionCpoRpaRps(
                selectedHour: selectedHour,
                flowRateController: flowRateController,
                dummmyTanks: dummyTanks,
                selectedTank: selectedTank,
                onHourTap: () => _showHourPicker(context),
                onTankChanged: (value) => setState(() => selectedTank = value),
              ),
              const SizedBox(height: 16),

              // === Section: RBDPO RRBDPO RPS ===
              SectionRbdpoRrbdpoRps(
                selectedHour: selectedHour,
                flowRateController: flowRateController,
                onHourTap: () => _showHourPicker(context),
                dummmyTanks: dummyTanks,
                selectedTank: selectedTank,
                onTankChanged: (value) => setState(() => selectedTank = value),
              ),
              const SizedBox(height: 16),

              // === Section: RFAD ===
              SectionRfad(
                selectedHour: selectedHour,
                flowRateController: flowRateController,
                onHourTap: () => _showHourPicker(context),
                dummmyTanks: dummyTanks,
                selectedTank: selectedTank,
                onTankChanged: (value) => setState(() => selectedTank = value),
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
                children: [CustomRemarkField(controller: notesController)],
              ),
              const SizedBox(height: 24),

              // === Submit Button ===
              CustomSaveButton(onPressed: () {}, label: 'Submit Laporan'),
            ],
          ],
        ),
      ),
    );
  }
}
