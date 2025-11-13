import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:logsheet_app/data/services/storage_service/storage_service.dart';
import 'package:logsheet_app/features/admin/pages/alerts/alerts_page.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/approval/fra_daily_production_approval_list_page.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_daily_production_list_page.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_daily_production_report_list_page.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/approval/ref_daily_production_approval_list_page.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_daily_production_list_page.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/refinery/ref_daily_production_reports_list.dart';
import 'package:logsheet_app/features/admin/pages/dry_fractionation/dry_fractionation_approval_list_page.dart';
import 'package:logsheet_app/features/admin/pages/dry_fractionation/dry_fractionation_list_page.dart';
import 'package:logsheet_app/features/admin/pages/dry_fractionation/dry_fractionation_report_list_page.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/deodorizing_filtration/deodorizing_filtration_approval_list_page.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/deodorizing_filtration/deodorizing_filtration_list_page.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/deodorizing_filtration/deodorizing_filtration_report_list_page.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/pretreatment_bleaching_filtration/pretreatment_bleaching_filtration_apprroval_list_page.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/pretreatment_bleaching_filtration/pretreatment_bleaching_filtration_list_page.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/pretreatment_bleaching_filtration/pretreatment_bleaching_filtration_report_lists_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_approval_list_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_input_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_list_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_report_list_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_lamp_glass/maintenance_lamps_glass_approval_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_lamp_glass/maintenance_lamps_glass_input_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_lamp_glass/maintenance_lamps_glass_report_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_startup_production/maintenance_startup_production_approval_list_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_startup_production/maintenance_startup_production_list_page.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_startup_production/maintenance_startup_production_report_list_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_quality_refinery_500_mt_production/daily_quality_refinery_500_mt_production_list_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_approval_list_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_input_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_list_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/daily_storage_tank_analytical/daily_storage_tank_analytical_report_list_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/production/quality_approval_list_production_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/production/quality_list_production_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/production/quality_report_list_production_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/qc/quality_approval_list_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/qc/quality_report_list_page.dart';
import 'package:logsheet_app/features/admin/pages/quality/qc/quality_list_qc_page.dart';
import 'package:logsheet_app/providers/master/business_unit_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/quality/quality_report/quality_report_qc_provider.dart';
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
  DataFormNoEntity? formQualityRefineryQC,
      formPretreatment,
      formDeodorizing,
      formQualityReportProduction,
      formDailyProductionFractionation,
      formDailyProductionRefinery,
      formDryFractionation,
      formChecklistLampsAndGlassControl,
      formChangeProductChecklist,
      formStartupProductChecklist,
      formDailyStorageTankAnalytical;

  Future<void> _logout() async {
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

      final storage = StorageService();
      await storage.deleteAllLoginData();
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
            .read<QualityReportQCProvider>()
            .fetchReadyForManagerApprovalReports();
        if (!mounted) return;
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
            .read<QualityReportQCProvider>()
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
    formQualityRefineryQC =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) => form.isMenu == "Quality_Report" && form.isActive == "T",
            )
            .first;
    formQualityReportProduction =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Quality_Report_Production" &&
                  form.isActive == "T",
            )
            .first;
    formPretreatment =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Logsheet_Pretreatment_Bleaching_Filtration" &&
                  form.isActive == "T",
            )
            .first;

    formDeodorizing =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Logsheet_Deodorizing_Filtration" &&
                  form.isActive == "T",
            )
            .first;

    formDailyProductionFractionation =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Daily_Production_Fractionation" &&
                  form.isActive == "T",
            )
            .first;

    formDailyProductionRefinery =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Daily_Production_Refinery" &&
                  form.isActive == "T",
            )
            .first;

    formDryFractionation =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Logsheet_Dry_Fractionation" &&
                  form.isActive == "T",
            )
            .first;

    formChecklistLampsAndGlassControl =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Checklist_Lamps_And_Glass_Control" &&
                  form.isActive == "T",
            )
            .first;
    formChangeProductChecklist =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Change_Product_Checklist" &&
                  form.isActive == "T",
            )
            .first;

    formStartupProductChecklist =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Start_Up_Produksi_Checklist" &&
                  form.isActive == "T",
            )
            .first;

    formDailyStorageTankAnalytical =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Daily_Storage_Tank_Analytical" &&
                  form.isActive == "T",
            )
            .first;

    // Daily_Production_Refinery_Fractination
    final userRole = widget.userEntity.role;
    return Scaffold(
      drawerEnableOpenDragGesture: true,
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
            Consumer<QualityReportQCProvider>(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("Version 1.0.17"), Text("Build 2025-11-12")],
            ),
          ],
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
                    return Column(
                      children: [
                        Row(
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
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 6),
                            Icon(
                              Icons.assignment_ind_rounded,
                              size: 24,
                              color: Colors.white,
                            ),
                            SizedBox(width: 18),

                            Expanded(
                              child: Text(
                                user.role,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
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

          if (AppRoles.qualityControlAccess.contains(userRole)) ...[
            _buildDrawerSubheader("Quality Control"),
            ExpansionTile(
              leading: const Icon(Icons.analytics, color: Color(0xFF655F5B)),
              title: Text(
                'Daily Storage Tank Analytical\n(${formDailyStorageTankAnalytical?.code})',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              childrenPadding: const EdgeInsets.only(left: 20.0),
              iconColor: const Color(0xFFAB2F2B),
              collapsedIconColor: Colors.grey,
              children: [
                _buildDrawerItem(
                  icon: Icons.list_alt,
                  title: 'List\n(${formDailyStorageTankAnalytical?.code})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DailyStorageTankAnalyticalListPage(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.list_alt,
                  title: 'Report\n(${formDailyStorageTankAnalytical?.code})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DailyStorageTankAnalyticalReportListPage(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.list_alt,
                  title: 'Approval\n(${formDailyStorageTankAnalytical?.code})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DailyStorageTankAnalyticalApprovalListPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(
                Icons.factory_outlined,
                color: Color(0xFF655F5B),
              ),
              title: Text(
                '${formQualityRefineryQC?.treeMenu} \n(${formQualityRefineryQC?.name}) ',
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
                _buildDrawerItem(
                  icon: Icons.list_alt_outlined,
                  title: 'Quality List (${formQualityRefineryQC?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QualityReportQCList()),
                    );
                  },
                ),
                if (AppRoles.qualityControlManagerApproval.contains(
                  userRole,
                )) ...[
                  _buildDrawerItem(
                    icon: Icons.check_circle_outline,
                    title: 'Approval (${formQualityRefineryQC?.name})',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QualityApprovalListScreenPage(),
                        ),
                      );
                    },
                  ),
                ],
                _buildDrawerItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Reports (${formQualityRefineryQC?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => QualityReportListPage(
                              userName: user.username,
                              role: user.role,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // ExpansionTile(
            //   leading: const Icon(Icons.analytics, color: Color(0xFF655F5B)),
            //   title: Text(
            //     'Daily Quality Refinery 500 MT Prodcuction\n(${formStartupProductChecklist?.code})',
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
            //       icon: Icons.list_alt,
            //       title: 'List\n(${formStartupProductChecklist?.code})',
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder:
            //                 (_) =>
            //                     DailyQualityRefinery500MtProductionListPage(),
            //           ),
            //         );
            //       },
            //     ),
            //   ],
            // ),
          ],

          if (AppRoles.productionQualityAccess.contains(userRole)) ...[
            _buildDrawerSubheader("Production"),
            ExpansionTile(
              leading: const Icon(
                Icons.factory_outlined,
                color: Color(0xFF655F5B),
              ),
              title: Text(
                // 'Quality Refinery List \n(${formQualityReportProduction?.code})',
                '${formQualityReportProduction?.treeMenu} \n(${formQualityReportProduction?.name})',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              childrenPadding: const EdgeInsets.only(left: 20.0),
              iconColor: const Color(0xFFAB2F2B),
              collapsedIconColor: Colors.grey,
              children: [
                _buildDrawerItem(
                  icon: Icons.list_alt_outlined,
                  title: 'Quality List ${formQualityReportProduction?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QualityReportProductionList(),
                      ),
                    );
                  },
                ),
                // Manager-only Approval item
                if (AppRoles.productionQualityManagerApproval.contains(
                  userRole,
                )) ...[
                  _buildDrawerItem(
                    icon: Icons.check_circle_outline,
                    title: 'Approval (${formQualityReportProduction?.name})',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QualityApprovalListProductionPage(),
                        ),
                      );
                    },
                  ),
                ],
                _buildDrawerItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Reports (${formQualityReportProduction?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => QualityReportListProductionPage(
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
          if (AppRoles.logsheetAccess.contains(userRole)) ...[
            ExpansionTile(
              leading: const Icon(
                Icons.article_rounded,
                color: Color(0xFF655F5B),
              ),
              title: Text(
                '${formPretreatment?.treeMenu}\n (${formPretreatment?.name})',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              childrenPadding: const EdgeInsets.only(left: 20.0),
              iconColor: const Color(0xFFAB2F2B),
              collapsedIconColor: Colors.grey,
              children: [
                _buildDrawerItem(
                  icon: Icons.list_alt_outlined,
                  title: 'List ${formPretreatment?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                LogsheetPretreatmentBleachingFiltrationListPage(),
                      ),
                    );
                  },
                ),
                // Manager-only Approval item
                if (AppRoles.logsheetManagerApproval.contains(userRole)) ...[
                  _buildDrawerItem(
                    icon: Icons.check_circle_outline,
                    title: 'Approval (${formPretreatment?.name})',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  PretreatmentBleachingFiltrationApprovalListPage(),
                        ),
                      );
                    },
                  ),
                ],
                _buildDrawerItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Reports (${formPretreatment?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                LogsheetPretreatmentBleachingFiltrationReportListsPage(
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
          // Deodorizing Filtration Logsheet
          if (AppRoles.logsheetAccess.contains(userRole)) ...[
            ExpansionTile(
              leading: const Icon(
                Icons.article_rounded,
                color: Color(0xFF655F5B),
              ),
              title: Text(
                '${formDeodorizing?.treeMenu} \n(${formDeodorizing?.name})',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              childrenPadding: const EdgeInsets.only(left: 20.0),
              iconColor: const Color(0xFFAB2F2B),
              collapsedIconColor: Colors.grey,
              children: [
                _buildDrawerItem(
                  icon: Icons.list_alt_outlined,
                  title: 'List (${formDeodorizing?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeodorizingFiltrationListPage(),
                      ),
                    );
                  },
                ),
                // Manager-only Approval item
                if (AppRoles.logsheetManagerApproval.contains(userRole)) ...[
                  _buildDrawerItem(
                    icon: Icons.check_circle_outline,
                    title: 'Approval (${formDeodorizing?.name})',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DeodorizingFiltrationApprovalListPage(),
                        ),
                      );
                    },
                  ),
                ],
                _buildDrawerItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Reports (${formDeodorizing?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DeodorizingFiltrationReportListPage(
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
          if (AppRoles.logsheetAccess.contains(userRole)) ...[
            ExpansionTile(
              leading: const Icon(
                Icons.article_rounded,
                color: Color(0xFF655F5B),
              ),
              title: Text(
                '${formDryFractionation?.treeMenu}\n (${formDryFractionation?.name})',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              childrenPadding: const EdgeInsets.only(left: 20.0),
              iconColor: const Color(0xFFAB2F2B),
              collapsedIconColor: Colors.grey,
              children: [
                _buildDrawerItem(
                  icon: Icons.list_alt_outlined,
                  title: 'List ${formDryFractionation?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DryFractionationListPage(),
                      ),
                    );
                  },
                ),
                // Manager-only Approval item
                if (AppRoles.logsheetManagerApproval.contains(userRole)) ...[
                  _buildDrawerItem(
                    icon: Icons.check_circle_outline,
                    title: 'Approval (${formDryFractionation?.name})',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DryFractionationApprovalListPage(),
                        ),
                      );
                    },
                  ),
                ],
                _buildDrawerItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Reports (${formDryFractionation?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DryFractionationReportListPage(
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

          // Daily Productions
          if (AppRoles.logsheetAccess.contains(userRole)) ...[
            _buildDrawerSubheader("Daily Production"),
            ExpansionTile(
              leading: const Icon(
                Icons.article_rounded,
                color: Color(0xFF655F5B),
              ),
              title: Text(
                'Refinery\n(${formDailyProductionRefinery?.name})',
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
                _buildDrawerItem(
                  icon: Icons.list_alt_outlined,
                  title: 'List (${formDailyProductionRefinery?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DailyProductionRefineryListPage(
                              dataForm: formDailyProductionRefinery!,
                            ),
                      ),
                    );
                  },
                ),
                if (AppRoles.productionManagerApproval.contains(userRole)) ...[
                  _buildDrawerItem(
                    icon: Icons.check_circle_outline,
                    title: 'Approval (${formDailyProductionRefinery?.name})',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DailyProductionRefineryApprovalListPage(),
                        ),
                      );
                    },
                  ),
                ],
                _buildDrawerItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Reports (${formDailyProductionRefinery?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DailyProductionRefineryReportListPage(
                              userName: user.username,
                              role: userRole,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(
                Icons.article_rounded,
                color: Color(0xFF655F5B),
              ),
              title: Text(
                'Fractionation\n(${formDailyProductionFractionation?.name})',
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
                _buildDrawerItem(
                  icon: Icons.list_alt_outlined,
                  title: 'List (${formDailyProductionFractionation?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DailyProductionFractionationListPage(
                              formData: formDailyProductionFractionation!,
                            ),
                      ),
                    );
                  },
                ),
                if (AppRoles.productionManagerApproval.contains(userRole)) ...[
                  _buildDrawerItem(
                    icon: Icons.check_circle_outline,
                    title:
                        'Approval (${formDailyProductionFractionation?.name})',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  DailyProductionFractionationApprovalListPage(),
                        ),
                      );
                    },
                  ),
                ],
                _buildDrawerItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Reports (${formDailyProductionFractionation?.name})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DailyProductionFractionationReportListPage(
                              userName: user.username,
                              role: userRole,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
          // Show Maintenance section for all roles
          _buildDrawerSubheader("Maintenance"),
          ExpansionTile(
            leading: const Icon(
              Icons.lightbulb_outline_rounded,
              color: Color(0xFF655F5B),
            ),
            title: Text(
              'Lamps & Glass\n(${formChecklistLampsAndGlassControl?.code})',
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
              if (AppRoles.managerProd.contains(userRole))
                _buildDrawerItem(
                  icon: Icons.check_circle_outline,
                  title:
                      'Approval (${formChecklistLampsAndGlassControl?.code})',
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
                title: 'Input (${formChecklistLampsAndGlassControl?.code})',
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
                title: 'Report (${formChecklistLampsAndGlassControl?.code})',
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
          if (AppRoles.productionQualityAccess.contains(userRole)) ...[
            ExpansionTile(
              leading: const Icon(
                Icons.change_circle_outlined,
                color: Color(0xFF655F5B),
              ),
              title: Text(
                'Change Product Checklist\n(${formChangeProductChecklist?.code})',
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
                _buildDrawerItem(
                  icon: Icons.list_alt,
                  title: 'List (${formChangeProductChecklist?.code})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MaintenanceChangeProductListPage(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Report (${formChangeProductChecklist?.code})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => MaintenanceChangeProductReportListPage(),
                      ),
                    );
                  },
                ),
                if (AppRoles.managerProd.contains(userRole))
                  _buildDrawerItem(
                    icon: Icons.check_circle_outline,
                    title: 'Approval (${formChangeProductChecklist?.code})',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => MaintenanceChangeProductApprovalListPage(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],

          ExpansionTile(
            leading: const Icon(
              Icons.arrow_circle_up_rounded,
              color: Color(0xFF655F5B),
            ),
            title: Text(
              'StartUp Product Checklist\n(${formStartupProductChecklist?.code})',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 20.0),
            iconColor: const Color(0xFFAB2F2B),
            collapsedIconColor: Colors.grey,
            children: [
              _buildDrawerItem(
                icon: Icons.list_alt,
                title: 'List\n(${formStartupProductChecklist?.code})',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MaintenanceStartupProductionListPage(),
                    ),
                  );
                },
              ),

              _buildDrawerItem(
                icon: Icons.receipt_long_outlined,
                title: 'Report\n(${formStartupProductChecklist?.code})',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MaintenanceStartupProductionReportListPage(),
                    ),
                  );
                },
              ),
              if (AppRoles.managerProd.contains(userRole))
                _buildDrawerItem(
                  icon: Icons.check_circle_outline,
                  title: 'Approval\n(${formStartupProductChecklist?.code})',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                MaintenanceStartupProductionApprovalListPage(),
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
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
