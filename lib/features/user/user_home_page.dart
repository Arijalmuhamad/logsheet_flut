import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/features/admin/pages/alerts/alerts_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_lamp_glass/maintenance_lamps_glass_approval_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_lamp_glass/maintenance_lamps_glass_input_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_lamp_glass/maintenance_lamps_glass_report_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_approval.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_data.dart';
import 'package:logsheet_app/features/admin/pages/quality/quality_report_list.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/transaction/quality_report_refinery_provider.dart';
import 'package:provider/provider.dart';
import '../auth/login_page.dart';

class UserHomePage extends StatefulWidget {
  final UserEntity userEntity;

  const UserHomePage({super.key, required this.userEntity});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Timer? _alertTimer;

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

  /// A reusable method to build consistently styled drawer items.
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF655F5B)),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
      dense: true,
    );
  }

  @override
  void initState() {
    super.initState();

    final userProvider = context.read<UserProvider>();

    if (userProvider.currentUser?.role == "MGR") {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await context
            .read<QualityReportRefineryProvider>()
            .fetchReadyForManagerApprovalReports();
      });
    }

    _alertTimer = Timer.periodic(const Duration(minutes: 3), (timer) {
      _fetchAlerts();
    });
  }

  void _fetchAlerts() {
    if (mounted) {
      final userProvider = context.read<UserProvider>();
      if (userProvider.currentUser?.role == "MGR") {
        context
            .read<QualityReportRefineryProvider>()
            .fetchReadyForManagerApprovalReports();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _alertTimer?.cancel();
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
        actions: [
          if (widget.userEntity.role == "MGR")
            Consumer<QualityReportRefineryProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlertsPage()),
                    );
                  },
                  icon:
                      provider.readyReportsList.isEmpty
                          ? Icon(Icons.notifications_rounded)
                          : Badge.count(
                            count: provider.readyReportsList.length,
                            child: Icon(Icons.notifications_rounded),
                          ),
                );
              },
            ),
          SizedBox(width: 20),
        ],
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
          _buildDrawerItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            onTap: () {
              Navigator.pop(context);
            },
          ),

          if (["ADM", "LEAD", "OPR", "MGR"].contains(userRole)) ...[
            _buildDrawerSubheader("Transactions"),
            ExpansionTile(
              leading: const Icon(
                Icons.factory_outlined,
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
              children: [
                // Manager-only Approval item
                if (["MGR", "ADM"].contains(userRole)) ...[
                  _buildDrawerItem(
                    icon: Icons.check_circle_outline,
                    title: 'Approval (F/QCO-002)',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QualityApprovalListScreen(),
                        ),
                      );
                    },
                  ),
                ],
                _buildDrawerItem(
                  icon: Icons.list_alt_outlined,
                  title: 'Quality List (F/QCO-002)',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QualityReportList()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Reports (F/QCO-002)',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => QualityListPage(
                              userName: user.username,
                              role: user.role,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],

          // Show Maintenance section for all roles (as per your original code)
          _buildDrawerSubheader("Maintenance"),
          ExpansionTile(
            leading: const Icon(
              Icons.lightbulb_outline_rounded,
              color: Color(0xFF655F5B),
            ),
            title: const Text(
              'Lamps & Glass',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 20.0),
            iconColor: const Color(0xFFAB2F2B),
            collapsedIconColor: Colors.grey,
            children: [
              // Show Approval only to Managers and Leads (you can adjust roles here)
              if (["MGR", "LEAD", "ADM"].contains(userRole))
                _buildDrawerItem(
                  icon: Icons.check_circle_outline,
                  title: 'Approval (F/RFA-013)',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MaintenanceLampsGlassApprovalPage(),
                      ),
                    );
                  },
                ),
              _buildDrawerItem(
                icon: Icons.input_rounded,
                title: 'Input (F/RFA-013)',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceLampsGlassInputPage(
                            userName: user.username,
                          ),
                    ),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.receipt_long_outlined,
                title: 'Report (F/RFA-013)',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MaintenanceLampsGlassReportPage(),
                    ),
                  );
                },
              ),
            ],
          ),
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
