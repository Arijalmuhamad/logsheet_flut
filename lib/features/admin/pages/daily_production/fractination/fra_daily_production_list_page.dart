import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_daily_production_detail_page.dart';
import 'package:logsheet_app/features/admin/pages/daily_production/fractination/fra_daily_production_input_page.dart';
import 'package:logsheet_app/providers/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionFractionationListPage extends StatefulWidget {
  const DailyProductionFractionationListPage({
    super.key,
    required this.formData,
  });
  final DataFormNoEntity formData;

  @override
  State<DailyProductionFractionationListPage> createState() =>
      _DailyProductionFractionationListPageState();
}

class _DailyProductionFractionationListPageState
    extends State<DailyProductionFractionationListPage> {
  @override
  void initState() {
    super.initState();
    final username = context.read<UserProvider>().currentUser?.username;
    final role = context.read<UserProvider>().currentUser?.role;
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<DailyProductionFractionationProvider>()
          .fetchAllTickets(null, null, username ?? "", role ?? "", plantCode);
      if (!mounted) return;
      await context.read<ValueProvider>().fetchAllInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: Consumer<UserProvider>(
        builder:
            (context, provider, child) => FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DailyProductionFractinationInputPage(
                          dataForm: widget.formData,
                          userName: provider.currentUser?.username ?? "",
                        ),
                  ),
                );
              },
              label: const Text("Tambah Ticket"),
              icon: Icon(Icons.add),
              backgroundColor: Color(0xFFB91C1C),
              foregroundColor: Colors.white,
            ),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer3<
      DailyProductionFractionationProvider,
      PlantProvider,
      UserProvider
    >(
      builder: (
        context,
        dailyProdFracProvider,
        plantprovider,
        userProvider,
        child,
      ) {
        List<DailyProductionFractionationEntity> filteredList =
            dailyProdFracProvider.reportsList
                .where(
                  (e) => e.preparedStatus == null && e.checkedStatus == null,
                )
                .toList();
        if (dailyProdFracProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (dailyProdFracProvider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Error: ${dailyProdFracProvider.errorMessage!}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final plantCode = plantprovider.currentPlant?.code ?? "";

                      await dailyProdFracProvider.fetchAllTickets(
                        null,
                        null,
                        userProvider.currentUser?.username ?? "",
                        userProvider.currentUser?.role ?? "",
                        plantCode,
                      );
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
          );
        }
        if (filteredList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No data',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final plantCode = plantprovider.currentPlant?.code ?? "";

                      await dailyProdFracProvider.fetchAllTickets(
                        null,
                        null,
                        userProvider.currentUser?.username ?? "",
                        userProvider.currentUser?.role ?? "",
                        plantCode,
                      );
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final report = filteredList[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => DailyProductionFractionationDetailPage(
                              item: report,
                              formData: widget.formData,
                            ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 18.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                report.id,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(report),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getStatusText(report),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),

                        // Transaction Date and Time
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat(
                                'yyyy-MM-dd',
                              ).format(report.transactionDate!),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 16),
                            const Icon(
                              Icons.schedule,
                              size: 18,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            // Text(
                            //   DateFormat('HH:mm').format(report.time!),
                            //   style: const TextStyle(
                            //     fontSize: 14,
                            //     color: Colors.black87,
                            //   ),
                            // ),
                            SizedBox(width: 16),
                            const Icon(
                              Icons.timelapse,
                              size: 18,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Shift ${report.shift}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Entered By
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Entried by: ${report.entryBy}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Fractionation List (${widget.formData.code})"),
      actions: [
        context.watch<DailyProductionFractionationProvider>().isLoading
            ? CircularProgressIndicator()
            : IconButton(
              onPressed: () async {
                final username =
                    context.read<UserProvider>().currentUser?.username;
                final role = context.read<UserProvider>().currentUser?.role;
                final plantCode =
                    context.read<PlantProvider>().currentPlant?.code ?? "";
                await context
                    .read<DailyProductionFractionationProvider>()
                    .fetchAllTickets(
                      null,
                      null,
                      username ?? "",
                      role ?? "",
                      plantCode,
                    );
              },
              icon: Consumer<DailyProductionFractionationProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  return const Icon(Icons.replay);
                },
              ),
            ),
      ],
    );
  }

  String _getStatusText(DailyProductionFractionationEntity report) {
    if (report.checkedStatus == "Approved") {
      return "Approved";
    }

    if (report.checkedStatus == "Rejected") {
      return "Rejected";
    }
    if (report.preparedStatus == "Approved") {
      return "Prepared ${report.shift}";
    }

    if (report.preparedStatus == "Rejected") {
      return "Rejected";
    }
    return "Submitted";
  }

  Color _getStatusColor(DailyProductionFractionationEntity report) {
    if (report.checkedStatus == "Approved") {
      return Colors.green;
    }

    if (report.checkedStatus == "Rejected") {
      return Colors.red;
    }

    if (report.preparedStatus == "Approved") {
      return Colors.orangeAccent;
    }

    if (report.preparedStatus == "Rejected") {
      return Colors.red;
    }
    return Colors.grey;
  }
}
