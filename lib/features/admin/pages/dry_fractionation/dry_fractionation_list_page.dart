import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/display.dart';
import 'package:logsheet_app/core/utils/get_status_color.dart';
import 'package:logsheet_app/core/utils/get_status_text.dart';
import 'package:logsheet_app/data/remote/dry_fractionation/dry_fractionation_entity.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/admin/pages/dry_fractionation/dry_fractionation_detail_page.dart';
import 'package:logsheet_app/features/admin/pages/dry_fractionation/dry_fractionation_input_page.dart';
import 'package:logsheet_app/providers/dry_fractionation/dry_fractionation_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:logsheet_app/providers/master/user_provider.dart';
import 'package:provider/provider.dart';

class DryFractionationListPage extends StatefulWidget {
  const DryFractionationListPage({super.key});

  @override
  State<DryFractionationListPage> createState() =>
      _DryFractionationListPageState();
}

class _DryFractionationListPageState extends State<DryFractionationListPage> {
  DataFormNoEntity? form;
  @override
  void initState() {
    super.initState();
    final username = context.read<UserProvider>().currentUser?.username;
    final role = context.read<UserProvider>().currentUser?.role;
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => context.read<DryFractionationProvider>().fetchAllTickets(
        null,
        null,
        username ?? "",
        role ?? "",
        plantCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    form =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Logsheet_Dry_Fractionation" &&
                  form.isActive == "T",
            )
            .first;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          log("Tombol tambah Dry Fractionation Ticket diklik");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DryFractionationInputPage(form: form),
            ),
          );
        },
        label: const Text("Tambah Ticket"),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<DryFractionationProvider>(
      builder: (context, provider, child) {
        List<DryFractionationEntity> filteredList = provider.reportsList;
        if (provider.isLoadingFetchTickets) {
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
                    onPressed: () async {
                      final username =
                          context.read<UserProvider>().currentUser?.username;
                      final role =
                          context.read<UserProvider>().currentUser?.role;
                      final plantCode =
                          context.read<PlantProvider>().currentPlant?.code ??
                          "";

                      await context
                          .read<DryFractionationProvider>()
                          .fetchAllTickets(
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
                    onPressed: () async {
                      final username =
                          context.read<UserProvider>().currentUser?.username ??
                          "";
                      final role =
                          context.read<UserProvider>().currentUser?.role ?? "";
                      final plantCode =
                          context.read<PlantProvider>().currentPlant?.code ??
                          "";

                      await context
                          .read<DryFractionationProvider>()
                          .fetchAllTickets(
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
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 4),
          child: ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final item = filteredList[index];
              log("list from provider length ${provider.reportsList.length}");
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DryFractionationDetailPage(
                              item: item,
                              isDisplayed: true,
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
                                color: getStatusColor(item),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                getStatusText(item),
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
                              timeOfDayToString(
                                item.fillingStartTime ?? TimeOfDay.now(),
                              ),
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
                            Text("${item.workCenter}"),
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

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Dry Frac. List (${form?.code})"),
      actions: [
        context.watch<DryFractionationProvider>().isLoadingFetchTickets
            ? CircularProgressIndicator()
            : IconButton(
              onPressed: () async {
                final username =
                    context.read<UserProvider>().currentUser?.username;
                final role = context.read<UserProvider>().currentUser?.role;
                final plantCode =
                    context.read<PlantProvider>().currentPlant?.code ?? "";
                await context.read<DryFractionationProvider>().fetchAllTickets(
                  null,
                  null,
                  username ?? "",
                  role ?? "",
                  plantCode,
                );
              },
              icon: Consumer<DryFractionationProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoadingFetchTickets) {
                    return const CircularProgressIndicator();
                  }
                  return const Icon(Icons.replay);
                },
              ),
            ),
      ],
    );
  }
}
