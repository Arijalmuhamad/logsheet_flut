import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/data/remote/transactions/report_notification_data_entity.dart';
import 'package:logsheet_app/data/repositories/daily_production/daily_production_refinery_repository.dart';

class DailyProductionRefineryProvider with ChangeNotifier {
  final DailyProductionRefineryRepository _repository;

  DailyProductionRefineryProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingDelete = false;
  bool get isLoadingDelete => _isLoadingDelete;

  bool _isLoadingFilterTicket = false;
  bool get isLoadingFilterReport => _isLoadingFilterTicket;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoadingAlert = false;
  bool get isLoadingAlert => _isLoadingAlert;

  List<DailyProductionRefineryEntity> _reportsList = [];
  List<DailyProductionRefineryEntity> get reportsList => _reportsList;

  List<DailyProductionRefineryEntity> _filteredTickets = [];
  List<DailyProductionRefineryEntity> get filteredTickets => _filteredTickets;

  List<DailyProductionRefineryEntity> _approvedTransactions = [];
  List<DailyProductionRefineryEntity> get approvedTransactions =>
      _approvedTransactions;

  List<ReportNotificationDataEntity> _readyReportsList = [];
  List<ReportNotificationDataEntity> get readyReportsList => _readyReportsList;

  String? _latestId;
  String? get latestId => _latestId;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setLoadingFilterTicket(bool value) {
    _isLoadingFilterTicket = value;
    notifyListeners();
  }

  void _setLoadingDelete(bool value) {
    _isLoadingDelete = value;
    notifyListeners();
  }

  void _setLoadingAlert(bool value) {
    _isLoadingAlert = value;
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

  Future<bool> insertTicket(DailyProductionRefineryEntity entity) async {
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

  Future<bool> deleteTicketById(String id, String username) async {
    _setLoadingDelete(true);
    _setErrorMessage(null);
    try {
      final response = await _repository.deleteTicket(id, username);
      log("Quality Refinery Provider deleteTicketById response: $response");
      _setLoadingDelete(false);

      _reportsList.removeWhere((element) => element.id == id);
      notifyListeners();

      return response;
    } catch (e) {
      _setLoadingDelete(false);
      _setErrorMessage('Failed to delete report: $e');

      return false;
    }
  }

  Future<void> fetchAllTickets(
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
      _reportsList = await _repository.getAllTickets(
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
                    .where((report) => report.preparedBy == null)
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
                          report.preparedBy != null &&
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
      log('Daily Prod Refinery List length: ${_reportsList.length}');
    } catch (e) {
      _setErrorMessage('Failed to fetch Daily Production Refinery: $e');
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
    DailyProductionRefineryEntity report,
    String username,
    String role,
    String plantCode,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      log('Updating report...');
      final result = await _repository.updateReportTicket(report);
      log(result.toString());
      fetchAllTickets(null, null, username, role, plantCode);
      await Future.delayed(const Duration(milliseconds: 300));
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
    String? remark,
    String id,
    String role,
    String plantCode,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      log("Sending Approval or Rejection for shift $shift report");
      final result = await _repository.sendApproveRejectTicket(
        username,
        status,
        userRole,
        shift,
        remark,
        id,
      );
      log("status from provider: $result");
      fetchAllTickets(null, null, username, role, plantCode);
      return result;
    } catch (e) {
      _setErrorMessage('Failed to send approval or rejection report: $e');
      _setLoading(false);
      return false;
    }
  }
}
