import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_approval_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_control_detail_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_control_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/lamps_and_glass_report_entity.dart';
import 'package:logsheet_app/data/remote/maintenance/monthly_approval_status.dart';
import 'package:logsheet_app/data/repositories/maintenance/maintenance_lamps_and_glass_repository.dart';

class MaintenanceLampsAndGlassProvider extends ChangeNotifier {
  final MaintenanceLampsAndGlassRepository _repository;

  MaintenanceLampsAndGlassProvider(this._repository);

  List<LampsAndGlassEntity> _lampsAndGlassList = [];
  List<LampsAndGlassEntity> get lampsAndGlassList => _lampsAndGlassList;

  MonthlyApprovalStatus? approvalStatus;

  List<LampsAndGlassApprovalEntity> _lampsAndGlassApprovalList = [];
  List<LampsAndGlassApprovalEntity> get lampsAndGlassApprovalList =>
      _lampsAndGlassApprovalList;

  List<LampsAndGlassReportEntity> _reportList = [];
  List<LampsAndGlassReportEntity> get reportList => _reportList;

  List<LampsAndGlassEntity> _lampsList = [];
  List<LampsAndGlassEntity> get lampsList => _lampsList;

  List<LampsAndGlassEntity> _glassList = [];
  List<LampsAndGlassEntity> get glassList => _glassList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingSubmit = false;
  bool get isLoadingSubmit => _isLoadingSubmit;

  bool _isLoadingDelete = false;
  bool get isLoadingDelete => _isLoadingDelete;

  bool _isLoadingUpdate = false;
  bool get isLoadingUpdate => _isLoadingUpdate;

  bool _isDataAlreadyExist = false;
  bool get isDataAlreadyExist => _isDataAlreadyExist;

  String? _latestId;
  String? get latestId => _latestId;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLamps = true;
  bool get isLamps => _isLamps;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setLoadingDelete(bool value) {
    _isLoadingDelete = value;
    notifyListeners();
  }

  void _setLoadingUpdate(bool value) {
    _isLoadingUpdate = value;
    notifyListeners();
  }

  void _setSubmitLoading(bool value) {
    _isLoadingSubmit = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setLamps(bool value) {
    _isLamps = value;
    notifyListeners();
  }

  void _setDataExists(bool value) {
    _isDataAlreadyExist = value;
    notifyListeners();
  }

  Future<void> fetchAllLampsAndGlass() async {
    log('Trying to fetch all lamps and glass from the database');
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _lampsAndGlassList = await _repository.getAllLampsAndGlass();

      _lampsList =
          _lampsAndGlassList.where((item) => item.category == "LAMPS").toList();

      _glassList =
          _lampsAndGlassList.where((item) => item.category == "GLASS").toList();

      _lampsList.sort((x, y) {
        final prefixX = RegExp(r'[A-Za-z]+').stringMatch(x.code)!;
        final prefixY = RegExp(r'[A-Za-z]+').stringMatch(y.code)!;

        final cmpPrefix = prefixX.compareTo(prefixY);
        if (cmpPrefix != 0) return cmpPrefix;

        final numX = int.parse(x.code.substring(prefixX.length));
        final numY = int.parse(y.code.substring(prefixY.length));
        return numX.compareTo(numY);
      });
      _glassList.sort((a, b) {
        final prefixA = RegExp(r'^[A-Za-z]+').stringMatch(a.code)!;
        final prefixB = RegExp(r'^[A-Za-z]+').stringMatch(b.code)!;

        final cmpPrefix = prefixA.compareTo(prefixB);
        if (cmpPrefix != 0) return cmpPrefix;

        final numA = int.parse(a.code.substring(prefixA.length));
        final numB = int.parse(b.code.substring(prefixB.length));
        return numA.compareTo(numB);
      });
      _setLoading(false);
      _setErrorMessage(null);
      log('Fetch successful, total in the list: ${_lampsAndGlassList.length}');
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to fetch Lamps and Glass: $e');
    }
  }

  Future<void> fetchAllLampsAndGlassFromDate(String time) async {
    log('Trying to fetch all lamps and glass based on date from the database');
    _setLoading(true);
    _setErrorMessage(null);
    try {
      log('initial Lamps and Glass list: ${_reportList.length}');
      _reportList = await _repository.getAllLampsAndGlassFromDate(time);

      _reportList.sort((x, y) {
        final prefixX = RegExp(r'^[A-Za-z]+').stringMatch(x.checkItem)!;
        final prefixY = RegExp(r'^[A-Za-z]+').stringMatch(y.checkItem)!;

        final cmpPrefix = prefixX.compareTo(prefixY);
        if (cmpPrefix != 0) return cmpPrefix;

        // Then compare number part
        final numX = int.parse(x.checkItem.substring(prefixX.length));
        final numY = int.parse(y.checkItem.substring(prefixY.length));
        return numX.compareTo(numY);
      });
      notifyListeners();
      log('Fetch successful, total in the list: ${_reportList.length}');

      _setLoading(false);
      _setErrorMessage(null);
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to fetch Lamps and Glass based on date: $e');
    }
  }

