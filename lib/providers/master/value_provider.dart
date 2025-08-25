import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/value_entity.dart';
import 'package:logsheet_app/data/remote/master/tank_entity.dart';
import 'package:logsheet_app/data/repositories/master/value_repository.dart';

class ValueProvider with ChangeNotifier {
  final ValueRepository _valueRepository;

  ValueProvider(this._valueRepository);

  List<MasterValueEntity> _oilTypeLists = [];
  List<MasterValueEntity> get oilTypeLists => _oilTypeLists;

  List<TankEntity> _toTankGroupLists = [];
  List<TankEntity> get toTankGroupLists => _toTankGroupLists;

  List<MasterValueEntity> _workCenterLists = [];
  List<MasterValueEntity> get workCenterLists => _workCenterLists;

  List<TankEntity> _tankSourceLists = [];
  List<TankEntity> get tankSourceList => _tankSourceLists;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // bool _initialDataFetched = false;

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
      _tankSourceLists = await _valueRepository.getAllToTankGroup().timeout(
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

  void fetchAllInitialData() async {
    if (_workCenterLists.isNotEmpty &&
        _tankSourceLists.isNotEmpty &&
        _tankSourceLists.isNotEmpty &&
        _oilTypeLists.isNotEmpty) {
      return;
    }
    _setLoading(true);
    _setErrorMessage(null);

    try {
      fetchWorkCenterLists();
      fetchTankSourceLists();
      fetchToTankGroupLists();
      fetchOilTypes();
      _setLoading(false);
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage('Failed to fetch initial data: $e');
    } finally {
      _setLoading(false);
    }
  }
}
