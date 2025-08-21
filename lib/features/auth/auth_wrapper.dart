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

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _checkLoginStatus(),
    );
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
      if (!mounted) return;
      log("attemp to login");
      final userProvider = context.read<UserProvider>();
      final user = await userProvider.loginUser(username, password);

      log("${user?.username} ${user?.password}");
      if (user?.username != null && mounted) {
        log("username is not null, attemping to setup providers");
        try {
          await _setupProviders(buCode, plantCode);

          if (!mounted) return;
          log("Navigating to Home Page");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      user?.role == "ADM"
                          ? AdminHomePage(
                            userEntity: user!,
                            userName: user.username,
                          )
                          : UserHomePage(userEntity: user!),
            ),
          );
        } catch (e) {
          _navigateToLogin();
        }
      } else {
        log("username is null, navigate to login");

        _navigateToLogin();
      }
    } else {
      log("data in sharedpreference is null, navigate to login");
      _navigateToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator()],
        ),
      ),
    );
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

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }
}
