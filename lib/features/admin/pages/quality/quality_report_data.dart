import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_detail.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_edit.dart';
import 'package:logsheet_app/features/admin/widgets/custom_filter_dropdown_chip.dart';
import 'package:logsheet_app/features/admin/widgets/quality_report_item_card.dart';
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
  final TextEditingController timeController = TextEditingController();

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
                // Filter Chips
                _filterChips(),
                // const SizedBox(height: 8),

                //Build Report Content
                _buildReportContent(),

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

  Widget _filterChips() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomFilterDropdownChip(
                  label: 'Filter',
                  options: ['List 1', 'List 2', 'List 3'],
                  chipIcon: Icons.calendar_today,
                  controller: dateController,
                  isCalendar: true,
                  onSelected: (value) {},
                ),
                const SizedBox(width: 8),
                CustomFilterDropdownChip(
                  label: 'Pilih Tanggal',
                  options: const [],
                  chipIcon: Icons.calendar_today,
                  controller: dateController,
                  isCalendar: true,
                  selectedOption:
                      _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : null,
                  onSelected: (_) {
                    _pickDate(context);
                  },
                ),
                const SizedBox(width: 8),
                CustomFilterDropdownChip(
                  label: 'Pilih Waktu',
                  options: _hours,
                  chipIcon: Icons.alarm,
                  controller: timeController,
                  isCalendar: false,
                  selectedOption: _selectedHour,
                  onSelected: (selectedValue) {
                    setState(() {
                      (_selectedHour == 'All')
                          ? null
                          : _selectedHour = selectedValue;
                      // _selectedHour = selectedValue;
                      _filterData();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportContent() {
    return Expanded(
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
                                color: Color(0xFF655F5B), // Neutral Gray
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: allData.length,
                            itemBuilder: (context, index) {
                              final report = allData[index];
                              return QualityReportItemCard(
                                report: report,
                                index: index,
                                onTap: () => _onTapRow(report),
                                onEdit: () => _editData(report),
                                onDelete: () => _deleteData(allData[index].id),
                              );
                            },
                          ),
                ),
              ),
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
