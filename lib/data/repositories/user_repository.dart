import 'package:logsheet_app/data/remote/user_entity.dart';
import 'package:logsheet_app/data/services/user_mysql_service.dart';

class UserRepository {
  final UserMySQLService _userMySQLService;

  UserRepository(this._userMySQLService);

  // -- CRUD OPERATIONS, FETCH DATA FROM THE MYSQL DATABASE
  // REGISTER
  Future<bool> registerUser(UserEntity user) async {
    return await _userMySQLService.registerUser(
      user.username,
      user.password,
      user.isActive,
      user.role,
    );
  }

  // LOGIN
  Future<UserEntity?> login(String username, String password) async {
    final Map<String, dynamic>? userData = await _userMySQLService.loginUser(
      username,
      password,
    );

    if (userData == null) {
      return null;
    } else {
      return UserEntity.fromMap(userData);
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
    return await _userMySQLService.updateUser(
      user.userid,
      user.username,
      user.password, // problem
      user.isActive,
      user.role,
    );
  }

  // DELETE A USER
  Future<bool> deleteUser(String userid) async {
    return await _userMySQLService.deletedUser(userid);
  }
}
