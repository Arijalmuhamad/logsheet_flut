import 'package:drift/drift.dart';
import 'package:logsheet_app/core/database/app_database.dart';

class UserDao {
  final AppDatabase db;

  UserDao(this.db);

  Future<int> insertUser(MUsersCompanion user) {
    return db.into(db.mUsers).insert(user);
  }

  Future<List<MUser>> getAllUsers() {
    return db.select(db.mUsers).get();
  }

  Future<void> updateUser(MUser user) async {
    await db.update(db.mUsers).replace(user);
  }

  Future<void> deleteUser(String userid) async {
    await (db.delete(db.mUsers)..where((t) => t.userid.equals(userid))).go();
  }

  /// Login dengan username dan password (hanya jika isactive == 'T')
  Future<MUser?> login(String username, String password) {
    return (db.select(db.mUsers)..where(
      (t) =>
          t.username.equals(username) &
          t.password.equals(password) &
          t.isactive.equals('T'),
    )).getSingleOrNull();
  }

  /// Dapatkan user berdasarkan username (tanpa cek password)
  Future<MUser?> getUserByUsername(String username) {
    return (db.select(db.mUsers)
      ..where((t) => t.username.equals(username))).getSingleOrNull();
  }
}
