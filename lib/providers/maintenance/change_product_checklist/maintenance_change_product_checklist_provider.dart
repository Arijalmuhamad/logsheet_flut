import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_detail_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/maintenance_change_product_checklist_report_entity.dart';
import 'package:logsheet_app/data/repositories/maintenance/change_product_checklist_repository/change_product_checklist_repository.dart';

class ChangeProductChecklistProvider with ChangeNotifier {
  final ChangeProductChecklistRepository _repository;

  ChangeProductChecklistProvider(this._repository);

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
  List<MaintenanceChangeProductChecklistEntity> _langkahkerjaList = [];
  List<MaintenanceChangeProductChecklistEntity> get langkahkerjaList =>
      _langkahkerjaList;

  // List of Reports
  List<MaintenanceChangeProductChecklistReportEntity> _reportList = [];
  List<MaintenanceChangeProductChecklistReportEntity> get reportList =>
      _reportList;

  // List of Reports (Approval)
  List<MaintenanceChangeProductChecklistReportEntity> _approvalList = [];
  List<MaintenanceChangeProductChecklistReportEntity> get approvalList =>
      _approvalList;

  String? _latestId;
  String? get latestId => _latestId;

  List<MaintenanceChangeProductChecklistEntity> _langkahKerjaPreTreatmentList =
      [];
  List<MaintenanceChangeProductChecklistEntity>
  get langkahKerjaPreTreatmentList => _langkahKerjaPreTreatmentList;

  List<MaintenanceChangeProductChecklistEntity> _langkahKerjaBleacherList = [];
  List<MaintenanceChangeProductChecklistEntity> get langkahKerjaBleacherList =>
      _langkahKerjaBleacherList;

  List<MaintenanceChangeProductChecklistEntity> _langkahKerjaDeodorizationList =
      [];
  List<MaintenanceChangeProductChecklistEntity>
  get langkahKerjaDeodorizationList => _langkahKerjaDeodorizationList;

  List<MaintenanceChangeProductChecklistEntity> _langkahKerjaFractionationList =
      [];
  List<MaintenanceChangeProductChecklistEntity>
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

  Future<void> getAllChangeProductFromDate(String date) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _reportList = await _repository.getAllChangeProductFromDate(date);
      notifyListeners();

      log('List Length: ${_reportList.length}');
    } catch (e) {
      _setErrorMessage("$e");
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> insertChangeProductChecklist({
    required header,
    required details,
  }) async {
    _setLoadingInput(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.insertChangeProductChecklist(
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

  Future<bool> deleteChangeProductChecklist(String id) async {
    _setLoadingDelete(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.deleteChangeProductChecklist(id);

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

  Future<bool> updateChangeProductChecklist({
    required String id,
    required String company,
    required String plant,
    required String workCenter,
    required DateTime checkDate,
    required String remarks,
    required List<MaintenanceChangeProductChecklistDetailEntity> details,
  }) async {
    _setLoadingEdit(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.updateChangeProduct(
        id: id,
        company: company,
        plant: plant,
        workCenter: workCenter,
        checkDate: checkDate,
        remarks: remarks,
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

  Future<String?> getLatestId(String plantCode) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _latestId = await _repository.getLatestId(plantCode);
      log("latest ID = $_latestId");
      return _latestId;
    } catch (e) {
      _setErrorMessage('Failed to get latest id: $e');
      return null;
    } finally {
      _setLoading(false);
    }
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

  Future<bool> updateApproveRejectToHeader({
    required String id,
    required String approvedBy,
    required String status,
    required String role,
  }) async {
    _setLoadingApproval(true);
    _setErrorMessage(null);
    try {
      final result = await _repository.updateApproveRejectToHeader(
        id: id,
        approvedBy: approvedBy,
        status: status,
        role: role,
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
      _approvalList = await _repository.getAllApprovalHeaderAndDetail();
      notifyListeners();

      log('Approval List Length: ${_approvalList.length}');
    } catch (e) {
      _setErrorMessage("$e");
    } finally {
      _setLoading(false);
    }
  }
}
