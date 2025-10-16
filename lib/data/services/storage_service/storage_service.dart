import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const keys = (
    username: 'username',
    password: 'password',
    businessUnit: 'business_unit',
    plant: 'plant',
  );

  // Save username
  Future<void> saveUsername(String value) async {
    await _secureStorage.write(key: keys.username, value: value);
  }

  // Save password
  Future<void> savePassword(String value) async {
    await _secureStorage.write(key: keys.password, value: value);
  }

  // Save Business Unit
  Future<void> saveBusinessUnit(String value) async {
    await _secureStorage.write(key: keys.businessUnit, value: value);
  }

  // Save Plant
  Future<void> savePlant(String value) async {
    await _secureStorage.write(key: keys.plant, value: value);
  }

  // Read username
  Future<void> readUsername() async {
    await _secureStorage.read(key: keys.username);
  }

  // Read password
  Future<void> readPassword() async {
    await _secureStorage.read(key: keys.password);
  }

  // Read Business Unit
  Future<void> readBusinessUnit() async {
    await _secureStorage.read(key: keys.businessUnit);
  }

  // Read Plant
  Future<void> readPlant() async {
    await _secureStorage.read(key: keys.plant);
  }

  // Delete username
  Future<void> deleteUsername(String value) async {
    await _secureStorage.delete(key: keys.username);
  }

  // Delete password
  Future<void> deletePassword() async {
    await _secureStorage.delete(key: keys.password);
  }

  // Delete Business Unit
  Future<void> deleteBusinessUnit() async {
    await _secureStorage.delete(key: keys.businessUnit);
  }

  // Delete Plant
  Future<void> deletePlant() async {
    await _secureStorage.delete(key: keys.plant);
  }

  Future<Map<String, String?>> readAllLoginData() async {
    try {
      final data = await _secureStorage.readAll();
      return {
        keys.username: data[keys.username],
        keys.password: data[keys.password],
        keys.businessUnit: data[keys.businessUnit],
        keys.plant: data[keys.plant],
      };
    } on PlatformException catch (e) {
      log("Error PlatformException: $e");
      await deleteAllLoginData();
      return {};
    }
  }

  Future<void> deleteAllLoginData() async {
    await Future.wait([
      _secureStorage.delete(key: keys.username),
      _secureStorage.delete(key: keys.password),
      _secureStorage.delete(key: keys.businessUnit),
      _secureStorage.delete(key: keys.plant),
    ]);
  }
}
