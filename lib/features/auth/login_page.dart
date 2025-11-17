import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/business_unit_entity.dart';
import 'package:logsheet_app/data/remote/master/plant_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/data/services/storage_service/storage_service.dart';
import 'package:logsheet_app/features/admin/admin_home_page.dart';
import 'package:logsheet_app/features/user/user_home_page.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import '../../providers/master/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _updater = ShorebirdUpdater();
  var _currentTrack = UpdateTrack.stable;
  bool _isCheckingForUpdates = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  bool _isPasswordVisible = false;

  String? selectedPlant;
  String? selectedBusinessUnit;

  bool _isLoggingIn = false;

  bool _isInitialDataLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isInitialDataLoading = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final businessUnitProvider = context.read<BusinessUnitProvider>();

        await businessUnitProvider.fetchAllBusinessUnits();
        await _checkForUpdates();
        if (!mounted) {
          return;
        }
      } catch (e) {
        setState(() {
          _errorMessage = "Failed to load initial data.";
        });
      } finally {
        setState(() {
          _isInitialDataLoading = false;
        });
      }
    });
  }

  Future<void> _handleLogin() async {
    if (_isLoggingIn) return;

    setState(() {
      _isLoggingIn = true;
      _errorMessage = null;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Simplified validation
    if (username.isEmpty ||
        password.isEmpty ||
        selectedBusinessUnit == null ||
        selectedPlant == null) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
        _isLoggingIn = false;
      });
      return;
    }

    final userProvider = context.read<UserProvider>();
    final businessUnitProvider = context.read<BusinessUnitProvider>();
    final plantProvider = context.read<PlantProvider>();
    final dataForm = context.read<DataFormNoProvider>();

    try {
      final user = await userProvider.loginUser(username, password);
      log("$user");

      if (user != null) {
        // Find the selected entities
        final selectedBusinessUnitEntity = businessUnitProvider
            .listBusinessUnits
            .firstWhere((bu) => bu.buCode == selectedBusinessUnit);

        final selectedPlantEntity = plantProvider.plantList.firstWhere(
          (plant) => plant.code == selectedPlant,
        );
        if (!mounted) return;

        // Set the providers
        businessUnitProvider.setCurrentBusinessUnit(selectedBusinessUnitEntity);
        plantProvider.setCurrentPlant(selectedPlantEntity);

        await dataForm.fetchAll();

        if (!mounted) return;
        // Save credentials for next time
        // await _saveToStorageService(
        //   user: user,
        //   plant: selectedPlantEntity,
        //   bu: selectedBusinessUnitEntity,
        //   password: password,
        // );
        if (user.role == "ADM") {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AdminHomePage(
                    userEntity: userProvider.currentUser!,
                    userName: userProvider.currentUser!.username,
                  ),
            ),
          );
        } else {
          if (!_isInitialDataLoading) {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        UserHomePage(userEntity: userProvider.currentUser!),
              ),
            );
          }
        }
      } else {
        setState(() {
          _errorMessage =
              userProvider.errorMessage ?? 'Login failed. Please try again.';
        });
      }
    } catch (e) {
      log('Error during login: $e');
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-sawit-2.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(100),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Container(
                padding: const EdgeInsets.only(
                  top: 24,
                  bottom: 12,
                  right: 24,
                  left: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo-kpn-2.png',
                            height: 50,
                            width: 150,
                          ),
                          Text(
                            "E-Logsheet",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF655F5B), // Neutral Gray
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF655F5B), // Neutral Gray
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: const Text(
                        "Enter your details to login",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Username
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "Enter your username",
                        filled: true,
                        fillColor: const Color(0xFFF0ECE9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: "Enter your password",
                        filled: true,
                        fillColor: const Color(0xFFF0ECE9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Business Unit
                    Consumer<BusinessUnitProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          // Return a disabled dropdown with a loading indicator or message
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: null,
                            items: [],
                            onChanged: null, // Disable the dropdown
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF0ECE9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Loading Business Unit...',
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        if (provider.listBusinessUnits.isEmpty) {
                          return TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF0ECE9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Biz. Unit tidak ditemukan.',
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(Icons.warning_amber_rounded),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () async {
                                  await context
                                      .read<BusinessUnitProvider>()
                                      .fetchAllBusinessUnits();
                                },
                              ),
                            ),
                          );
                        }
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedBusinessUnit,
                          items:
                              provider.listBusinessUnits.map((businessUnit) {
                                return DropdownMenuItem<String>(
                                  value: businessUnit.buCode,
                                  child: Text(
                                    "${businessUnit.buCode} - ${businessUnit.buName}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) async {
                            setState(() {
                              selectedBusinessUnit = value;
                              context.read<PlantProvider>().clearPlants();
                              selectedPlant = null;
                            });

                            if (value != null) {
                              await context
                                  .read<PlantProvider>()
                                  .fetchPlantsByBusinessUnit(value);
                            } else {
                              context.read<PlantProvider>().clearPlants();
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Business Unit',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(Icons.business_center_rounded),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    Consumer<PlantProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          // Return a disabled dropdown with a loading indicator or message
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: null,
                            items: [],
                            onChanged: null, // Disable the dropdown
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF0ECE9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Loading Plant...',
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        if (provider.plantList.isEmpty) {
                          return TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF0ECE9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Plant tidak ditemukan.',
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(Icons.warning_amber_rounded),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () async {
                                  await context
                                      .read<PlantProvider>()
                                      .fetchAllPlant();
                                },
                              ),
                            ),
                          );
                        }
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedPlant,
                          items:
                              provider.plantList.map((plant) {
                                return DropdownMenuItem<String>(
                                  value: plant.code,
                                  child: Text(
                                    "${plant.code} - ${plant.name}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPlant = value!;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Plant',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(Icons.forest_rounded),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 8),

                    if (_errorMessage != null)
                      Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoggingIn ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child:
                            _isLoggingIn
                                ? SizedBox(
                                  width: 23,
                                  height: 23,
                                  child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Version 1.0.18",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            "Build 2025-11-17",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _saveToStorageService({
  //   required UserEntity user,
  //   required PlantEntity plant,
  //   required BusinessUnitEntity bu,
  //   required String password,
  // }) async {
  //   log("LOGIN PAGE saveToStorageService: ${user.username}, $password");

  //   final storage = StorageService();

  //   await storage.saveUsername(user.username);
  //   await storage.savePassword(password);\]
  //   await storage.saveBusinessUnit(bu.buCode);
  //   await storage.savePlant(plant.code);
  // }

  Future<void> _checkForUpdates() async {
    if (_isCheckingForUpdates) return;

    try {
      setState(() {
        _isCheckingForUpdates = true;
      });
      final status = await _updater.checkForUpdate(track: _currentTrack);
      log("log: $status");
      if (!mounted) return;
      switch (status) {
        case UpdateStatus.upToDate:
          // tampilan widget no update atau tidak display apapun
          // contoh: _showNoUpdateAvaliable();
          //  return _showRestartAppAlert('upToDate');
          return;
        case UpdateStatus.outdated:
          // tampilan widget Dialog update available
          //contoh: _showRestartAppAlert();
          return _showRestartAppAlert();
        case UpdateStatus.restartRequired:
          // fungsi lainnya
          // _showRestartAppAlert();
          return _showRestartAppAlert();
        case UpdateStatus.unavailable:
          // Do nothing, there is already a warning displayed at the top of the
          // screen.
          return;
          // return _showRestartAppAlert('unavailable');
      }
    } on Exception catch (error) {
      log('Error checking for update: $error');
    } finally {
      setState(() {
        _isCheckingForUpdates = false;
      });
    }
  }

  void _showRestartAppAlert() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button.
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text("Perlu Restart!"),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Update Baru Telah Hadir! Silahkan Restart Aplikasi!'),
                  Text('Apakah Anda Ingin Restart Sekarang?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Restart'),
                onPressed: () async {
                  // SystemNavigator.pop();
                  await FlutterExitApp.exitApp();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
