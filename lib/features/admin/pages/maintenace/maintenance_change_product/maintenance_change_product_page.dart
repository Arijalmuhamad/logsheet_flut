import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/features/admin/widgets/checklist_item_row.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/section_card.dart';

class MaintenanceChangeChecklistPage extends StatefulWidget {
  final String userName;

  const MaintenanceChangeChecklistPage({super.key, required this.userName});

  @override
  State<MaintenanceChangeChecklistPage> createState() =>
      _MaintenanceChangeChecklistPageState();
}

class _MaintenanceChangeChecklistPageState
    extends State<MaintenanceChangeChecklistPage> {
  bool isLoading = false;

  final TextEditingController dateEntryController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? selectedFirstPart;
  String? selectedNextPart;
  String? selectedLocation;
  int? selectedHour;

  bool checklist1 = false;
  bool checklist2 = false;

  final List<String> dummyFirstParts = ['RPS', 'CPKO'];
  final List<String> dummyNextParts = ['CPO', 'CPKO'];
  final List<String> dummyLocations = ['Refinery', 'Fractination'];

  @override
  void dispose() {
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      // Reset data di sini jika ada
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Change & Start-Up Checklist',
        onRefresh: _refreshPage,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDateField(
                  controller: dateEntryController,
                  label: 'Tanggal Aktivitas',
                  icon: Icons.event,
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
                CustomDropdown.fromStringItems(
                  hint: 'Pilih Produk Awal',

                  prefixIcon: PrefixIconHelper.get('factory'),
                  stringItems: dummyFirstParts,
                  value: selectedFirstPart,
                  onChanged:
                      (value) => setState(() => selectedFirstPart = value),
                ),
                const SizedBox(height: 8),
                CustomDropdown.fromStringItems(
                  hint: 'Pilih Produk Selanjutnya',
                  prefixIcon: PrefixIconHelper.get('factory'),
                  stringItems: dummyNextParts,
                  value: selectedNextPart,
                  onChanged:
                      (value) => setState(() => selectedNextPart = value),
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
                const SizedBox(height: 16),
                if (selectedLocation == 'Refinery') ...[
                  SectionCard(
                    title: 'Pre-Treatment Section',
                    children: [
                      ChecklistItemRow(
                        number: 1,
                        description:
                            'Stop pompa P001, Buka by pass Degumming dan by pass Bleacher.',
                        value: checklist1,
                        onChanged:
                            (val) => setState(() => checklist1 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 2,
                        description:
                            'Blow Jalur Pre-Treatment (Blow Jalur dari Pump 001 sampai ke Bleacher).',
                        value: checklist1,
                        onChanged:
                            (val) => setState(() => checklist1 = val ?? false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    title: 'Bleacher Section',
                    children: [
                      ChecklistItemRow(
                        number: 1,
                        description:
                            'Kosongkan Slope Tank dan Tank Splash Oil.',
                        value: checklist1,
                        onChanged:
                            (val) => setState(() => checklist1 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 2,
                        description:
                            'Kosongkan Bleacher Tank, Niagara Filter, dan dorong sisa-sisa minyak pada niagara dengan steam.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 3,
                        description: 'Bersihkan strainer pompa P001.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 4,
                        description: 'Ganti Filter bag 10 micron.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 5,
                        description:
                            'Lakukan penarikan feed raw material dari tanki yang sudah direlease oleh QC.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 6,
                        description: 'Start-up bleacher section.',
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
                        description:
                            'Kosongkan isi Tank 701, Tank 703, dan Receiver Tank.',
                        value: checklist1,
                        onChanged:
                            (val) => setState(() => checklist1 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 2,
                        description: 'Matikan Power Thermopack.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 3,
                        description:
                            'Kosongkan Deodorize Tannk dari Tray 1,2,3 dan 4.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 4,
                        description: 'Ganti Filter Bag 5 Micron.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 5,
                        description:
                            'Start-up Niagara dan hidupkan Thermopack.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 6,
                        description:
                            'Lakukan pengisian F701, D703, dan D702 sampai high level.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 7,
                        description: 'Lakukan Start-up Deodorizer.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 8,
                        description: 'Lakukan Pengisian Tray 1,2,3,4.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 9,
                        description:
                            'Sirkulasi hingga mencapai temperatur yang sesuai.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 10,
                        description:
                            'Quality Check oleh QC dan produk sudah inspec.',
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
                        description:
                            'Persiapkan tanki crystallizer yang akan dipakai.',
                        value: checklist1,
                        onChanged:
                            (val) => setState(() => checklist1 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 2,
                        description: 'Lakukan blow jalur.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 3,
                        description:
                            'Lakukan penarikan Feed Raw Material yang sudah direlease oleh QC. (Pastikan Ketersediaan steam saat penarikan feed raw material).',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 4,
                        description: 'Lakukan Washing Filter Press.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 5,
                        description: 'Lakukan Cooling dan Filtrasi.',
                        value: checklist2,
                        onChanged:
                            (val) => setState(() => checklist2 = val ?? false),
                      ),
                      ChecklistItemRow(
                        number: 6,
                        description:
                            'Quality Check oleh QC dan produk sudah inspec.',
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
        ],
      ),
    );
  }
}
