import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:logsheet_app/data/remote/maintenance/start_up_produksi_checklist/maintenance_start_up_produksi_checklist_detail_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/start_up_produksi_checklist/maintenance_start_up_produksi_checklist_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/start_up_produksi_checklist/maintenance_start_up_produksi_checklist_report_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/start_up_produksi_checklist/maintenance_start_up_produksi_header_entity.dart';
import 'package:logsheet_app/data/repositories/maintenance/start_up_produksi_checklist_repository/start_up_produksi_checklist_repository.dart';

class MaintenanceStartUpProduksiChecklistProvider with ChangeNotifier {
  final StartUpProduksiChecklistRepository _repository;

  MaintenanceStartUpProduksiChecklistProvider(this._repository);

  // Loading state for fetching
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Loading state for input
  bool _isLoadingInput = false;
  bool get isLoadingInput => _isLoadingInput;

  // Loading state for edit
  bool _isLoadingEdit = false;
  bool get isLoadingEdit => _isLoadingEdit;

  // Loading state for delete
  bool _isLoadingDelete = false;
  bool get isLoadingDelete => _isLoadingDelete;

  // Loading state for approval
  bool _isLoadingApproval = false;
  bool get isLoadingApproval => _isLoadingApproval;

  // Error Message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // List of langkah kerja
  List<MaintenanceStartUpProduksiChecklistEntity> _langkahkerjaList = [];
  List<MaintenanceStartUpProduksiChecklistEntity> get langkahkerjaList =>
      _langkahkerjaList;

  // List of Reports
  List<MaintenanceStartUpProduksiChecklistReportEntity> _reportList = [];
  List<MaintenanceStartUpProduksiChecklistReportEntity> get reportList =>
      _reportList;

  List<MaintenanceStartUpProduksiChecklistReportEntity> _uniqueReportList = [];
  List<MaintenanceStartUpProduksiChecklistReportEntity> get uniqueReportList =>
      _uniqueReportList;

  List<MaintenanceStartUpProduksiChecklistDetailEntity> _reportDetailList = [];
  List<MaintenanceStartUpProduksiChecklistDetailEntity> get reportDetailList =>
      _reportDetailList;

  // List of Reports (Approval)
  List<MaintenanceStartUpProduksiChecklistReportEntity> _approvalList = [];
  List<MaintenanceStartUpProduksiChecklistReportEntity> get approvalList =>
      _approvalList;

  List<MaintenanceStartUpProduksiChecklistReportEntity> _uniqueApprovalList =
      [];
  List<MaintenanceStartUpProduksiChecklistReportEntity>
  get uniqueApprovalList => _uniqueApprovalList;

  String? _latestId;
  String? get latestId => _latestId;

  List<MaintenanceStartUpProduksiChecklistEntity>
  _langkahKerjaPreTreatmentList = [];
  List<MaintenanceStartUpProduksiChecklistEntity>
  get langkahKerjaPreTreatmentList => _langkahKerjaPreTreatmentList;

  List<MaintenanceStartUpProduksiChecklistEntity> _langkahKerjaBleacherList =
      [];
  List<MaintenanceStartUpProduksiChecklistEntity>
  get langkahKerjaBleacherList => _langkahKerjaBleacherList;

  List<MaintenanceStartUpProduksiChecklistEntity>
  _langkahKerjaDeodorizationList = [];
  List<MaintenanceStartUpProduksiChecklistEntity>
  get langkahKerjaDeodorizationList => _langkahKerjaDeodorizationList;

  List<MaintenanceStartUpProduksiChecklistEntity>
  _langkahKerjaFractionationList = [];
  List<MaintenanceStartUpProduksiChecklistEntity>
  get langkahKerjaFractionationList => _langkahKerjaFractionationList;

