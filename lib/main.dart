import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/database/app_database.dart';
import 'core/database/database_instance.dart'; // <-- ini penting
import 'data/dao/business_unit_dao.dart';
import 'providers/user_provider.dart';
import 'features/auth/login_page.dart';

void main() {
  db =
      AppDatabase(); // ✅ inisialisasi instance ke variabel global di database_instance.dart

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider<BusinessUnitDao>(create: (_) => BusinessUnitDao(db)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Logsheet App',
      theme: ThemeData(
        primaryColor: Color(0xFFAB2F2B),
        scaffoldBackgroundColor: Color(0xFFEFF3F9),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF655F5B)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFAB2F2B),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
