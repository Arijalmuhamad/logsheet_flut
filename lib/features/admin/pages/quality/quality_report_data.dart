import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_detail.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_refinery_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class QualityListPage extends StatefulWidget {
  final String userName;
  final String role;

  const QualityListPage({
    super.key,
    required this.userName,
    required this.role,
  });

  @override
  State<QualityListPage> createState() => _QualityListPageState();
}

class _QualityListPageState extends State<QualityListPage> {
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  String? _tempSelectedShift;
  final List<String> shifts = ["1", "2", "3"];

  final List<String> _hours = List.generate(
    24,
    (index) => '${index.toString().padLeft(2, '0')}:00',
  );

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    final user = context.read<UserProvider>().currentUser;
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await context.read<ValueProvider>().fetchOilTypes(),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<QualityReportRefineryProvider>().fetchAllReports(
        null,
        null,
        user?.username ?? "",
        user?.role ?? "",
        plantCode,
        filter: false,
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();

    super.dispose();
  }

  // void _fetchReports() {
  //   Provider.of<QualityReportRefineryProvider>(
  //     context,
  //     listen: false,
  //   ).fetchAllReports(null, null, widget.userName, widget.role);
  // }

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

  Future<void> _deleteData(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Konfirmasi Hapus',
              style: TextStyle(
                color: Color(0xFF655F5B),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Apakah Anda yakin ingin menghapus data ini?',
              style: TextStyle(color: Color(0xFF655F5B)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: TextButton.styleFrom(foregroundColor: Colors.black87),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAB2F2B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      // Assuming you have a delete method in your provider
      // await Provider.of<QualityReportRefineryProvider>(context, listen: false).delete(id);
      _showSnackbar('🗑️ Data berhasil dihapus');
      // _fetchReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
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
                  child: Consumer<QualityReportRefineryProvider>(
                    builder: (context, provider, child) {
                      List<QualityReportRefineryEntity> filteredReports =
                          provider.reportsList;

                      if (_selectedDate != null) {
                        filteredReports =
                            filteredReports.where((report) {
                              // This ensures we only compare the Year, Month, and Day, ignoring the time.
                              return report.transactionDate?.year ==
                                      _selectedDate!.year &&
                                  report.transactionDate?.month ==
                                      _selectedDate!.month &&
                                  report.transactionDate?.day ==
                                      _selectedDate!.day;
                            }).toList();
                      }

                      // 3. Apply the hour filter if an hour is selected.
                      if (_tempSelectedShift != null) {
                        // We parse the selected hour string "HH:00" to get the hour as an integer.
                        final selectedShift = int.tryParse(_tempSelectedShift!);
                        if (selectedShift != null) {
                          filteredReports =
                              filteredReports.where((report) {
                                return report.shift == selectedShift;
                              }).toList();
                        }
                      }

                      if (filteredReports.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("No data."),
                              OutlinedButton(
                                onPressed: () {
                                  final plantCode =
                                      Provider.of<PlantProvider>(
                                        context,
                                        listen: false,
                                      ).currentPlant?.code ??
                                      "";

                                  Provider.of<QualityReportRefineryProvider>(
                                    context,
                                    listen: false,
                                  ).fetchAllPreparedTransactions(plantCode);
                                },
                                child: const Text("Refresh"),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 12),
                        itemCount: filteredReports.length,
                        itemBuilder: (context, index) {
                          final report = filteredReports[index];
                          return Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => QualityDetailPage(
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
                value: null,
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
          onPressed: () {
            setState(() {
              // _fetchReports();
            });
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: const Text(
        'Quality Report List (F/QCO-002)',
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

  String _getStatusText(QualityReportRefineryEntity report) {
    if (report.checkedStatus == "Approved") {
      return "Approved";
    }

    if (report.checkedStatus == "Rejected") {
      return "Rejected";
    }
    if (report.preparedStatusShift1 == "Approved" ||
        report.preparedStatusShift2 == "Approved" ||
        report.preparedStatusShift3 == "Approved") {
      return "Prepared ${report.shift}";
    }

    if (report.preparedStatusShift1 == "Rejected" ||
        report.preparedStatusShift2 == "Rejected" ||
        report.preparedStatusShift3 == "Rejected") {
      return "Rejected";
    }
    return "Submitted";
  }

  Color _getStatusColor(QualityReportRefineryEntity report) {
    if (report.checkedStatus == "Approved") {
      return Colors.green;
    }

    if (report.checkedStatus == "Rejected") {
      return Colors.red;
    }

    if (report.preparedStatusShift1 == "Approved" ||
        report.preparedStatusShift2 == "Approved" ||
        report.preparedStatusShift3 == "Approved") {
      return Colors.orangeAccent;
    }

    if (report.preparedStatusShift1 == "Rejected" ||
        report.preparedStatusShift2 == "Rejected" ||
        report.preparedStatusShift3 == "Rejected") {
      return Colors.red;
    }
    return Colors.grey;
  }
}

extension QualityReportRefineryEntityExtension on QualityReportRefineryEntity {
  String get shift {
    if (time == null) return '-';
    final hour = time!.hour;
    if (hour >= 7 && hour < 15) return '1';
    if (hour >= 15 && hour < 23) return '2';
    return '3';
  }
}
