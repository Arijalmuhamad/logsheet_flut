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


  List<ChangeProductChecklistEntity> _langkahKerjaPreTreatmentList = [];
  List<ChangeProductChecklistEntity> get langkahKerjaPreTreatmentList => _langkahKerjaPreTreatmentList;

  List<ChangeProductChecklistEntity> _langkahKerjaBleacherList = [];
  List<ChangeProductChecklistEntity> get langkahKerjaBleacherList => _langkahKerjaBleacherList;

  List<ChangeProductChecklistEntity> _langkahKerjaDeodorizationList = [];
  List<ChangeProductChecklistEntity> get langkahKerjaDeodorizationList => _langkahKerjaDeodorizationList;

  List<ChangeProductChecklistEntity> _langkahKerjaFractionationList = [];
  List<ChangeProductChecklistEntity> get langkahKerjaFractionationList => _langkahKerjaFractionationList;

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
    // _setErrorMessage(value);
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> getLangkahKerja() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _langkahkerjaList = await _repository.getLangkahKerja();

      _langkahKerjaPreTreatmentList = _langkahkerjaList
          .where((element) =>
          element.category == 'Pre Treatment Section' &&
          element.workCenter == 'Refinery')
          .toList()
        ..sort((a, b) => (a.sortNo ?? 0).compareTo(b.sortNo ?? 0));

       _langkahKerjaBleacherList = _langkahkerjaList
          .where((element) =>
          element.category == 'Bleacher Section' &&
          element.workCenter == 'Refinery')
          .toList()
        ..sort((a, b) => (a.sortNo ?? 0).compareTo(b.sortNo ?? 0));

         _langkahKerjaDeodorizationList = _langkahkerjaList
          .where((element) =>
          element.category == 'Deodorization Section' &&
          element.workCenter == 'Refinery')
          .toList()
        ..sort((a, b) => (a.sortNo ?? 0).compareTo(b.sortNo ?? 0));

        _langkahKerjaFractionationList = _langkahkerjaList
          .where((element) =>
          element.category == 'Fractionation Section' &&
          element.workCenter == 'Fractionation')
          .toList()
        ..sort((a, b) => (a.sortNo ?? 0).compareTo(b.sortNo ?? 0));

      log('List Length: ${_langkahkerjaList.length}');
     
    } catch (e) {
      _setErrorMessage("$e");
    } finally {
      _setLoading(false);
    }
  }
}
