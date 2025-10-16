import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/services/storage_service/storage_service.dart';
import 'package:logsheet_app/features/admin/admin_home_page.dart';
import 'package:logsheet_app/features/auth/login_page.dart';
import 'package:logsheet_app/features/user/user_home_page.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

enum AuthState { uninitialized, unauthorized, authorized }

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  AuthState _authState = AuthState.uninitialized;
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await context.read<DataFormNoProvider>().fetchAll();
    //   Future.delayed(Duration(milliseconds: 100));
    //   if (!mounted) return;
    //   await _checkLoginStatus();
    // });
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final storage = StorageService();
    final credentials = await storage.readAllLoginData();

    final username = credentials[StorageService.keys.username];
    final password = credentials[StorageService.keys.password];
    final buCode = credentials[StorageService.keys.businessUnit];
    final plantCode = credentials[StorageService.keys.plant];

    log("FROM THE STORAGE SERVICE: $username, $password, $buCode, $plantCode");

    if (username != null &&
        password != null &&
        buCode != null &&
        plantCode != null) {
      log("attemp to login");
      if (!mounted) return;
      final userProvider = context.read<UserProvider>();
      final user = await userProvider.loginUser(username, password);

      log("${user?.username} ${user?.password}");

      if (user?.username != null && mounted) {
        log("username is not null, attemping to setup providers");

        await _setupProviders(buCode, plantCode);
      }
    }
  }

  Future<void> _setupProviders(String buCode, String plantCode) async {
    final buProvider = context.read<BusinessUnitProvider>();
    final plantProvider = context.read<PlantProvider>();

    await buProvider.fetchAllBusinessUnits();
    final matchingBu = buProvider.listBusinessUnits.firstWhere(
      (bu) => bu.buCode == buCode,
      orElse:
          () => throw Exception("Business Units Tidak ditemukan di database"),
    );
    log("Matching bu: ${matchingBu.buCode}");
    buProvider.setCurrentBusinessUnit(matchingBu);

    await plantProvider.fetchPlantsByBusinessUnit(buCode);
    final matchingPlant = plantProvider.plantList.firstWhere(
      (plant) => plant.code == plantCode,
      orElse: () => throw Exception("Plant tidak ditemukan di database."),
    );

    log("Matching plant code: ${matchingPlant.code}");
    plantProvider.setCurrentPlant(matchingPlant);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    if (userProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userProvider.currentUser != null) {
      if (userProvider.currentUser!.role == 'ADM') {
        return AdminHomePage(
          userName: userProvider.currentUser!.username,
          userEntity: userProvider.currentUser!,
        );
      } else {
        return UserHomePage(userEntity: userProvider.currentUser!);
      }
    } else {
      return const LoginPage();
    }
  }

  // void _navigateToLogin() {
  //   if (mounted) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const LoginPage()),
  //     );
  //   }
  // }
}
