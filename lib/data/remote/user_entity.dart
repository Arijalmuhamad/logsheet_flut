import 'package:flutter/foundation.dart';

class UserEntity {
  final String userid;
  final String username;
  final String password;
  final String role;
  final String isActive;

  UserEntity({
    required this.userid,
    required this.username,
    required this.password,
    required this.role,
    required this.isActive,
  });

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      userid: map['userid'] as String,
      username: map['username'] as String,
      password: "",
      role: map['roles'] as String,
      isActive: map['isactive'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'username': username,
      'password': password,
      'roles': role,
      'isactive': isActive,
    };
  }
}
