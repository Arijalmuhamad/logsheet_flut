import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/features/admin/widgets/checklist_item_row.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
// ignore: unused_import
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/section_card.dart';

class MaintenanceStartupPage extends StatefulWidget {
  final String userName;

  const MaintenanceStartupPage({super.key, required this.userName});

  @override
  State<MaintenanceStartupPage> createState() => _MaintenanceStartupPageState();
}

class _MaintenanceStartupPageState extends State<MaintenanceStartupPage> {
  bool isLoading = false;

  final TextEditingController dateEntryController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? selectedPart;
  String? selectedLocation;
  int? selectedHour;

  bool checklist1 = false;
  bool checklist2 = false;

  final List<String> dummyParts = ['CPO', 'CPKO'];
  final List<String> dummyLocations = ['Refinery', 'Fractination'];

  void _resetForm() {
    setState(() {
      dateEntryController.clear();
      notesController.clear();
      selectedPart = null;
      selectedLocation = null;
      selectedHour = null;
    });
  }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _resetForm();
    setState(() => isLoading = false);
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

  @override
  void dispose() {
    dateEntryController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title: 'Checklist Start-Up Produk',
        onRefresh: _refreshPage,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDropdown.fromStringItems(
                  hint: 'Pilih Part', // icon: Icons.factory,
                  prefixIcon: PrefixIconHelper.get('factory'),
                  stringItems: dummyParts,
                  value: selectedPart,
                  onChanged: (value) => setState(() => selectedPart = value),
                ),
                const SizedBox(height: 8),
                CustomDropdown.fromStringItems(
                  hint: 'Pilih Lokasi',
                  prefixIcon: PrefixIconHelper.get('location'),
                  stringItems: dummyLocations,
                  value: selectedLocation,
                  onChanged:
                      (value) => setState(() => selectedLocation = value),
                ),
                const SizedBox(height: 8),
                CustomDateField(
                  controller: dateEntryController,
                  label: 'Tanggal Aktivitas',
                  icon: Icons.event,
                ),
                const SizedBox(height: 8),
                CustomHourField(
                  selectedHour: selectedHour,
                  onTap: () => _showHourPicker(context),
                ),

                const SizedBox(height: 16),
                if (selectedLocation == 'Refinery') ...[
                  SectionCard(
                    title: 'Pre-Start Up',
                    children: [
                      ChecklistItemRow(
                        number: 1,
                        description:
                            'Lakukan cleaning strainer 001 dan pergantian filter bag',
                        value: checklist1,
                        onChanged:
                            (val) => setState(() => checklist1 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 2,
                        description:
                            'Start Sirkulasi Air Dirty Cooling Tower, Start Pump V602 Vacuum Bleacher, dan Pump V702 Vacuum Deo',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    title: 'Pre-Treatment Section',
                    children: [
                      ChecklistItemRow(
                        number: 1,
                        description:
                            'Start pompa P001 dan tarik feed material yang sudah direlease oleh QC.',
                        value: checklist1,
                        onChanged:
                            (val) => setState(() => checklist1 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 2,
                        description: 'Start pompa Phosphoric Acid.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    title: 'Deodorization Section',
                    children: [
                      ChecklistItemRow(
                        number: 1,
                        description: 'Start Pompa Bleacher.',
                        value: checklist1,
                        onChanged:
                            (val) => setState(() => checklist1 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 2,
                        description: 'Lakukan Pengisian Bleacher.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 3,
                        description: 'Lakukan Pengisian Niagara Filter.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    title: 'Remark',
                    children: [CustomRemarkField(controller: notesController)],
                  ),

                  const SizedBox(height: 24),
                  CustomSaveButton(onPressed: () {}, label: 'Submit Laporan'),
                ] else if (selectedLocation == 'Fractination') ...[
                  const SizedBox(height: 12),
                  SectionCard(
                    title: 'Fractination Section',
                    children: [
                      ChecklistItemRow(
                        number: 1,
                        description: 'Lakukan Pengisian Feed Daerator.',
                        value: checklist1,
                        onChanged:
                            (val) => setState(() => checklist1 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 2,
                        description: 'Start Mesin Thermopack.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 3,
                        description:
                            'Lakukan Pengisian Deodorizer dari Tray 1,2,3 dan 4.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 4,
                        description:
                            'Sirkulasi hingga Mencapai Temperatur yang sesuai.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 5,
                        description: 'Start Sirkulasi PFAD.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 6,
                        description:
                            'Sirkulasi hingga Quality Inspect oleh QC.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    title: 'Remark',
                    children: [CustomRemarkField(controller: notesController)],
                  ),
                  const SizedBox(height: 24),
                  CustomSaveButton(onPressed: () {}, label: 'Submit Laporan'),
                ] else ...[
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Silakan pilih part terlebih dahulu',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withAlpha((255 * 0.5).round()),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFAB2F2B)),
              ),
            ),
        ],
      ),
    );
  }
}