  // functions for changing loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setLoadingInput(bool value) {
    _isLoadingInput = value;
    notifyListeners();
  }

  void _setLoadingEdit(bool value) {
    _isLoadingEdit = value;
    notifyListeners();
  }

  void _setLoadingDelete(bool value) {
    _isLoadingDelete = value;
    notifyListeners();
  }

  void _setLoadingApproval(bool value) {
    _isLoadingApproval = value;
    notifyListeners();
  }

  // Set Error Message
  void _setErrorMessage(String? value) {
    // _setErrorMessage(value);
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> getLangkahKerja() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _langkahkerjaList = await _repository.getLangkahKerja();

      _langkahKerjaPreTreatmentList =
          _langkahkerjaList
              .where(
                (element) =>
                    element.category == 'Pre Treatment Section' &&
                    element.workCenter == 'Refinery',
              )
              .toList()
            ..sort((a, b) => (a.sortNo ?? 0).compareTo(b.sortNo ?? 0));

      _langkahKerjaBleacherList =
          _langkahkerjaList
              .where(
                (element) =>
                    element.category == 'Bleacher Section' &&
                    element.workCenter == 'Refinery',
              )
              .toList()
            ..sort((a, b) => (a.sortNo ?? 0).compareTo(b.sortNo ?? 0));

      _langkahKerjaDeodorizationList =
          _langkahkerjaList
              .where(
                (element) =>
                    element.category == 'Deodorization Section' &&
                    element.workCenter == 'Refinery',
              )
              .toList()
            ..sort((a, b) => (a.sortNo ?? 0).compareTo(b.sortNo ?? 0));

      _langkahKerjaFractionationList =
          _langkahkerjaList
              .where(
                (element) =>
                    element.category == 'Fractionation Section' &&
                    element.workCenter == 'Fractionation',
              )
              .toList()
            ..sort((a, b) => (a.sortNo ?? 0).compareTo(b.sortNo ?? 0));

      log('List Length: ${_langkahkerjaList.length}');

      notifyListeners();

      log('List Length: ${_langkahkerjaList.length}');
    } catch (e) {
      _setErrorMessage("$e");
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> fetchLatestId(String plantCode) async {
    _setLoading(false);
    _setErrorMessage(null);
    try {
      _latestId = await _repository.getLatestId(plantCode);
      log("latest ID = $_latestId");
      return _latestId;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to get latest id: $e');
      return null;
    }
  }

  Future<void> getAllReportsFromDate(String date, String role) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _reportList.clear();
      _reportList = await _repository.getAllReportsFromDate(date, role);

      final uniqueData =
          <String, MaintenanceStartUpProduksiChecklistReportEntity>{};

      for (var item in _reportList) {
        if (!uniqueData.containsKey(item.id) && item.flag == 'T') {
          uniqueData[item.id] = item;
        }
      }

      _uniqueReportList = uniqueData.values.toList();

      notifyListeners();
      log('Unique Header Count: ${_reportList.length}');
      log('Report List Length: ${_uniqueReportList.length}');
    } catch (e) {
      _setErrorMessage("$e");
    } finally {
      _setLoading(false);
    }
  }

  void updateChecklistStatus(String checkItemCode, String newStatus) {
    final index = _reportDetailList.indexWhere(
      (item) => item.checkItem == checkItemCode,
    );

    if (index != -1) {
      _reportDetailList[index] =
          MaintenanceStartUpProduksiChecklistDetailEntity(
            id: _reportDetailList[index].id,
            idHdr: _reportDetailList[index].idHdr,
            checkItem: _reportDetailList[index].checkItem,
            statusItem: newStatus,
          );
    }
    notifyListeners();
  }

  Future<bool> insertStartUpProduksiChecklist({
    required MaintenanceStartUpProduksiHeaderEntity header,
    required List<MaintenanceStartUpProduksiChecklistDetailEntity> details,
  }) async {
    _setLoadingInput(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.insertReportsChecklist(
        header: header,
        details: details,
      );

      if (result) {
        _setLoadingInput(false);
        return true;
      } else {
        _setErrorMessage('Failed to insert Change Product Checklist.');
        _setLoadingInput(false);
        return false;
      }
    } catch (e) {
      _setErrorMessage('$e');
      _setLoadingInput(false);
      return false;
    }
  }

  Future<void> prepopulateReportDetailList() async {
    _reportDetailList.clear();

    // Safety check in case _latestId is null
    if (_latestId == null || _latestId!.isEmpty) {
      log("Error: _latestId is null or empty in prepopulateReportDetailList");
      _setErrorMessage("Cannot generate detail list: Latest ID is missing.");
      notifyListeners();
      return;
    }

    final idLatest =
        _latestId!.length > 9 ? _latestId!.substring(0, 9) : _latestId!;

    final idDetailBase = "${idLatest.substring(0, 3)}D${idLatest.substring(3)}";

    for (var i = 0; i < _langkahkerjaList.length; i++) {
      final langkahKerja = _langkahkerjaList[i];

      final detailId = "$idDetailBase${(i + 1).toString().padLeft(6, '0')}";

      final detailItem = MaintenanceStartUpProduksiChecklistDetailEntity(
        id: detailId,
        idHdr: "",
        checkItem: langkahKerja.code,
        statusItem: 'F',
      );

      _reportDetailList.add(detailItem);
    }
    notifyListeners();
    return;
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final result = await _repository.updateAutoNumber(
        plantCode,
        newAutoNumber,
      );
      return result;
    } catch (e) {
      _setErrorMessage('Failed to update autonumber: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<String> generateHeaderId(String plantCode) async {
    if (_latestId == null || _latestId!.isEmpty) {
      log("⚠️ _latestId is null or empty in _generateHeaderId");
      return '';
    }

    final latest = _latestId!;
    log("🧩 Latest ID: $latest");

    // Pisahkan bagian depan (prefix + plantid + accountingyear) dan autonumber
    final prefixPart = latest.length > 9 ? latest.substring(0, 9) : latest;
    final autoPart = latest.length > 9 ? latest.substring(9) : "";

    // Konversi autonumber ke int dan tambah 1
    int newAuto = 1; // default kalau autoPart kosong atau gagal parsing
    if (autoPart.isNotEmpty) {
      try {
        newAuto = int.parse(autoPart) + 1;
      } catch (e) {
        log("⚠️ Gagal parsing autonumber: $e");
      }
    }

    // Pad autonumber agar tetap memiliki panjang sama (mis. 6 digit)
    // final newAutoStr = newAuto.toString().padLeft(autoPart.length, '0');
    final newAutoStr = newAuto.toString().padLeft(6, '0');

    // Gabungkan lagi jadi ID baru
    final newId = "$prefixPart$newAutoStr";

    log("✅ Generated new ID: $newId");

    await updateAutoNumber(plantCode, newAuto);

    return newId;
  }

  Future<void> clearUniqueReportList() async {
    _setLoading(true);
    _uniqueReportList.clear();
    notifyListeners();
    _setLoading(false);
  }

  void prepopulateReportDetailListForDetail(String idHdr) {
    _setLoading(true);
    _reportDetailList.clear();

    final _selectedReportList =
        _reportList.where((report) => report.id == idHdr).toList();

    for (var reportItem in _selectedReportList) {
      final detailItem = MaintenanceStartUpProduksiChecklistDetailEntity(
        id: reportItem.detailId,
        idHdr: idHdr,
        checkItem: reportItem.checkItem,
        statusItem: reportItem.statusItem,
      );
      _reportDetailList.add(detailItem);
    }
    _setLoading(false);
    notifyListeners();
  }

  Future<bool> deleteStartUpProduksiChecklist(String id) async {
    _setLoadingDelete(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.deleteReportChecklist(id);

      if (result) {
        _setLoadingDelete(false);
        return true;
      } else {
        _setErrorMessage('Failed to delete Change Product Checklist.');
        _setLoadingDelete(false);
        return false;
      }
    } catch (e) {
      _setErrorMessage('$e');
      return false;
    } finally {
      _setLoadingDelete(false);
    }
  }

  Future<bool> updateStartUpProduksiChecklist({
    required String id,
    required String company,
    required String plant,
    required String workCenter,
    required DateTime checkDate,
    required String remarks,
    required String updatedBy,
    required DateTime updatedAt,
    required List<MaintenanceStartUpProduksiChecklistDetailEntity> details,
  }) async {
    _setLoadingEdit(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.updateReportChecklist(
        id: id,
        company: company,
        plant: plant,
        workCenter: workCenter,
        checkDate: checkDate,
        remarks: remarks,
        updatedBy: updatedBy,
        updatedAt: updatedAt,
        details: details,
      );

      if (result) {
        _setLoadingEdit(false);
        return true;
      } else {
        _setErrorMessage('Failed to update Change Product Checklist.');
        _setLoadingEdit(false);
        return false;
      }
    } catch (e) {
      _setErrorMessage('$e');
      _setLoadingEdit(false);
      return false;
    }
  }

  Future<bool> updateApproveRejectToHeader({
    required String id,
    required String approvedBy,
    required String status,
    required String role,
    String? remarks,
  }) async {
    _setLoadingApproval(true);
    _setErrorMessage(null);
    try {
      final result = await _repository.updateApproveRejectToHeader(
        id: id,
        approvedBy: approvedBy,
        status: status,
        role: role,
        remarks: remarks,
      );

      if (result) {
        _setLoadingApproval(false);
        return true;
      } else {
        _setErrorMessage('Failed to update approval status.');
        _setLoadingApproval(false);
        return false;
      }
    } catch (e) {
      _setErrorMessage('$e');
      _setLoadingApproval(false);
      return false;
    }
  }


  Future<void> getAllApprovalHeaderAndDetail() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _approvalList.clear();
      _approvalList = await _repository.getAllApprovalHeaderAndDetail();

      final uniqueData =
          <String, MaintenanceStartUpProduksiChecklistReportEntity>{};

      for (var item in _approvalList) {
        if (!uniqueData.containsKey(item.id)) {
          uniqueData[item.id] = item;
        }
      }
      _uniqueApprovalList = uniqueData.values.toList();
      notifyListeners();

      log('Approval List Length: ${_approvalList.length}');
    } catch (e) {
      _setErrorMessage("$e");
    } finally {
      _setLoading(false);
    }
  }
}
