import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/data/repositories/transaction/quality_report_refinery_repository.dart';

class QualityReportRefineryProvider with ChangeNotifier {
  final QualityReportRefineryRepository _repository;

  QualityReportRefineryProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<QualityReportRefineryEntity> _reportsList = [];
  List<QualityReportRefineryEntity> get reportsList => _reportsList;

  List<QualityReportRefineryEntity> _approvedTransactions = [];
  List<QualityReportRefineryEntity> get approvedTransactions =>
      _approvedTransactions;

  String? _latestId;
  String? get latestId => _latestId;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setLatestId(String value) {
    _latestId = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<String?> fetchLatestId(String plantCode) async {
    _setLoading(false);
    _setErrorMessage(null);
    try {
      _latestId = await _repository.getLatestTicketId(plantCode);
      log("latest ID = $_latestId");
      return _latestId;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to get latest id: $e');
      return null;
    }
  }

  Future<bool> insert(QualityReportRefineryEntity entity) async {
    _setLoading(false);
    _setErrorMessage(null);

    try {
      _setLoading(true);
      _setErrorMessage(null);
      final result = await _repository.insert(entity);
      notifyListeners();
      if (result) {
        // await Future.delayed(const Duration(seconds: 2));
        _setLoading(false);
        _setErrorMessage(null);
        return result;
      } else {
        _setLoading(false);
        _setErrorMessage('Failed to insert report.');
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to insert report: $e');
      return false;
    }
  }

  void fetchAllReports(
    DateTime? dateFilter,
    String? time,
    String username,
    String role,
    String plantCode, {
    bool filter = true,
  }) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      log('Fetching reports...');
      _reportsList = await _repository.getAllReports(
        dateFilter,
        time,
        username,
        role,
        plantCode,
      );
      notifyListeners();

      switch (role) {
        case "LEAD":
          // preparedStatusShift1 or 2 or 3 must be empty
          if (filter) {
            _reportsList =
                _reportsList
                    .where(
                      (report) =>
                          report.preparedByShift1 == null &&
                          report.preparedByShift2 == null &&
                          report.preparedByShift3 == null,
                    )
                    .toList();
            notifyListeners();
          }
          break;

        case "MGR":
          if (filter) {
            _reportsList =
                _reportsList
                    .where(
                      (report) =>
                          report.preparedByShift1 != null &&
                          report.preparedByShift2 != null &&
                          report.preparedByShift3 != null &&
                          report.checkedStatus == null,
                    )
                    .toList();
            notifyListeners();
          }
          break;
        default:
          break;
      }
      notifyListeners();

      // await Future.delayed(const Duration(seconds: 1));
      _setLoading(false);
      log('Report List length: ${_reportsList.length}');
    } catch (e) {
      _setErrorMessage('Failed to fetch Quality Reports: $e');
      _setLoading(false);
    }
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _setLoading(false);
      log('Update auto number...');
      final result = await _repository.updateAutoNumber(
        plantCode,
        newAutoNumber,
      );
      log(result.toString());
      return result;
    } catch (e) {
      _setErrorMessage('Failed to update autonumber: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateReport(
    QualityReportRefineryEntity report,
    String username,
    String role,
    String plantCode,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      log('Updating report...');
      final result = await _repository.updateReport(report);
      log(result.toString());
      fetchAllReports(null, null, username, role, plantCode);
      await Future.delayed(const Duration(seconds: 1));
      _setLoading(false);
      return result;
    } catch (e) {
      _setErrorMessage('Failed to update report: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendApproveRejectReport(
    String username,
    String status,
    String userRole,
    int shift,
    String remark,
    String id,
    String role,
    String plantCode,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      log("Sending Approval or Rejection for shift $shift report");
      final result = await _repository.sendApproveRejectReport(
        username,
        status,
        userRole,
        shift,
        remark,
        id,
      );
      log("status from provider: $result");
      fetchAllReports(null, null, username, role, plantCode);
      return result;
    } catch (e) {
      _setErrorMessage('Failed to send approval or rejection report: $e');
      _setLoading(false);
      return false;
    }
  }

  void fetchAllPreparedTransactions(String plantCode) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _approvedTransactions = await _repository.getAllPreparedTransactions(
        plantCode,
      );
      await Future.delayed(Duration(milliseconds: 500));
      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Failed to fetch users: $e');
      _setLoading(false);
    }
  }
}
