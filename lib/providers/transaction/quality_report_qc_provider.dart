import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/quality_refinery/quality_report_qc_entity.dart';
import 'package:logsheet_app/data/remote/transactions/report_notification_data_entity.dart';
import 'package:logsheet_app/data/repositories/quality_report/quality_report_qc_repository.dart';

class QualityReportQCProvider with ChangeNotifier {
  final QualityReportQCRepository _repository;

  QualityReportQCProvider(this._repository);

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

  List<QualityReportQcEntity> _reportsList = [];
  List<QualityReportQcEntity> get reportsList => _reportsList;

  List<QualityReportQcEntity> _filteredTickets = [];
  List<QualityReportQcEntity> get filteredTickets => _filteredTickets;

  List<QualityReportQcEntity> _approvedTransactions = [];
  List<QualityReportQcEntity> get approvedTransactions => _approvedTransactions;

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

  Future<bool> insertTicket(QualityReportQcEntity entity) async {
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
    QualityReportQcEntity report,
    String username,
    String role,
    String plantCode,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      log('Updating report...');
      final result = await _repository.updateReportTicket(report, role);
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

      if (result) {
        await fetchAllTickets(null, null, username, role, plantCode);
        return result;
      } else {
        return false;
      }
    } catch (e) {
      _setErrorMessage('Failed to send approval or rejection report: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<void> fetchReportsForManager(String plantCode) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _approvedTransactions = await _repository.getReportsForManager(plantCode);
      await Future.delayed(Duration(milliseconds: 500));
      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Failed to fetch transaction reports: $e');
      _setLoading(false);
    }
  }

  Future<List<int>> fetchReportedHours(
    DateTime dateFilter,
    String plantCode,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final List<int> reportedTime = await _repository.getReportedHours(
        dateFilter,
        plantCode,
      );
      return reportedTime;
    } catch (e) {
      _setErrorMessage('Failed to fetch reported hours: $e');
      _setLoading(false);
      return [];
    }
  }

  Future<List<ReportNotificationDataEntity>>
  fetchReadyForManagerApprovalReports() async {
    _setLoadingAlert(true);
    _setErrorMessage(null);
    try {
      log("Fetching ready for manager approval list");
      _readyReportsList = await _repository.getReadyForManagerApprovalReports();

      log("${_readyReportsList.length} is ready to be approved.");
      _setLoadingAlert(false);
      return _readyReportsList;
    } catch (e) {
      log('Failed to fetch reported hours: $e');
      _setErrorMessage('Failed to fetch reported hours: $e');
      _setLoadingAlert(false);
      return [];
    }
  }

  Future<void> fetchFilteredTickets(
    DateTime? dateFilter,
    String plantCode,
    String? shift,
  ) async {
    _setLoadingFilterTicket(true);
    _setErrorMessage(null);

    try {
      _filteredTickets = await _repository.getFilteredTickets(
        dateFilter,
        plantCode,
        shift,
      );
      _setLoadingFilterTicket(false);
      notifyListeners();
    } catch (e) {
      _setErrorMessage('(QR Provider) Failed fetch filtered QR ticket: $e');
      _setLoading(false);
    }
  }
}
