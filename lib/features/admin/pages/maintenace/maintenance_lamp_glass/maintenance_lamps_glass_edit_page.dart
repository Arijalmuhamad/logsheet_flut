import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_report_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
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

  @override
  void initState() {
    super.initState();

    dateEntryController.text = DateFormat(
      'dd-M-yyyy',
    ).format(widget.lampsAndGlassList[0].entryDate);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ValueProvider>().fetchWorkCenterLists(),
    );

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
    final entity = widget.lampsAndGlassList;
    final provider = context.read<MaintenanceLampsAndGlassProvider>();
    return Scaffold(
      appBar: _buildAppBar(entity[0]),
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
                                  onPressed: () {
                                    context
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
                                  onPressed: () {},
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
                            itemCount:
                                widget
                                    .lampsAndGlassList
                                    .length, //TODO:ganti jadi lamps aja
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                value:
                                    widget
                                                .lampsAndGlassList[index]
                                                .statusItem ==
                                            "T"
                                        ? true
                                        : false,
                                onChanged: (value) {
                                  setState(() {
                                    if (widget
                                            .lampsAndGlassList[index]
                                            .statusItem ==
                                        "T") {
                                      setState(() {
                                        widget
                                            .lampsAndGlassList[index]
                                            .statusItem = "F";
                                      });
                                    }

                                    if (widget
                                            .lampsAndGlassList[index]
                                            .statusItem ==
                                        "F") {
                                      setState(() {
                                        widget
                                            .lampsAndGlassList[index]
                                            .statusItem = "T";
                                      });
                                    }
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
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                value:
                                    widget
                                                .lampsAndGlassList[index]
                                                .statusItem ==
                                            "T"
                                        ? true
                                        : false,
                                onChanged: (value) {
                                  setState(() {
                                    if (widget
                                            .lampsAndGlassList[index]
                                            .statusItem ==
                                        "T") {
                                      setState(() {
                                        widget
                                            .lampsAndGlassList[index]
                                            .statusItem = "F";
                                      });
                                    }

                                    if (widget
                                            .lampsAndGlassList[index]
                                            .statusItem ==
                                        "F") {
                                      setState(() {
                                        widget
                                            .lampsAndGlassList[index]
                                            .statusItem = "T";
                                      });
                                    }
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

  AppBar _buildAppBar(LampsAndGlassReportEntity entity) =>
      AppBar(title: Text("${entity.entryDate} - Edit"));

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
