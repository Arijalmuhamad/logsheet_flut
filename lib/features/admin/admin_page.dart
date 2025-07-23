import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/features/admin/pages/daily_porduction/refinary/fer_daily_production_page.dart';
import 'package:logsheet_app/features/admin/pages/daily_porduction/fractination/fra_daily_production_page.dart';
import 'package:logsheet_app/features/admin/pages/filtration/fp_input.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_cleaning/maintenance_cleaning_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_cleaning_checksheet/maintenance_daily_check_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_daily_check_report_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_dry_frac/maintenance_dry_frac_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_filter/maintenance_filter_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_lamp_glass/maintenance_lamp_glass_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_schedule/maintenance_schedule_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_startup/maintenance_startup_page.dart';
import 'package:logsheet_app/features/admin/pages/master/business_unit/business_unit_view.dart';
import 'package:logsheet_app/features/upload/upload_page.dart';
import 'package:logsheet_app/features/admin/pages/master/master_mastervalue.dart';
import '../auth/login_page.dart';
import 'pages/master/user/master_user.dart';
import 'pages/master/master_business_unit.dart';
import 'pages/quality/quality_report_input.dart';
import 'pages/quality/quality_report_data.dart';
import 'pages/quality/quality_report_status.dart';

// import 'pages/quality_report/quality_report_main.dart';

