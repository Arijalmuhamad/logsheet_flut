// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../data/dao/mastervalue_dao.dart';

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

  DateTime selectedDate = DateTime.now();
  final TextEditingController remarksController = TextEditingController();

  Map<String, List<String>> groupedItems = {};
  final Map<String, bool> checklistValues = {};
  final Set<String> expandedGroups = {};
  bool isLoading = true;
  int? selectedHour;
  String? selectedPlant;

  final List<String> plantList = ['Plant A', 'Plant B', 'Plant C'];

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

  void _resetForm() {
    setState(() {
      remarksController.clear();
      checklistValues.updateAll((key, value) => false);
    });
  }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _resetForm();
    setState(() => isLoading = false);
  }

  Widget _buildGroupSection(String group, List<String> items) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Group
          InkWell(
            onTap: () {
              setState(() {
                expandedGroups.contains(group)
                    ? expandedGroups.remove(group)
                    : expandedGroups.add(group);
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFFF0ECE9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    group,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF655F5B),
                    ),
                  ),
                  Icon(
                    expandedGroups.contains(group)
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF655F5B),
                  ),
                ],
              ),
            ),
          ),

          // Checklist Items
          if (expandedGroups.contains(group))
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
              child: Column(
                children:
                    items.map((item) {
                      final key = '$group-$item';
                      final isChecked = checklistValues[key] ?? false;
                      checklistValues.putIfAbsent(key, () => false);

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isChecked
                                  ? const Color(0xFFFFF5F4)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isChecked
                                    ? const Color(0xFFAB2F2B)
                                    : const Color(0xFFE0E0E0),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              activeColor: const Color(0xFFAB2F2B),
                              onChanged: (value) {
                                setState(() {
                                  checklistValues[key] = value ?? false;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF655F5B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _showHourPicker(BuildContext context) {
    int initialHour = selectedHour ?? TimeOfDay.now().hour;

    // Set default selectedHour sebelum picker tampil
    selectedHour = initialHour;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Pilih Jam Input',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF655F5B),
                  ),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialHour,
                  ),
                  onSelectedItemChanged: (int value) {
                    selectedHour = value;
                  },
                  children: List.generate(
                    24,
                    (index) => Center(
                      child: Text(
                        '${index.toString().padLeft(2, '0')}:00',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF655F5B),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {}); // Refresh UI
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAB2F2B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Pilih', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFAB2F2B),
              onPrimary: Colors.white,
              onSurface: Color(0xFF655F5B),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFFAB2F2B)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showPlantPicker(BuildContext context) {
    int initialIndex =
        selectedPlant != null ? plantList.indexOf(selectedPlant!) : 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Pilih Plant',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF655F5B),
                  ),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedPlant = plantList[index];
                    });
                  },
                  children:
                      plantList
                          .map(
                            (plant) => Center(
                              child: Text(
                                plant,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF655F5B),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAB2F2B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Pilih', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
        title: const Text(
          'Daily Checklist',
          style: TextStyle(
            color: Color(0xFF655F5B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshPage),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Input Plant
                      InkWell(
                        onTap: () => _showPlantPicker(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.factory),
                          ),
                          child: Text(
                            selectedPlant ?? 'Pilih Plant',
                            style: TextStyle(
                              color:
                                  selectedPlant != null
                                      ? const Color(0xFF655F5B)
                                      : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Input Tanggal
                      InkWell(
                        onTap: () => _showDatePicker(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            DateFormat('dd MMMM yyyy').format(selectedDate),
                            style: const TextStyle(color: Color(0xFF655F5B)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Input Jam
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
                      const SizedBox(height: 16),

                      const Text(
                        'Items',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF655F5B),
                        ),
                      ),
                      const SizedBox(height: 8),

                      ...groupedItems.entries.map(
                        (entry) => _buildGroupSection(entry.key, entry.value),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Catatan Tambahan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF655F5B),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: remarksController,
                              maxLines: 5,
                              minLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Tuliskan catatan Anda di sini...',
                                hintStyle: const TextStyle(color: Colors.grey),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF0ECE9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFAB2F2B),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xFF655F5B),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 24),
                        child: Row(
                          children: [
                            // Tombol Reset
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _resetForm,
                                icon: const Icon(Icons.refresh, size: 20),
                                label: const Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE0E0E0),
                                  foregroundColor: const Color(0xFF655F5B),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Tombol Save
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final remarks = remarksController.text;
                                  debugPrint("Remarks: $remarks");
                                  debugPrint("Checklist: $checklistValues");
                                },
                                icon: const Icon(Icons.save, size: 20),
                                label: const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFAB2F2B),
                                  foregroundColor: Colors.white,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
