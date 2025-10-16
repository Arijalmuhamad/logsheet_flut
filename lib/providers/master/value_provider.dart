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

  List<MasterValueEntity> _oilTypeListsDailyProduction = [];
  List<MasterValueEntity> get oilTypeListsDailyProduction =>
      _oilTypeListsDailyProduction;

  List<TankEntity> _toTankGroupLists = [];
  List<TankEntity> get toTankGroupLists => _toTankGroupLists;

  List<MasterValueEntity> _workCenterLists = [];
  List<MasterValueEntity> get workCenterLists => _workCenterLists;

  List<MasterValueEntity> _workCenterFractLists = [];
  List<MasterValueEntity> get workCenterFractLists => _workCenterFractLists;

  List<TankEntity> _tankSourceLists = [];
  List<TankEntity> get tankSourceList => _tankSourceLists;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isWorkCenterLoading = false;
  bool get isWorkCenterLoading => _isWorkCenterLoading;

  bool _isWorkCenterFractLoading = false;
  bool get isWorkCenterFractLoading => _isWorkCenterFractLoading;

  bool _isOilTypeLoading = false;
  bool get isOilTypeLoading => _isOilTypeLoading;

  bool _isTankSourceLoading = false;
  bool get isTankSourceLoading => _isTankSourceLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // bool _initialDataFetched = false;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setWorkCenterLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setOilTypesLoading(bool value) {
    _isOilTypeLoading = value;
    notifyListeners();
  }

  void _setTankSourceLoading(bool value) {
    _isTankSourceLoading = value;
    notifyListeners();
  }

  void _setWorkCenterFractLoading(bool value) {
    _isWorkCenterFractLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchOilTypes() async {
    _setOilTypesLoading(true);
    _setErrorMessage(null);

    try {
      _oilTypeLists = await _valueRepository.getAllOilTypes().timeout(
        const Duration(seconds: 60),
      );
      notifyListeners();
      log("(ValueProvider) oil type list length: $_oilTypeLists");
    } catch (e) {
      _setErrorMessage('(ValueProvider) Failed to fetch Oil Type: $e');
    } finally {
      _setOilTypesLoading(false);
    }
  }

  Future<void> fetchOilTypesDailyProd() async {
    _setOilTypesLoading(true);
    _setErrorMessage(null);

    List<String> excludeOil = [
      "RPS",
      "STEARIN",
      "ROL",
      "OLEIN",
      "RRBDPS",
      "RRPDPO",
      "RROL",
    ];

    try {
      _oilTypeListsDailyProduction = await _valueRepository
          .getAllOilTypes()
          .timeout(const Duration(seconds: 60));
      _oilTypeListsDailyProduction =
          _oilTypeListsDailyProduction
              .where((item) => !excludeOil.contains(item.name))
              .toList();

      log("${_oilTypeListsDailyProduction.length}");
      log("${_oilTypeLists.length}");
      notifyListeners();
      log("(ValueProvider) oil type list length: $_oilTypeLists");
    } catch (e) {
      _setErrorMessage('(ValueProvider) Failed to fetch Oil Type: $e');
    } finally {
      _setOilTypesLoading(false);
    }
  }

  Future<void> fetchToTankGroupLists() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _toTankGroupLists = await _valueRepository.getAllToTankGroup().timeout(
        const Duration(seconds: 60),
      );
      notifyListeners();
      log("(ValueProvider) To Tank Group list length: $_toTankGroupLists");
    } catch (e) {
      _setErrorMessage('(ValueProvider) Failed to fetch Tank Group list: $e');
      _setLoading(false);
    }
  }

  Future<void> fetchTankSourceLists() async {
    _setTankSourceLoading(true);
    _setErrorMessage(null);

    try {
      _tankSourceLists = await _valueRepository.getAllToTankGroup().timeout(
        const Duration(seconds: 60),
      );
      notifyListeners();
      log("(ValueProvider) Tank Source list length: $_tankSourceLists");
    } catch (e) {
      _setErrorMessage('(ValueProvider) Failed to fetch Tank Source list: $e');
    } finally {
      _setTankSourceLoading(false);
    }
  }

  Future<void> fetchWorkCenterLists() async {
    _setWorkCenterLoading(true);
    _setErrorMessage(null);

    try {
      _workCenterLists = await _valueRepository.getAllWorkCenters().timeout(
        const Duration(seconds: 60),
      );
      notifyListeners();
      log("(ValueProvider) Refinery Machine list length: $_workCenterLists");
    } catch (e) {
      _setErrorMessage(
        '(ValueProvider) Failed to fetch Refinery Machine list: $e',
      );
    } finally {
      _setWorkCenterLoading(false);
    }
  }

  Future<void> fetchWorkCenterFractLists() async {
    _setWorkCenterFractLoading(true);
    _setErrorMessage(null);

    try {
      _workCenterFractLists = await _valueRepository
          .getAllFractWorkCenters()
          .timeout(const Duration(seconds: 60));
      notifyListeners();
      log("(ValueProvider) FRACT Machine list length: $_workCenterFractLists");
    } catch (e) {
      _setErrorMessage(
        '(ValueProvider) Failed to fetch FRACT Machine list: $e',
      );
    } finally {
      _setWorkCenterFractLoading(false);
    }
  }

  Future<void> fetchAllInitialData() async {
    // if (_workCenterLists.isEmpty ||
    //     _tankSourceLists.isEmpty ||
    //     _toTankGroupLists.isEmpty ||
    //     _oilTypeLists.isEmpty) {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await fetchWorkCenterLists();
      await fetchTankSourceLists();
      await fetchToTankGroupLists();
      await fetchWorkCenterFractLists();
      await fetchOilTypes();
      await fetchOilTypesDailyProd();
    } catch (e) {
      _setErrorMessage('Failed to fetch initial data: $e');
    } finally {
      _setLoading(false);
      _setErrorMessage(null);
    }
    // }
  }
}
