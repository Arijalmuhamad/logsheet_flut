import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_porduction/fractination/fra_daily_production_page.dart';
import 'package:logsheet_app/features/admin/pages/daily_porduction/refinary/fer_daily_production_page.dart';
import 'package:logsheet_app/features/admin/pages/filtration/fp_input.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_data.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_input.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_status.dart';
import '../auth/login_page.dart';

class UserHomePage extends StatefulWidget {
  final UserEntity userEntity;

  const UserHomePage({super.key, required this.userEntity});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  void _logoutConfirmation() async {
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
          'User Page',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade100),
              child: Row(
                children: const [
                  Icon(Icons.account_circle, size: 40, color: Colors.blue),
                  SizedBox(width: 12),
                  Text(
                    'User Menu',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),

            userRole == "OPR"
                ? ExpansionTile(
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
                                      userName: widget.userEntity.username,
                                    ),
                                settings: const RouteSettings(
                                  name: 'QualityInput',
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
                                    ),
                                settings: const RouteSettings(
                                  name: 'QualityReports',
                                ),
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
                                builder:
                                    (_) => StatusPage(
                                      userName: widget.userEntity.username,
                                    ),
                                settings: const RouteSettings(
                                  name: 'QualityStatus',
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
                                      userName: widget.userEntity.username,
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
                                      userName: widget.userEntity.username,
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
                                      userName: widget.userEntity.username,
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
                )
                : SizedBox(),

            // ExpansionTile(
            //   leading: const Icon(Icons.settings_applications_outlined),
            //   title: const Text('Master'),
            //   iconColor: Colors.blue,
            //   collapsedIconColor: Colors.grey,
            //   children: [
            //     ListTile(
            //       contentPadding: const EdgeInsets.only(left: 40),
            //       leading: const Icon(Icons.person_outline),
            //       title: const Text('User Management'),
            //       onTap: () => Navigator.pop(context),
            //     ),
            //     ListTile(
            //       contentPadding: const EdgeInsets.only(left: 40),
            //       leading: const Icon(Icons.category_outlined),
            //       title: const Text('Category'),
            //       onTap: () => Navigator.pop(context),
            //     ),
            //     ListTile(
            //       contentPadding: const EdgeInsets.only(left: 40),
            //       leading: const Icon(Icons.storage_outlined),
            //       title: const Text('Data Storage'),
            //       onTap: () => Navigator.pop(context),
            //     ),
            //   ],
            // ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: _logoutConfirmation,
            ),
          ],
        ),
      ),
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
}
