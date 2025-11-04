import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_checkbox_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/product_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class DailyStorageTankAnalyticalInputPage extends StatefulWidget {
  const DailyStorageTankAnalyticalInputPage({super.key});

  @override
  State<DailyStorageTankAnalyticalInputPage> createState() =>
      _DailyStorageTankAnalyticalInputPageState();
}

class _DailyStorageTankAnalyticalInputPageState
    extends State<DailyStorageTankAnalyticalInputPage> {
  DataFormNoEntity? formData;
  String? selectedTank;
  String? selectedOilType;

  final TextEditingController dateEntryController = TextEditingController();
  final TextEditingController kapasitasTankiController =
      TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController emptySpaceController = TextEditingController();

  // Quality Parameters
  final TextEditingController ffaController = TextEditingController();
  final TextEditingController moistureController = TextEditingController();
  final TextEditingController loviBondRController = TextEditingController();
  final TextEditingController loviBondYController = TextEditingController();
  final TextEditingController ivController = TextEditingController();
  final TextEditingController pvController = TextEditingController();
  final TextEditingController slipMeltingPointController =
      TextEditingController();
  final TextEditingController cloudPointController = TextEditingController();
  final TextEditingController anvController = TextEditingController();
  final TextEditingController bCaroteneController = TextEditingController();
  final TextEditingController dobiController = TextEditingController();
  final TextEditingController totoxController = TextEditingController();

  final TextEditingController remarkController = TextEditingController();

  bool odorChecked = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ValueProvider>().fetchTankSourceLists();
      await context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
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
            // Text('Ini Adalah Halaman List'),
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
            SizedBox(height: 16.0),
            Consumer<ProductProvider>(
              builder: (
                BuildContext context,
                ProductProvider provider,
                Widget? child,
              ) {
                if (provider.isLoading)
                  if (provider.isLoading) {
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
                return DropdownButtonFormField(
                  value: selectedOilType,
                  items:
                      provider.productRefineryList.map((oil) {
                        return DropdownMenuItem(
                          value: oil.rawMaterial,
                          child: Text("${oil.rawMaterial}"),
                        );
                      }).toList(),
                  onChanged: (value) => setState(() => selectedOilType = value),
                  decoration: InputDecoration(
                    hintText: 'Pilih Oil Type',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/icons/oil-refinery-tanks.svg',
                        height: 24,
                        width: 24,
                      ),
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
            SizedBox(height: 16.0),
            CustomDateField(
              controller: dateEntryController,
              label: 'Tanggal',
              icon: Icons.event,
            ),
            SizedBox(height: 16.0),
            CustomTextField(
              controller: kapasitasTankiController,
              label: 'Kapasistas Tanki (Kg)',
              icon: Icons.storage_rounded,
              isNumeric: true,
            ),
            CustomTextField(
              controller: quantityController,
              label: 'Quantity (Kg)',
              icon: Icons.storage_rounded,
              isNumeric: true,
            ),
            CustomTextField(
              controller: emptySpaceController,
              label: 'Empty Space (Kg)',
              icon: Icons.storage_rounded,
              isNumeric: true,
            ),
            SizedBox(height: 8.0),
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
                      'Quality Parameter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    CustomTextField(
                      controller: ffaController,
                      label: 'FFA (%)',
                      icon: Icons.storage_rounded,
                      isNumeric: true,
                    ),
                    CustomTextField(
                      controller: moistureController,
                      label: 'Moisture (%)',
                      icon: Icons.storage_rounded,
                      isNumeric: true,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CustomTextField(
                              controller: loviBondRController,
                              label: 'LoviBond (R)',
                              icon: Icons.storage_rounded,
                              isNumeric: true,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CustomTextField(
                              controller: loviBondYController,
                              label: 'LoviBond (Y)',
                              icon: Icons.storage_rounded,
                              isNumeric: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomTextField(
                      controller: ivController,
                      label: 'IV (gt2/100g)',
                      icon: Icons.storage_rounded,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: pvController,
                      label: 'PV (meqO2/kg)',
                      icon: Icons.storage_rounded,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: slipMeltingPointController,
                      label: 'Slip Melting Point (oC)',
                      icon: Icons.storage_rounded,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: cloudPointController,
                      label: 'Cloud Point (oC)',
                      icon: Icons.storage_rounded,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: anvController,
                      label: 'Anv (oC)',
                      icon: Icons.storage_rounded,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: bCaroteneController,
                      label: 'B-Carotene (ppm)',
                      icon: Icons.storage_rounded,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: dobiController,
                      label: 'DOBI',
                      icon: Icons.storage_rounded,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: totoxController,
                      label: 'Totox',
                      icon: Icons.storage_rounded,
                      isNumeric: true,
                    ),
                    // SizedBox(height: 8),
                    CustomCheckboxField(
                      label: 'Odor',
                      icon: Icons.check_circle_outline,
                      onChanged: (value) {
                        // Do something when checked
                        setState(() => odorChecked = value ?? false);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            CustomRemarkField(controller: remarkController),
            SizedBox(height: 32.0),
            CustomSaveButton(onPressed: () {}),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
