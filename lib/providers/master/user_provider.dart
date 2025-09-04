import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/role_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/data/repositories/master/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _repository;

  UserProvider(this._repository);

  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  String _userName = '';
  String get userName => _userName;

  List<UserEntity> _listUsers = [];
  List<UserEntity> get listUser => _listUsers;

  List<RoleEntity> _listRoles = [];
  List<RoleEntity> get listRoles => _listRoles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCreateEditLoading = false;
  bool get isCreateEditLoading => _isCreateEditLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setCreateEditLoading(bool value) {
    _isCreateEditLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchAllUsers() async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _listUsers = await _repository.getAllUser();

      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Failed to fetch users: $e');
      _setLoading(false);
    }
  }

  Future<void> fetchAllRoles() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _listRoles = await _repository.getAllRoles();
      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Failed to fetch roles: $e');
      _setLoading(false);
    }
  }

  Future<bool> updateUser(UserEntity user) async {
    setCreateEditLoading(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.updateUser(user);

      if (result) {
        setCreateEditLoading(false);
        _setErrorMessage(null);
        fetchAllUsers();
        return true;
      } else {
        setCreateEditLoading(false);
        _setErrorMessage('Failed to edit user.');
        return false;
      }
    } catch (e) {
      _setErrorMessage('Failed to edit user: $e');
      setCreateEditLoading(false);
      return false;
    }
  }

  Future<UserEntity?> loginUser(String username, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final result = await _repository.login(username, password);
      if (result.errorMessage != null) {
        _setErrorMessage(result.errorMessage);
        _setLoading(false);
        return null;
      } else if (result.user == null) {
        _setErrorMessage('Invalid username or password.');
        _setLoading(false);
        return null;
      } else {
        _setErrorMessage(null);
        _setLoading(false);
        await Future.delayed(const Duration(seconds: 1));
        _currentUser = result.user;
        return result.user;
      }
    } catch (e) {
      _setErrorMessage('Failed to fetch users: $e');
      _setLoading(false);
      return null;
    }
  }

  Future<bool?> registerUser(UserEntity user) async {
    setCreateEditLoading(true);
    _setErrorMessage(null);

    try {
      final response = await _repository.registerUser(user);
      setCreateEditLoading(false);
      _setErrorMessage(null);

      _listUsers.insert(0, user);
      notifyListeners();

      return response;
    } catch (e) {
      setCreateEditLoading(false);
      _setErrorMessage('Failed to register user: $e');
      return null;
    }
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  Future<bool> deleteUser(String userid) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final response = await _repository.deleteUser(userid);
      _setLoading(false);
      _setErrorMessage(null);

      _listUsers.removeWhere((element) => element.userid == userid);
      notifyListeners();

      return response;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to delete user: $e');

      return false;
    }
  }
}
