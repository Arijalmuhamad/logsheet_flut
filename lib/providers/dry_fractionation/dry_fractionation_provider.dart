import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:logsheet_app/data/repositories/dry_fractionation/dry_fractionation_repository.dart';

class DryFractionationProvider with ChangeNotifier {
  final DryFractionationRepository _repository;

  DryFractionationProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingFetchTickets = false;
  bool get isLoadingFetchTickets => _isLoadingFetchTickets;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<DryFractionationEntity> _reportsList = [];
  List<DryFractionationEntity> get reportsList => _reportsList;

  String? _latestId;
  String? get latestId => _latestId;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setLoadingFetchTickets(bool value) {
    _isLoadingFetchTickets = value;
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
      _setLoading(false);
    }
  }
}
