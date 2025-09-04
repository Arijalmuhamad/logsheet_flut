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

  Future<void> fetchOilTypes() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _oilTypeLists = await _valueRepository.getAllOilTypes().timeout(
        const Duration(seconds: 60),
      );
      notifyListeners();
      log("(ValueProvider) oil type list length: $_oilTypeLists");
    } catch (e) {
      _setErrorMessage('(ValueProvider) Failed to fetch Oil Type: $e');
      _setLoading(false);
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
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _tankSourceLists = await _valueRepository.getAllToTankGroup().timeout(
        const Duration(seconds: 60),
      );
      notifyListeners();
      log("(ValueProvider) Tank Source list length: $_tankSourceLists");
    } catch (e) {
      _setErrorMessage('(ValueProvider) Failed to fetch Tank Source list: $e');
      _setLoading(false);
    }
  }

  Future<void> fetchWorkCenterLists() async {
    _setLoading(true);
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
      _setLoading(false);
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
      await fetchOilTypes();
      _setLoading(false);
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage('Failed to fetch initial data: $e');
    } finally {
      _setLoading(false);
    }
    // }
  }

  // Future<void> fetchAllInitialData() async {
  //   // Guard clause to prevent fetching if data already exists or is already loading.
  //   if (_isLoading ||
  //       (_workCenterLists.isNotEmpty &&
  //           _tankSourceLists.isNotEmpty &&
  //           _toTankGroupLists.isNotEmpty &&
  //           _oilTypeLists.isNotEmpty)) {
  //     return;
  //   }

  //   _setLoading(true);
  //   _setErrorMessage(null);

  //   try {
  //     _workCenterLists = await _valueRepository.getAllWorkCenters().timeout(
  //       const Duration(seconds: 5),
  //     );
  //     _tankSourceLists = await _valueRepository.getAllTankSource().timeout(
  //       const Duration(seconds: 5),
  //     );

  //     _toTankGroupLists = await _valueRepository.getAllToTankGroup().timeout(
  //       const Duration(seconds: 5),
  //     );

  //     _oilTypeLists = await _valueRepository.getAllOilTypes().timeout(
  //       const Duration(seconds: 5),
  //     );
  //   } catch (e) {
  //     _setErrorMessage('(ValueProvider) Failed to fetch initial data: $e');
  //     log('(ValueProvider) Failed to fetch initial data: $e');
  //   } finally {
  //     // This will now correctly be called only after all fetches are complete or have failed.
  //     _setLoading(false);
  //   }
  // }
}
