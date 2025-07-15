import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/features/admin/widgets/checklist_item_row.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/section_card.dart';

class MaintenanceChecksheetPage extends StatefulWidget {
  final String userName;
  const MaintenanceChecksheetPage({super.key, required this.userName});

  @override
  State<MaintenanceChecksheetPage> createState() =>
      _MaintenanceChecksheetPageState();
}

class _MaintenanceChecksheetPageState extends State<MaintenanceChecksheetPage> {
  bool isLoading = false;
  int? selectedHour;
  String? selectedFloor;
  String? selectedJob;

  final TextEditingController dateEntryController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool checklist1 = false;
  bool checklist2 = false;

  final List<String> dummyFloor = ['Lantai 1', 'Lantai 2'];
  final List<String> dummyJobs = [
    'Pembersihan Lantai',
    'Pembersihan Tangga',
    'Pembersihan Plafond',
    'Membuang Sampah',
  ];

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _resetForm();
    setState(() {
      isLoading = false;
    });
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

  void _resetForm() {
    setState(() {
      selectedFloor = null;
      selectedJob = null;
      dateEntryController.clear();
      selectedHour = null;
    });
  }

  Widget _buildChecklistSection() {
    switch (selectedJob) {
      case 'Pembersihan Lantai':
        return SectionCard(
          title:
              'Pembersihan Lantai Area Produksi Refinery & Fractionation Lantai 1',
          children: [
            ChecklistItemRow(
              number: 1,
              description: 'Lantai Area Buffer Steerin Plant 150 & 500',
              value: checklist1,
              onChanged: (value) {
                setState(() => checklist1 = value ?? false);
              },
            ),
            ChecklistItemRow(
              number: 2,
              description: 'Lantai Area Bulk Phosporic Plant 150 & 500',
              value: checklist2,
              onChanged: (value) {
                setState(() => checklist2 = value ?? false);
              },
            ),
            ChecklistItemRow(
              number: 3,
              description: 'Lantai Area PHE & SHE Plant 150 & 500',
              value: false,
              onChanged: (value) {},
            ),
            ChecklistItemRow(
              number: 4,
              description: 'Lantai Area',
              value: false,
              onChanged: (value) {},
            ),
            ChecklistItemRow(
              number: 5,
              description:
                  'Lantai Area Sekitar Chiller & Compressor Plant 150 & 500',
              value: false,
              onChanged: (value) {},
            ),
            ChecklistItemRow(
              number: 6,
              description:
                  'Pembersihan & Merapikan Area Penempatan Phosporic Acid',
              value: false,
              onChanged: (value) {},
            ),
          ],
        );

      case 'Pembersihan Tangga':
        return SectionCard(
          title: 'Pembersihan Tangga',
          children: [
            ChecklistItemRow(
              number: 1,
              description: 'Tangga Menuju Lantai 2',
              value: false,
              onChanged: (value) {},
            ),
          ],
        );

      case 'Pembersihan Plafond':
        return SectionCard(
          title: 'Pembersihan Plafond',
          children: [
            ChecklistItemRow(
              number: 1,
              description: 'Plafond Area Produksi Refinery & Fractionation',
              value: false,
              onChanged: (value) {},
            ),
          ],
        );

      case 'Membuang Sampah':
        return SectionCard(
          title: 'Membuang Sampah',
          children: [
            ChecklistItemRow(
              number: 1,
              description:
                  'Membuang Sampah Area Produksi Refinery & Fractionation',
              value: false,
              onChanged: (value) {},
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  @override
  void dispose() {
    dateEntryController.dispose();
    super.dispose();
    notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title: 'Daily Cleaning Checksheet',
        onRefresh: _refreshPage,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdown.fromStringItems(
                  hint: 'Pilih Lantai',
                  prefixIcon: PrefixIconHelper.get('floor'),
                  stringItems: dummyFloor,
                  value: selectedFloor,
                  onChanged: (value) => setState(() => selectedFloor = value),
                ),
                const SizedBox(height: 8),
                CustomDropdown.fromStringItems(
                  hint: 'Pilih Pekerjaan',
                  prefixIcon: PrefixIconHelper.get('job'),
                  stringItems: dummyJobs,
                  value: selectedJob,
                  onChanged: (value) => setState(() => selectedJob = value),
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

                selectedJob == null
                    ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'Silakan pilih pekerjaan terlebih dahulu',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                    : _buildChecklistSection(),
                const SizedBox(height: 12),
                SectionCard(
                  title: 'Remark',
                  children: [CustomRemarkField(controller: notesController)],
                ),
                const SizedBox(height: 24),
                CustomSaveButton(
                  onPressed: () {
                    // Implementasi simpan data
                  },
                  label: 'Submit Laporan',
                ),

                const SizedBox(height: 80),
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
