import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/logsheet/pretreatment_bleaching_filtration_entity.dart';
import 'package:logsheet_app/data/repositories/logsheet/pretreatment_bleaching_filtration_repository.dart';

class PretreatmentBleachingFiltrationProvider extends ChangeNotifier {
  final PretreatmentBleachingFiltrationRepository _repository;

  PretreatmentBleachingFiltrationProvider(this._repository);
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingReset = false;
  bool get isLoadingReset => _isLoadingReset;

  bool _isLoadingFilterTicket = false;
  bool get isLoadingFilterReport => _isLoadingFilterTicket;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _latestId;
  String? get latestId => _latestId;

  bool _isLoadingDelete = false;
  bool get isLoadingDelete => _isLoadingDelete;

  List<PretreatmentBleachingFiltrationEntity> _pretreatmentList = [];
  List<PretreatmentBleachingFiltrationEntity> get pretreatmentList =>
      _pretreatmentList;
  List<PretreatmentBleachingFiltrationEntity> _filteredTickets = [];
  List<PretreatmentBleachingFiltrationEntity> get filteredTickets =>
      _filteredTickets;

  List<PretreatmentBleachingFiltrationEntity> _reportsForManager = [];
  List<PretreatmentBleachingFiltrationEntity> get reportsForManager =>
      _reportsForManager;

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

  void setLoadingReset(bool value) {
    _isLoadingReset = value;
    notifyListeners();
  }

  void _setErrorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<String?> fetchLatestId(String plantCode) async {
    _setLoading(false);
    _setErrorMessage(null);
    try {
      _latestId = await _repository.getLatestTicketId(plantCode);
      log("(PBE Provider) latest ID = $_latestId");
      return _latestId;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('(PBE Provider) Failed to get latest id: $e');
      return null;
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
      _setErrorMessage('(PBE Provider) Failed to update autonumber: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> insert(PretreatmentBleachingFiltrationEntity entity) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _setErrorMessage(null);
      final result = await _repository.insert(entity);

      if (result) {
        _setLoading(false);
        _setErrorMessage(null);
        return result;
      } else {
        _setLoading(false);
        _setErrorMessage('(PBE Provider) Failed to insert report.');
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('(PBE Provider) Failed to insert report: $e');
      return false;
    }
  }

  Future<bool> updateTicket(
    PretreatmentBleachingFiltrationEntity entity,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.update(entity);
      _setLoading(false);
      _setErrorMessage(null);

      return result;
    } catch (e) {
      log("$e");
      _setLoading(false);
      _setErrorMessage("$e");
      return false;
    }
  }

  Future<bool> deleteTicketById(String id, String username) async {
    _setLoadingDelete(true);
    _setErrorMessage(null);

    try {
      final response = await _repository.deleteTicket(id, username);
      log("Pretreatment Provider deleteTicketById response: $response");
      _setLoadingDelete(false);

      _pretreatmentList.removeWhere((e) => e.id == id);

      return response;
    } catch (e) {
      _setLoadingDelete(false);
      _setErrorMessage('(PBE Provider) Failed to delete report: $e');
      log("(PBE Provider) Pretreatment Provider: $e");

      return false;
    }
  }

  Future<void> fetchAllTicket(
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
      _pretreatmentList = await _repository.getAllTicket(
        dateFilter,
        time,
        username,
        role,
        plantCode,
      );
      notifyListeners();
      log("pretreatment ticket list length is ${_pretreatmentList.length}");

      // switch (role) {
      //   case "LEAD":
      //     // preparedStatusShift1 or 2 or 3 must be empty
      //     if (filter) {
      //       _pretreatmentList =
      //           _pretreatmentList
      //               .where((report) => report.preparedBy == null)
      //               .toList();
      //       notifyListeners();
      //     }
      //     break;

      //   case "MGR":
      //     if (filter) {
      //       _pretreatmentList =
      //           _pretreatmentList
      //               .where(
      //                 (report) =>
      //                     report.preparedBy != null &&
      //                     report.checkedStatus == null,
      //               )
      //               .toList();
      //       notifyListeners();
      //     }
      //     break;
      //   default:
      //     break;
      // }
      // notifyListeners();

      _setLoading(false);
      _setErrorMessage(null);
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('(PBE Provider) Failed to insert report: $e');
    }
  }

  Future<void> fetchReportsForManager(String plantCode) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _reportsForManager = await _repository.getReportsForManager(plantCode);
      _setLoading(false);
    } catch (e) {
      _setErrorMessage(
        '(PBE Provider) Failed to fetch reports for manager: $e',
      );
      _setLoading(false);
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
      log("Sending Approval or Rejection for report");
      final result = await _repository.sendApproveRejectReport(
        username,
        status,
        userRole,
        shift,
        remark,
        id,
      );
      log("status from provider: $result");
      await fetchAllTicket(null, null, username, role, plantCode);
      return result;
    } catch (e) {
      _setErrorMessage(
        '(PBE Provider) Failed to send approval or rejection report: $e',
      );
      _setLoading(false);
      return false;
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
      _setErrorMessage('(PBE Provider) Failed fetch filtered PBE ticket: $e');
      _setLoading(false);
    }
  }
}
