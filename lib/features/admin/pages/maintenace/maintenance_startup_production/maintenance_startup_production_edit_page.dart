import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/prefix_icon_helper.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_report_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_production_checklist_header_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/value_entity.dart';
import 'package:logsheet_app/features/admin/widgets/checklist_item_row.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_dropdown.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_minute_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_remark_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_save_button.dart';
import 'package:logsheet_app/features/admin/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/providers/maintenance/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/product_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class MaintenanceStartupProductionEditPage extends StatefulWidget {
  String id;
  MaintenanceStartupProductionEditPage({super.key, required this.id});

  @override
  State<MaintenanceStartupProductionEditPage> createState() =>
      _MaintenanceStartupProductionEditPageState();
}

class _MaintenanceStartupProductionEditPageState
    extends State<MaintenanceStartupProductionEditPage> {
  bool isLoading = false;

  DataFormNoEntity? form;

  final TextEditingController dateEntryController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  String? selectedFirstProduct;
  String? selectedNextProduct;
  String? selectedPlant;
  String? selectedWorkCenter;
  int? selectedHour;

  List<MasterValueEntity> workCenterList = [];

  List<String> firstProducts = [];
  List<String> nextProducts = [];
  final List<String> plants = ['Refinery', 'Fractination'];

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final changeProductChecklistProvider =
          context.read<ChangeProductChecklistProvider>();
      final valueProvider = context.read<ValueProvider>();
      final productProvider = context.read<ProductProvider>();
      final plant = context.read<PlantProvider>().currentPlant;

      setState(() => isLoading = true);

      try {
        await changeProductChecklistProvider.getLangkahKerja();
        await valueProvider.fetchWorkCenterLists();
        await valueProvider.fetchWorkCenterFractLists();
        await changeProductChecklistProvider.fetchLatestId(plant?.code ?? "");
        await productProvider.fetchProducts();

        final item = changeProductChecklistProvider.uniqueReportList.firstWhere(
          (element) => element.id == widget.id,
        );

        final reportItem = item;
        log("Report Item workCenter: ${reportItem.workCenter}");

        // Tentukan Plant berdasar Work Center
        if (reportItem.workCenter == 'REF-01' ||
            reportItem.workCenter == 'REF-02') {
          selectedPlant = 'Refinery';
          workCenterList = valueProvider.workCenterLists;

          // ambil produk untuk refinery
          var refineryFirstProductsList =
              productProvider.productRefineryList
                  .map((product) => product.rawMaterial ?? '-')
                  .toSet()
                  .toList();
          // var refineryNextProductsList =
          //     productProvider.productRefineryList
          //         .map((product) => product.finishGood ?? '-')
          //         .toSet()
          //         .toList();

          firstProducts = refineryFirstProductsList;
          nextProducts = List.from(firstProducts);
        } else {
          selectedPlant = 'Fractination';
          workCenterList = valueProvider.workCenterFractLists;

          // ambil produk untuk fractination
          var fractionationFirstProductsList =
              productProvider.productFractionationList
                  .map((product) => product.rawMaterial ?? '-')
                  .toSet()
                  .toList();
          // var fractionationNextProductsList =
          //     productProvider.productFractionationList
          //         .map((product) => product.finishGood ?? '-')
          //         .toSet()
          //         .toList();

          firstProducts = fractionationFirstProductsList;
          nextProducts = List.from(firstProducts);
        }

        // isi field berdasarkan data report
        selectedWorkCenter = reportItem.workCenter;
        dateEntryController.text = _formatDateString(
          reportItem.transactionDate ?? '',
        );
        if (reportItem.transactionTime != null &&
            reportItem.transactionTime!.isNotEmpty) {
          final parts = reportItem.transactionTime!.split(':');
          selectedHour = int.tryParse(parts.first);
        } else {
          selectedHour = null;
        }

        selectedFirstProduct = reportItem.firstProduct ?? '';
        selectedNextProduct = reportItem.nextProduct ?? '';
        remarkController.text = reportItem.remarks ?? '';

        form = context.read<DataFormNoProvider>().dataFormNoList.firstWhere(
          (form) =>
              form.isMenu == "Change_Product_Checklist" && form.isActive == "T",
        );

        log("Selected location: $selectedPlant");
        log("Selected workCenter: $selectedWorkCenter");
        log("Selected firstProduct: $selectedFirstProduct");
        log("Selected nextProduct: $selectedNextProduct");
        log("First products length: ${firstProducts.length}");
        log("Next products length: ${nextProducts.length}");
      } catch (e, st) {
        log("Error in _initializePage: $e");
        log(st.toString());
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      // Reset data di sini jika ada
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

  String _formatDateString(String? s) {
    if (s == null || s.isEmpty) return '-';
    final dt = DateTime.tryParse(s);
    if (dt != null) {
      return DateFormat('dd-MM-yyyy').format(dt);
    }
    // If parsing fails, return the original string as a fallback
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final changeProductChecklistProvider =
        context.watch<ChangeProductChecklistProvider>();
    final valueProvider = context.read<ValueProvider>();
    final productProvider = context.read<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Change Product (F/RFA-015)"),
        actions: [
          IconButton(
            onPressed: () async {
              await _refreshPage();
            },
            icon: Icon(Icons.replay_rounded),
          ),
        ],
      ),
      body:
          (isLoading)
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomDropdown.fromStringItems(
                          hint: 'Pilih Plant',
                          prefixIcon: PrefixIconHelper.get('location'),
                          stringItems: plants,
                          value: selectedPlant,
                          isDisabled: true,
                          onChanged: (value) {
                            setState(() {
                              selectedPlant = value;
                              selectedWorkCenter = null;

                              if (value == 'Refinery') {
                                workCenterList = valueProvider.workCenterLists;
                              } else if (value == 'Fractination') {
                                workCenterList =
                                    valueProvider.workCenterFractLists;
                              }

                              debugPrint(
                                "Updated workCenterList: $workCenterList",
                              );
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer<ValueProvider>(
                          builder: (context, provider, child) {
                            if (provider.workCenterLists.isEmpty) {
                              return DropdownButtonFormField<String>(
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
                            } else {
                              if (selectedPlant == "Refinery") {
                                return DropdownButtonFormField(
                                  value: selectedWorkCenter,
                                  items:
                                      provider.workCenterLists.map((machine) {
                                        return DropdownMenuItem<String>(
                                          value: machine.code,
                                          child: Text(
                                            "${machine.code} - ${machine.name}",
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (value) async {
                                    setState(() => selectedWorkCenter = value);
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
                              } else {
                                return DropdownButtonFormField(
                                  value: selectedWorkCenter,
                                  items:
                                      provider.workCenterFractLists.map((
                                        machine,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: machine.code,
                                          child: Text(
                                            "${machine.code} - ${machine.name}",
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (value) async {
                                    setState(() => selectedWorkCenter = value);
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
                              }
                            }
                          },
                        ),

                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CustomDateField(
                                  controller: dateEntryController,
                                  label: 'Tanggal',
                                  icon: Icons.event,
                                  isDisabled: true,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CustomHourMinuteField(
                                  selectedTime:
                                      selectedHour != null
                                          ? TimeOfDay(
                                            hour: selectedHour!,
                                            minute: 0,
                                          )
                                          : TimeOfDay(hour: 8, minute: 0),
                                  onTap: () => _showHourPicker(context),
                                  hint: '',
                                  isDisabled: true,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        CustomDropdown.fromStringItems(
                          hint: 'Pilih Produk Awal',

                          prefixIcon: PrefixIconHelper.get('factory'),
                          stringItems: firstProducts,
                          value: selectedFirstProduct,
                          isDisabled: true,
                          onChanged: (value) {
                            setState(() => selectedFirstProduct = value);
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown.fromStringItems(
                          hint: 'Pilih Produk Selanjutnya',
                          prefixIcon: PrefixIconHelper.get('factory'),
                          stringItems: nextProducts,
                          value: selectedNextProduct,
                          isDisabled: true,
                          onChanged: (value) {
                            setState(() => selectedNextProduct = value);
                          },
                        ),
                        const SizedBox(height: 16),

                        if (selectedPlant == 'Refinery') ...[
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
                                    'Pre-Treatment Section',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        changeProductChecklistProvider
                                            .langkahKerjaPreTreatmentList
                                            .length,
                                    itemBuilder: (context, index) {
                                      final langkah =
                                          changeProductChecklistProvider
                                              .langkahKerjaPreTreatmentList[index];

                                      // cari item yang cocok di reportDetailList berdasarkan checkItem == code
                                      final detailIndex =
                                          changeProductChecklistProvider
                                              .reportDetailList
                                              .indexWhere(
                                                (detail) =>
                                                    detail.checkItem ==
                                                    langkah.code,
                                              );

                                      // ambil status dari reportDetailList (default 'F' kalau belum ada)
                                      final isChecked =
                                          detailIndex != -1
                                              ? changeProductChecklistProvider
                                                      .reportDetailList[detailIndex]
                                                      .statusItem ==
                                                  "T"
                                              : false;

                                      return ChecklistItemRow(
                                        number: index + 1,
                                        description: langkah.name ?? '-',
                                        value: isChecked,
                                        onChanged: (val) {
                                          final newStatus =
                                              (val ?? false) ? "T" : "F";
                                          changeProductChecklistProvider
                                              .updateChecklistStatus(
                                                langkah.code!,
                                                newStatus,
                                              );
                                        },
                                      );
                                    },
                                  ),
                                  Divider(
                                    height: 0.0,
                                    thickness: 1,
                                    endIndent: 0,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 24.0),
                                  Text(
                                    'Bleacher Section',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        changeProductChecklistProvider
                                            .langkahKerjaBleacherList
                                            .length,

                                    itemBuilder: (context, index) {
                                      final langkah =
                                          changeProductChecklistProvider
                                              .langkahKerjaBleacherList[index];
                                      final detailIndex =
                                          changeProductChecklistProvider
                                              .reportDetailList
                                              .indexWhere(
                                                (detail) =>
                                                    detail.checkItem ==
                                                    langkah.code,
                                              );
                                      final isChecked =
                                          detailIndex != -1
                                              ? changeProductChecklistProvider
                                                      .reportDetailList[detailIndex]
                                                      .statusItem ==
                                                  "T"
                                              : false;
                                      return ChecklistItemRow(
                                        number: index + 1,
                                        description: langkah.name ?? '-',
                                        value: isChecked,
                                        onChanged: (val) {
                                          final newStatus =
                                              (val ?? false) ? "T" : "F";
                                          changeProductChecklistProvider
                                              .updateChecklistStatus(
                                                langkah.code!,
                                                newStatus,
                                              );
                                        },
                                      );
                                    },
                                  ),
                                  Divider(
                                    height: 0.0,
                                    thickness: 1,
                                    endIndent: 0,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 24.0),
                                  Text(
                                    'Deodorization Section',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        changeProductChecklistProvider
                                            .langkahKerjaDeodorizationList
                                            .length,
                                    itemBuilder: (context, index) {
                                      final langkah =
                                          changeProductChecklistProvider
                                              .langkahKerjaDeodorizationList[index];

                                      final detailIndex =
                                          changeProductChecklistProvider
                                              .reportDetailList
                                              .indexWhere(
                                                (detail) =>
                                                    detail.checkItem ==
                                                    langkah.code,
                                              );
                                      final isChecked =
                                          detailIndex != -1
                                              ? changeProductChecklistProvider
                                                      .reportDetailList[detailIndex]
                                                      .statusItem ==
                                                  "T"
                                              : false;
                                      return ChecklistItemRow(
                                        number: index + 1,
                                        description: langkah.name ?? '-',
                                        value: isChecked,
                                        onChanged: (val) {
                                          final newStatus =
                                              (val ?? false) ? "T" : "F";
                                          changeProductChecklistProvider
                                              .updateChecklistStatus(
                                                langkah.code!,
                                                newStatus,
                                              );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else if (selectedPlant == 'Fractination') ...[
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
                                    'Fractination Section',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        changeProductChecklistProvider
                                            .langkahKerjaFractionationList
                                            .length,
                                    itemBuilder: (context, index) {
                                      final langkah =
                                          changeProductChecklistProvider
                                              .langkahKerjaFractionationList[index];

                                      final detailIndex =
                                          changeProductChecklistProvider
                                              .reportDetailList
                                              .indexWhere(
                                                (detail) =>
                                                    detail.checkItem ==
                                                    langkah.code,
                                              );
                                      final isChecked =
                                          detailIndex != -1
                                              ? changeProductChecklistProvider
                                                      .reportDetailList[detailIndex]
                                                      .statusItem ==
                                                  "T"
                                              : false;
                                      return ChecklistItemRow(
                                        number: index + 1,
                                        description: langkah.name ?? '-',
                                        value: isChecked,
                                        onChanged: (val) {
                                          final newStatus =
                                              (val ?? false) ? "T" : "F";
                                          changeProductChecklistProvider
                                              .updateChecklistStatus(
                                                langkah.code!,
                                                newStatus,
                                              );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 12),
                          const Center(
                            child: Text(
                              'Silakan pilih part terlebih dahulu',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                        if (selectedPlant != null) ...[
                          // SectionCard(
                          //   title: 'Remark',
                          //   children: [CustomRemarkField(controller: notesController)],
                          // ),
                          // const SizedBox(height: 24),
                          // CustomSaveButton(onPressed: () {}, label: 'Submit Laporan'),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Card(
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
                                      'Remark',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    CustomRemarkField(
                                      controller: remarkController,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child:
                                (context
                                        .watch<ChangeProductChecklistProvider>()
                                        .isLoadingInput)
                                    ? Center(child: CircularProgressIndicator())
                                    : CustomSaveButton(
                                      onPressed: () async {
                                        bool isSuccess =
                                            await _updateChecklist();
                                        if (isSuccess) {
                                          showSnackBar(
                                            "Berhasil menyimpan data checklist",
                                            context,
                                          );
                                          Navigator.of(context).pop();
                                        } else {
                                          showSnackBar(
                                            "Gagal meyimpan data checklist",
                                            context,
                                          );
                                        }
                                      },
                                      label: 'Update Laporan',
                                    ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  DateTime? parseDateFormatFromController(String? selectedDate) {
    if (selectedDate == null || selectedDate.isEmpty) return null;
    try {
      // UI format = "dd-MM-yyyy"
      final inputFormat = DateFormat('dd-MM-yyyy');
      final dateTime = inputFormat.parse(selectedDate);

      // langsung return objek DateTime (bukan String)
      return dateTime;
    } catch (e) {
      log('Date parse error: $e');
      return null;
    }
  }

  Future<bool> _updateChecklist() {
    final businessUnit =
        context.read<BusinessUnitProvider>().currentBusinessUnit;
    final plant = context.read<PlantProvider>().currentPlant;
    final details =
        context.read<ChangeProductChecklistProvider>().reportDetailList;

    final user = context.read<UserProvider>();

    var isSuccess = context
        .read<ChangeProductChecklistProvider>()
        .updateChangeProductChecklist(
          id: widget.id,
          company: businessUnit?.buCode ?? "",
          plant: plant?.code ?? '',
          workCenter: selectedWorkCenter ?? '',
          checkDate: DateTime.now(),
          remarks: remarkController.text,
          updatedBy: user.currentUser?.username ?? '',
          updatedAt: DateTime.now(),
          details: details,
        );
    return isSuccess;
  }
}
