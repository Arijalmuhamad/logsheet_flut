import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/transactions/quality_report_refinery_entity.dart';
import 'package:logsheet_app/data/repositories/quality_report_refinery_repository.dart';
import 'package:mysql_client/mysql_client.dart';

class QualityReportRefineryProvider with ChangeNotifier {
  final QualityReportRefineryRepository _repository;

  QualityReportRefineryProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

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

      if (result) {
        return result;
      } else {
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to insert report: $e');
      return false;
    }
  }
}
