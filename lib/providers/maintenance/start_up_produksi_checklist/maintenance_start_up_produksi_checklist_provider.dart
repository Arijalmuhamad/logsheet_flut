import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:logsheet_app/data/remote/maintenance/start_up_produksi_checklist/maintenance_start_up_produksi_checklist_detail_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/start_up_produksi_checklist/maintenance_start_up_produksi_checklist_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/start_up_produksi_checklist/maintenance_start_up_produksi_checklist_report_entity.dart';
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
}
