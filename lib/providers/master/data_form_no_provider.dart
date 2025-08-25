import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/repositories/master/data_form_no_repository.dart';

class DataFormNoProvider extends ChangeNotifier {
  final DataFormNoRepository _repository;

  DataFormNoProvider(this._repository);

  List<DataFormNoEntity> _dataFormNoList = [];
  List<DataFormNoEntity> get dataFormNoList => _dataFormNoList;

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

  Future<void> fetchAll() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _dataFormNoList = await _repository.getAllDataFormNo();
      _setLoading(false);
    } catch (e) {
      _setErrorMessage("Error: $e");
      log("Error in Data Form No Provider: $e");
    }
  }
}
