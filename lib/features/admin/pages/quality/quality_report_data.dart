import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_detail.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_edit.dart';
import 'package:logsheet_app/providers/quality_report_refinery_provider.dart';
import 'package:provider/provider.dart';

class QualityListPage extends StatefulWidget {
  final String userName;

  const QualityListPage({super.key, required this.userName});

  @override
  State<QualityListPage> createState() => _QualityListPageState();
}

class _QualityListPageState extends State<QualityListPage> {
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedHour;
  String? _tempSelectedHour;

  List<QualityReportRefineryEntity> _filteredData = [];

  bool _isLoading = false;
  bool _isInitialLoading = true;

  final List<String> _hours = List.generate(
    24,
    (index) => '${index.toString().padLeft(2, '0')}:00',
  );

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReports();
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _fetchReports() {
    Provider.of<QualityReportRefineryProvider>(
      context,
      listen: false,
    ).fetchAllReports(null, null);
  }

  // void _filterData(List<QualityReportRefineryEntity> allReports) {
  //   setState(() {
  //     _filteredData =
  //         allReports.where((item) {
  //           final itemHour =
  //               item.time != null
  //                   ? DateFormat('HH:mm').format(item.time!)
  //                   : null;

  //           final matchHour =
  //               (_selectedHour == null || _selectedHour == 'all')
  //                   ? true
  //                   : itemHour == _selectedHour;

  //           final matchDate =
  //               _selectedDate == null ||
  //               DateFormat(
  //                     'yyyy-MM-dd',
  //                   ).format(item.entryDate ?? DateTime.now()) ==
  //                   DateFormat('yyyy-MM-dd').format(_selectedDate!);

  //           return matchHour && matchDate;
  //         }).toList();
  //   });
  // }

  void _resetFormAndRefresh() {
    setState(() {
      _dateController.clear();
      _selectedDate = DateTime.now();
      _selectedHour = null;
      _tempSelectedHour = null;
      _fetchReports();
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
        _fetchReports();
      });
    }
  }

  // Future<void> _editData(QualityReportRefineryEntity item) async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder:
  //           (context) => QualityEditPage(item: item, userName: widget.userName),
  //     ),
  //   );

  //   if (result == true) {
  //     _fetchReports();
  //   }
  // }

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
      _fetchReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: Consumer<QualityReportRefineryProvider>(
        builder: (context, provider, child) {
          _filteredData = provider.reportsList;
          if (_isInitialLoading) {
            // _filterData(provider.reportsList); // Apply initial filter
            _isInitialLoading = false;
          } else {
            // Re-filter data when provider's reportsList changes (e.g., after fetchAllReports)
            // _filterData(provider.reportsList);
          }

          if (provider.isLoading && _isInitialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && !provider.isLoading) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }

          return _buildBody(context);
        },
      ),
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child:
                        _filteredData.isEmpty
                            ? const Center(
                              child: Text(
                                'Tidak ada data',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF655F5B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                            : _buildDataTable(),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: const Center(child: CircularProgressIndicator()),
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
            value: _tempSelectedHour,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0ECE9),
              hintText: "Pilih jam",
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
                value: 'all',
                child: Text('Semua'),
              ),
              ..._hours.map(
                (hour) =>
                    DropdownMenuItem<String?>(value: hour, child: Text(hour)),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _tempSelectedHour = value;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _selectedHour = _tempSelectedHour;
              _fetchReports(); // Fetch reports again with updated filters
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

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 32,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF0ECE9)),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF655F5B),
          ),
          dataTextStyle: const TextStyle(fontSize: 13, color: Colors.black87),
          columns: const [
            DataColumn(label: Center(child: Text('No'))),
            DataColumn(label: Center(child: Text('Tanggal'))),
            DataColumn(label: Center(child: Text('Jam'))),
            DataColumn(label: Center(child: Text('Shift'))),
            DataColumn(label: Center(child: Text('Flowrate'))),
            DataColumn(label: Center(child: Text('FFA'))),
            DataColumn(label: Center(child: Text('IV'))),
            DataColumn(label: Center(child: Text('PV'))),
            DataColumn(label: Center(child: Text('DOBI'))),
            DataColumn(label: Center(child: Text('Carotene'))),
            DataColumn(label: Center(child: Text('Color R'))),
            DataColumn(label: Center(child: Text('Color Y'))),
            DataColumn(label: Center(child: Text('Status'))),
            DataColumn(label: Center(child: Text('Aksi'))),
          ],
          rows: List.generate(_filteredData.length, (index) {
            final item = _filteredData[index];
            final isEven = index % 2 == 0;
            return DataRow(
              color: WidgetStateProperty.all(
                isEven ? Colors.grey.shade100 : Colors.white,
              ),
              cells: [
                DataCell(Center(child: Text('${index + 1}'))),
                DataCell(
                  Center(
                    child: Text(
                      DateFormat(
                        'yyyy-MM-dd',
                      ).format(item.entryDate ?? DateTime.now()),
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      item.time != null
                          ? DateFormat('HH:mm').format(item.time!)
                          : '-',
                    ),
                  ),
                ),
                DataCell(Center(child: Text(item.shift))),
                DataCell(
                  Center(
                    child: Text(item.pFlowRate?.toStringAsFixed(2) ?? '-'),
                  ),
                ),
                DataCell(
                  Center(child: Text(item.pFFA?.toStringAsFixed(2) ?? '-')),
                ),
                DataCell(
                  Center(child: Text(item.pIV?.toStringAsFixed(2) ?? '-')),
                ),
                DataCell(
                  Center(child: Text(item.pPV?.toStringAsFixed(2) ?? '-')),
                ),
                DataCell(
                  Center(child: Text(item.pDobi?.toStringAsFixed(2) ?? '-')),
                ),
                DataCell(
                  Center(
                    child: Text(item.pCarotene?.toStringAsFixed(2) ?? '-'),
                  ),
                ),
                DataCell(Center(child: Text(item.bColorR?.toString() ?? '-'))),
                DataCell(Center(child: Text(item.bColorY?.toString() ?? '-'))),
                DataCell(
                  Center(
                    child: Text(
                      item.flag != 'T' ? 'Not Uploaded' : 'Uploaded',
                      style: TextStyle(
                        color:
                            item.flag != 'T'
                                ? const Color(0xFFAB2F2B)
                                : const Color(0xFF655F5B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: 'Edit',
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF6B7280),
                            ),
                            onPressed: () {
                              // _editData(item);
                            },
                          ),
                        ),
                        Tooltip(
                          message: 'Hapus',
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color(0xFFB91C1C),
                            ),
                            onPressed: () {
                              _deleteData(item.id);
                            },
                          ),
                        ),
                        Tooltip(
                          message: 'Detail',
                          child: IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              color: Color(0xFF655F5B),
                            ),
                            onPressed: () => _onTapRow(item),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: const Text(
        'Quality Data List',
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

  void _onTapRow(QualityReportRefineryEntity item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QualityDetailPage(item: item)),
    );
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
