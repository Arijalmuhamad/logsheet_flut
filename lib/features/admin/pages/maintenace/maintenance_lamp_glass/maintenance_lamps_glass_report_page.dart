import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/show_alert_dialog.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_lamp_glass/maintenance_lamps_glass_edit_page.dart';
import 'package:logsheet_app/features/admin/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/providers/maintenance/maintenance_lamps_and_glass_provider.dart';
import 'package:provider/provider.dart';

class MaintenanceLampsGlassReportPage extends StatefulWidget {
  const MaintenanceLampsGlassReportPage({super.key});

  @override
  State<MaintenanceLampsGlassReportPage> createState() =>
      _MaintenanceLampsGlassReportPageState();
}

class _MaintenanceLampsGlassReportPageState
    extends State<MaintenanceLampsGlassReportPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _remarksController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lamps & Glass Report(F/RFA-013)")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
          child: Column(
            children: [
              _buildFilterSection(context),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Consumer<MaintenanceLampsAndGlassProvider>(
                  builder: (context, provider, child) {
                    if (provider.reportList.isEmpty) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: const Text("No Data"),
                          ),
                        ],
                      );
                    }
                    if (provider.isLoading) {
                      return Center(child: const CircularProgressIndicator());
                    }
                
                    final report = provider.reportList[0];
                    return Card(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Spacer(),
                              PopupMenuButton(
                                icon: Icon(Icons.more_vert_rounded),
                                onSelected: (value) {
                                  if (value == "edit") {
                                    // handle edit
                                    // showSnackBar(value, context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                MaintenanceLampsGlassEditPage(
                                                  lampsAndGlassList:
                                                      provider.reportList,
                                                ),
                                      ),
                                    );
                                  }
                
                                  if (value == "delete") {
                                    // handle delete
                                    DialogUtil.showAlert(
                                      context: context,
                                      title: "Delete ${report.entryDate}",
                                      message: "Apakah anda yakin?",
                                      onCancel: () => Navigator.pop(context),
                                      onConfirm: () async {
                                        final result = await context
                                            .read<
                                              MaintenanceLampsAndGlassProvider
                                            >()
                                            .deleteLampsAndGlass(report.id);
                
                                        if (result) {
                                          if (!context.mounted) return;
                                          showSnackBar(
                                            "Delete berhasil",
                                            context,
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                                itemBuilder:
                                    (context) => [
                                      const PopupMenuItem(
                                        value: "edit",
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 18),
                                            SizedBox(width: 8),
                                            Text("Edit"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: "delete",
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8),
                                            Text("Delete"),
                                          ],
                                        ),
                                      ),
                                    ],
                              ),
                            ],
                          ),
                          // const Divider(indent: 12, endIndent: 12),
                          _buildInfoRow(
                            context,
                            icon: Icons.article,
                            label: "ID",
                            value: report.id,
                          ),
                          _buildInfoRow(
                            context,
                            icon: Icons.business_outlined,
                            label: "Company",
                            value: report.company,
                          ),
                          _buildInfoRow(
                            context,
                            icon: Icons.factory_outlined,
                            label: "Plant",
                            value: report.plant,
                          ),
                          _buildInfoRow(
                            context,
                            icon: Icons.precision_manufacturing_outlined,
                            label: "Work Center",
                            value: report.workCenter,
                          ),
                          _buildInfoRow(
                            context,
                            icon: Icons.calendar_today_outlined,
                            label: "Check Date",
                            // Formatting the date nicely!
                            value: DateFormat(
                              'd MMMM yyyy',
                            ).format(report.checkDate!),
                          ),
                          _buildInfoRow(
                            context,
                            icon: Icons.person_outline,
                            label: "Entry By",
                            value: report.entryBy,
                          ),
                          const SizedBox(height: 4),
                          const Divider(
                            indent: 18,
                            endIndent: 18,
                            thickness: 0.7,
                          ),
                
                          ListView.builder(
                            itemCount: provider.reportList.length,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              log("ItemBuilder Index: $index");
                              // return Text("$index");
                              return CheckboxListTile(
                                enabled: false,
                                value:
                                    provider.reportList[index].statusItem ==
                                    "T",
                                title: Text(
                                  provider.reportList[index].checkItem,
                                ),
                                onChanged: (value) {},
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            },
                          ),
                          _buildTextField(
                            controller: _remarksController,
                            label: 'Remarks',
                            icon: Icons.note_rounded,
                            hintText: 'Remarks',
                            lines: 5,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Pilih tanggal',
              filled: true,
              fillColor: const Color(0xFFF0ECE9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.calendar_today),
            ),
            onTap: () => _pickDate(context),
          ),
        ),
        const SizedBox(width: 10),
        const SizedBox(width: 10),
        Consumer<MaintenanceLampsAndGlassProvider>(
          builder:
              (context, provider, child) => ElevatedButton.icon(
                onPressed:
                    provider.isLoading
                        ? null
                        : () async {
                          setState(() {
                            log("$_selectedDate");
                            log(_dateController.text);
                          });
                          await context
                              .read<MaintenanceLampsAndGlassProvider>()
                              .fetchAllLampsAndGlassFromDate(
                                _dateController.text,
                              );
                        },
                icon: const Icon(Icons.search),
                label: const Text('Cari'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAB2F2B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        // _fetchReports();
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isEnabled = false,
    String? hintText,
    bool isNumeric = false,
    int lines = 1,
  }) {
    controller.text =
        context.read<MaintenanceLampsAndGlassProvider>().reportList[0].remarks;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      child: TextField(
        controller: controller,
        minLines: 1,
        enabled: isEnabled,
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
