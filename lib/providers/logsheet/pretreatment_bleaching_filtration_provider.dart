import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/transactions/pretreatment_bleaching_filtration_entity.dart';
import 'package:logsheet_app/data/repositories/logsheet/pretreatment_bleaching_filtration_repository.dart';

class PretreatmentBleachingFiltrationProvider extends ChangeNotifier {
  final PretreatmentBleachingFiltrationRepository _repository;

  PretreatmentBleachingFiltrationProvider(this._repository);
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingReset = false;
  bool get isLoadingReset => _isLoadingReset;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _latestId;
  String? get latestId => _latestId;

  List<PretreatmentBleachingFiltrationEntity> _pretreatmentList = [];
  List<PretreatmentBleachingFiltrationEntity> get pretreatmentList =>
      _pretreatmentList;

  void _setLoading(bool value) {
    _isLoading = value;
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
      log("latest ID = $_latestId");
      return _latestId;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to get latest id: $e');
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
      _setErrorMessage('Failed to update autonumber: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> insert(PretreatmentBleachingFiltrationEntity entity) async {
    _setLoading(false);
    _setErrorMessage(null);

    try {
      _setLoading(false);
      _setErrorMessage(null);
      final result = await _repository.insert(entity);

      if (result) {
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

  void fetchAllLogsheet() async {
    _setLoading(false);
    _setErrorMessage(null);

    try {
      _pretreatmentList = await _repository.getAllLogsheet();
      notifyListeners();

      _setLoading(false);
      _setErrorMessage(null);
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to insert report: $e');
    }
  }
}
