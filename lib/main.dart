import 'package:flutter/material.dart';
import 'package:logsheet_app/data/repositories/business_unit_repository.dart';
import 'package:logsheet_app/data/repositories/plant_repository.dart';
import 'package:logsheet_app/data/repositories/user_repository.dart';
import 'package:logsheet_app/data/services/business_unit_mysql_service.dart';
import 'package:logsheet_app/data/services/plant_mysql_service.dart';
import 'package:logsheet_app/data/services/user_mysql_service.dart';
import 'package:logsheet_app/features/admin/admin_page.dart';
import 'package:logsheet_app/providers/business_unit_provider.dart';
import 'package:logsheet_app/providers/plant_provider.dart';
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
        // Provide UserMySQL Service
        Provider<UserMySQLService>(create: (context) => UserMySQLService()),

        // Provide BusinessUnitMySQL Service
        Provider<BusinessUnitMySQLService>(
          create: (context) => BusinessUnitMySQLService(),
        ),

        // Provide PlantMySQL Service
        Provider<PlantMySQLService>(create: (context) => PlantMySQLService()),

        // Provide User Repository
        Provider<UserRepository>(
          create: (context) => UserRepository(context.read<UserMySQLService>()),
        ),

        // Provide Business Unit Repository
        Provider<BusinessUnitRepository>(
          create:
              (context) => BusinessUnitRepository(
                context.read<BusinessUnitMySQLService>(),
              ),
        ),

        // Provide Plant Repository
        Provider<PlantRepository>(
          create:
              (context) => PlantRepository(context.read<PlantMySQLService>()),
        ),

        // Provide The User Provider
        ChangeNotifierProvider(
          create: (context) => UserProvider(context.read<UserRepository>()),
        ),

        // Provide the Business Unit Provider
        ChangeNotifierProvider(
          create:
              (context) =>
                  BusinessUnitProvider(context.read<BusinessUnitRepository>()),
        ),

        // Provide Plant Provider
        ChangeNotifierProvider(
          create: (context) => PlantProvider(context.read<PlantRepository>()),
        ),

        //Provide Business Unit DAO
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
      // home: const LoginPage(),
      home: AdminHomePage(userName: 'admin'),
    );
  }
}
