import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_entity.dart';
import 'package:logsheet_app/features/admin/widgets/custom_checkbox_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
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
import 'package:logsheet_app/providers/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:logsheet_app/providers/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_provider.dart';
import 'package:provider/provider.dart';

class DailyQualityCompositeFractionationInputPage extends StatefulWidget {
  const DailyQualityCompositeFractionationInputPage({super.key});

  @override
  State<DailyQualityCompositeFractionationInputPage> createState() =>
      _DailyQualityCompositeFractionationInputPageState();
}

class _DailyQualityCompositeFractionationInputPageState
    extends State<DailyQualityCompositeFractionationInputPage> {
  String? selectedTankSource;
  String? selectedWorkCenter;
  int? selectedHour;
  String? selectedFgToTank;
  String? selectedBpToTank;

  DataFormNoEntity? formData;

  bool isLoading = false;

  bool breakTest = false;

  final TextEditingController flowRateController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  // === Raw Material Controllers ===
  final TextEditingController rmMniController = TextEditingController();
  final TextEditingController rmIvController = TextEditingController();
  final TextEditingController rmColorRController = TextEditingController();
  final TextEditingController rmColorYController = TextEditingController();
  final TextEditingController rmColorWController = TextEditingController();
  final TextEditingController rmColorBController = TextEditingController();

  // === Finished Goods Controllers ===
  final TextEditingController fgFfaController = TextEditingController();
  final TextEditingController fgMniController = TextEditingController();
  final TextEditingController fgIvController = TextEditingController();
  final TextEditingController fgColorRController = TextEditingController();
  final TextEditingController fgColorYController = TextEditingController();
  final TextEditingController fgColorWController = TextEditingController();
  final TextEditingController fgColorBController = TextEditingController();
  final TextEditingController fgCpController = TextEditingController();
  final TextEditingController fgClarityController = TextEditingController();

  final TextEditingController bpFfaController = TextEditingController();
  final TextEditingController bpMniController = TextEditingController();
  final TextEditingController bpIvController = TextEditingController();
  final TextEditingController bpPvController = TextEditingController();
  final TextEditingController bpColorRController = TextEditingController();
  final TextEditingController bpColorYController = TextEditingController();
  final TextEditingController bpColorWController = TextEditingController();
  final TextEditingController bpColorBController = TextEditingController();

  bool breakTestChecked = false;

  int currentPage = 1;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ValueProvider>().fetchTankSourceLists();
      // await context.read<ProductProvider>().fetchProducts();
      await context.read<ValueProvider>().fetchWorkCenterFractLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu ==
                      "Daily_Quality_Composite_Fractionation_500_mt" &&
                  form.isActive == "T",
            )
            .first;

    log("${formData!.code}");
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: Text(
        'Quality Report - ${formData!.code}',
        style: TextStyle(
          color: Color(0xFF655F5B),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () {})],
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Transaction Date: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
                  ],
                ),
                const SizedBox(height: 8),

                Consumer<ValueProvider>(
                  builder: (context, provider, child) {
                    if (provider.isWorkCenterFractLoading) {
                      // Return a disabled dropdown with a loading indicator or message
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
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      );
                    }
                    if (provider.workCenterFractLists.isEmpty) {
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
                                  .fetchWorkCenterFractLists();
                            },
                          ),
                        ),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      value: selectedWorkCenter,
                      items:
                          provider.workCenterFractLists.map((machine) {
                            return DropdownMenuItem<String>(
                              value: machine.code,
                              child: Text(
                                "${machine.code} | ${machine.name}",
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
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
                        hintText: 'Pilih Work Center',
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

                const SizedBox(height: 8),

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
                const SizedBox(height: 8.0),
                Consumer<ValueProvider>(
                  builder: (context, provider, child) {
                    if (provider.isTankSourceLoading) {
                      // Return a disabled dropdown with a loading indicator or message
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
                          hintText: 'Loading Tank Source...',
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
                          hintText: 'Tank Sources tidak ditemukan.',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.warning_amber_rounded),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              context
                                  .read<ValueProvider>()
                                  .fetchTankSourceLists();
                            },
                          ),
                        ),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      value: selectedTankSource,
                      isExpanded: true,
                      items:
                          provider.tankSourceList.map((tank) {
                            return DropdownMenuItem<String>(
                              value: tank.code,
                              child: Text(
                                tank.code,
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() => selectedTankSource = value);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF0ECE9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Pilih tank source',
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
                const SizedBox(height: 8),

                // Jam Input
                const SizedBox(height: 32),
                _paginationNavigation(),
                const SizedBox(height: 24),
                _buildFormSection(),
                const SizedBox(height: 24),
                Consumer<DailyQualityCompositeFractionationProvider>(
                  builder: (
                    BuildContext context,
                    DailyQualityCompositeFractionationProvider provider,
                    Widget? child,
                  ) {
                    return (provider.isLoadingInput)
                        ? Center(child: CircularProgressIndicator())
                        : CustomSaveButton(
                          onPressed: () async {
                            final bool isSuccess;
                            isSuccess =
                                await _insertDailyQualityCompositeFractionationReport();
                            if (isSuccess) {
                              showSnackBar(
                                "Berhasil menyimpan data",
                                this.context,
                              );
                              Navigator.of(this.context).pop();
                            } else {
                              showSnackBar("Gagal meyimpan data", this.context);
                            }
                          },
                        );
                  },
                ),
              ],
            ),
          ),

          // Loading Overlay
          if (isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
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

  Widget _buildFormSection() {
    switch (currentPage) {
      case 1:
        return _buildSection("Raw Material", [
          CustomTextField(
            controller: rmMniController,
            label: 'M&I (%)',
            icon: Icons.storage_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: rmIvController,
            label: 'IV (%)',
            icon: Icons.scale,
            isNumeric: true,
          ),

          CustomTextField(
            controller: rmColorRController,
            label: 'Colour (R)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: rmColorYController,
            label: 'Colour (Y)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: rmColorWController,
            label: 'Color (W)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: rmColorBController,
            label: 'Color (B)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),
        ]);
        break;
      case 2:
        return _buildSection("Finished Goods", [
          CustomTextField(
            controller: fgFfaController,
            label: 'FFA',
            icon: Icons.bubble_chart,
            isNumeric: true,
          ),

          CustomTextField(
            controller: fgMniController,
            label: 'M&I',
            icon: Icons.storage_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: fgIvController,
            label: 'IV',
            icon: Icons.scale,
            isNumeric: true,
          ),

          CustomTextField(
            controller: fgColorRController,
            label: 'Colour (R)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: fgColorYController,
            label: 'Colour (Y)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: fgColorWController,
            label: 'Color (W)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: fgColorBController,
            label: 'Color (B)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: fgCpController,
            label: 'CP',
            icon: Icons.storage_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: fgClarityController,
            label: 'Clarity',
            icon: Icons.auto_awesome,
            isNumeric: false,
          ),

          Consumer<ValueProvider>(
            builder: (context, provider, child) {
              if (provider.isTankSourceLoading) {
                // Return a disabled dropdown with a loading indicator or message
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
                    hintText: 'Loading Tank Source...',
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
                    hintText: 'Tank Sources tidak ditemukan.',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.warning_amber_rounded),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        context.read<ValueProvider>().fetchTankSourceLists();
                      },
                    ),
                  ),
                );
              }
              return DropdownButtonFormField<String>(
                value: selectedFgToTank,
                isExpanded: true,
                items:
                    provider.tankSourceList.map((tank) {
                      return DropdownMenuItem<String>(
                        value: tank.code,
                        child: Text(tank.code, style: TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() => selectedFgToTank = value);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF0ECE9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Pilih tank source',
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
        ]);
        break;
      case 3:
        return _buildSection("By Product", [
          CustomTextField(
            controller: bpFfaController,
            label: 'FFA',
            icon: Icons.bubble_chart,
            isNumeric: true,
          ),
          CustomTextField(
            controller: bpMniController,
            label: 'M&I',
            icon: Icons.storage_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: bpIvController,
            label: 'IV',
            icon: Icons.scale,
            isNumeric: true,
          ),

          CustomTextField(
            controller: bpPvController,
            label: 'PV',
            icon: Icons.energy_savings_leaf,
            isNumeric: true,
          ),

          CustomTextField(
            controller: bpColorRController,
            label: 'Colour (R)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: bpColorYController,
            label: 'Colour (Y)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: bpColorWController,
            label: 'Color (W)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),

          CustomTextField(
            controller: bpColorBController,
            label: 'Color (B)',
            icon: Icons.color_lens_rounded,
            isNumeric: true,
          ),

          Consumer<ValueProvider>(
            builder: (context, provider, child) {
              if (provider.isTankSourceLoading) {
                // Return a disabled dropdown with a loading indicator or message
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
                    hintText: 'Loading Tank Source...',
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
                    hintText: 'Tank Sources tidak ditemukan.',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.warning_amber_rounded),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        context.read<ValueProvider>().fetchTankSourceLists();
                      },
                    ),
                  ),
                );
              }
              return DropdownButtonFormField<String>(
                value: selectedBpToTank,
                isExpanded: true,
                items:
                    provider.tankSourceList.map((tank) {
                      return DropdownMenuItem<String>(
                        value: tank.code,
                        child: Text(tank.code, style: TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() => selectedBpToTank = value);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF0ECE9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Pilih tank source',
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
        ]);
        break;
      case 4:
        return _buildSection("Remarks", [
          CustomRemarkField(controller: remarkController),
        ]);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _paginationNavigation() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 24.0, // Small spacing between buttons
        runSpacing: 8.0,
        children: [
          // Tombol PREV (lebih kecil)
          ElevatedButton(
            onPressed:
                currentPage > 1
                    ? () {
                      setState(() {
                        currentPage--;
                      });
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF655F5B),
              foregroundColor: Colors.white,
              minimumSize: const Size(32, 32),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 👈 Add this
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Icon(Icons.chevron_left, size: 18),
          ),

          ...List.generate(4, (index) {
            int pageNumber = index + 1;
            bool isSelected = pageNumber == currentPage;

            return ElevatedButton(
              onPressed: () {
                setState(() {
                  currentPage = pageNumber;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSelected
                        ? const Color(0xFF655F5B)
                        : const Color(0xFFE0E0E0),
                foregroundColor: isSelected ? Colors.white : Colors.black87,
                minimumSize: const Size(32, 32),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 👈 Add this
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                elevation: isSelected ? 3 : 0,
              ),
              child: Text(
                pageNumber.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            );
          }),

          ElevatedButton(
            onPressed:
                currentPage < 4
                    ? () {
                      setState(() {
                        currentPage++;
                      });
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF655F5B),
              foregroundColor: Colors.white,
              minimumSize: const Size(32, 32),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Icon(Icons.chevron_right, size: 18),
          ),
        ],
      ),
    );
  }

  Future<bool> _insertDailyQualityCompositeFractionationReport() async {
    final plant = context.read<PlantProvider>().currentPlant;
    final user = context.read<UserProvider>();
    final id = await context
        .read<DailyQualityCompositeFractionationProvider>()
        .generateId(plant?.code ?? "");
    final businessUnit =
        context.read<BusinessUnitProvider>().currentBusinessUnit;

    try {
      final report = DailyQualityCompositeFractionationEntity(
        id: id,
        transactionDate: DateTime.now(),
        time:
            selectedHour != null
                ? TimeOfDay(hour: selectedHour!, minute: 0)
                : null,
        crystalizer: selectedTankSource,
        workCenter: selectedWorkCenter,
        rmMni: parseDouble(rmMniController.text),
        rmIv: parseDouble(rmIvController.text),
        rmColorR: parseDouble(rmColorRController.text),
        rmColorY: parseDouble(rmColorYController.text),
        rmColorW: parseDouble(rmColorWController.text),
        rmColorB: parseDouble(rmColorBController.text),
        fgFfa: parseDouble(fgFfaController.text),
        fgMni: parseDouble(fgMniController.text),
        fgIv: parseDouble(fgIvController.text),
        fgColorR: parseDouble(fgColorRController.text),
        fgColorY: parseDouble(fgColorYController.text),
        fgColorW: parseDouble(fgColorWController.text),
        fgColorB: parseDouble(fgColorBController.text),
        fgCp: parseDouble(fgCpController.text),
        fgClarity: fgClarityController.text,
        fgToTank: selectedFgToTank,
        bpFfa: parseDouble(bpFfaController.text),
        bpMni: parseDouble(bpMniController.text),
        bpIv: parseDouble(bpIvController.text),
        bpPv: parseDouble(bpPvController.text),
        bpColorR: parseDouble(bpColorRController.text),
        bpColorY: parseDouble(bpColorYController.text),
        bpColorW: parseDouble(bpColorWController.text),
        bpColorB: parseDouble(bpColorBController.text),
        bpToTank: selectedBpToTank,

        remarks: remarkController.text,
        flag: 'T',
        entryBy: user.currentUser?.username ?? '',
        entryDate: DateTime.now(),
        preparedBy: null,
        preparedDate: null,
        preparedStatus: null,
        preparedStatusRemarks: null,
        checkedBy: null,
        checkedDate: null,
        checkedStatus: null,
        checkedStatusRemarks: null,
        updatedBy: null,
        updatedDate: null,
        formNo: formData?.code,
        dateIssued: formData?.dateIssued,
        revisionNo: formData?.revisionNo.toString(),
        revisionDate: formData?.revisionDate,
      );

      final isSuccess = await context
          .read<DailyQualityCompositeFractionationProvider>()
          .insertDailyQualityCompositeFractionationReport(report: report);

      return isSuccess;
    } catch (e) {
      debugPrint("Error inserting Daily Quality Composite Fractionation: $e");
      return false;
    }
  }
}
