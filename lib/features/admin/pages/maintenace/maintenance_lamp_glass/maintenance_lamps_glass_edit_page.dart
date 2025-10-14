import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/show_alert_dialog.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_control_detail_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_report_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/providers/maintenance/maintenance_lamps_and_glass_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class MaintenanceLampsGlassEditPage extends StatefulWidget {
  const MaintenanceLampsGlassEditPage({
    super.key,
    required this.lampsAndGlassList,
  });
  final List<LampsAndGlassReportEntity> lampsAndGlassList;

  @override
  State<MaintenanceLampsGlassEditPage> createState() =>
      _MaintenanceLampsGlassEditPageState();
}

class _MaintenanceLampsGlassEditPageState
    extends State<MaintenanceLampsGlassEditPage> {
  final dateEntryController = TextEditingController();
  final remarksController = TextEditingController();

  String? selectedWorkCenter;
  int? selectedHour;

  Map<String, List<String>> groupedItems = {};
  final Set<String> expandedGroups = {};
  final Map<String, bool> checklistValues = {};
  List<LampsAndGlassReportEntity>? lampsList, glassList;

  @override
  void initState() {
    super.initState();

    dateEntryController.text = DateFormat(
      'dd-M-yyyy',
    ).format(widget.lampsAndGlassList[0].entryDate);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ValueProvider>().fetchWorkCenterLists(),
    );

    selectedWorkCenter = widget.lampsAndGlassList[0].workCenter;
    remarksController.text = widget.lampsAndGlassList[0].remarks;

    dateEntryController.addListener(_validateInput);
  }

  @override
  void dispose() {
    super.dispose();
    dateEntryController.dispose();
    remarksController.dispose();
    dateEntryController.removeListener(_validateInput);
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

  String parseDateFormatFromController(String selectedDate) {
    DateFormat inputFormat = DateFormat('dd-M-yyyy');
    DateTime dateTimeObject = inputFormat.parse(selectedDate);
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    String formattedDate = outputFormat.format(dateTimeObject);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final lampsAndGlassList = widget.lampsAndGlassList;
    lampsList =
        lampsAndGlassList.where((e) => e.checkItem.startsWith("L")).toList();

    glassList =
        lampsAndGlassList.where((e) => e.checkItem.startsWith("KC")).toList();
    final provider = context.watch<MaintenanceLampsAndGlassProvider>();

    return Scaffold(
      appBar: _buildAppBar(lampsAndGlassList[0]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
          child: Column(
            children: [
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
                          if (provider.isLoading) {
                            return DropdownButtonFormField(
                              value: null,
                              items: [],
                              onChanged: null,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF0ECE9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Loading Work Center...',
                                prefixIcon: const Padding(
                                  padding: EdgeInsetsGeometry.all(12.0),
                                  child: SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          if (provider.workCenterLists.isEmpty) {
                            return TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF0ECE9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Work Center tidak ditemukan.',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Icon(Icons.warning_amber_rounded),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: () async {
                                    await context
                                        .read<ValueProvider>()
                                        .fetchWorkCenterLists();
                                  },
                                ),
                              ),
                            );
                          }

                          return DropdownButtonFormField(
                            value: selectedWorkCenter,
                            items:
                                provider.workCenterLists.map((workCenter) {
                                  return DropdownMenuItem<String>(
                                    value: workCenter.code,
                                    child: Text(
                                      "${workCenter.code} - ${workCenter.name}",
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
                        isDisabled: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: remarksController,
                        label: 'Remarks',
                        icon: Icons.note_rounded,
                        hintText: 'Remarks',
                        lines: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SizedBox(
                          height: 50,
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () => provider.setLamps(true),
                                  child: Text(
                                    "Lamps",
                                    style: TextStyle(
                                      fontWeight:
                                          provider.isLamps
                                              ? FontWeight.bold
                                              : FontWeight.w400,
                                      fontSize: 18,
                                      color:
                                          provider.isLamps
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
                                          .read<
                                            MaintenanceLampsAndGlassProvider
                                          >()
                                          .setLamps(false),
                                  child: Text(
                                    "Glass",
                                    style: TextStyle(
                                      fontWeight:
                                          !provider.isLamps
                                              ? FontWeight.bold
                                              : FontWeight.w400,
                                      fontSize: 18,
                                      color:
                                          !provider.isLamps
                                              ? Colors.red
                                              : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(thickness: 0.5),
                      const SizedBox(height: 16),

                      provider.isLamps
                          ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: lampsList?.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(lampsList?[index].checkItem ?? "-"),
                                value:
                                    lampsList?[index].statusItem == "T"
                                        ? true
                                        : false,
                                onChanged: (value) {
                                  setState(() {
                                    if (lampsList?[index].statusItem == "T") {
                                      setState(() {
                                        lampsList?[index].statusItem = "F";
                                      });
                                    } else {
                                      lampsList?[index].statusItem = "T";
                                    }

                                    // if (lampsList?[index].statusItem == "F") {
                                    //   setState(() {
                                    //     lampsList?[index].statusItem = "T";
                                    //   });
                                    // }
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            },
                          )
                          : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: glassList?.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(glassList?[index].checkItem ?? "-"),
                                value:
                                    glassList?[index].statusItem == "T"
                                        ? true
                                        : false,
                                onChanged: (value) {
                                  setState(() {
                                    if (glassList?[index].statusItem == "T") {
                                      setState(() {
                                        glassList?[index].statusItem = "F";
                                      });
                                    } else {
                                      glassList?[index].statusItem = "T";
                                    }

                                    // if (glassList?[index].statusItem == "F") {
                                    //   setState(() {
                                    //     glassList?[index].statusItem = "T";
                                    //   });
                                    // }
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(LampsAndGlassReportEntity entity) {
    final String date = DateFormat('yyyy-MM-dd').format(entity.entryDate);
    final provider = context.watch<MaintenanceLampsAndGlassProvider>();
    return AppBar(
      title: Text("Edit $date "),
      actions: [
        provider.isLoadingUpdate
            ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(color: Colors.white),
            )
            : IconButton(
              onPressed: () {
                DialogUtil.showAlert(
                  context: context,
                  title: "Edit $date",
                  message: "Apakah anda yakin?",
                  onCancel: () => Navigator.pop(context),
                  cancelText: "Tidak",
                  confirmText: "Ya",
                  onConfirm: () async {
                    List<LampsAndGlassReportEntity> lampsAndGlass = [
                      ...lampsList!,
                      ...glassList!,
                    ];

                    List<LampsAndGlassControlDetailEntity> lampsAndGlassDetail =
                        lampsAndGlass
                            .map(
                              (e) =>
                                  LampsAndGlassControlDetailEntity.fromReportEntity(
                                    e,
                                  ),
                            )
                            .toList();

                    final result = await context
                        .read<MaintenanceLampsAndGlassProvider>()
                        .updateLampsAndGlass(
                          id: lampsAndGlass[0].id,
                          company: lampsAndGlass[0].company,
                          plant: lampsAndGlass[0].plant,
                          workCenter:
                              selectedWorkCenter ?? lampsAndGlass[0].workCenter,
                          checkDate:
                              lampsAndGlass[0].checkDate ?? DateTime.now(),
                          remarks: remarksController.text,
                          details: lampsAndGlassDetail,
                        );

                    if (result) {
                      if (!mounted) return;
                      Navigator.pop(context);
                      showSnackBar("Edit $date berhasil.", context);
                    }
                  },
                );
              },
              icon: Icon(Icons.save_rounded, color: Colors.white, size: 25),
            ),
      ],
    );
  }

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
}