class AdminHomePage extends StatefulWidget {
  final String userName;
  final astronautBlue = const Color(0xFF00336E);
  const AdminHomePage({super.key, required this.userName});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Logout'),
            content: const Text('Apakah Anda yakin ingin logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (confirm == true && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: buildAppBar(),
      drawer: buildDrawer(context),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.account_circle,
              size: 64,
              color: Color(0xFFAB2F2B), // merah bata
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome, ${widget.userName}!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF655F5B), // abu gelap konsisten
                letterSpacing: 1.1,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                getMySQLConnection();
              },
              child: Text("Test Database Connection"),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)), // Neutral Gray
      title: const Text(
        'Admin Panel',
        style: TextStyle(
          color: Color(0xFF655F5B),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  // Function to build drawer
  Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFAB2F2B), // Brick Red
            ),
            child: Row(
              children: const [
                Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Admin Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.dashboard_outlined,
              color: Color(0xFF655F5B),
            ),
            title: const Text(
              'Dashboard',
              style: TextStyle(color: Color(0xFF655F5B)), // Neutral Gray
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            leading: const Icon(
              Icons.settings_applications_outlined,
              color: Color(0xFF655F5B),
            ),
            title: const Text(
              'Master',
              style: TextStyle(color: Color(0xFF655F5B)), // Neutral Gray
            ),
            iconColor: Color(0xFFAB2F2B), // Brick Red
            collapsedIconColor: Colors.grey,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(Icons.business, color: Color(0xFF655F5B)),
                title: const Text('Company'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MasterCompany()),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(Icons.forest, color: Color(0xFF655F5B)),
                title: const Text('Plant'),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(),
                  // );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(Icons.person, color: Color(0xFF655F5B)),
                title: const Text('Users'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MstUserPage(userName: widget.userName),
                      settings: const RouteSettings(name: 'Users'),
                    ),
                  );
                },
              ),
              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 40.0),
              //   leading: const Icon(Icons.apartment, color: Color(0xFF655F5B)),
              //   title: const Text('Biz Unit'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder:
              //             (_) => MstBusinessUnitPage(userName: widget.userName),
              //         settings: const RouteSettings(name: 'BusinessUnit'),
              //       ),
              //     );
              //   },
              // ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(
                  Icons.table_chart,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Values'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MstMastervaluePage(userName: widget.userName),
                      settings: const RouteSettings(name: 'MasterValues'),
                    ),
                  );
                },
              ),
            ],
          ),

          ExpansionTile(
            leading: const Icon(
              Icons.description_outlined,
              color: Color(0xFF655F5B),
            ),
            title: const Text(
              'Transaction',
              style: TextStyle(color: Color(0xFF655F5B)), // Neutral Gray
            ),
            iconColor: Color(0xFFAB2F2B),
            collapsedIconColor: Colors.grey,
            children: <Widget>[
              // Submenu: Quality Refinery
              ExpansionTile(
                leading: const Icon(
                  Icons.factory_outlined,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Quality'),
                childrenPadding: const EdgeInsets.only(left: 60.0),
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.input_outlined,
                      color: Color(0xFF655F5B),
                    ),
                    title: const Text('Input'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => QualityReportRefineryPage(
                                userName: widget.userName,
                              ),
                          settings: const RouteSettings(name: 'QualityInput'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.receipt_long,
                      color: Color(0xFF655F5B),
                    ),
                    title: const Text('Reports'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => QualityListPage(userName: widget.userName),
                          settings: const RouteSettings(name: 'QualityReports'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Color(0xFF655F5B),
                    ),
                    title: const Text('Status'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StatusPage(userName: widget.userName),
                          settings: const RouteSettings(name: 'QualityStatus'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // Submenu: Filtration Performance
              ExpansionTile(
                leading: const Icon(
                  Icons.water_damage_outlined,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Filtration'),
                childrenPadding: const EdgeInsets.only(left: 60.0),
                children: [
                  ListTile(
                    leading: const Icon(Icons.input_outlined),
                    title: const Text('Input'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => FiltrationPerformPage(
                                userName: widget.userName,
                              ),
                          settings: const RouteSettings(
                            name: 'FiltrationInput',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // Submenu: Filtration Performance
              ExpansionTile(
                leading: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Daily Production'),
                childrenPadding: const EdgeInsets.only(left: 60.0),
                children: [
                  ListTile(
                    leading: const Icon(Icons.filter_list),
                    title: const Text('Refinery'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DailyProductionRefineryPage(
                                userName: widget.userName,
                              ),
                          settings: const RouteSettings(
                            name: 'FiltrationInput',
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.factory),
                    title: const Text('Fractination'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DailyProductionFractinationPage(
                                userName: widget.userName,
                              ),
                          settings: const RouteSettings(
                            name: 'FiltrationInput',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          ExpansionTile(
            leading: const Icon(
              Icons.settings,
              color: Color(0xFF655F5B),
            ), // Neutral Gray
            title: const Text(
              'Maintenance',
              style: TextStyle(color: Color(0xFF655F5B)), // Neutral Gray
            ),
            iconColor: Color(0xFFAB2F2B), // Brick Red
            collapsedIconColor: Colors.grey,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(
                  Icons.cleaning_services,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Cleaning'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceCleaningPage(
                            userName: widget.userName,
                          ),
                      settings: const RouteSettings(name: 'Cleaning'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(
                  Icons.track_changes,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Dry Frac Monitor'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              MaintenanceDryFracPage(userName: widget.userName),
                      settings: const RouteSettings(name: 'DryFracMonitor'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(Icons.event_note, color: Color(0xFF655F5B)),
                title: const Text('Cleaning Schedule'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceSchedulePage(
                            userName: widget.userName,
                          ),
                      settings: const RouteSettings(name: 'CleaningSchedule'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(Icons.checklist, color: Color(0xFF655F5B)),
                title: const Text('Daily Check'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceChecksheetPage(
                            userName: widget.userName,
                          ),
                      settings: const RouteSettings(name: 'DailyCheck'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Lamp & Glass'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceLampsGlassPage(
                            userName: widget.userName,
                          ),
                      settings: const RouteSettings(name: 'LampGlass'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(Icons.filter_alt, color: Color(0xFF655F5B)),
                title: const Text('Niagara Filter'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              MaintenanceFilterPage(userName: widget.userName),
                      settings: const RouteSettings(name: 'NiagaraFilter'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(
                  Icons.change_circle,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Change Prod.'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceChangeChecklistPage(
                            userName: widget.userName,
                          ),
                      settings: const RouteSettings(name: 'ChangeProduct'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(
                  Icons.play_circle_outline,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Startup Prod.'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              MaintenanceStartupPage(userName: widget.userName),
                      settings: const RouteSettings(name: 'StartupProduct'),
                    ),
                  );
                },
              ),
            ],
          ),

          ExpansionTile(
            leading: const Icon(Icons.bar_chart, color: Color(0xFF655F5B)),
            title: const Text(
              'Reports',
              style: TextStyle(color: Color(0xFF655F5B)),
            ),
            iconColor: Color(0xFFAB2F2B),
            collapsedIconColor: Colors.grey,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(
                  Icons.cleaning_services,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Cleaning Report'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceCleaningPage(
                            userName: widget.userName,
                          ),
                      settings: const RouteSettings(name: 'Cleaning'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(
                  Icons.track_changes,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Dry Frac Monitor'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              MaintenanceDryFracPage(userName: widget.userName),
                      settings: const RouteSettings(name: 'DryFracMonitor'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(Icons.event_note, color: Color(0xFF655F5B)),
                title: const Text('Cleaning Schedule'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceSchedulePage(
                            userName: widget.userName,
                          ),
                      settings: const RouteSettings(name: 'CleaningSchedule'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(Icons.checklist, color: Color(0xFF655F5B)),
                title: const Text('Daily Check'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceChecksheetReportPage(
                            userName: widget.userName,
                          ),
                      settings: const RouteSettings(name: 'DailyCheck'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Lamp & Glass'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceLampsGlassPage(
                            userName: widget.userName,
                          ),
                      settings: const RouteSettings(name: 'LampGlass'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(Icons.filter_alt, color: Color(0xFF655F5B)),
                title: const Text('Niagara Filter'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              MaintenanceFilterPage(userName: widget.userName),
                      settings: const RouteSettings(name: 'NiagaraFilter'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(
                  Icons.change_circle,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Change Prod.'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceChangeChecklistPage(
                            userName: widget.userName,
                          ),
                      settings: const RouteSettings(name: 'ChangeProduct'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 40.0),
                leading: const Icon(
                  Icons.play_circle_outline,
                  color: Color(0xFF655F5B),
                ),
                title: const Text('Startup Prod.'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              MaintenanceStartupPage(userName: widget.userName),
                      settings: const RouteSettings(name: 'StartupProduct'),
                    ),
                  );
                },
              ),
            ],
          ),

          ListTile(
            leading: const Icon(Icons.upload, color: Color(0xFF655F5B)),
            title: const Text(
              'Upload',
              style: TextStyle(color: Color(0xFF655F5B)),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UploadPage()),
              );
            },
          ),

          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Settings'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     // Navigasi ke halaman Settings
          //   },
          // ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFAB2F2B)),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Color(0xFFAB2F2B),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
