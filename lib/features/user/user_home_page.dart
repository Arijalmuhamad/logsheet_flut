import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_lamp_glass/maintenance_lamps_glass_input_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_approval.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_data.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_list.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';
import '../auth/login_page.dart';

class UserHomePage extends StatefulWidget {
  final UserEntity userEntity;

  const UserHomePage({super.key, required this.userEntity});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  void _logout() async {
    final shouldLogout = await showDialog<bool>(
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (shouldLogout == true && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRole = widget.userEntity.role;
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Logsheet Automation',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: _buildDrawer(context, userRole, widget.userEntity),
      body: Center(
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
          child: Text(
            'Welcome, ${widget.userEntity.username}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, String userRole, UserEntity user) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary, // Brick Red
            ),
            //username, business unit, plant
            child: Column(
              children: [
                Spacer(),
                Consumer<UserProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.person, size: 36, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            user.username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // SizedBox(height: 10),
                Consumer<BusinessUnitProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 6),
                        Icon(Icons.business, size: 24, color: Colors.white),
                        SizedBox(width: 18),
                        Expanded(
                          child: Text(
                            provider.currentBusinessUnit != null
                                ? "${provider.currentBusinessUnit!.buCode} - ${provider.currentBusinessUnit!.buName}"
                                : "Code - Business Unit Name",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              // fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Consumer<PlantProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 6),
                        Icon(Icons.forest, size: 24, color: Colors.white),
                        SizedBox(width: 18),
                        Expanded(
                          child: Text(
                            provider.currentPlant != null
                                ? "${provider.currentPlant!.code} - ${provider.currentPlant!.name}"
                                : "Code - Plant",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              // fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
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
              if (userRole == "ADM" ||
                  userRole == "LEAD" ||
                  userRole == "OPR" ||
                  userRole == "MGR")
                ExpansionTile(
                  leading: const Icon(
                    Icons.factory_outlined,
                    color: Color(0xFF655F5B),
                  ),
                  title: const Text('Quality'),
                  childrenPadding: const EdgeInsets.only(left: 60.0),
                  children: [
                    if (userRole == "MGR")
                      ListTile(
                        leading: const Icon(
                          Icons.check_rounded,
                          color: Color(0xFF655F5B),
                        ),
                        title: const Text('Approval'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QualityApprovalListScreen(),
                              settings: const RouteSettings(
                                name: 'QualityReportList',
                              ),
                            ),
                          );
                        },
                      ),
                    ListTile(
                      leading: const Icon(Icons.list, color: Color(0xFF655F5B)),
                      title: const Text('Quality List'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QualityReportList(),
                            settings: const RouteSettings(
                              name: 'QualityReportList',
                            ),
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
                                (_) => QualityListPage(
                                  userName: widget.userEntity.username,
                                  role: widget.userEntity.role,
                                ),
                            settings: const RouteSettings(
                              name: 'QualityReports',
                            ),
                          ),
                        );
                      },
                    ),
                    // ListTile(
                    //   leading: const Icon(
                    //     Icons.info_outline,
                    //     color: Color(0xFF655F5B),
                    //   ),
                    //   title: const Text('Status'),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder:
                    //             (_) => StatusPage(
                    //               userName: widget.userEntity.username,
                    //             ),
                    //         settings: const RouteSettings(
                    //           name: 'QualityStatus',
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              // Submenu: Filtration Performance
              // ExpansionTile(
              //   leading: const Icon(
              //     Icons.water_damage_outlined,
              //     color: Color(0xFF655F5B),
              //   ),
              //   title: const Text('Filtration'),
              //   childrenPadding: const EdgeInsets.only(left: 60.0),
              //   children: [
              //     ListTile(
              //       leading: const Icon(Icons.input_outlined),
              //       title: const Text('Input'),
              //       onTap: () {
              //         Navigator.pop(context);
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder:
              //                 (_) => FiltrationPerformPage(
              //                   userName: widget.userEntity.username,
              //                 ),
              //             settings: const RouteSettings(
              //               name: 'FiltrationInput',
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ],
              // ),
              // Submenu: Filtration Performance
              // ExpansionTile(
              //   leading: const Icon(
              //     Icons.calendar_today,
              //     color: Color(0xFF655F5B),
              //   ),
              //   title: const Text('Daily Production'),
              //   childrenPadding: const EdgeInsets.only(left: 60.0),
              //   children: [
              //     ListTile(
              //       leading: const Icon(Icons.filter_list),
              //       title: const Text('Refinery'),
              //       onTap: () {
              //         Navigator.pop(context);
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder:
              //                 (_) => DailyProductionRefineryPage(
              //                   userName: widget.userEntity.username,
              //                 ),
              //             settings: const RouteSettings(
              //               name: 'FiltrationInput',
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //     ListTile(
              //       leading: const Icon(Icons.factory),
              //       title: const Text('Fractination'),
              //       onTap: () {
              //         Navigator.pop(context);
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder:
              //                 (_) => DailyProductionFractinationPage(
              //                   userName: widget.userEntity.username,
              //                 ),
              //             settings: const RouteSettings(
              //               name: 'FiltrationInput',
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ],
              // ),
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
              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 40.0),
              //   leading: const Icon(
              //     Icons.cleaning_services,
              //     color: Color(0xFF655F5B),
              //   ),
              //   title: const Text('Cleaning'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder:
              //             (_) => MaintenanceCleaningPage(
              //               userName: widget.userEntity.username,
              //             ),
              //         settings: const RouteSettings(name: 'Cleaning'),
              //       ),
              //     );
              //   },
              // ),
              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 40.0),
              //   leading: const Icon(
              //     Icons.track_changes,
              //     color: Color(0xFF655F5B),
              //   ),
              //   title: const Text('Dry Frac Monitor'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder:
              //             (_) => MaintenanceDryFracPage(
              //               userName: widget.userEntity.username,
              //             ),
              //         settings: const RouteSettings(name: 'DryFracMonitor'),
              //       ),
              //     );
              //   },
              // ),
              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 40.0),
              //   leading: const Icon(Icons.event_note, color: Color(0xFF655F5B)),
              //   title: const Text('Cleaning Schedule'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder:
              //             (_) => MaintenanceSchedulePage(
              //               userName: widget.userEntity.username,
              //             ),
              //         settings: const RouteSettings(name: 'CleaningSchedule'),
              //       ),
              //     );
              //   },
              // ),
              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 40.0),
              //   leading: const Icon(Icons.checklist, color: Color(0xFF655F5B)),
              //   title: const Text('Daily Check'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder:
              //             (_) => MaintenanceChecksheetPage(
              //               userName: widget.userEntity.username,
              //             ),
              //         settings: const RouteSettings(name: 'DailyCheck'),
              //       ),
              //     );
              //   },
              // ),
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
                          (_) => MaintenanceLampsGlassInputPage(
                            userName: widget.userEntity.username,
                          ),
                      settings: const RouteSettings(name: 'LampGlass'),
                    ),
                  );
                },
              ),
              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 40.0),
              //   leading: const Icon(Icons.filter_alt, color: Color(0xFF655F5B)),
              //   title: const Text('Niagara Filter'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder:
              //             (_) => MaintenanceFilterPage(
              //               userName: widget.userEntity.username,
              //             ),
              //         settings: const RouteSettings(name: 'NiagaraFilter'),
              //       ),
              //     );
              //   },
              // ),
              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 40.0),
              //   leading: const Icon(
              //     Icons.change_circle,
              //     color: Color(0xFF655F5B),
              //   ),
              //   title: const Text('Change Prod.'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder:
              //             (_) => MaintenanceChangeChecklistPage(
              //               userName: widget.userEntity.username,
              //             ),
              //         settings: const RouteSettings(name: 'ChangeProduct'),
              //       ),
              //     );
              //   },
              // ),
              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 40.0),
              //   leading: const Icon(
              //     Icons.play_circle_outline,
              //     color: Color(0xFF655F5B),
              //   ),
              //   title: const Text('Startup Prod.'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder:
              //             (_) => MaintenanceStartupPage(
              //               userName: widget.userEntity.username,
              //             ),
              //         settings: const RouteSettings(name: 'StartupProduct'),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),

          // ExpansionTile(
          //   leading: const Icon(Icons.bar_chart, color: Color(0xFF655F5B)),
          //   title: const Text(
          //     'Reports',
          //     style: TextStyle(color: Color(0xFF655F5B)),
          //   ),
          //   iconColor: Color(0xFFAB2F2B),
          //   collapsedIconColor: Colors.grey,
          //   children: <Widget>[
          //     ListTile(
          //       contentPadding: const EdgeInsets.only(left: 40.0),
          //       leading: const Icon(
          //         Icons.cleaning_services,
          //         color: Color(0xFF655F5B),
          //       ),
          //       title: const Text('Cleaning Report'),
          //       onTap: () {
          //         Navigator.pop(context);
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder:
          //                 (_) => MaintenanceCleaningPage(
          //                   userName: widget.userEntity.username,
          //                 ),
          //             settings: const RouteSettings(name: 'Cleaning'),
          //           ),
          //         );
          //       },
          //     ),
          //     ListTile(
          //       contentPadding: const EdgeInsets.only(left: 40.0),
          //       leading: const Icon(
          //         Icons.track_changes,
          //         color: Color(0xFF655F5B),
          //       ),
          //       title: const Text('Dry Frac Monitor'),
          //       onTap: () {
          //         Navigator.pop(context);
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder:
          //                 (_) => MaintenanceDryFracPage(
          //                   userName: widget.userEntity.username,
          //                 ),
          //             settings: const RouteSettings(name: 'DryFracMonitor'),
          //           ),
          //         );
          //       },
          //     ),
          //     ListTile(
          //       contentPadding: const EdgeInsets.only(left: 40.0),
          //       leading: const Icon(Icons.event_note, color: Color(0xFF655F5B)),
          //       title: const Text('Cleaning Schedule'),
          //       onTap: () {
          //         Navigator.pop(context);
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder:
          //                 (_) => MaintenanceSchedulePage(
          //                   userName: widget.userEntity.username,
          //                 ),
          //             settings: const RouteSettings(name: 'CleaningSchedule'),
          //           ),
          //         );
          //       },
          //     ),
          //     ListTile(
          //       contentPadding: const EdgeInsets.only(left: 40.0),
          //       leading: const Icon(Icons.checklist, color: Color(0xFF655F5B)),
          //       title: const Text('Daily Check'),
          //       onTap: () {
          //         Navigator.pop(context);
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder:
          //                 (_) => MaintenanceChecksheetReportPage(
          //                   userName: widget.userEntity.username,
          //                 ),
          //             settings: const RouteSettings(name: 'DailyCheck'),
          //           ),
          //         );
          //       },
          //     ),
          //     ListTile(
          //       contentPadding: const EdgeInsets.only(left: 40.0),
          //       leading: const Icon(
          //         Icons.lightbulb_outline,
          //         color: Color(0xFF655F5B),
          //       ),
          //       title: const Text('Lamp & Glass'),
          //       onTap: () {
          //         Navigator.pop(context);
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder:
          //                 (_) => MaintenanceLampsGlassPage(
          //                   userName: widget.userEntity.username,
          //                 ),
          //             settings: const RouteSettings(name: 'LampGlass'),
          //           ),
          //         );
          //       },
          //     ),
          //     ListTile(
          //       contentPadding: const EdgeInsets.only(left: 40.0),
          //       leading: const Icon(Icons.filter_alt, color: Color(0xFF655F5B)),
          //       title: const Text('Niagara Filter'),
          //       onTap: () {
          //         Navigator.pop(context);
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder:
          //                 (_) => MaintenanceFilterPage(
          //                   userName: widget.userEntity.username,
          //                 ),
          //             settings: const RouteSettings(name: 'NiagaraFilter'),
          //           ),
          //         );
          //       },
          //     ),
          //     ListTile(
          //       contentPadding: const EdgeInsets.only(left: 40.0),
          //       leading: const Icon(
          //         Icons.change_circle,
          //         color: Color(0xFF655F5B),
          //       ),
          //       title: const Text('Change Prod.'),
          //       onTap: () {
          //         Navigator.pop(context);
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder:
          //                 (_) => MaintenanceChangeChecklistPage(
          //                   userName: widget.userEntity.username,
          //                 ),
          //             settings: const RouteSettings(name: 'ChangeProduct'),
          //           ),
          //         );
          //       },
          //     ),
          //     ListTile(
          //       contentPadding: const EdgeInsets.only(left: 40.0),
          //       leading: const Icon(
          //         Icons.play_circle_outline,
          //         color: Color(0xFF655F5B),
          //       ),
          //       title: const Text('Startup Prod.'),
          //       onTap: () {
          //         Navigator.pop(context);
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder:
          //                 (_) => MaintenanceStartupPage(
          //                   userName: widget.userEntity.username,
          //                 ),
          //             settings: const RouteSettings(name: 'StartupProduct'),
          //           ),
          //         );
          //       },
          //     ),
          //   ],
          // ),

          // ListTile(
          //   leading: const Icon(Icons.upload, color: Color(0xFF655F5B)),
          //   title: const Text(
          //     'Upload',
          //     style: TextStyle(color: Color(0xFF655F5B)),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const UploadPage()),
          //     );
          //   },
          // ),

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
