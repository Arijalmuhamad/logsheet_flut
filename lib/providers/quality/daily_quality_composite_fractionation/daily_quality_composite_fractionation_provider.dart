import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:logsheet_app/data/remote/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_entity.dart';
import 'package:logsheet_app/data/repositories/quality/daily_quality_composite_fractionation/daily_quality_composite_fractionation_repository.dart';

class DailyQualityCompositeFractionationProvider with ChangeNotifier {
  final DailyQualityCompositeFractionationRepository _repository;

  DailyQualityCompositeFractionationProvider(this._repository);

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

  // Loading state for approval
  bool _isLoadingApproval = false;
  bool get isLoadingApproval => _isLoadingApproval;

  // Error Message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _latestId;
  String? get latestId => _latestId;

  List<DailyQualityCompositeFractionationEntity> _reportsList = [];
  List<DailyQualityCompositeFractionationEntity> get reportsList =>
      _reportsList;

  List<DailyQualityCompositeFractionationEntity> _approvalList = [];
  List<DailyQualityCompositeFractionationEntity> get approvalList =>
      _approvalList;

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

  void _setLoadingApproval(bool value) {
    _isLoadingApproval = value;
    notifyListeners();
  }

  // Set Error Message
  void _setErrorMessage(String? value) {
    // _setErrorMessage(value);
    _errorMessage = value;
    notifyListeners();
  }

  Future<bool> insertDailyQualityCompositeFractionationReport({
    required DailyQualityCompositeFractionationEntity report,
  }) async {
    _setLoadingInput(true);

    _setErrorMessage(null);

    try {
      final result = await _repository.insertDailyQualityCompositeFractionation(
        report: report,
      );

      if (result) {
        _setLoadingInput(false);
        return true;
      } else {
        _setErrorMessage(
          'Failed to insert Daily Quality Composite Fractionation.',
        );
        _setLoadingInput(false);
        return false;
      }
    } catch (e) {
      _setErrorMessage('$e');
      _setLoadingInput(false);
      return false;
    }
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final result = await _repository.updateAutoNumber(
        plantCode,
        newAutoNumber,
      );
      return result;
    } catch (e) {
      _setErrorMessage('Failed to update autonumber: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> getLatestId(String plantCode) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _latestId = await _repository.getLatestId(plantCode);
      log("latest ID = $_latestId");
      return _latestId;
    } catch (e) {
      _setErrorMessage('Failed to get latest id: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<String> generateId(String plantCode) async {
    await getLatestId(plantCode);

    if (_latestId == null || _latestId!.isEmpty) {
      log("_latestId is null or empty in _generateHeaderId");
      return '';
    }

    final latest = _latestId!;
    log("Latest ID: $latest");

    // Pisahkan bagian depan (prefix + plantid + accountingyear) dan autonumber
    final prefixPart = latest.length > 10 ? latest.substring(0, 10) : latest;
    final autoPart = latest.length > 10 ? latest.substring(10) : "";

    // Konversi autonumber ke int dan tambah 1
    int newAuto = 1; // default kalau autoPart kosong atau gagal parsing
    if (autoPart.isNotEmpty) {
      try {
        newAuto = int.parse(autoPart) + 1;
      } catch (e) {
        log("Gagal parsing autonumber: $e");
      }
    }

    // Pad autonumber agar tetap memiliki panjang sama (mis. 6 digit)
    // final newAutoStr = newAuto.toString().padLeft(autoPart.length, '0');
    final newAutoStr = newAuto.toString().padLeft(6, '0');

    // Gabungkan lagi jadi ID baru
    final newId = "$prefixPart$newAutoStr";

    log("Generated new ID: $newId");

    await updateAutoNumber(plantCode, newAuto);

    return newId;
  }

  Future<void> getAllDailyCompositeFractionationReport(
    String? dateFilter,
    String? role,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      log('Fetching reports...');
      _reportsList = await _repository.getAllDailyQualityCompositeReport(
        dateFilter ?? '',
        role ?? '',
      );
      _reportsList = _reportsList.where((item) => item.flag == 'T').toList();

      notifyListeners();

      // await Future.delayed(const Duration(seconds: 1));
      _setLoading(false);
      log('Report List length: ${_reportsList.length}');
    } catch (e) {
      _setErrorMessage('Failed to fetch Quality Reports: $e');
      _setLoading(false);
    }
  }

  Future<bool> deletedailyQualityCompositeFractionation(String id) async {
    _setLoadingDelete(true);
    _setErrorMessage(null);

    try {
      final result = await _repository
          .deletedailyQualityCompositeFractionationReport(id);

      if (result) {
        _setLoadingDelete(false);
        return true;
      } else {
        _setErrorMessage(
          'Failed to delete dailyQualityCompositeFractionation.',
        );
        _setLoadingDelete(false);
        return false;
      }
    } catch (e) {
      _setErrorMessage('$e');
      return false;
    } finally {
      _setLoadingDelete(false);
    }
  }

  Future<bool> updateDailyQualityCompositeFractionationReport(
    DailyQualityCompositeFractionationEntity report,
    String id,
  ) async {
    _setLoadingEdit(true);
    _setErrorMessage(null);
    try {
      log('Updating report...');
      final isSuccess = await _repository
          .updateDailyQualityCompositeFractionationReport(report, id);
      await Future.delayed(const Duration(milliseconds: 300));
      _setLoadingEdit(false);
      return isSuccess;
    } catch (e) {
      _setErrorMessage('Failed to update report: $e');
      _setLoadingEdit(false);
      return false;
    }
  }
}
