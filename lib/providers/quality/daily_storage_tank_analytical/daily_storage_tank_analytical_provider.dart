import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_from_db_entity.dart';
import 'package:logsheet_app/data/remote/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_to_db_entity.dart';
import 'package:logsheet_app/data/repositories/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_repository.dart';

class DailyStorageTankAnalyticalProvider with ChangeNotifier {
  final DailyStorageTankAnalyticalRepository _repository;

  DailyStorageTankAnalyticalProvider(this._repository);

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

  String? _latestId;
  String? get latestId => _latestId;

  List<DailyStorageTankAnalyticalFromDbEntity> _reportsList = [];
  List<DailyStorageTankAnalyticalFromDbEntity> get reportsList => _reportsList;

  List<DailyStorageTankAnalyticalFromDbEntity> _approvalList = [];
  List<DailyStorageTankAnalyticalFromDbEntity> get approvalList =>
      _approvalList;

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

  Future<bool> insertDailyStorageTankAnalyticalReport({
    required DailyStorageTankAnalyticalToDbEntity report,
  }) async {
    _setLoadingInput(true);

    _setErrorMessage(null);

    try {
      final result = await _repository.insertDailyStorageTankAnalytical(
        report: report,
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

  Future<String?> fetchLatestId(String plantCode) async {
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

  Future<String> generateId(String plantCode) async {
    await fetchLatestId(plantCode);

    if (_latestId == null || _latestId!.isEmpty) {
      log("_latestId is null or empty in _generateHeaderId");
      return '';
    }

    final latest = _latestId!;
    log("Latest ID: $latest");

    // Pisahkan bagian depan (prefix + plantid + accountingyear) dan autonumber
    final prefixPart = latest.length > 9 ? latest.substring(0, 9) : latest;
    final autoPart = latest.length > 9 ? latest.substring(9) : "";

    // Konversi autonumber ke int dan tambah 1
    int newAuto = 1; // default kalau autoPart kosong atau gagal parsing
    if (autoPart.isNotEmpty) {
      try {
        newAuto = int.parse(autoPart) + 1;
      } catch (e) {
        log("Gagal parsing autonumber: $e");
      }
    }

    // Pad autonumber agar tetap memiliki panjang sama (mis. 6 digit)
    // final newAutoStr = newAuto.toString().padLeft(autoPart.length, '0');
    final newAutoStr = newAuto.toString().padLeft(6, '0');

    // Gabungkan lagi jadi ID baru
    final newId = "$prefixPart$newAutoStr";

    log("Generated new ID: $newId");

    await updateAutoNumber(plantCode, newAuto);

    return newId;
  }

  Future<void> getAllDailyStorageTankReport(
    String? dateFilter,
    String? role,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      log('Fetching reports...');
      _reportsList = await _repository.getAllDailyStorageTankReport(
        dateFilter ?? '',
        role ?? '',
      );
      _reportsList = _reportsList.where((item) => item.flag == 'T').toList();

      notifyListeners();

      // await Future.delayed(const Duration(seconds: 1));
      _setLoading(false);
      log('Report List length: ${_reportsList.length}');
    } catch (e) {
      _setErrorMessage('Failed to fetch Quality Reports: $e');
      _setLoading(false);
    }
  }

  Future<bool> deleteDailyStorageTankAnalyticalReport(String id) async {
    _setLoadingDelete(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.deleteDailyStorageTankAnalyticalReport(
        id,
      );

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

  Future<bool> updateDailyStorageTankAnalyticalReport(
    DailyStorageTankAnalyticalToDbEntity report,
    String id,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      log('Updating report...');
      final isSuccess = await _repository
          .updatedeleteDailyStorageTankAnalyticalReport(report, id);
      await Future.delayed(const Duration(milliseconds: 300));
      _setLoading(false);
      return isSuccess;
    } catch (e) {
      _setErrorMessage('Failed to update report: $e');
      _setLoading(false);
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

  Future<void> getAllDailyStorageTankApproval() async {
    _setLoadingApproval(true);
    _setErrorMessage(null);
    try {
      log('Fetching reports...');
      _approvalList = await _repository.getAllDailyStorageTankApproval();

      notifyListeners();

      // await Future.delayed(const Duration(seconds: 1));
      _setLoadingApproval(false);
      log('Approval List length: ${_approvalList.length}');
    } catch (e) {
      _setErrorMessage('Failed to fetch approval daily storage: $e');
      _setLoadingApproval(false);
    }
  }
}
