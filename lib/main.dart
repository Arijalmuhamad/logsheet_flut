import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logsheet_app/core/theme/app_theme.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/data/repositories/daily_production/daily_production_refinery_repository.dart';
import 'package:logsheet_app/data/repositories/logsheet/deodorizing_filtration_repository.dart';
import 'package:logsheet_app/data/repositories/logsheet/pretreatment_bleaching_filtration_repository.dart';
import 'package:logsheet_app/data/repositories/maintenance/maintenance_lamps_and_glass_repository.dart';
import 'package:logsheet_app/data/repositories/master/business_unit_repository.dart';
import 'package:logsheet_app/data/repositories/master/data_form_no_repository.dart';
import 'package:logsheet_app/data/repositories/master/plant_repository.dart';
import 'package:logsheet_app/data/repositories/quality_report/quality_report_production_repository.dart';
import 'package:logsheet_app/data/repositories/quality_report/quality_report_qc_repository.dart';
import 'package:logsheet_app/data/repositories/master/user_repository.dart';
import 'package:logsheet_app/data/repositories/master/value_repository.dart';
import 'package:logsheet_app/data/services/daily_production/daily_production_refinery_mysql_service.dart';
import 'package:logsheet_app/data/services/logsheet/deodorizing_filtration_mysql_service.dart';
import 'package:logsheet_app/data/services/logsheet/pretreatment_bleaching_filtration_mysql_service.dart';
import 'package:logsheet_app/data/services/maintenance/maintenance_lamps_and_glass_mysql_service.dart';
import 'package:logsheet_app/data/services/master/business_unit_mysql_service.dart';
import 'package:logsheet_app/data/services/master/data_form_no_mysql_service.dart';
import 'package:logsheet_app/data/services/master/plant_mysql_service.dart';
import 'package:logsheet_app/data/services/quality_report/quality_report_production_mysql_service.dart';
import 'package:logsheet_app/data/services/quality_report/quality_report_qc_mysql_service.dart';
import 'package:logsheet_app/data/services/master/user_mysql_service.dart';
import 'package:logsheet_app/data/services/master/value_mysql_service.dart';
import 'package:logsheet_app/features/auth/auth_wrapper.dart';
import 'package:logsheet_app/providers/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/providers/logsheet/deodorizing_filtration_provider.dart';
import 'package:logsheet_app/providers/logsheet/pretreatment_bleaching_filtration_provider.dart';
import 'package:logsheet_app/providers/maintenance/maintenance_lamps_and_glass_provider.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_production_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_qc_provider.dart';
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
        // Provide Quality Report QC MySQL Service
        Provider<QualityReportQCMySQLService>(
          create: (context) => QualityReportQCMySQLService(),
        ),
        // Provide Quality Report Production MySQL Service
        Provider<QualityReportProductionMySQLService>(
          create: (context) => QualityReportProductionMySQLService(),
        ),
        // Provide Daily Production Refinery MySQL Service
        Provider<DailyProductionRefineryMySQLService>(
          create: (context) => DailyProductionRefineryMySQLService(),
        ),
        // Provider Maintenance Lamps And Glass MySQL Service
        Provider<MaintenanceLampsAndGlassMySQLService>(
          create: (context) => MaintenanceLampsAndGlassMySQLService(),
        ),
        // Provider Maintenance Lamps And Glass MySQL Service
        Provider<DataFormNoMySQLService>(
          create: (context) => DataFormNoMySQLService(),
        ),
        Provider<PretreatmentBleachingFiltrationMySQLService>(
          create: (context) => PretreatmentBleachingFiltrationMySQLService(),
        ),
        Provider<DeodorizingFiltrationMySQLService>(
          create: (context) => DeodorizingFiltrationMySQLService(),
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
        // Provide Quality Report QC Repository
        Provider<QualityReportQCRepository>(
          create:
              (context) => QualityReportQCRepository(
                context.read<QualityReportQCMySQLService>(),
              ),
        ),
        // Provide Quality Report Production Repository
        Provider<QualityReportProductionRepository>(
          create:
              (context) => QualityReportProductionRepository(
                context.read<QualityReportProductionMySQLService>(),
              ),
        ),
        // Provide Daily Production Refinery Repository
        Provider<DailyProductionRefineryRepository>(
          create:
              (context) => DailyProductionRefineryRepository(
                context.read<DailyProductionRefineryMySQLService>(),
              ),
        ),
        // Provide Maintenance Lamps And Glass Repository
        Provider<MaintenanceLampsAndGlassRepository>(
          create:
              (context) => MaintenanceLampsAndGlassRepository(
                context.read<MaintenanceLampsAndGlassMySQLService>(),
              ),
        ),
        // Provide Data Form No Repository
        Provider<DataFormNoRepository>(
          create:
              (context) =>
                  DataFormNoRepository(context.read<DataFormNoMySQLService>()),
        ),
        // Pretreatment Bleaching Filtration Repository
        Provider<PretreatmentBleachingFiltrationRepository>(
          create:
              (context) => PretreatmentBleachingFiltrationRepository(
                context.read<PretreatmentBleachingFiltrationMySQLService>(),
              ),
        ),
        // Pretreatment Bleaching Filtration Repository
        Provider<DeodorizingFiltrationRepository>(
          create:
              (context) => DeodorizingFiltrationRepository(
                context.read<DeodorizingFiltrationMySQLService>(),
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
        // Provide Quality Report QC Provider
        ChangeNotifierProvider(
          create:
              (context) => QualityReportQCProvider(
                context.read<QualityReportQCRepository>(),
              ),
        ),
        // Provide Quality Report Production Provider
        ChangeNotifierProvider(
          create:
              (context) => QualityReportProductionProvider(
                context.read<QualityReportProductionRepository>(),
              ),
        ),
        // Provide Quality Report Production Provider
        ChangeNotifierProvider(
          create:
              (context) => DailyProductionRefineryProvider(
                context.read<DailyProductionRefineryRepository>(),
              ),
        ),
        // Provide Maintenance Lamps And Glass Provider
        ChangeNotifierProvider(
          create:
              (context) => MaintenanceLampsAndGlassProvider(
                context.read<MaintenanceLampsAndGlassRepository>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  DataFormNoProvider(context.read<DataFormNoRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => PretreatmentBleachingFiltrationProvider(
                context.read<PretreatmentBleachingFiltrationRepository>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => DeodorizingFiltrationProvider(
                context.read<DeodorizingFiltrationRepository>(),
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
