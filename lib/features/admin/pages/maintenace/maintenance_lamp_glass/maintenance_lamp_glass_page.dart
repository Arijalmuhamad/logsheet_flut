// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/data/dao/mastervalue_dao.dart';
import 'package:logsheet_app/features/admin/widgets/checklist_group_section.dart';
import 'package:logsheet_app/features/admin/widgets/custom_app_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_reset_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/section_card.dart';

class MaintenanceLampsGlassPage extends StatefulWidget {
  final String userName;
  const MaintenanceLampsGlassPage({super.key, required this.userName});

  @override
  State<MaintenanceLampsGlassPage> createState() =>
      _ChecklistLampsGlassPageState();
}

class _ChecklistLampsGlassPageState extends State<MaintenanceLampsGlassPage> {
  late final AppDatabase db;
  late MastervalueDao mastervalueDao;

  bool isLoading = false;

  final TextEditingController dateEntryController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? selectedLocation;
  int? selectedHour;

  final List<String> dummyLocations = ['Refinery', 'Fractination'];
  Map<String, List<String>> groupedItems = {};
  final Set<String> expandedGroups = {};
  final Map<String, bool> checklistValues = {};

  void _resetForm() {
    setState(() {
      dateEntryController.clear();
      notesController.clear();
      selectedLocation = null;
      selectedHour = null;
      checklistValues.clear(); // tambahkan
      expandedGroups.clear(); // tambahkan
    });
  }

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    mastervalueDao = MastervalueDao(db);
    _loadChecklistComponents();
  }

  Future<void> _loadChecklistComponents() async {
    final components = await mastervalueDao.getActiveComponents();
    final Map<String, List<String>> grouped = {};
    for (var item in components) {
      final groupName = item.group.replaceAll('component_', '').toUpperCase();
      grouped.putIfAbsent(groupName, () => []).add(item.name);
    }
    setState(() {
      groupedItems = grouped;
      isLoading = false;
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
      appBar: CustomAppBar(title: 'Daily Checklist', onRefresh: _refreshPage),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                SectionCard(
                  title: 'Items',
                  children: [
                    ...groupedItems.entries.map(
                      (entry) => ChecklistGroupSection(
                        group: entry.key,
                        items: entry.value,
                        expandedGroups: expandedGroups,
                        checklistValues: checklistValues,
                        onToggle: (group) {
                          setState(() {
                            expandedGroups.contains(group)
                                ? expandedGroups.remove(group)
                                : expandedGroups.add(group);
                          });
                        },
                        onCheckChanged: (key, val) {
                          setState(() {
                            checklistValues[key] = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                SectionCard(
                  title: 'Remark',
                  children: [CustomRemarkField(controller: notesController)],
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomResetButton(
                        onPressed: () {
                          setState(() {
                            _resetForm();
                            checklistValues.clear();
                            expandedGroups.clear();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomSaveButton(
                        onPressed: () {
                          // Simpan data
                        },
                        label: 'Submit Laporan',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
