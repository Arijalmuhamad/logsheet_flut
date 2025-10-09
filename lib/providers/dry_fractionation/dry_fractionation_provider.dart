import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:logsheet_app/data/repositories/dry_fractionation/dry_fractionation_repository.dart';

class DryFractionationProvider with ChangeNotifier {
  final className = "Dry Fractionation";
  final DryFractionationRepository _repository;

  DryFractionationProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingDelete = false;
  bool get isLoadingDelete => _isLoadingDelete;

  bool _isLoadingUpdate = false;
  bool get isLoadingUpdate => _isLoadingUpdate;

  bool _isLoadingApproval = false;
  bool get isLoadingApproval => _isLoadingApproval;

  bool _isLoadingFetchTickets = false;
  bool get isLoadingFetchTickets => _isLoadingFetchTickets;

  bool _isLoadingFilterTicket = false;
  bool get isLoadingFilterTicket => _isLoadingFilterTicket;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<DryFractionationEntity> _reportsList = [];
  List<DryFractionationEntity> get reportsList => _reportsList;

  List<DryFractionationEntity> _filteredTickets = [];
  List<DryFractionationEntity> get filteredTickets => _filteredTickets;

  List<DryFractionationEntity> _reportsForManager = [];
  List<DryFractionationEntity> get reportsForManager => _reportsForManager;

  String? _latestId;
  String? get latestId => _latestId;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setLoadingDelete(bool value) {
    _isLoadingDelete = value;
    notifyListeners();
  }

  void _setLoadingUpdate(bool value) {
    _isLoadingUpdate = value;
    notifyListeners();
  }

  void _setLoadingApproval(bool value) {
    _isLoadingApproval = value;
    notifyListeners();
  }

  void _setLoadingFetchTickets(bool value) {
    _isLoadingFetchTickets = value;
    notifyListeners();
  }

  void _setLoadingFilterTicket(bool value) {
    _isLoadingFilterTicket = value;
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
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _latestId = await _repository.getLatestTicketId(plantCode);
      log("latest ID = $_latestId");
      return _latestId;
    } catch (e) {
      _setErrorMessage('Failed to get latest id: $e');
    } finally {
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

  Future<bool> insertTicket(DryFractionationEntity entity) async {
    _setLoading(false);
    _setErrorMessage(null);

    try {
      _setLoading(true);
      _setErrorMessage(null);
      final result = await _repository.insert(entity);
      notifyListeners();
      if (result) {
        return result;
      } else {
        _setErrorMessage('Failed to insert report.');
        return false;
      }
    } catch (e) {
      _setErrorMessage('Failed to insert report: $e');
      return false;
    } finally {
      _setLoading(false);
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
    _setLoadingFetchTickets(true);
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

      if (filter) {
        _reportsList =
            _reportsList.where((report) => report.preparedBy == null).toList();
        notifyListeners();
      }
      log('Report List length: ${_reportsList.length}');
    } catch (e) {
      _setErrorMessage('Failed to fetch Quality Reports: $e');
    } finally {
      _setLoadingFetchTickets(false);
    }
  }

  // Delete Ticket Provider
  Future<bool> deleteTicketById(String id, String username) async {
    _setLoadingDelete(true);
    _setErrorMessage(null);

    try {
      final response = await _repository.deleteTicket(id, username);
      log("$className Provider deleteTicketById response: $response");
      _reportsList.removeWhere((e) => e.id == id);

      return response;
    } catch (e) {
      _setErrorMessage('($className Provider) Failed to delete report: $e');
      log("($className Provider) Pretreatment Provider: $e");

      return false;
    } finally {
      _setLoadingDelete(false);
    }
  }

  // Update Ticket Provider
  Future<bool> updateTicket(
    DryFractionationEntity entity,
    String username,
    String role,
    String plantCode,
  ) async {
    _setLoadingUpdate(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.update(entity);

      await fetchAllTickets(null, null, username, role, plantCode);

      return result;
    } catch (e) {
      log("$e");
      _setErrorMessage("$e");
      return false;
    } finally {
      _setLoadingUpdate(false);
    }
  }

  // Send Approve Reject Ticket Provider
  Future<bool> sendApproveRejectReport(
    String username,
    String status,
    String userRole,
    String? remark,
    String id,
    String plantCode,
  ) async {
    _setLoadingApproval(true);
    _setErrorMessage(null);

    try {
      log("($className Provider) Sending Approval or Rejection");
      final result = await _repository.sendApproveRejectTicket(
        username,
        status,
        userRole,
        remark,
        id,
      );
      log("($className Provider) status from provider: $result");
      await fetchAllTickets(null, null, username, userRole, plantCode);
      return result;
    } catch (e) {
      _setErrorMessage('$e');
      return false;
    } finally {
      _setLoadingApproval(false);
    }
  }

  // Fetch Filtered Tickets
  Future<void> fetchFilteredTickets(
    DateTime? dateFilter,
    String plantCode,
    String? shift,
  ) async {
    _setLoadingFilterTicket(true);
    _setErrorMessage(null);

    try {
      //
      _filteredTickets = await _repository.getFilteredTickets(
        dateFilter,
        plantCode,
        shift,
      );
      notifyListeners();
    } catch (e) {
      _setErrorMessage(
        '($className Provider) Failed fetch filtered Daily Prod Refinery ticket: $e',
      );
    } finally {
      _setLoadingFilterTicket(false);
    }
  }

  Future<void> fetchReportsForManager(String plantCode) async {
    _setLoadingFetchTickets(true);
    _setErrorMessage(null);
    try {
      _reportsForManager = await _repository.getReportsForManager(plantCode);
    } catch (e) {
      _setErrorMessage(
        '(PBE Provider) Failed to fetch reports for manager: $e',
      );
    } finally {
      _setLoadingFetchTickets(false);
    }
  }
}
