import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/logsheet/pretreatment_bleaching_filtration_entity.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/pretreatment_bleaching_filtration/pretreatment_bleaching_filtration_detail_page.dart';
import 'package:logsheet_app/providers/logsheet/pretreatment_bleaching_filtration_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:provider/provider.dart';

class LogsheetPretreatmentBleachingFiltrationReportListsPage
    extends StatefulWidget {
  const LogsheetPretreatmentBleachingFiltrationReportListsPage({
    super.key,
    required this.userName,
    required this.role,
  });

  final String userName;
  final String role;

  @override
  State<LogsheetPretreatmentBleachingFiltrationReportListsPage> createState() =>
      _LogsheetPretreatmentBleachingFiltrationReportListsPageState();
}

class _LogsheetPretreatmentBleachingFiltrationReportListsPageState
    extends State<LogsheetPretreatmentBleachingFiltrationReportListsPage> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  String? _tempSelectedShift = "All";
  final List<String> shifts = ["1", "2", "3", "4", "5"];

  DataFormNoEntity? formData;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async => await context
          .read<PretreatmentBleachingFiltrationProvider>()
          .fetchFilteredTickets(_selectedDate, plantCode, _tempSelectedShift),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _resetFormAndRefresh() {
    setState(() {
      _dateController.clear();
      _selectedDate = DateTime.now();
      _tempSelectedShift = null;
      // _fetchReports();
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 3),
      ),
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

  // Future<void> _deleteData(String id) async {
  //   final confirm = await showDialog<bool>(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //           backgroundColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           title: const Text(
  //             'Konfirmasi Hapus',
  //             style: TextStyle(
  //               color: Color(0xFF655F5B),
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           content: const Text(
  //             'Apakah Anda yakin ingin menghapus data ini?',
  //             style: TextStyle(color: Color(0xFF655F5B)),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, false),
  //               style: TextButton.styleFrom(foregroundColor: Colors.black87),
  //               child: const Text('Batal'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () => Navigator.pop(context, true),
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color(0xFFAB2F2B),
  //                 foregroundColor: Colors.white,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //               ),
  //               child: const Text('Hapus'),
  //             ),
  //           ],
  //         ),
  //   );

  //   if (confirm == true) {
  //     // Assuming you have a delete method in your provider
  //     // await Provider.of<QualityReportRefineryProvider>(context, listen: false).delete(id);
  //     _showSnackbar('🗑️ Data berhasil dihapus');
  //     // _fetchReports();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Logsheet_Pretreatment_Bleaching_Filtration",
            )
            .first;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: Text(
        'PBE List (${formData!.code})',
        style: TextStyle(
          color: Color(0xFF655F5B),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _resetFormAndRefresh,
        ),
      ],
    );
  }

  Stack _buildBody(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildFilterSection(context),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  margin: const EdgeInsets.only(top: 16),
                  child: Consumer<PretreatmentBleachingFiltrationProvider>(
                    builder: (context, provider, child) {
                      // List<PretreatmentBleachingFiltrationEntity>
                      // filteredTickets = provider.filteredTickets;

                      // if (_selectedDate != null) {
                      //   filteredTickets =
                      //       filteredTickets.where((ticket) {
                      //         return ticket.transactionDate?.year ==
                      //                 _selectedDate!.year &&
                      //             ticket.transactionDate?.month ==
                      //                 _selectedDate!.month &&
                      //             ticket.transactionDate?.day ==
                      //                 _selectedDate!.day;
                      //       }).toList();
                      // }
                      // if (_tempSelectedShift != null) {
                      //   // We parse the selected hour string "HH:00" to get the hour as an integer.
                      //   final selectedShift = int.tryParse(_tempSelectedShift!);
                      //   if (selectedShift != null) {
                      //     filteredTickets =
                      //         filteredTickets.where((report) {
                      //           return report.shift == selectedShift;
                      //         }).toList();
                      //   }
                      // }
                      if (provider.filteredTickets.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("No data."),
                              OutlinedButton(
                                onPressed: () async {
                                  final plantCode =
                                      context
                                          .read<PlantProvider>()
                                          .currentPlant
                                          ?.code ??
                                      "";

                                  await context
                                      .read<
                                        PretreatmentBleachingFiltrationProvider
                                      >()
                                      .fetchFilteredTickets(
                                        _selectedDate,
                                        plantCode,
                                        _tempSelectedShift,
                                      );
                                },
                                child: const Text("Refresh"),
                              ),
                            ],
                          ),
                        );
                      }

                      if (provider.isLoadingFilterReport) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 12),
                        itemCount: provider.filteredTickets.length,
                        itemBuilder: (context, index) {
                          final report = provider.filteredTickets[index];
                          return Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            LogsheetPretreatmentBleachingFiltrationDetailPage(
                                              item: report,
                                              isDisplayed: false,
                                            ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 18.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            report.id,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(report),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            _getStatusText(report),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 16),

                                    // Transaction Date and Time
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(report.transactionDate!),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        const Icon(
                                          Icons.schedule,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          DateFormat(
                                            'HH:mm',
                                          ).format(report.time!),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        const Icon(
                                          Icons.timelapse,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Shift ${report.shift}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Entered By
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Entried by: ${report.entryBy}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
        Expanded(
          child: DropdownButtonFormField<String?>(
            isExpanded: true,
            value: _tempSelectedShift,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0ECE9),
              hintText: "Pilih Shift",
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.access_time),
            ),
            items: [
              const DropdownMenuItem<String?>(
                value: "All",
                child: Text('Semua'),
              ),
              ...shifts.map(
                (shift) => DropdownMenuItem<String?>(
                  value: shift,
                  child: Text(" $shift"),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _tempSelectedShift = value;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () async {
            final plantCode =
                context.read<PlantProvider>().currentPlant?.code ?? "";

            await context
                .read<PretreatmentBleachingFiltrationProvider>()
                .fetchFilteredTickets(
                  _selectedDate,
                  plantCode,
                  _tempSelectedShift,
                );
          },
          icon: const Icon(Icons.search),
          label: const Text('Cari'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFAB2F2B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusText(PretreatmentBleachingFiltrationEntity report) {
    if (report.checkedStatus == "Approved") {
      return "Approved";
    }

    if (report.checkedStatus == "Rejected") {
      return "Rejected";
    }
    if (report.preparedStatus == "Approved") {
      return "Prepared ${report.shift}";
    }

    if (report.preparedStatus == "Rejected") {
      return "Rejected";
    }
    return "Submitted";
  }

  Color _getStatusColor(PretreatmentBleachingFiltrationEntity report) {
    if (report.checkedStatus == "Approved") {
      return Colors.green;
    }

    if (report.checkedStatus == "Rejected") {
      return Colors.red;
    }

    if (report.preparedStatus == "Approved") {
      return Colors.orangeAccent;
    }

    if (report.preparedStatus == "Rejected") {
      return Colors.red;
    }
    return Colors.grey;
  }
}
