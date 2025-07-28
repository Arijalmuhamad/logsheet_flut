import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/business_unit_entity.dart';
import 'package:logsheet_app/data/repositories/business_unit_repository.dart';

class BusinessUnitProvider extends ChangeNotifier {
  final BusinessUnitRepository _businessUnitRepository;

  BusinessUnitProvider(this._businessUnitRepository);

  BusinessUnitEntity? _currentBusinessUnit;
  BusinessUnitEntity? get currentBusinessUnit => _currentBusinessUnit;

  List<BusinessUnitEntity> _listBusinessUnits = [];
  List<BusinessUnitEntity> get listBusinessUnits => _listBusinessUnits;

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

  Future<bool?> createBusinessUnit(BusinessUnitEntity businessUnit) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final response = await _businessUnitRepository.registerBusinessUnit(
        businessUnit,
      );

      _setLoading(false);
      _setErrorMessage(null);

      _listBusinessUnits.add(businessUnit);
      notifyListeners();

      return response;
    } catch (e) {
      _setErrorMessage('Failed to add business units: $e');
      _setLoading(false);

      return null;
    }
  }

  void fetchAllBusinessUnits() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _listBusinessUnits = await _businessUnitRepository.getAllBusinessUnits();

      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Failed to fetch business units: $e');
      _setLoading(false);
    }
  }

  Future<bool> updateBusinessUnit(BusinessUnitEntity businessUnit) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final response = await _businessUnitRepository.updateBusinessUnit(
        businessUnit,
      );
      _setLoading(false);
      _setErrorMessage(null);

      if (response) {
        _setLoading(false);
        _setErrorMessage(null);
        return true;
      } else {
        _setLoading(false);
        _setErrorMessage('Failed to edit business unit.');
        return false;
      }
    } catch (e) {
      _setErrorMessage('Failed to edit business unit: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteBusinessUnit(String buCode) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final response = await _businessUnitRepository.deleteBusinessUnit(buCode);
      _setLoading(false);
      _setErrorMessage(null);

      _listBusinessUnits.removeWhere((element) => element.buCode == buCode);
      notifyListeners();

      return response;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to delete business unit: $e');
      return false;
    }
  }
}
