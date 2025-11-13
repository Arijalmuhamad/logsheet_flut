import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_to_db_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_checkbox_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/admin/widgets/custom_text_field.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/product_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:logsheet_app/providers/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_provider.dart';
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
  final TextEditingController suhuController = TextEditingController();

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
  final TextEditingController pController = TextEditingController();
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
                return DropdownButtonFormField<String>(
                  value: selectedOilType,
                  items:
                      [
                            ...provider.productFractionationList,
                            ...provider.productRefineryList,
                          ]
                          .map((e) => e.rawMaterial)
                          .toSet() // Ensures unique rawMaterial values
                          .map((rawMaterial) {
                            return DropdownMenuItem<String>(
                              value: rawMaterial,
                              child: Text(rawMaterial ?? ''),
                            );
                          })
                          .toList(),
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
              icon: Icons.scale,
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
              icon: Icons.add_box,
              isNumeric: true,
            ),

            CustomTextField(
              controller: suhuController,
              label: 'Suhu (°C)',
              icon: Icons.thermostat,
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
                      icon: Icons.bubble_chart,
                      isNumeric: true,
                    ),
                    CustomTextField(
                      controller: moistureController,
                      label: 'Moisture (%)',
                      icon: Icons.water_drop,
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
                              icon: Icons.color_lens_rounded,
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
                              icon: Icons.color_lens_rounded,
                              isNumeric: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomTextField(
                      controller: ivController,
                      label: 'IV (gt2/100g)',
                      icon: Icons.scale,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: pvController,
                      label: 'PV (meqO2/kg)',
                      icon: Icons.energy_savings_leaf,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: slipMeltingPointController,
                      label: 'Slip Melting Point (oC)',
                      icon: Icons.fireplace,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: cloudPointController,
                      label: 'Cloud Point (°C)',
                      icon: Icons.wb_cloudy,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: anvController,
                      label: 'Anv (°C)',
                      icon: Icons.fact_check,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: bCaroteneController,
                      label: 'B-Carotene (ppm)',
                      icon: Icons.color_lens,
                      isNumeric: true,
                    ),

                     CustomTextField(
                      controller: pController,
                      label: 'P (ppm)',
                      icon: Icons.bubble_chart,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: dobiController,
                      label: 'DOBI',
                      icon: Icons.opacity,
                      isNumeric: true,
                    ),

                    CustomTextField(
                      controller: totoxController,
                      label: 'Totox',
                      icon: Icons.bubble_chart,
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
            Consumer<DailyStorageTankAnalyticalProvider>(
              builder: (context, provider, child) {
                return (provider.isLoadingInput)
                    ? Center(child: CircularProgressIndicator())
                    : CustomSaveButton(
                      onPressed: () async {
                        final bool isSuccess =
                            await _insertDailyStorageTankAnalyticalReport();
                        if (isSuccess) {
                          showSnackBar("Berhasil menyimpan data", context);
                          Navigator.of(context).pop();
                        } else {
                          showSnackBar("Gagal meyimpan data", context);
                        }
                      },
                    );
              },
            ),

            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Future<bool> _insertDailyStorageTankAnalyticalReport() async {
    final plant = context.read<PlantProvider>().currentPlant;
    final user = context.read<UserProvider>();
    final id = await context
        .read<DailyStorageTankAnalyticalProvider>()
        .generateId(plant?.code ?? "");
    final businessUnit =
        context.read<BusinessUnitProvider>().currentBusinessUnit;
    final formattedDate = parseDateFormatFromController(
      dateEntryController.text,
    );

    try {
      final report = DailyStorageTankAnalyticalToDbEntity(
        id: id,
        company: businessUnit?.buCode ?? "",
        plant: plant?.code ?? '',
        transactionDate: formattedDate,
        postingDate: DateTime.now(),
        tankNo: selectedTank,
        oilType: selectedOilType,
        kapasitasTanki: int.tryParse(kapasitasTankiController.text) ?? 0,
        quantity: int.tryParse(quantityController.text) ?? 0,
        emptySpace: int.tryParse(emptySpaceController.text) ?? 0,
        suhu: int.tryParse(suhuController.text) ?? 0,
        qpFFA: double.tryParse(ffaController.text) ?? 0.0,
        qpMoisture: moistureController.text,
        qpColorR: int.tryParse(loviBondRController.text) ?? 0,
        qpColorY: int.tryParse(loviBondYController.text) ?? 0,
        qpIV: double.tryParse(ivController.text) ?? 0.0,
        qpPV: double.tryParse(pvController.text) ?? 0.0,
        qpSlipMeltingPoint: slipMeltingPointController.text,
        qpCloudPoint: double.tryParse(cloudPointController.text) ?? 0.0,
        qpANV: double.tryParse(anvController.text) ?? 0.0,
        betaCarotene: double.tryParse(bCaroteneController.text) ?? 0.0,
        qpP: double.tryParse(pController.text) ?? 0.0, 
        qpDobi: double.tryParse(dobiController.text) ?? 0.0,
        qpTotox: double.tryParse(totoxController.text) ?? 0.0,
        qpOdor: odorChecked ? "T" : "F",
        remarks: remarkController.text,

        // Metadata
        flag: 'T',
        entryBy: user.currentUser?.username ?? '',
        entryDate: DateTime.now(),
        preparedBy: null,
        preparedDate: null,
        preparedStatus: null,
        preparedStatusRemarks: null,
        approvedBy: null,
        approvedDate: null,
        approvedStatus: null,
        approvedStatusRemarks: null,
        updatedBy: null,
        updatedDate: null,
        formNo: formData?.code,
        dateIssued: formData?.dateIssued,
        revisionNo: formData?.revisionNo.toString(),
        revisionDate: formData?.revisionDate,
      );

      final isSuccess = await context
          .read<DailyStorageTankAnalyticalProvider>()
          .insertDailyStorageTankAnalyticalReport(report: report);

      return isSuccess;
    } catch (e) {
      debugPrint("Error inserting Daily Storage Tank Analytical report: $e");
      return false;
    }
  }

  DateTime? parseDateFormatFromController(String? selectedDate) {
    final date = DateTime.now();

    if (selectedDate == null || selectedDate.isEmpty) return null;
    try {
      // UI format = "dd-MM-yyyy"
      final inputFormat = DateFormat('dd-MM-yyyy');
      final dateTime = inputFormat.parse(selectedDate);

      // langsung return objek DateTime (bukan String)

      final combinedDateTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        date.hour,
        date.minute,
        date.second,
      );

      return combinedDateTime;
    } catch (e) {
      log('Date parse error: $e');
      return null;
    }
  }
}
