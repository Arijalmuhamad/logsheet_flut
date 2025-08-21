import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_control_detail_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_control_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/providers/maintenance/maintenance_lamps_and_glass_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class MaintenanceLampsGlassInputPage extends StatefulWidget {
  final String userName;
  const MaintenanceLampsGlassInputPage({super.key, required this.userName});

  @override
  State<MaintenanceLampsGlassInputPage> createState() =>
      _ChecklistLampsGlassPageState();
}

class _ChecklistLampsGlassPageState
    extends State<MaintenanceLampsGlassInputPage> {
  // late final AppDatabase db;
  // late MastervalueDao mastervalueDao;

  bool isLoading = false;

  final TextEditingController dateEntryController = TextEditingController();
  // final TextEditingController notesController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  String? selectedWorkCenter;
  int? selectedHour;

  final List<String> workCenters = [];
  Map<String, List<String>> groupedItems = {};
  final Set<String> expandedGroups = {};
  final Map<String, bool> checklistValues = {};

  // void _resetForm() {
  //   setState(() {
  //     dateEntryController.clear();
  //     notesController.clear();
  //     selectedLocation = null;
  //     selectedHour = null;
  //     checklistValues.clear(); // tambahkan
  //     expandedGroups.clear(); // tambahkan
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // db = AppDatabase();
    // mastervalueDao = MastervalueDao(db);
    // _loadChecklistComponents();

    dateEntryController.text = DateFormat('dd-M-yyyy').format(DateTime.now());

    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>
          context
              .read<MaintenanceLampsAndGlassProvider>()
              .fetchAllLampsAndGlass(),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ValueProvider>().fetchWorkCenterLists(),
    );

    dateEntryController.addListener(_validateInput);
  }

  // Future<void> _loadChecklistComponents() async {
  //   final components = await mastervalueDao.getActiveComponents();
  //   final Map<String, List<String>> grouped = {};
  //   for (var item in components) {
  //     final groupName = item.group.replaceAll('component_', '').toUpperCase();
  //     grouped.putIfAbsent(groupName, () => []).add(item.name);
  //   }
  //   setState(() {
  //     groupedItems = grouped;
  //     isLoading = false;
  //   });
  // }

  // Future<void> _refreshPage() async {
  //   setState(() => isLoading = true);
  //   await Future.delayed(const Duration(milliseconds: 600));
  //   _resetForm();
  //   setState(() => isLoading = false);
  // }

  // void _showHourPicker(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder:
  //         (context) => CustomHourPicker(
  //           selectedHour: selectedHour,
  //           onHourSelected: (hour) {
  //             setState(() => selectedHour = hour);
  //           },
  //         ),
  //   );
  // }

  @override
  void dispose() {
    dateEntryController.removeListener(_validateInput);
    dateEntryController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  void _validateInput() {
    final date = dateEntryController.text;
    final workCenter = selectedWorkCenter;

    if (workCenter != null && workCenter.isNotEmpty && date.isNotEmpty) {
      String formattedDate = parseDateFormatFromController(date);
      context.read<MaintenanceLampsAndGlassProvider>().checkIfDataExists(
        workCenter: workCenter,
        date: formattedDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lampsAndGlassProvider =
        context.watch<MaintenanceLampsAndGlassProvider>();
    final isFormDisabled = lampsAndGlassProvider.isDataAlreadyExist;
    final isLoadingCheck = lampsAndGlassProvider.isLoading;
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Lamps & Glass (F/RFA-013)"),
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<MaintenanceLampsAndGlassProvider>()
                  .fetchAllLampsAndGlass();
            },
            icon: Icon(Icons.replay_rounded),
          ),
        ],
      ),
      body:
          context.watch<MaintenanceLampsAndGlassProvider>().isLoading
              ? _showLoading()
              : showMainScreen(context, isFormDisabled),
    );
  }

  SingleChildScrollView showMainScreen(
    BuildContext context,
    bool isFormDisabled,
  ) {
    final lampsAndGlassProvider =
        context.watch<MaintenanceLampsAndGlassProvider>();
    final valueProvider = context.watch<ValueProvider>();
    return SingleChildScrollView(
      child: Column(
        children: [
          if (isFormDisabled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.amber.shade100,
              child: Text(
                'Input for this Work Center and Date already exists.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.amber.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Consumer<ValueProvider>(
                    builder: (context, provider, child) {
                      if (provider.workCenterLists.isEmpty) {
                        return DropdownButtonFormField<String>(
                          value: null,
                          items: [],
                          onChanged: null, // Disable the dropdown
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Loading Work Center...',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return DropdownButtonFormField<String>(
                        value: selectedWorkCenter,
                        items:
                            valueProvider.workCenterLists.map((workCenter) {
                              return DropdownMenuItem<String>(
                                value: workCenter.code,
                                child: Text(
                                  "${workCenter.code} - ${workCenter.name}",
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedWorkCenter = value;
                          });
                          _validateInput();
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
                      );
                    },
                  ),

                  SizedBox(height: 12),
                  CustomDateField(
                    controller: dateEntryController,
                    label: 'Tanggal Aktivitas',
                    icon: Icons.event,
                    // isLimitDate: true,
                  ),
                  const SizedBox(height: 16),
                  AbsorbPointer(
                    absorbing: isFormDisabled,
                    child: _buildTextField(
                      controller: remarksController,
                      label: 'Remarks',
                      icon: Icons.note_rounded,
                      hintText: 'Remarks',
                      lines: 5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed:
                                () => context
                                    .read<MaintenanceLampsAndGlassProvider>()
                                    .setLamps(true),
                            child: Text(
                              "Lamps",
                              style: TextStyle(
                                fontWeight:
                                    lampsAndGlassProvider.isLamps
                                        ? FontWeight.bold
                                        : FontWeight.w400,
                                fontSize: 18,
                                color:
                                    lampsAndGlassProvider.isLamps
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            width: 20,
                            thickness: 0.5,
                            indent: 20,
                            endIndent: 0,
                            color: Colors.grey,
                          ),
                          TextButton(
                            onPressed:
                                () => context
                                    .read<MaintenanceLampsAndGlassProvider>()
                                    .setLamps(false),
                            child: Text(
                              "Glass",
                              style: TextStyle(
                                fontWeight:
                                    !lampsAndGlassProvider.isLamps
                                        ? FontWeight.bold
                                        : FontWeight.w400,
                                fontSize: 18,
                                color:
                                    !lampsAndGlassProvider.isLamps
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(thickness: 0.5),
                  const SizedBox(height: 16),
                  //custom tab bar view
                  lampsAndGlassProvider.isLamps
                      ? AbsorbPointer(
                        absorbing: isFormDisabled,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lampsAndGlassProvider.lampsList.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              value:
                                  lampsAndGlassProvider
                                      .lampsList[index]
                                      .statusItem,
                              title: Text(
                                "${lampsAndGlassProvider.lampsList[index].code} - ${lampsAndGlassProvider.lampsList[index].name}",
                              ),
                              onChanged: (bool? value) {
                                setState(() {
                                  lampsAndGlassProvider
                                      .lampsList[index]
                                      .statusItem = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          },
                        ),
                      )
                      : AbsorbPointer(
                        absorbing: isFormDisabled,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: lampsAndGlassProvider.glassList.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              value:
                                  lampsAndGlassProvider
                                      .glassList[index]
                                      .statusItem,
                              title: Text(
                                "${lampsAndGlassProvider.glassList[index].code} - ${lampsAndGlassProvider.glassList[index].name}",
                              ),
                              onChanged: (bool? value) {
                                setState(() {
                                  lampsAndGlassProvider
                                      .glassList[index]
                                      .statusItem = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          },
                        ),
                      ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child:
                        context
                                .watch<MaintenanceLampsAndGlassProvider>()
                                .isSubmitLoading
                            ? SizedBox(
                              width: 14,
                              height: 14,
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Center _showLoading() => Center(child: CircularProgressIndicator());

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    bool isNumeric = false,
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        minLines: 1,
        maxLines: lines,
        keyboardType:
            isNumeric
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
        inputFormatters:
            isNumeric
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                : [],
        decoration: InputDecoration(
          labelText: label,

          // hintText: hintText,
          labelStyle: const TextStyle(
            color: Color(0xFF655F5B),
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Color(0xFF655F5B)),
          filled: true,
          fillColor: const Color(0xFFF0ECE9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Color(0xFF655F5B), fontSize: 16),
      ),
    );
  }

  void _submitForm() async {
    final selectedDate = dateEntryController.text;
    final remarks = remarksController.text;
    log(
      "Date selected : $selectedDate, \n Remarks: $remarks, selected work center: $selectedWorkCenter",
    );

    final reportProvider = context.read<MaintenanceLampsAndGlassProvider>();
    final plant = context.read<PlantProvider>().currentPlant;
    final businessUnit =
        context.read<BusinessUnitProvider>().currentBusinessUnit;
    final user = context.read<UserProvider>();
    final latestIdFromDatabase = await reportProvider.fetchLatestId(
      plant?.code ?? "",
    );

    Future<String?> buildIdNumber() async {
      log("ID Number FROM PROVIDER: $latestIdFromDatabase");
      if (latestIdFromDatabase == null) {
        log("ID is null");
        return "";
      }
      log("Prefix: ${latestIdFromDatabase.substring(0, 9)}");
      int digit = (int.parse((latestIdFromDatabase.substring(9))) + 1);
      final update = await context
          .read<MaintenanceLampsAndGlassProvider>()
          .updateAutoNumber(plant?.code ?? "", digit);
      if (update) {
        //update
        String lastDigit = digit.toString().padLeft(6, '0');
        log("Last Digit: $lastDigit, is update successful: true");
        String idPrefix = latestIdFromDatabase.substring(0, 9);
        log("Built Ticket: ${idPrefix + lastDigit}");
        return idPrefix + lastDigit;
      }

      return null;
    }

    String? buildIdDetailNumber(int index) {
      final idDetailPrefix =
          "${latestIdFromDatabase!.substring(0, 3)}D${latestIdFromDatabase.substring(3, 9)}";
      return idDetailPrefix + index.toString().padLeft(6, '0');
    }

    final builtId = await buildIdNumber();

    log("Built String ID : $builtId");
    log("Built String ID Detail 1: ${buildIdDetailNumber(1)}");
    log("Built String ID Detail 2: ${buildIdDetailNumber(2)}");
    log("Built String ID Detail 3: ${buildIdDetailNumber(3)}");

    String formattedDate = parseDateFormatFromController(selectedDate);

    final controlEntity = LampsAndGlassControlEntity(
      id: builtId ?? "",
      company: businessUnit?.buCode ?? "",
      plant: plant?.code ?? "",
      workCenter: selectedWorkCenter ?? "",
      checkDate: DateTime.parse(formattedDate),
      remarks: remarks,
      entryBy: user.currentUser?.username ?? "",
      entryDate: DateTime.now(),
      checkedBy: null,
      checkedDate: null,
      checkedStatus: null,
      checkedStatusRemarks: null,
    );

    log("id: ${controlEntity.id}");
    log("company: ${controlEntity.company}");
    log("plant: ${controlEntity.plant}");
    log("work center: ${controlEntity.workCenter}");
    log("check date: ${controlEntity.checkDate}");
    log("remarks: ${controlEntity.remarks}");
    log("entry by: ${controlEntity.entryBy}");
    log("entry date: ${controlEntity.entryDate}");
    log("checked by: ${controlEntity.checkedBy}");
    log("checked date: ${controlEntity.checkedDate}");
    log("checked status: ${controlEntity.checkedStatus}");
    log("checked status remark: ${controlEntity.checkedStatusRemarks}");

    List<LampsAndGlassEntity> lampsAndGlassListCombined = [
      if (mounted)
        ...context.read<MaintenanceLampsAndGlassProvider>().lampsList,
      if (mounted)
        ...context.read<MaintenanceLampsAndGlassProvider>().glassList,
    ];

    List<LampsAndGlassControlDetailEntity> controlDetailList = [
      if (mounted)
        ...lampsAndGlassListCombined.asMap().entries.map((e) {
          int index = e.key;
          LampsAndGlassEntity entity = e.value;

          return LampsAndGlassControlDetailEntity(
            id: buildIdDetailNumber(index + 1).toString(),
            idHdr: builtId ?? "",
            checkItem: entity.code,
            statusItem: entity.statusItem ? 'T' : 'F',
          );
        }),
    ];

    for (var detail in controlDetailList) {
      log(
        'ID: ${detail.id}, ID Header: ${detail.idHdr},CHECK ITEM: ${detail.checkItem}, STATUS ITEM: ${detail.statusItem}',
      );
    }
    if (!mounted) return;
    final controlResult = await context
        .read<MaintenanceLampsAndGlassProvider>()
        .insertToControl(controlEntity);

    if (controlResult) {
      if (!mounted) return;
      final controlDetailResult = await context
          .read<MaintenanceLampsAndGlassProvider>()
          .insertToControlDetail(controlDetailList);
      if (controlDetailResult) {
        if (!mounted) return;
        Navigator.pop(context);
        _showSnackBar("Data Berhasil Diinput.");
      } else {
        if (!mounted) return;
        _showSnackBar(
          "Error Inserting to Lamps and Glass Control Detail to database table: ${context.read<MaintenanceLampsAndGlassProvider>().errorMessage}.",
        );
      }
    } else {
      if (!mounted) return;
      _showSnackBar(
        "Error Inserting to Lamps and Glass Control to database table: ${context.read<MaintenanceLampsAndGlassProvider>().errorMessage}.",
      );
    }
  }

  String parseDateFormatFromController(String selectedDate) {
    DateFormat inputFormat = DateFormat('dd-M-yyyy');
    DateTime dateTimeObject = inputFormat.parse(selectedDate);
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    String formattedDate = outputFormat.format(dateTimeObject);
    return formattedDate;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
