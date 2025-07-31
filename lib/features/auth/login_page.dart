import 'package:flutter/material.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/data/dao/user_dao.dart';
import 'package:provider/provider.dart';

import '../admin/admin_home_page.dart';
import '../user/user_home_page.dart';
import '../../providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late final AppDatabase db;
  late final UserDao userDao;

  String? errorMessage;
  bool isPasswordVisible = false;

  String? selectedPlant;
  String? selectedCompany;

  final List<String> plantOptions = ['Fractination', 'Refinery'];
  final List<String> companyOptions = ['EUP', 'PS'];

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    userDao = UserDao(db);
  }

  Future<void> _handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // User Provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    //login to the mysql database
    final user = await userProvider.loginUser(username, password);

    if (user != null) {
      if (user.role == 'ADM') {
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
        errorMessage = 'Username atau password salah, atau akun tidak aktif.';
      });
    }

    // if (selectedPlant == null || selectedCompany == null) {
    //   setState(() {
    //     errorMessage = 'Silakan pilih Plant dan Company terlebih dahulu.';
    //   });
    //   return;
    // }

    // final user = await userDao.login(username, password);

    // if (user != null) {
    //   setState(() => errorMessage = null);
    //   if (!mounted) return;

    //   Provider.of<UserProvider>(
    //     context,
    //     listen: false,
    //   ).setUserName(user.username);

    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text('Login berhasil ✅')));

    //   if (user.role == 'admin') {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => AdminHomePage(userName: user.username),
    //       ),
    //     );
    //   } else if (user.role == 'user') {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => UserHomePage(userName: user.username),
    //       ),
    //     );
    //   } else {
    //     _showError("Role tidak dikenali");
    //   }
    // } else {
    //   setState(() {
    //     errorMessage = 'Username atau password salah, atau akun tidak aktif.';
    //   });
    // }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFC8B8AB), // Tan
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
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
                              fontSize: 20,
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
                        "Log In",
                        style: TextStyle(
                          fontSize: 28,
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
                      controller: usernameController,
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
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
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
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Plant
                    // DropdownButtonFormField<String>(
                    //   value: selectedPlant,
                    //   isExpanded: true,
                    //   decoration: InputDecoration(
                    //     prefixIcon: const Icon(Icons.factory),
                    //     filled: true,
                    //     fillColor: const Color(0xFFF0ECE9),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //   ),
                    //   hint: const Text("Pilih Plant"),
                    //   items:
                    //       plantOptions
                    //           .map(
                    //             (plant) => DropdownMenuItem(
                    //               value: plant,
                    //               child: Text(plant),
                    //             ),
                    //           )
                    //           .toList(),
                    //   onChanged:
                    //       (value) => setState(() => selectedPlant = value),
                    // ),
                    // const SizedBox(height: 16),

                    // Dropdown Company
                    // DropdownButtonFormField<String>(
                    //   value: selectedCompany,
                    //   isExpanded: true,
                    //   decoration: InputDecoration(
                    //     prefixIcon: const Icon(Icons.business),
                    //     filled: true,
                    //     fillColor: const Color(0xFFF0ECE9),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //   ),
                    //   hint: const Text("Pilih Company"),
                    //   items:
                    //       companyOptions
                    //           .map(
                    //             (company) => DropdownMenuItem(
                    //               value: company,
                    //               child: Text(company),
                    //             ),
                    //           )
                    //           .toList(),
                    //   onChanged:
                    //       (value) => setState(() => selectedCompany = value),
                    // ),
                    // const SizedBox(height: 8),
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          "Log In",
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
