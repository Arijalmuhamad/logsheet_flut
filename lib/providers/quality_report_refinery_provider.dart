import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/data/repositories/quality_report_refinery_repository.dart';

class QualityReportRefineryProvider with ChangeNotifier {
  final QualityReportRefineryRepository _repository;

  QualityReportRefineryProvider(this._repository);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  List<QualityReportRefineryEntity> _reportsList = [];

  List<QualityReportRefineryEntity> get reportsList => _reportsList;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> insert(QualityReportRefineryEntity entity) async {
    _setLoading(false);
    _setErrorMessage(null);

    try {
      _setLoading(true);
      final result = await _repository.insert(entity);
      notifyListeners();
      if (result) {
        _setLoading(false);
        _setErrorMessage('Success.');
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

  void fetchAllReports(DateTime? dateFilter, String? time) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _setLoading(false);
      log('Fetching reports...');
      _reportsList = await _repository.getAllReports(dateFilter, time);

      log('Report List length: ${_reportsList.length}');
      notifyListeners();
    } catch (e) {
      _setErrorMessage('Failed to fetch Quality Reports: $e');
      _setLoading(false);
    }
  }
}
