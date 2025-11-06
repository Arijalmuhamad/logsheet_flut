import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_checkbox_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class DailyQualityRefinery500MtProductionInputPage extends StatefulWidget {
  const DailyQualityRefinery500MtProductionInputPage({super.key});

  @override
  State<DailyQualityRefinery500MtProductionInputPage> createState() =>
      _DailyQualityRefinery500MtProductionInputPageState();
}

class _DailyQualityRefinery500MtProductionInputPageState
    extends State<DailyQualityRefinery500MtProductionInputPage> {
  @override
  final TextEditingController remarkController = TextEditingController();

  DataFormNoEntity? formData;
  String? selectedTank;
  int? selectedHour;

  bool odorChecked = false;

  final TextEditingController flowRateController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where((form) => form.isMenu == "Change_Product_Checklist")
            .first;
    return AppBar(
      title: Text("Daily Storage Tank Analytical List (${formData!.code})"),
      actions: [],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomHourMinuteField(
              selectedTime:
                  selectedHour != null
                      ? TimeOfDay(hour: selectedHour!, minute: 0)
                      : TimeOfDay(hour: 8, minute: 0),
              onTap: () => _showHourPicker(context),
              hint: '',
            ),
            SizedBox(height: 8.0),
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isTankSourceLoading) {
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
                      hintText: 'Loading Tanks...',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  );
                }
                if (provider.tankSourceList.isEmpty) {
                  return TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Tank List tidak ditemukan.',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.warning_amber_rounded),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await context
                              .read<ValueProvider>()
                              .fetchTankSourceLists();
                        },
                      ),
                    ),
                  );
                }
                return DropdownButtonFormField(
                  value: selectedTank,
                  items:
                      provider.tankSourceList.map((tank) {
                        return DropdownMenuItem(
                          value: tank.code,
                          child: Text("${tank.code} | ${tank.name}"),
                        );
                      }).toList(),
                  onChanged: (value) => setState(() => selectedTank = value),
                  decoration: InputDecoration(
                    hintText: 'Pilih Tank',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(Icons.storage_rounded), // 🛢 Tank icon
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                  ),
                );
              },
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: flowRateController,
              label: 'Flow Rate (T/H)',
              icon: Icons.storage_rounded,
              isNumeric: true,
            ),
            _buildSection("CPO", [
              CustomTextField(
                controller: flowRateController,
                label: 'FFA (%)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'M&I (%)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Dobi',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'IV',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'PV',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'AV',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Totox',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Color (R)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Color (Y)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Color (B)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),
            ]),
            _buildSection("BPO", [
              CustomTextField(
                controller: flowRateController,
                label: 'Color (R)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Color (Y)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Color (W/B)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomCheckboxField(
                label: 'Break Test',
                icon: Icons.check_circle_outline,
                onChanged: (value) {
                  // Do something when checked
                  setState(() => odorChecked = value ?? false);
                },
              ),
            ]),

            _buildSection("BPO", [
              CustomTextField(
                controller: flowRateController,
                label: 'Color (R)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Color (Y)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Color (W/B)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomCheckboxField(
                label: 'Break Test',
                icon: Icons.check_circle_outline,
                onChanged: (value) {
                  // Do something when checked
                  setState(() => odorChecked = value ?? false);
                },
              ),
            ]),

            _buildSection("RBDPO", [
              CustomTextField(
                controller: flowRateController,
                label: 'FFA',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),
              CustomTextField(
                controller: flowRateController,
                label: 'Moist',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'IMP',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'IV',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'PV',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Color (R)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Color (Y)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'Color (W/B)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'To Tank',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),
            ]),
            _buildSection("PFAD", [
              CustomTextField(
                controller: flowRateController,
                label: 'FFA (%)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'M&I (%)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'To Tank',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),
            ]),

            _buildSection("SPENT EARTH", [
              CustomTextField(
                controller: flowRateController,
                label: 'M&I (%)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: flowRateController,
                label: 'SPTH (%)',
                icon: Icons.storage_rounded,
                isNumeric: true,
              ),
            ]),
            SizedBox(height: 16.0),
            CustomRemarkField(controller: remarkController),
            SizedBox(height: 16.0),
            CustomSaveButton(onPressed: () {}),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
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

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF655F5B),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
