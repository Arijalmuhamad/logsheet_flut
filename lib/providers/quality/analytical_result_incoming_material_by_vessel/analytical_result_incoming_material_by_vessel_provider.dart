import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/quality/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_detail_entity.dart';
import 'package:logsheet_app/data/remote/quality/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_entity.dart';
import 'package:logsheet_app/data/repositories/quality/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_repository.dart';

class AnalyticalResultIncomingMaterialByVesselProvider with ChangeNotifier {
  final AnalyticalResultIncomingMaterialByVesselRepository _repository;

  AnalyticalResultIncomingMaterialByVesselProvider(this._repository);

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

  Future<bool> insertAnalyticalResultIncomingMaterialByVessel({
    required AnalyticalResultIncomingMaterialByVesselHeaderEntity headerInput,
    required List<AnalyticalResultIncomingMaterialByVesselDetailEntity>
    detailInput,
    required String plantCode,
  }) async {
    _setLoadingInput(true);

    try {
      // 1. Generate header id (juga update autonumber di DB)
      final newHeaderId = await generateIdHeader(plantCode);

      if (newHeaderId == null || newHeaderId.isEmpty) {
        _setErrorMessage('Failed to generate header id');
        return false;
      }

      // 2. Make header with the new id (menggunakan copyWith pada header)
      final header = headerInput.copyWith(id: newHeaderId);

      // 3. Determine prefix (bagian sebelum autonumber header) & sisipkan 'D' di pos ke-3
      const int autoLength = 6; // panjang autonumber (ubah jika perlu)
      final int headerLen = newHeaderId.length;

      if (headerLen <= autoLength) {
        _setErrorMessage('Header id length is too short to extract prefix');
        return false;
      }

      // prefixBeforeAuto = newHeaderId tanpa autonumber akhir
      final prefixBeforeAuto = newHeaderId.substring(0, headerLen - autoLength);

      // insert 'D' at index 3 of that prefix
      final prefixWithD = prefixBeforeAuto.replaceRange(3, 3, 'D');

      // 4. Build detail list: prefixWithD + autonumber detail (padLeft ke 6)
      final details = <AnalyticalResultIncomingMaterialByVesselDetailEntity>[];

      for (var i = 0; i < detailInput.length; i++) {
        final detailAuto = (i + 1).toString().padLeft(
          autoLength,
          '0',
        ); // 000001, 000002, ...
        final detailId = "$prefixWithD$detailAuto";

        details.add(detailInput[i].copyWith(id: detailId, idHdr: newHeaderId));
      }

      // 5. Kirim ke repository
      return await _repository.insertAnalyticalResultIncomingMaterialByVessel(
        header: header,
        details: details,
      );
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoadingInput(false);
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

  Future<String> generateIdHeader(String plantCode) async {
    await getLatestId(plantCode);

    if (_latestId == null || _latestId!.isEmpty) {
      log("_latestId is null or empty in _generateHeaderId");
      return '';
    }

    final latest = _latestId!;
    log("Latest ID: $latest");

    final prefixPart = latest.length > 9 ? latest.substring(0, 9) : latest;
    final autoPart = latest.length > 9 ? latest.substring(9) : "";

    int newAuto = 1;
    if (autoPart.isNotEmpty) {
      try {
        newAuto = int.parse(autoPart) + 1;
      } catch (e) {
        log("Gagal parsing autonumber: $e");
      }
    }

    final newAutoStr = newAuto.toString().padLeft(6, '0');

    final newId = "$prefixPart$newAutoStr";

    log("Generated new ID: $newId");

    await updateAutoNumber(plantCode, newAuto);

    return newId;
  }
}
