// import 'package:flutter/material.dart';
// import 'package:logsheet_app/core/database/app_database.dart';
// import 'package:logsheet_app/data/dao/user_dao.dart';
// import 'package:provider/provider.dart';

// import '../../features/admin/admin_page.dart';
// import '../../features/user/user_page.dart';
// import '../../core/providers/user_provider.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   late final AppDatabase db;
//   late final UserDao userDao;

//   String? errorMessage;
//   bool isPasswordVisible = false;

//   @override
//   void initState() {
//     super.initState();
//     db = AppDatabase();
//     userDao = UserDao(db);
//   }

//   Future<void> _handleLogin() async {
//     final username = usernameController.text.trim();
//     final password = passwordController.text.trim();

//     // ✅ 1. Hardcoded login sementara
//     if (username == 'admin' && password == 'admin123') {
//       Provider.of<UserProvider>(context, listen: false).setUserName('admin');

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Login sebagai Admin (Hardcode) ✅')),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const AdminHomePage(userName: 'admin'),
//         ),
//       );
//       return;
//     }

//     // ✅ 2. Login normal ke database
//     final user = await userDao.login(username, password);

//     if (user != null) {
//       setState(() => errorMessage = null);
//       if (!mounted) return;

//       Provider.of<UserProvider>(
//         context,
//         listen: false,
//       ).setUserName(user.username);

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Login berhasil ✅')));

//       if (user.role == 'admin') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => AdminHomePage(userName: user.username),
//           ),
//         );
//       } else if (user.role == 'user') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => UserHomePage(userName: user.username),
//           ),
//         );
//       } else {
//         _showError("Role tidak dikenali");
//       }
//     } else {
//       setState(() {
//         errorMessage = 'Username atau password salah, atau akun tidak aktif.';
//       });
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   void dispose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     db.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEFF3F9),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(32),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 20,
//                   offset: Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Log In",
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   "Enter your details to login",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//                 const SizedBox(height: 32),

//                 TextFormField(
//                   controller: usernameController,
//                   decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.person),
//                     hintText: "Enter your username",
//                     filled: true,
//                     fillColor: const Color(0xFFF5F5F5),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 TextFormField(
//                   controller: passwordController,
//                   obscureText: !isPasswordVisible,
//                   decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.lock_outline),
//                     hintText: "Enter your password",
//                     filled: true,
//                     fillColor: const Color(0xFFF5F5F5),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         isPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() => isPasswordVisible = !isPasswordVisible);
//                       },
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 if (errorMessage != null)
//                   Text(
//                     errorMessage!,
//                     style: const TextStyle(color: Colors.red),
//                   ),

//                 const SizedBox(height: 16),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _handleLogin,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       "Log In",
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 Center(
//                   child: RichText(
//                     text: TextSpan(
//                       text: "Don't have an account? ",
//                       style: const TextStyle(color: Colors.black),
//                       children: [
//                         TextSpan(
//                           text: "Sign Up",
//                           style: const TextStyle(
//                             color: Colors.blue,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
