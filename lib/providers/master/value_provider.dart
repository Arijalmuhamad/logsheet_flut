import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/master_value_entity.dart';
import 'package:logsheet_app/data/repositories/master/value_repository.dart';

class ValueProvider with ChangeNotifier {
  final ValueRepository _valueRepository;

  ValueProvider(this._valueRepository);

  List<MasterValueEntity> _oilTypeLists = [];
  List<MasterValueEntity> get oilTypeLists => _oilTypeLists;

  List<MasterValueEntity> _toTankGroupLists = [];
  List<MasterValueEntity> get toTankGroupLists => _toTankGroupLists;

  List<MasterValueEntity> _workCenterLists = [];
  List<MasterValueEntity> get workCenterLists => _workCenterLists;

  List<MasterValueEntity> _tankSourceLists = [];
  List<MasterValueEntity> get tankSourceList => _tankSourceLists;

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

  void fetchOilTypes() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _oilTypeLists = await _valueRepository.getAllOilTypes().timeout(
        const Duration(seconds: 60),
      );
      notifyListeners();
      log("oil type list length: $_oilTypeLists");
    } catch (e) {
      _setErrorMessage('Failed to fetch Oil Type: $e');
      _setLoading(false);
    }
  }

  void fetchToTankGroupLists() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _toTankGroupLists = await _valueRepository.getAllToTankGroup().timeout(
        const Duration(seconds: 60),
      );
      notifyListeners();
      log("To Tank Group list length: $_toTankGroupLists");
    } catch (e) {
      _setErrorMessage('Failed to fetch Tank Group list: $e');
      _setLoading(false);
    }
  }

  void fetchTankSourceLists() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _tankSourceLists = await _valueRepository.getAllTankSource().timeout(
        const Duration(seconds: 60),
      );
      notifyListeners();
      log("Tank Source list length: $_tankSourceLists");
    } catch (e) {
      _setErrorMessage('Failed to fetch Tank Source list: $e');
      _setLoading(false);
    }
  }

  void fetchWorkCenterLists() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _workCenterLists = await _valueRepository.getAllWorkCenters().timeout(
        const Duration(seconds: 60),
      );
      notifyListeners();
      log("Refinery Machine list length: $_workCenterLists");
    } catch (e) {
      _setErrorMessage('Failed to fetch Refinery Machine list: $e');
      _setLoading(false);
    }
  }
}
