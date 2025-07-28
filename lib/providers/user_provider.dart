import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/role_entity.dart';
import 'package:logsheet_app/data/remote/user_entity.dart';
import 'package:logsheet_app/data/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository;

  UserProvider(this._userRepository);

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

  void fetchAllUsers() async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _listUsers = await _userRepository.getAllUser();

      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Failed to fetch users: $e');
      _setLoading(false);
    }
  }

  void fetchAllRoles() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _listRoles = await _userRepository.getAllRoles();
      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Failed to fetch roles: $e');
      _setLoading(false);
    }
  }

  Future<bool> updateUser(UserEntity user) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final result = await _userRepository.updateUser(user);

      if (result) {
        _setLoading(false);
        _setErrorMessage(null);
        return true;
      } else {
        _setLoading(false);
        _setErrorMessage('Failed to edit user.');
        return false;
      }
    } catch (e) {
      _setErrorMessage('Failed to edit user: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<UserEntity?> loginUser(String username, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final result = await _userRepository.login(username, password);

      if (result == null) {
        _setErrorMessage('Invalid username or password.');
        _setLoading(false);
        return null;
      } else {
        _setErrorMessage(null);
        _setLoading(false);
        _currentUser = result;
        return result;
      }
    } catch (e) {
      _setErrorMessage('Failed to fetch users: $e');
      _setLoading(false);
      return null;
    }
  }

  Future<bool?> registerUser(UserEntity user) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final response = await _userRepository.registerUser(user);
      _setLoading(false);
      _setErrorMessage(null);

      _listUsers.add(user);
      notifyListeners();

      return response;
    } catch (e) {
      _setLoading(false);
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
      final response = await _userRepository.deleteUser(userid);
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
