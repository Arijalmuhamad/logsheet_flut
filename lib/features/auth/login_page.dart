import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:provider/provider.dart';

import '../admin/admin_home_page.dart';
import '../user/user_home_page.dart';
import '../../providers/master/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  bool _isPasswordVisible = false;

  MySQLConnection? _connection;

  String? selectedPlant;
  String? selectedBusinessUnit;

  bool _isLoggingIn = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>
          Provider.of<BusinessUnitProvider>(
            context,
            listen: false,
          ).fetchAllBusinessUnits(),
    );
  }

  Future<void> _handleLogin() async {
    if (_isLoggingIn) return;

    setState(() {
      _isLoggingIn = true;
      _errorMessage = null;
    });

    log(selectedBusinessUnit ?? "no biz unit selected");
    log(selectedPlant ?? "no plant unit selected");

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter username and password.';
        _isLoggingIn = false; // Re-enable the login button
      });
      return;
    }

    if (selectedBusinessUnit == null) {
      setState(() {
        _errorMessage = 'Please select a Business Unit.';
        _isLoggingIn = false; // Re-enable the login button
      });
      return; // Stop the login process
    }

    if (selectedPlant == null) {
      setState(() {
        _errorMessage = 'Please select a Plant.';
        _isLoggingIn = false; // Re-enable the login button
      });
      return; // Stop the login process
    }

    // User Provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final businessUnitProvider = Provider.of<BusinessUnitProvider>(
      context,
      listen: false,
    );
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);

    try {
      //login to the mysql database

      final user = await userProvider.loginUser(username, password);

      if (user != null) {
        if (user.role == 'ADM') {
          final selectedBusinessUnitEntity = businessUnitProvider
              .listBusinessUnits
              .firstWhere((bu) => bu.buCode == selectedBusinessUnit);
          businessUnitProvider.setCurrentBusinessUnit(
            selectedBusinessUnitEntity,
          );
          final selectedPlantEntity = plantProvider.plantList.firstWhere(
            (plant) => plant.code == selectedPlant,
          );

          log("Selected Plant: $selectedPlant");
          log("Founded Plant: ${selectedPlantEntity.name}");

          plantProvider.setCurrentPlant(selectedPlantEntity);

          log("login plant in provider: ${plantProvider.currentPlant?.code}");

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      AdminHomePage(userEntity: user, userName: user.username),
            ),
          );
        } else {
          final selectedBusinessUnitEntity = businessUnitProvider
              .listBusinessUnits
              .firstWhere((bu) => bu.buCode == selectedBusinessUnit);
          businessUnitProvider.setCurrentBusinessUnit(
            selectedBusinessUnitEntity,
          );
          final selectedPlantEntity = plantProvider.plantList.firstWhere(
            (plant) => plant.code == selectedPlant,
          );

          log("Selected Plant: $selectedPlant");
          log("Founded Plant: ${selectedPlantEntity.name}");

          plantProvider.setCurrentPlant(selectedPlantEntity);
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserHomePage(userEntity: user),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage =
              userProvider.errorMessage ?? 'Login gagal. Silakan coba lagi.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan tidak terduga: $e';
      });
      log('Error during login: $e');
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _connection?.close();
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
                padding: const EdgeInsets.all(24),
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
                        return DropdownButtonFormField<String>(
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
                          onChanged: (value) {
                            setState(() {
                              selectedBusinessUnit = value;
                              Provider.of<PlantProvider>(
                                context,
                                listen: false,
                              ).clearPlants();
                              selectedPlant = null;
                            });

                            if (value != null) {
                              Provider.of<PlantProvider>(
                                context,
                                listen: false,
                              ).fetchPlantsByBusinessUnit(value);
                            } else {
                              Provider.of<PlantProvider>(
                                context,
                                listen: false,
                              ).clearPlants();
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
                        return DropdownButtonFormField<String>(
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

                    SizedBox(height: 24),

                    if (_errorMessage != null)
                      Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
