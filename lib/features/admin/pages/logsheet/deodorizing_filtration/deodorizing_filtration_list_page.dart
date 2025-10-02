import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/logsheet/deodorizing_filtration_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/deodorizing_filtration/deodorizing_filtration_detail_page.dart';
import 'package:logsheet_app/features/admin/pages/logsheet/deodorizing_filtration/deodorizing_filtration_input_page.dart';
import 'package:logsheet_app/providers/logsheet/deodorizing_filtration_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class DeodorizingFiltrationListPage extends StatefulWidget {
  const DeodorizingFiltrationListPage({super.key});

  @override
  State<DeodorizingFiltrationListPage> createState() =>
      _DeodorizingFiltrationListPageState();
}

class _DeodorizingFiltrationListPageState
    extends State<DeodorizingFiltrationListPage> {
  DataFormNoEntity? formQualityRefinery;

  @override
  void initState() {
    super.initState();
    final username = context.read<UserProvider>().currentUser?.username;
    final role = context.read<UserProvider>().currentUser?.role;
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => context
          .read<DeodorizingFiltrationProvider>()
          .fetchAllTicket(null, null, username ?? "", role ?? "", plantCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    formQualityRefinery =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where((form) => form.isMenu == "Logsheet_Deodorizing_Filtration")
            .first;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          log("Tombol tambah Deodorizing Filtration dilick");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeodorizingFiltrationInputPage(),
            ),
          );
        },
        label: const Text("Tambah Ticket"),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() =>
      AppBar(title: Text("Deodorizing List (${formQualityRefinery?.code})"));

  Widget _buildBody() {
    return Consumer<DeodorizingFiltrationProvider>(
      builder: (context, provider, child) {
        List<DeodorizingFiltrationEntity> filteredList =
            provider.deodorizingList
                .where(
                  (e) => e.preparedStatus == null && e.checkedStatus == null,
                )
                .toList();
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (provider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Error: ${provider.errorMessage!}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      final username =
                          context.read<UserProvider>().currentUser?.username;
                      final role =
                          context.read<UserProvider>().currentUser?.role;
                      final plantCode =
                          context.read<PlantProvider>().currentPlant?.code ??
                          "";

                      context
                          .read<DeodorizingFiltrationProvider>()
                          .fetchAllTicket(
                            null,
                            null,
                            username ?? "",
                            role ?? "",
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
                    onPressed: () {
                      final username =
                          context.read<UserProvider>().currentUser?.username ??
                          "";
                      final role =
                          context.read<UserProvider>().currentUser?.role ?? "";
                      final plantCode =
                          context.read<PlantProvider>().currentPlant?.code ??
                          "";

                      context
                          .read<DeodorizingFiltrationProvider>()
                          .fetchAllTicket(
                            null,
                            null,
                            username,
                            role,
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
          padding: EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 4),
          child: ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final item = filteredList[index];
              log(
                "list from provider length ${provider.deodorizingList.length}",
              );
              return Card(
                child: InkWell(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DeodorizingFiltrationDetailPage(
                                item: item,
                                isDisplayed: true,
                              ),
                        ),
                      ),
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
                                item.id,
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
                                color: _getStatusColor(item),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getStatusText(item),
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
                              ).format(item.transactionDate!),
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
                            Text(
                              DateFormat('HH:mm').format(item.time!),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 16),
                            const Icon(
                              Icons.timelapse,
                              size: 18,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Shift ${item.shift}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/oil-refinery-tanks.svg',
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            Text("${item.refineryMachine}"),
                            const SizedBox(width: 50),

                            Icon(Icons.oil_barrel_rounded),
                            const SizedBox(width: 6),
                            Text(
                              item.oilType == null ? "N/A" : "${item.oilType}",
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

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
                              'Entried by: ${item.entryBy}',
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

  String _getStatusText(DeodorizingFiltrationEntity report) {
    if (report.checkedStatus == "Approved") {
      return "Approved";
    }

    if (report.checkedStatus == "Rejected") {
      return "Rejected";
    }
    if (report.preparedStatus != null) {
      return "Prepared ${report.shift}";
    }

    if (report.preparedStatus == "Rejected") {
      return "Rejected";
    }
    return "Submitted";
  }

  Color _getStatusColor(DeodorizingFiltrationEntity report) {
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
