import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/features/admin/widgets/checklist_item_row.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_field.dart';
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
  final List<String> dummyPreTreatmentSectionItem = [
    'Pre-Treatment Section item 1',
    'Pre-Treatment Section item 2',
  ];

  final List<String> dummyBleacherSectionItem = [
    'Bleacher Section item 1',
    'Bleacher Section item 2',
  ];

  final List<String> dummyDeodorizationSectionItem = [
    'DeodorizationItem Section item 1',
    'DeodorizationItem Section item 2',
  ];

  final List<String> dummyFractinationSectionItem = [
    'FractinationItem Section item 1',
    'FractinationItem Section item 2',
  ];

  // final Map<String, Map<String, List<String>>> dummyChecklists = {
  //   'Refinery': {
  //     'Pre-Treatment Section': [
  //       'Pre-Treatment Section item 1',
  //       'Pre-Treatment Section item 2',
  //     ],
  //     'Bleacher Section': [
  //       'Bleacher Section item 1',
  //       'Bleacher Section item 2',
  //     ],
  //     'Deodorization Section': [
  //       'Deodorization Section item 1',
  //       'Deodorization Section item 2',
  //     ],
  //   },
  //   'Fractination': {
  //     'Fractination': ['Fractination item 1', 'Fractination item 2'],
  //   },
  // };

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
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Change Product (F/RFA-015)"),
        actions: [
          IconButton(
            onPressed: () async {
              await _refreshPage();
            },
            icon: Icon(Icons.replay_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CustomDateField(
                          controller: dateEntryController,
                          label: 'Tanggal',
                          icon: Icons.event,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomHourMinuteField(
                          selectedTime:
                              selectedHour != null
                                  ? TimeOfDay(hour: selectedHour!, minute: 0)
                                  : TimeOfDay(hour: 8, minute: 0),
                          onTap: () => _showHourPicker(context),
                          hint: '',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                CustomDropdown.fromStringItems(
                  hint: 'Pilih Produk Awal',

                  prefixIcon: PrefixIconHelper.get('factory'),
                  stringItems: dummyFirstParts,
                  value: selectedFirstPart,
                  onChanged:
                      (value) => setState(() => selectedFirstPart = value),
                ),
                const SizedBox(height: 16),
                CustomDropdown.fromStringItems(
                  hint: 'Pilih Produk Selanjutnya',
                  prefixIcon: PrefixIconHelper.get('factory'),
                  stringItems: dummyNextParts,
                  value: selectedNextPart,
                  onChanged:
                      (value) => setState(() => selectedNextPart = value),
                ),
                const SizedBox(height: 16),
                CustomDropdown.fromStringItems(
                  hint: 'Pilih Plant',
                  prefixIcon: PrefixIconHelper.get('location'),
                  stringItems: dummyLocations,
                  value: selectedLocation,
                  onChanged:
                      (value) => setState(() => selectedLocation = value),
                ),
                const SizedBox(height: 24),
                if (selectedLocation == 'Refinery') ...[
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pre-Treatment Section',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: dummyPreTreatmentSectionItem.length,
                            itemBuilder: (context, index) {
                              return ChecklistItemRow(
                                number: index + 1,
                                description:
                                    dummyPreTreatmentSectionItem[index],
                                value: checklist1,
                                onChanged:
                                    (val) => setState(
                                      () => checklist1 = val ?? false,
                                    ),
                              );
                            },
                          ),
                          Divider(
                            height: 0.0,
                            thickness: 1,
                            endIndent: 0,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 24.0),
                          Text(
                            'Bleacher Section',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: dummyBleacherSectionItem.length,
                            itemBuilder: (context, index) {
                              return ChecklistItemRow(
                                number: index + 1,
                                description: dummyBleacherSectionItem[index],
                                value: checklist1,
                                onChanged:
                                    (val) => setState(
                                      () => checklist1 = val ?? false,
                                    ),
                              );
                            },
                          ),
                          Divider(
                            height: 0.0,
                            thickness: 1,
                            endIndent: 0,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 24.0),
                          Text(
                            'Deodorization Section',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: dummyDeodorizationSectionItem.length,
                            itemBuilder: (context, index) {
                              return ChecklistItemRow(
                                number: index + 1,
                                description:
                                    dummyDeodorizationSectionItem[index],
                                value: checklist1,
                                onChanged:
                                    (val) => setState(
                                      () => checklist1 = val ?? false,
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (selectedLocation == 'Fractination') ...[
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fractination Section',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: dummyFractinationSectionItem.length,
                            itemBuilder: (context, index) {
                              return ChecklistItemRow(
                                number: index + 1,
                                description:
                                    dummyFractinationSectionItem[index],
                                value: checklist1,
                                onChanged:
                                    (val) => setState(
                                      () => checklist1 = val ?? false,
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Silakan pilih part terlebih dahulu',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
                if (selectedLocation != null) ...[
                  // SectionCard(
                  //   title: 'Remark',
                  //   children: [CustomRemarkField(controller: notesController)],
                  // ),
                  // const SizedBox(height: 24),
                  // CustomSaveButton(onPressed: () {}, label: 'Submit Laporan'),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Remark',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            CustomRemarkField(controller: notesController),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: CustomSaveButton(
                      onPressed: () {},
                      label: 'Submit Laporan',
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
