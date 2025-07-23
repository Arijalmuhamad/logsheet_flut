import 'package:flutter/material.dart';
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

  void _fetchAllUsers() async {
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

  Future<bool> _loginUser(String username, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final result = await _userRepository.login(username, password);

      if (result == null) {
        _setErrorMessage('Invalid username or password.');
        _setLoading(false);
        return false;
      } else {
        _setErrorMessage(null);
        _setLoading(false);
        _currentUser = result;
        return true;
      }
    } catch (e) {
      _setErrorMessage('Failed to fetch users: $e');
      _setLoading(false);
      return false;
    }
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }
}
