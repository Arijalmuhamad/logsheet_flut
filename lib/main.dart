import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logsheet_app/core/theme/app_theme.dart';
import 'package:logsheet_app/data/repositories/maintenance/maintenance_lamps_and_glass_repository.dart';
import 'package:logsheet_app/data/repositories/master/business_unit_repository.dart';
import 'package:logsheet_app/data/repositories/master/plant_repository.dart';
import 'package:logsheet_app/data/repositories/transaction/quality_report_refinery_repository.dart';
import 'package:logsheet_app/data/repositories/master/user_repository.dart';
import 'package:logsheet_app/data/repositories/master/value_repository.dart';
import 'package:logsheet_app/data/services/maintenance/maintenance_lamps_and_glass_mysql_service.dart';
import 'package:logsheet_app/data/services/master/business_unit_mysql_service.dart';
import 'package:logsheet_app/data/services/master/plant_mysql_service.dart';
import 'package:logsheet_app/data/services/storage_service/storage_service.dart';
import 'package:logsheet_app/data/services/transaction/quality_report_refinery_mysql_service.dart';
import 'package:logsheet_app/data/services/master/user_mysql_service.dart';
import 'package:logsheet_app/data/services/master/value_mysql_service.dart';
import 'package:logsheet_app/features/auth/auth_wrapper.dart';
import 'package:logsheet_app/features/auth/login_page.dart';
import 'package:logsheet_app/providers/maintenance/maintenance_lamps_and_glass_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_refinery_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/database/app_database.dart';
import 'core/database/database_instance.dart'; // <-- ini penting
import 'data/dao/business_unit_dao.dart';
import 'providers/master/user_provider.dart';

void main() async {
  db =
      AppDatabase(); // ✅ inisialisasi instance ke variabel global di database_instance.dart
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        // Provide UserMySQL Service
        Provider<UserMySQLService>(create: (context) => UserMySQLService()),
        // Provide BusinessUnitMySQL Service
        Provider<BusinessUnitMySQLService>(
          create: (context) => BusinessUnitMySQLService(),
        ),
        // provide ValueMySQL Service
        Provider<ValueMySQLService>(create: (context) => ValueMySQLService()),
        // Provide PlantMySQL Service
        Provider<PlantMySQLService>(create: (context) => PlantMySQLService()),
        // Provide Quality Report Refinery MySQL Service
        Provider<QualityReportRefineryMysqlService>(
          create: (context) => QualityReportRefineryMysqlService(),
        ),
        // Provider Maintenance Lamps And Glass MySQL Service
        Provider<MaintenanceLampsAndGlassMySQLService>(
          create: (context) => MaintenanceLampsAndGlassMySQLService(),
        ),

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
        // Provide Value Repository
        Provider<ValueRepository>(
          create:
              (context) => ValueRepository(
                mySQLService: context.read<ValueMySQLService>(),
              ),
        ),
        // Provide Plant Repository
        Provider<PlantRepository>(
          create:
              (context) => PlantRepository(context.read<PlantMySQLService>()),
        ),
        // Provide Quality Report Refinery Repository
        Provider<QualityReportRefineryRepository>(
          create:
              (context) => QualityReportRefineryRepository(
                context.read<QualityReportRefineryMysqlService>(),
              ),
        ),
        // Provide Maintenance Lamps And Glass Repository
        Provider<MaintenanceLampsAndGlassRepository>(
          create:
              (context) => MaintenanceLampsAndGlassRepository(
                context.read<MaintenanceLampsAndGlassMySQLService>(),
              ),
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
        ChangeNotifierProvider(
          create: (context) => ValueProvider(context.read<ValueRepository>()),
        ),
        // Provide Plant Provider
        ChangeNotifierProvider(
          create: (context) => PlantProvider(context.read<PlantRepository>()),
        ),
        // Provide Quality Report Refinery Provider
        ChangeNotifierProvider(
          create:
              (context) => QualityReportRefineryProvider(
                context.read<QualityReportRefineryRepository>(),
              ),
        ),
        // Provide Maintenance Lamps And Glass Provider
        ChangeNotifierProvider(
          create:
              (context) => MaintenanceLampsAndGlassProvider(
                context.read<MaintenanceLampsAndGlassRepository>(),
              ),
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
    // final dummyEntity = UserEntity(
    //   userid: "123",
    //   username: "ADMIN",
    //   password: "",
    //   role: "ADM",
    //   isActive: "T",
    // );

    return MaterialApp(
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Logsheet Automation',
      theme: AppTheme.lightTheme,
      // home: const LoginPage(),
      // home: const MaintenanceLampsGlassPage(userName: "ADMIN"),
      // home: ApprovalListScreen(),
      // home: AdminHomePage(userEntity: dummyEntity, userName: "ADMIN"),
      // home: UserHomePage(userEntity: dummyEntity),
      home: AuthWrapper(),
    );
  }
}
