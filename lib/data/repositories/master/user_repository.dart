import 'package:logsheet_app/data/remote/master/role_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/data/services/master/user_mysql_service.dart';

class UserRepository {
  final UserMySQLService _userMySQLService;

  UserRepository(this._userMySQLService);

  // -- CRUD OPERATIONS, FETCH DATA FROM THE MYSQL DATABASE
  // REGISTER
  Future<bool> registerUser(UserEntity user) async {
    return await _userMySQLService.registerUser(
      user.userid,
      user.username,
      user.password,
      user.isActive,
      user.role,
    );
  }

  // LOGIN
  Future<({UserEntity? user, String? errorMessage})> login(
    String username,
    String password,
  ) async {
    final loginResult = await _userMySQLService.loginUser(username, password);
    if (loginResult.errorMessage != null) {
      return (user: null, errorMessage: loginResult.errorMessage);
    } else if (loginResult.user == null) {
      return (user: null, errorMessage: 'Invalid username or password.');
    } else {
      return (user: UserEntity.fromMap(loginResult.user!), errorMessage: null);
    }
  }

  // GET ALL USER
  Future<List<UserEntity>> getAllUser() async {
    final List<Map<String, dynamic>> userMaps =
        await _userMySQLService.getAllUsers();

    return userMaps.map((map) => UserEntity.fromMap(map)).toList();
  }

  // UPDATE A USER
  Future<bool> updateUser(UserEntity user) async {
    return await _userMySQLService.updateUser(user);
  }

  // DELETE A USER
  Future<bool> deleteUser(String userId) async {
    return await _userMySQLService.deleteUser(userId);
  }

  // GET ALL ROLES
  Future<List<RoleEntity>> getAllRoles() async {
    final List<Map<String, dynamic>> roleMaps =
        await _userMySQLService.getAllRoles();

    return roleMaps.map((map) => RoleEntity.fromMap(map)).toList();
  }
}
