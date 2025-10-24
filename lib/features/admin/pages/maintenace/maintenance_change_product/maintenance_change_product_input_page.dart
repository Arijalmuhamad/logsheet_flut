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

class MaintenanceChangeProductInputPage extends StatefulWidget {

  const MaintenanceChangeProductInputPage({super.key});

  @override
  State<MaintenanceChangeProductInputPage> createState() =>
      _MaintenanceChangeProductInputPageState();
}

class _MaintenanceChangeProductInputPageState
    extends State<MaintenanceChangeProductInputPage> {
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
  final List<String> nextProducts = [];
  final List<String> plants = ['Refinery', 'Fractination'];
  
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ChangeProductChecklistProvider>().getLangkahKerja();
      await context.read<ValueProvider>().fetchWorkCenterLists();
      await context.read<ValueProvider>().fetchWorkCenterFractLists();

      final changeProductChecklistProvider =
          context.read<ChangeProductChecklistProvider>();

      final plant = context.read<PlantProvider>().currentPlant;

      await changeProductChecklistProvider.fetchLatestId(plant?.code ?? "");
      changeProductChecklistProvider.prepopulateReportDetailList();
      // var pertanyaan = changeProductChecklistProvider.reportDetailList;
      await context.read<ProductProvider>().fetchProducts();

      firstProducts = context
          .read<ProductProvider>()
          .productList
          .map((product) => product.rawMaterial ?? '-')
          .toSet()
          .toList();

      nextProducts.addAll(firstProducts);

      form =
          context
              .read<DataFormNoProvider>()
              .dataFormNoList
              .where(
                (form) =>
                    form.isMenu == "Change_Product_Checklist" &&
                    form.isActive == "T",
              )
              .first;
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
      body: Stack(
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
                  onChanged: (value) {
                    setState(() {
                      selectedPlant = value;
                      selectedWorkCenter = null;

                      if (value == 'Refinery') {
                        workCenterList = valueProvider.workCenterLists;
                      } else if (value == 'Fractination') {
                        workCenterList = valueProvider.workCenterFractLists;
                      }

                      debugPrint("Updated workCenterList: $workCenterList");
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedWorkCenter,
                  items:
                      workCenterList.map((workCenter) {
                        return DropdownMenuItem<String>(
                          value: workCenter.code,
                          child: Text(
                            "${workCenter.code} - ${workCenter.name}",
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  onChanged:
                      selectedPlant == null
                          ? null // Disable the dropdown if no location is selected
                          : (value) {
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
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomHourMinuteField(
                          selectedTime:
                              selectedHour != null
                                  ? TimeOfDay(hour: selectedHour!, minute: 0)
                                  : TimeOfDay(hour: 8, minute: 0),
                          onTap: () => _showHourPicker(context),
                          hint: '',
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
                  onChanged:
                      (value) => setState(() => selectedFirstProduct = value),
                ),
                const SizedBox(height: 16),
                CustomDropdown.fromStringItems(
                  hint: 'Pilih Produk Selanjutnya',
                  prefixIcon: PrefixIconHelper.get('factory'),
                  stringItems: nextProducts,
                  value: selectedNextProduct,
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
                            physics: const NeverScrollableScrollPhysics(),
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
                              final detailIndex = changeProductChecklistProvider
                                  .reportDetailList
                                  .indexWhere(
                                    (detail) =>
                                        detail.checkItem == langkah.code,
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
                                  final newStatus = (val ?? false) ? "T" : "F";
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
                            physics: const NeverScrollableScrollPhysics(),
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
                              final detailIndex = changeProductChecklistProvider
                                  .reportDetailList
                                  .indexWhere(
                                    (detail) =>
                                        detail.checkItem == langkah.code,
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
                                  final newStatus = (val ?? false) ? "T" : "F";
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
                            physics: const NeverScrollableScrollPhysics(),
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

                              final detailIndex = changeProductChecklistProvider
                                  .reportDetailList
                                  .indexWhere(
                                    (detail) =>
                                        detail.checkItem == langkah.code,
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
                                  final newStatus = (val ?? false) ? "T" : "F";
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
                            physics: const NeverScrollableScrollPhysics(),
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

                              final detailIndex = changeProductChecklistProvider
                                  .reportDetailList
                                  .indexWhere(
                                    (detail) =>
                                        detail.checkItem == langkah.code,
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
                                  final newStatus = (val ?? false) ? "T" : "F";
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
                            CustomRemarkField(controller: remarkController),
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
                                bool isSuccess = await _insertCheckList();
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
                              label: 'Submit Laporan',
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

  Future<bool> _insertCheckList() async {
    final selectedDate = dateEntryController.text;
    final formattedDate = parseDateFormatFromController(selectedDate);

    final plant = context.read<PlantProvider>().currentPlant;
    final businessUnit =
        context.read<BusinessUnitProvider>().currentBusinessUnit;
    final user = context.read<UserProvider>();

    final idHeader = await context
        .read<ChangeProductChecklistProvider>()
        .generateHeaderId(plant?.code ?? "");

    final header = MaintenanceChangeProductionChecklistHeaderEntity(
      id: idHeader,
      company: businessUnit?.buCode ?? "", //business unit provider
      plant: plant?.code ?? '',
      transactionDate: formattedDate,
      transactionTime:
          selectedHour != null
              ? TimeOfDay(hour: selectedHour!, minute: 0)
              : null,
      firstProduct: selectedFirstProduct ?? '',
      nextProduct: selectedNextProduct ?? '',
      workCenter: selectedWorkCenter ?? '',
      remarks: remarkController.text,
      flag: 'T',
      entryBy: user.currentUser?.username ?? '',
      entryDate: DateTime.now(),
      preparedBy: null, //null mulai dari
      preparedDate: null,
      preparedStatus: null,
      preparedStatusRemarks: null,
      checkedBy: null,
      checkedDate: null,
      checkedStatus: null,
      checkedStatusRemarks: null,
      updatedBy: null,
      updatedDate: null, // sampai sini null
      formNo: form?.code, // fetch di form sampe kebawah
      dateIssued: form?.dateIssued,
      revisionNo: form?.revisionNo.toString(),
      revisionDate: form?.revisionDate,
    );

    context.read<ChangeProductChecklistProvider>().reportDetailList.forEach((
      detail,
    ) {
      detail.idHdr = idHeader;
    });

    final details =
        context.read<ChangeProductChecklistProvider>().reportDetailList;

    var isSuccess = context
        .read<ChangeProductChecklistProvider>()
        .insertChangeProductChecklist(header: header, details: details);
    return isSuccess;
  }
}
