import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';

class MaintenanceFilterPage extends StatefulWidget {
  final String userName;

  const MaintenanceFilterPage({super.key, required this.userName});

  @override
  State<MaintenanceFilterPage> createState() => _MaintenanceFilterPageState();
}

enum StepType { perendaman, pencucian }

class _MaintenanceFilterPageState extends State<MaintenanceFilterPage> {
  bool isLoading = false;

  String? selectedLocation;
  double? selectedFilter;
  int? selectedHour;
  String? selectedKondisiFilter;

  final List<Map<String, String>> filterList = [
    {'code': '201', 'name': 'Filter Bag A'},
    {'code': '202', 'name': 'Filter Bag B'},
    {'code': '203', 'name': 'Filter Press C'},
  ];

  final List<String> dummyLocations = [
    'Refinery A',
    'Refinery B',
    'Refinery C',
  ];

  final TextEditingController tanggalRendamController = TextEditingController();
  final TextEditingController noFilterRendamController =
      TextEditingController();
  final TextEditingController kadarSodaController = TextEditingController();
  final TextEditingController phRendamController = TextEditingController();
  final TextEditingController pelaksanaRendamController =
      TextEditingController();

  final TextEditingController tanggalCuciController = TextEditingController();
  final TextEditingController noFilterCuciController = TextEditingController();
  final TextEditingController phBilasanController = TextEditingController();
  final TextEditingController pelaksanaCuciController = TextEditingController();

  @override
  void dispose() {
    tanggalRendamController.dispose();
    noFilterRendamController.dispose();
    kadarSodaController.dispose();
    phRendamController.dispose();
    pelaksanaRendamController.dispose();
    tanggalCuciController.dispose();
    noFilterCuciController.dispose();
    phBilasanController.dispose();
    pelaksanaCuciController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      selectedLocation = null;
      selectedFilter = null;
      selectedHour = null;
      selectedKondisiFilter =
          null; // Menambahkan reset untuk selectedKondisiFilter

      tanggalRendamController.clear();
      noFilterRendamController.clear();
      kadarSodaController.clear();
      phRendamController.clear();
      pelaksanaRendamController.clear();

      tanggalCuciController.clear();
      noFilterCuciController.clear();
      phBilasanController.clear();
      pelaksanaCuciController.clear();
    });
  }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _resetForm();
    setState(() => isLoading = false);
  }

  // Hour Picker
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
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title: 'Pencucian Filter Niagara',
        onRefresh: _refreshPage,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDropdown(
                  hint: 'Pilih Filter',
                  prefixIcon: PrefixIconHelper.get('filter'),

                  items:
                      filterList.map((filter) {
                        final value =
                            double.tryParse(filter['code'] ?? '') ?? 0.0;
                        return DropdownMenuItem<double>(
                          value: value,
                          child: Text(
                            'Filter ${filter['code']} - ${filter['name']}',
                          ),
                        );
                      }).toList(),
                  value: selectedFilter,
                  onChanged: (value) {
                    setState(() => selectedFilter = value);
                  },
                ),
                const SizedBox(height: 8),

                // Location Dropdown
                CustomDropdown.fromStringItems(
                  value: selectedLocation,
                  stringItems: dummyLocations,
                  hint: 'Pilih Lokasi',
                  prefixIcon: PrefixIconHelper.get('location'),
                  onChanged:
                      (value) => setState(() => selectedLocation = value),
                ),
                const SizedBox(height: 8),

                // Hour Picker Field
                CustomHourField(
                  selectedHour: selectedHour,
                  onTap: () => _showHourPicker(context),
                ),

                const SizedBox(height: 16),

                // Form Perendaman
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
                        const CustomSectionTitle(title: 'Perendaman'),
                        const SizedBox(height: 12),
                        CustomDateField(
                          controller: tanggalRendamController,
                          label: 'Tanggal Rendam',
                          icon: Icons.date_range,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: noFilterRendamController,
                          label: 'No Filter Rendam',
                          icon: Icons.confirmation_number,
                        ),
                        CustomTextField(
                          controller: kadarSodaController,
                          label: 'Kadar Caustic Soda',
                          icon: Icons.science,
                          hintText: 'Contoh: 100 kg',
                        ),
                        CustomTextField(
                          controller: phRendamController,
                          label: 'PH Air Rendaman',
                          icon: Icons.water_drop,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: pelaksanaRendamController,
                          label: 'Pelaksana',
                          icon: Icons.person,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Form Pencucian
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
                        const CustomSectionTitle(title: 'Pencucian'),
                        const SizedBox(height: 12),
                        CustomDateField(
                          controller: tanggalCuciController,
                          label: 'Tanggal Pencucian',
                          icon: Icons.date_range,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: noFilterCuciController,
                          label: 'No Filter Cuci',
                          icon: Icons.confirmation_number,
                        ),
                        CustomDropdown.fromStringItems(
                          value: selectedKondisiFilter,
                          stringItems: ['Bagus', 'Rusak'],
                          hint: 'Kondisi Filter',
                          prefixIcon: PrefixIconHelper.get('filter_list'),
                          onChanged:
                              (value) =>
                                  setState(() => selectedKondisiFilter = value),
                        ),
                        const SizedBox(
                          height: 12,
                        ), // Menambahkan SizedBox untuk konsistensi
                        CustomTextField(
                          controller: phBilasanController,
                          label: 'PH Air Bilasan',
                          icon: Icons.water_drop,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: pelaksanaCuciController,
                          label: 'Pelaksana',
                          icon: Icons.person,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomSaveButton(onPressed: () {}, label: 'Submit Laporan'),
              ],
            ),
          ),
          // Tambahkan indikator loading jika isLoading true
          if (isLoading)
            Container(
              color: Colors.black.withAlpha(
                (255 * 0.5).round(),
              ), // Menggunakan withAlpha untuk opasitas
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFAB2F2B)),
              ),
            ),
        ],
      ),
    );
  }
}
