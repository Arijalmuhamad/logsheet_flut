import 'package:flutter/material.dart';
import '../core/database/app_database.dart';
import '../data/dao/mastervalue_dao.dart'; // impor dari hasil Drift
// atau wherever your generated part file for `MMastervalue` is

class TankProvider extends ChangeNotifier {
  final AppDatabase db;
  late MastervalueDao _mastervalueDao;

  List<MMastervalue> _tankList = [];
  bool _isLoading = false;

  TankProvider(this.db) {
    _mastervalueDao = MastervalueDao(db);
    loadTanks();
  }

  List<MMastervalue> get tankList => _tankList;
  bool get isLoading => _isLoading;

  Future<void> loadTanks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tankList = await _mastervalueDao.getActiveTanks(); // langsung dari DAO
    } catch (e) {
      debugPrint("❌ Error loading tankList: $e");
      _tankList = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void refresh() => loadTanks();
}
