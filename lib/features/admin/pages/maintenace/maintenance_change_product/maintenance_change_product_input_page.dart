import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/data/remote/master/value_entity.dart';
import 'package:logsheet_app/features/admin/widgets/checklist_item_row.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/providers/maintenance/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

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
  String? selectedWorkCenter;
  int? selectedHour;

  List<MasterValueEntity> workCenterList = [];

  bool checklist1 = false;
  bool checklist2 = false;

  final List<String> dummyFirstParts = ['RPS', 'CPKO'];
  final List<String> dummyNextParts = ['CPO', 'CPKO'];
  final List<String> dummyLocations = ['Refinery', 'Fractination'];

  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ChangeProductChecklistProvider>().getLangkahKerja();
      await context.read<ValueProvider>().fetchWorkCenterLists();
      await context.read<ValueProvider>().fetchWorkCenterFractLists();
    });
  }

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
    final langkahKerjaProvider =
        context.watch<ChangeProductChecklistProvider>();
    final valueProvider = context.read<ValueProvider>();

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
                CustomDropdown.fromStringItems(
                  hint: 'Pilih Plant',
                  prefixIcon: PrefixIconHelper.get('location'),
                  stringItems: dummyLocations,
                  value: selectedLocation,
                  onChanged: (value) {
                    setState(() => selectedLocation = value);
                    setState(() {
                      if (value == 'Refinery') {
                        workCenterList = valueProvider.workCenterLists;
                      } else if (value == 'Fractination') {
                        workCenterList = valueProvider.workCenterFractLists;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedWorkCenter,
                  items:
                      workCenterList.map((workCenter) {
                        return DropdownMenuItem<String>(
                          value: workCenter.code,
                          child: Text(
                            "${workCenter.code} - ${workCenter.name}",
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  onChanged:
                      selectedLocation == null
                          ? null // Disable the dropdown if no location is selected
                          : (value) {
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
                    hintText: 'Work Center',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/icons/oil-refinery-tanks.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                  onChanged: (value) {
                    setState(() => selectedNextPart = value);
                  },
                ),
                const SizedBox(height: 16),

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
                            itemCount:
                                langkahKerjaProvider
                                    .langkahKerjaPreTreatmentList
                                    .length,
                            itemBuilder: (context, index) {
                              return ChecklistItemRow(
                                number: index + 1,
                                description:
                                    langkahKerjaProvider
                                        .langkahKerjaPreTreatmentList[index]
                                        .name!,
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
                            itemCount:
                                langkahKerjaProvider
                                    .langkahKerjaBleacherList
                                    .length,
                            itemBuilder: (context, index) {
                              return ChecklistItemRow(
                                number: index + 1,
                                description:
                                    langkahKerjaProvider
                                        .langkahKerjaBleacherList[index]
                                        .name!,
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
                            itemCount:
                                langkahKerjaProvider
                                    .langkahKerjaDeodorizationList
                                    .length,
                            itemBuilder: (context, index) {
                              return ChecklistItemRow(
                                number: index + 1,
                                description:
                                    langkahKerjaProvider
                                        .langkahKerjaDeodorizationList[index]
                                        .name!,
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
                            itemCount:
                                langkahKerjaProvider
                                    .langkahKerjaFractionationList
                                    .length,
                            itemBuilder: (context, index) {
                              return ChecklistItemRow(
                                number: index + 1,
                                description:
                                    langkahKerjaProvider
                                        .langkahKerjaFractionationList[index]
                                        .name!,
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