  Future<void> fetchAllLampsAndGlassFromMonth({
    required int year,
    required int month,
  }) async {
    log('Trying to fetch all lamps and glass based on date from the database');
    _setLoading(true);
    _setErrorMessage(null);
    try {
      log('initial Lamps and Glass list: ${_lampsAndGlassApprovalList.length}');
      _lampsAndGlassApprovalList = await _repository
          .getAllLampsAndGlassFromMonth(year: year, month: month);

      log(
        "_lampsAndGlassApprovalList list length is ${_lampsAndGlassApprovalList.length}",
      );

      approvalStatus = MonthlyApprovalStatus.fromEntityList(
        year: year,
        month: month,
        allChecks: _lampsAndGlassApprovalList,
      );

      notifyListeners();

      log(
        'Fetch successful, total in the list: ${_lampsAndGlassApprovalList.length} with completed Days: ${approvalStatus?.completedDays}',
      );

      _setLoading(false);
      _setErrorMessage(null);
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to fetch Lamps and Glass based on date: $e');
    }
  }

  Future<String?> fetchLatestId(String plantCode) async {
    _setLoading(false);
    _setErrorMessage(null);
    try {
      _latestId = await _repository.getLatestId(plantCode);
      log("latest ID = $_latestId");
      return _latestId;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to get latest id: $e');
      return null;
    }
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    _setSubmitLoading(true);
    _setErrorMessage(null);
    try {
      _setSubmitLoading(false);
      log('Update auto number...');
      final result = await _repository.updateAutoNumber(
        plantCode,
        newAutoNumber,
      );
      log(result.toString());
      return result;
    } catch (e) {
      _setErrorMessage('Failed to update autonumber: $e');
      _setSubmitLoading(false);
      return false;
    }
  }

  Future<bool> insertToControl(LampsAndGlassControlEntity entity) async {
    _setSubmitLoading(false);
    _setErrorMessage(null);

    try {
      _setSubmitLoading(true);
      _setErrorMessage(null);
      final result = await _repository.insertToControl(entity);
      notifyListeners();
      if (result) {
        // await Future.delayed(const Duration(seconds: 2));
        _setSubmitLoading(false);
        _setErrorMessage(null);
        return result;
      } else {
        _setSubmitLoading(false);
        _setErrorMessage('Failed to insert to control.');
        return false;
      }
    } catch (e) {
      _setSubmitLoading(false);
      _setErrorMessage('Failed to insert report: $e');
      return false;
    }
  }

  Future<bool> insertToControlDetail(
    List<LampsAndGlassControlDetailEntity> entityList,
  ) async {
    _setLoading(false);
    _setErrorMessage(null);

    try {
      _setLoading(true);
      _setErrorMessage(null);
      final result = await _repository.insertToControlDetail(entityList);
      notifyListeners();
      if (result) {
        // await Future.delayed(const Duration(seconds: 2));
        _setLoading(false);
        _setErrorMessage(null);
        return result;
      } else {
        _setLoading(false);
        _setErrorMessage('Failed to insert to control detail.');
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to insert report: $e');
      return false;
    }
  }

  Future<bool> updateApproveRejectToHeader({
    required String checkedBy,
    required String status,
    required int month,
    required int year,
    required String? remark,
  }) async {
    _setSubmitLoading(true);
    _setErrorMessage(null);
    try {
      log("Sending Approval or Rejection for year-month: $year-$month.");
      final result = await _repository.updateApproveRejectToHeader(
        checkedBy: checkedBy,
        status: status,
        month: month,
        year: year,
        remark: remark,
      );
      log("Approval Successful");
      await fetchAllLampsAndGlassFromMonth(year: year, month: month);
      notifyListeners();
      _setSubmitLoading(false);
      return result;
    } catch (e) {
      _setErrorMessage(
        'Failed to send approval or rejection lamps and glass report: $e',
      );
      _setLoading(false);
      return false;
    }
  }

  Future<void> checkIfDataExists({
    required String workCenter,
    required String date,
  }) async {
    log("Check if data existed for $workCenter on $date");
    _setLoading(true); // Show a general loading indicator
    _setDataExists(false);

    try {
      final result = await _repository.isDataExistForDate(
        workCenter: workCenter,
        date: date,
      );
      _setDataExists(result);
      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Failed to check data existence: $e');
      _setDataExists(false); // Assume false on error
      _setLoading(false);
    }
  }

  void resetDataExistCheck() {
    _isDataAlreadyExist = false;
  }

  Future<bool> deleteLampsAndGlass(String id) async {
    _setLoadingDelete(true);
    _setErrorMessage(null);
    try {
      final result = await _repository.deleteLampsAndGlass(id);
      return result;
    } catch (e) {
      _setErrorMessage('Error: $e');
      return false;
    } finally {
      _reportList = [];
      _setLoadingDelete(false);
    }
  }

  Future<bool> updateLampsAndGlass({
    required String id,
    required String company,
    required String plant,
    required String workCenter,
    required DateTime checkDate,
    required String remarks,
    required List<LampsAndGlassControlDetailEntity> details,
  }) async {
    _setLoadingUpdate(true);
    _setErrorMessage(null);
    try {
      final result = await _repository.updateLampsAndGlass(
        id: id,
        company: company,
        plant: plant,
        workCenter: workCenter,
        checkDate: checkDate,
        remarks: remarks,
        details: details,
      );
      return result;
    } catch (e) {
      _setErrorMessage('Error: $e');
      return false;
    } finally {
      _setLoadingUpdate(false);
    }
  }
}
