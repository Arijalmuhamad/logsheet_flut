import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:logsheet_app/data/remote/maintenance/change_product_checklist/change_product_checklist_entity.dart';
import 'package:logsheet_app/data/repositories/maintenance/change_product_checklist_repository/change_product_checklist_repository.dart';

class ChangeProductChecklistProvider with ChangeNotifier {
  final ChangeProductChecklistRepository _repository;

  ChangeProductChecklistProvider(this._repository);

  // Loading state for fetching
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Loading state for input
  bool _isLoadingInput = false;
  bool get isLoadingInput => _isLoadingInput;

  // Loading state for edit
  bool _isLoadingEdit = false;
  bool get isLoadingEdit => _isLoadingEdit;

  // Loading state for delete
  bool _isLoadingDelete = false;
  bool get isLoadingDelete => _isLoadingDelete;

  // Error Message
  String? _errorMessage = null;
  String? get errorMessage => _errorMessage;
  // List of langkah kerja
  List<ChangeProductChecklistEntity> _langkahkerjaList = [];
  List<ChangeProductChecklistEntity> get langkahkerjaList => _langkahkerjaList;

  // functions for changing loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setLoadingInput(bool value) {
    _isLoadingInput = value;
    notifyListeners();
  }

  void _setLoadingEdit(bool value) {
    _isLoadingEdit = value;
    notifyListeners();
  }

  void _setLoadingDelete(bool value) {
    _isLoadingDelete = value;
    notifyListeners();
  }

  // Set Error Message
  void _setErrorMessage(String? value) {
    _setErrorMessage(value);
    notifyListeners();
  }

  Future<void> getLangkahKerja() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.getLangkahKerja();
      notifyListeners();

      log('List Length: ${result.length}');
    } catch (e) {
      _setErrorMessage("$e");
    } finally {
      _setLoading(false);
    }
  }
}
