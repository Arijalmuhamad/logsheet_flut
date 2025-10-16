import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/data/services/storage_service/storage_service.dart';
import 'package:logsheet_app/features/admin/pages/master/business_unit/business_unit_page.dart';
import 'package:logsheet_app/features/admin/pages/master/plant/plant_page.dart';
import 'package:logsheet_app/features/admin/pages/master/user/user_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/qc/quality_approval_list_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/qc/quality_list_qc_page.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';
import '../auth/login_page.dart';
import 'pages/quality/qc/quality_report_list_page.dart';

// import 'pages/quality_report/quality_report_main.dart';

class AdminHomePage extends StatefulWidget {
  final UserEntity userEntity;
  final String userName;
  final astronautBlue = const Color(0xFF00336E);
  const AdminHomePage({
    super.key,
    required this.userEntity,
    required this.userName,
  });

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  DataFormNoEntity? formData;

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
      final storage = StorageService();
      await storage.deleteAllLoginData();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where((form) => form.isMenu == "Quality_Report")
            .first;
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
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
              'Welcome, ${widget.userEntity.username}!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF655F5B), // abu gelap konsisten
                letterSpacing: 1.1,
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     getMySQLConnection();
            //   },
            //   child: Text("Test Database Connection"),
            // ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(title: const Text('Logsheet Automation'));
  }

  Widget _buildDrawerSubheader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required GestureTapCallback onTap,
    String? formCode,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF655F5B)),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight:
                  FontWeight.w600, // Slightly less bold for a cleaner look
            ),
          ),
          if (formCode != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      formCode,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      onTap: onTap,
      dense: true, // Reduces vertical padding for a more compact list
    );
  }

  // Function to build drawer
  Widget _buildDrawer(BuildContext context) {
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
                            provider.currentUser != null
                                ? provider.currentUser!.username
                                : "User",
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
                            style: TextStyle(color: Colors.white, fontSize: 14),
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
          _buildDrawerItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            onTap: () {
              Navigator.pop(context); // Close drawer and stay on the home page
            },
          ),
          // -- Master Data Section --
          _buildDrawerSubheader("Master Data"),
          _buildDrawerItem(
            icon: Icons.business,
            title: 'Business Units',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BusinessUnitPage()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.forest,
            title: 'Plant',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlantPage()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.person_outline,
            title: 'Users',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserPage()),
              );
            },
          ),

          // -- Transactions Section --
          _buildDrawerSubheader("Transactions"),
          ExpansionTile(
            leading: const Icon(
              Icons.description_outlined,
              color: Color(0xFF655F5B),
            ),
            title: const Text(
              'Quality',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 20.0),
            iconColor: const Color(0xFFAB2F2B),
            collapsedIconColor: Colors.grey,
            children: <Widget>[
              _buildDrawerItem(
                icon: Icons.check_circle_outline,
                title: 'Approval',
                formCode: "(${formData!.code})",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QualityApprovalListScreenPage(),
                    ),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.list_alt_outlined,
                title: 'Quality List',
                formCode: "(${formData!.code})",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => QualityReportQCList()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.receipt_long_outlined,
                title: 'Reports',
                formCode: "(${formData!.code})",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => QualityReportListPage(
                            userName: widget.userEntity.username,
                            role: widget.userEntity.role,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
          // ExpansionTile(
          //   leading: const Icon(
          //     Icons.water_damage_outlined,
          //     color: Color(0xFF655F5B),
          //   ),
          //   title: const Text(
          //     'Logsheet',
          //     style: TextStyle(
          //       color: Colors.black87,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          //   childrenPadding: const EdgeInsets.only(left: 20.0),
          //   iconColor: const Color(0xFFAB2F2B),
          //   collapsedIconColor: Colors.grey,
          //   children: <Widget>[
          //     _buildDrawerItem(
          //       icon: Icons.input_rounded,
          //       title: 'Input',
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder:
          //                 (_) => FiltrationPerformInputPage(
          //                   userName: widget.userEntity.username,
          //                 ),
          //           ),
          //         );
          //       },
          //     ),
          //     // Add other Logsheet items here if needed
          //   ],
          // ),

          // -- Maintenance Section --
          // _buildDrawerSubheader("Maintenance"),
          // ExpansionTile(
          //   leading: const Icon(
          //     Icons.lightbulb_outline_rounded,
          //     color: Color(0xFF655F5B),
          //   ),
          //   title: const Text(
          //     'Lamps & Glass',
          //     style: TextStyle(
          //       color: Colors.black87,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          //   childrenPadding: const EdgeInsets.only(left: 20.0),
          //   iconColor: const Color(0xFFAB2F2B),
          //   collapsedIconColor: Colors.grey,
          //   children: [
          //     _buildDrawerItem(
          //       icon: Icons.check_circle_outline,
          //       title: 'Approval',
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) => MaintenanceLampsGlassApprovalPage(),
          //           ),
          //         );
          //       },
          //     ),
          //     _buildDrawerItem(
          //       icon: Icons.input_rounded,
          //       title: 'Input',
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder:
          //                 (_) => MaintenanceLampsGlassInputPage(
          //                   userName: widget.userEntity.username,
          //                 ),
          //           ),
          //         );
          //       },
          //     ),
          //     _buildDrawerItem(
          //       icon: Icons.receipt_long_outlined,
          //       title: 'Report',
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) => MaintenanceLampsGlassReportPage(),
          //           ),
          //         );
          //       },
          //     ),
          //   ],
          // ),

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
          // -- Footer Section --
          const Divider(height: 24, thickness: 1, indent: 16, endIndent: 16),
          _buildDrawerItem(icon: Icons.logout, title: 'Logout', onTap: _logout),
        ],
      ),
    );
  }
}
