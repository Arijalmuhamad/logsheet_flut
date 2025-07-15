import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_detail.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_edit.dart';
import '../../../../core/database/app_database.dart';
import '../../../../data/dao/quality_report_refinery_dao.dart';

class QualityListPage extends StatefulWidget {
  final String userName;
  const QualityListPage({super.key, required this.userName});

  @override
  State<QualityListPage> createState() => _QualityListPageState();
}

class _QualityListPageState extends State<QualityListPage> {
  late final AppDatabase db;
  late final QualityReportRefineryDao qualityReportRefDao;

  final TextEditingController dateController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedHour;
  String? _tempSelectedHour;

  List<TQualityReportRefineryData> allData = [];
  List<TQualityReportRefineryData> filteredData = [];

  bool isLoading = false;
  bool isInitialLoading = true;

  final List<String> _hours = List.generate(
    24,
    (index) => '${index.toString().padLeft(2, '0')}:00',
  );

  int _currentPage = 0;
  final int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    qualityReportRefDao = QualityReportRefineryDao(db);
    _selectedDate = DateTime.now();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isInitialLoading = true);
    final data = await qualityReportRefDao.getAllQualityReportsRefinery();
    setState(() {
      allData = data;
      isInitialLoading = false;
    });
    _filterData();
  }

  void _resetForm() {
    dateController.clear();
    _selectedDate = DateTime.now();
    _selectedHour = null;
    _tempSelectedHour = null;
    _filterData();
  }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _resetForm();
    setState(() => isLoading = false);
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

  void _filterData() {
    setState(() {
      filteredData =
          allData.where((item) {
            final itemHour = item.time?.substring(0, 5); // 'HH:mm' format

            final matchHour =
                (_selectedHour == null || _selectedHour == 'all')
                    ? true
                    : itemHour == _selectedHour;

            final matchDate =
                _selectedDate == null ||
                DateFormat('yyyy-MM-dd').format(item.report_date) ==
                    DateFormat('yyyy-MM-dd').format(_selectedDate!);

            return matchHour && matchDate;
          }).toList();

      _currentPage = 0;
    });
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
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        _filterData();
      });
    }
  }

  Future<void> _editData(TQualityReportRefineryData item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QualityEditPage(item: item, userName: widget.userName),
      ),
    );

    if (result == true) {
      _loadData();
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
                  backgroundColor: Color(0xFFAB2F2B),
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
      await qualityReportRefDao.deleteQualityReportRefinery(id);
      await _loadData();
      _showSnackbar('🗑️ Data berhasil dihapus');
    }
  }

  List<TQualityReportRefineryData> get paginatedData {
    int start = _currentPage * _rowsPerPage;
    int end = (start + _rowsPerPage).clamp(0, filteredData.length);
    return filteredData.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (filteredData.length / _rowsPerPage).ceil();

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: AppBar(
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
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshPage),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: dateController,
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

                    // Dropdown Jam
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
                            (hour) => DropdownMenuItem<String?>(
                              value: hour,
                              child: Text(hour),
                            ),
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

                    // Tombol cari Data
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedHour = _tempSelectedHour;
                          _filterData();
                        });
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Cari'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFAB2F2B,
                        ), // tombol utama
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
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child:
                      isInitialLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Card(
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
                                  filteredData.isEmpty
                                      ? const Center(
                                        child: Text(
                                          'Tidak ada data',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(
                                              0xFF655F5B,
                                            ), // Neutral Gray
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                      : SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            columnSpacing: 32,
                                            headingRowColor:
                                                WidgetStateProperty.all(
                                                  Color(0xFFF0ECE9), // Tan
                                                ),
                                            headingTextStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Color(
                                                0xFF655F5B,
                                              ), // Neutral Gray
                                            ),
                                            dataTextStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                            ),
                                            columns: const [
                                              DataColumn(
                                                label: Center(
                                                  child: Text('No'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('Tanggal'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('Jam'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('Shift'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('Flowrate'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('FFA'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('IV'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('PV'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('DOBI'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('Carotene'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('Color R'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('Color Y'),
                                                ),
                                              ),
                                              // Flag
                                              DataColumn(
                                                label: Center(
                                                  child: Text('Status'),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Center(
                                                  child: Text('Aksi'),
                                                ),
                                              ),
                                            ],
                                            rows: List.generate(paginatedData.length, (
                                              index,
                                            ) {
                                              final item = paginatedData[index];
                                              final isEven = index % 2 == 0;
                                              return DataRow(
                                                color: WidgetStateProperty.all(
                                                  isEven
                                                      ? Colors.grey.shade100
                                                      : Colors.white,
                                                ),
                                                cells: [
                                                  DataCell(
                                                    Center(
                                                      child: Text(
                                                        '${_currentPage * _rowsPerPage + index + 1}',
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(item.tanggal),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(
                                                        item.time?.substring(
                                                              0,
                                                              5,
                                                            ) ??
                                                            '-',
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(item.shift),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(
                                                        item.p_flowrate
                                                                ?.toStringAsFixed(
                                                                  2,
                                                                ) ??
                                                            '-',
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(
                                                        item.p_ffa
                                                                ?.toStringAsFixed(
                                                                  2,
                                                                ) ??
                                                            '-',
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(
                                                        item.p_iv
                                                                ?.toStringAsFixed(
                                                                  2,
                                                                ) ??
                                                            '-',
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(
                                                        item.p_pv
                                                                ?.toStringAsFixed(
                                                                  2,
                                                                ) ??
                                                            '-',
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(
                                                        item.p_dobi
                                                                ?.toStringAsFixed(
                                                                  2,
                                                                ) ??
                                                            '-',
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(
                                                        item.p_carotene
                                                                ?.toStringAsFixed(
                                                                  2,
                                                                ) ??
                                                            '-',
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(
                                                        item.b_color_r
                                                                ?.toString() ??
                                                            '-',
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(
                                                        item.b_color_y
                                                                ?.toString() ??
                                                            '-',
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Text(
                                                        item.flag == 'T'
                                                            ? 'Not Uploaded'
                                                            : 'Uploaded',
                                                        style: TextStyle(
                                                          color:
                                                              item.flag == 'T'
                                                                  ? Color(
                                                                    0xFFAB2F2B,
                                                                  ) // Brick Red
                                                                  : Color(
                                                                    0xFF655F5B,
                                                                  ), // Neutral Gray
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Tooltip(
                                                            message: 'Edit',
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons.edit,
                                                                color: Color(
                                                                  0xFF6B7280,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                _editData(item);
                                                              },
                                                            ),
                                                          ),
                                                          Tooltip(
                                                            message: 'Hapus',
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color: Color(
                                                                  0xFFB91C1C,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                _deleteData(
                                                                  item.id,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          Tooltip(
                                                            message: 'Detail',
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .info_outline,
                                                                color: Color(
                                                                  0xFF655F5B,
                                                                ), // Neutral Gray
                                                              ),
                                                              onPressed:
                                                                  () =>
                                                                      _onTapRow(
                                                                        item,
                                                                      ),
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
                                      ),
                            ),
                          ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Page ${_currentPage + 1} of $totalPages',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF655F5B), // Warna teks utama kamu
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed:
                            _currentPage > 0
                                ? () => setState(() => _currentPage--)
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFAB2F2B,
                          ), // Tombol utama kamu
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          elevation: 2,
                        ),
                        child: const Icon(Icons.arrow_back_ios, size: 16),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed:
                            _currentPage < totalPages - 1
                                ? () => setState(() => _currentPage++)
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFAB2F2B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          elevation: 2,
                        ),
                        child: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  void _onTapRow(TQualityReportRefineryData item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QualityDetailPage(item: item)),
    );
  }
}

extension QualityDataExtension on TQualityReportRefineryData {
  String get shift {
    final hourStr = time?.split(":").first;
    final hour = int.tryParse(hourStr ?? '');
    if (hour == null) return '-';
    if (hour >= 7 && hour < 15) return '1';
    if (hour >= 15 && hour < 23) return '2';
    return '3';
  }

  String get tanggal => DateFormat('yyyy-MM-dd').format(report_date);
}
