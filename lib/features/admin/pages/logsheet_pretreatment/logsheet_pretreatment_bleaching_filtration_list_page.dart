import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/data_form_no_entity.dart';
import 'package:logsheet_app/data/remote/transactions/pretreatment_bleaching_filtration_entity.dart';
import 'package:logsheet_app/features/admin/pages/logsheet_pretreatment/logsheet_pretreatment_bleaching_filtration_input_page.dart';
import 'package:logsheet_app/providers/logsheet/pretreatment_bleaching_filtration_provider.dart';
import 'package:logsheet_app/providers/master/data_form_no_provider.dart';
import 'package:logsheet_app/providers/master/plant_provider.dart';
import 'package:provider/provider.dart';

class LogsheetPretreatmentBleachingFiltrationListPage extends StatefulWidget {
  const LogsheetPretreatmentBleachingFiltrationListPage({super.key});

  @override
  State<LogsheetPretreatmentBleachingFiltrationListPage> createState() =>
      _LogsheetPretreatmentBleachingFiltrationListPageState();
}

class _LogsheetPretreatmentBleachingFiltrationListPageState
    extends State<LogsheetPretreatmentBleachingFiltrationListPage> {
  DataFormNoEntity? formQualityRefinery;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) =>
          context
              .read<PretreatmentBleachingFiltrationProvider>()
              .fetchAllLogsheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    formQualityRefinery =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Logsheet_Pretreatment_Bleaching_Filtration",
            )
            .first;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          log("Tombol tambah PBE logsheet diklik");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FiltrationPerformInputPage(),
            ),
          );
        },
        label: const Text("Tambah Logsheet"),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() =>
      AppBar(title: Text("PBF List (${formQualityRefinery?.code})"));

  Widget _buildBody() {
    return Consumer<PretreatmentBleachingFiltrationProvider>(
      builder: (context, provider, child) {
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
                      // final plantCode =
                      //     Provider.of<PlantProvider>(
                      //       context,
                      //       listen: false,
                      //     ).currentPlant?.code ??
                      //     "";

                      Provider.of<PretreatmentBleachingFiltrationProvider>(
                        context,
                        listen: false,
                      ).fetchAllLogsheet();
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.pretreatmentList.isEmpty) {
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
                      // final plantCode =
                      //     Provider.of<PlantProvider>(
                      //       context,
                      //       listen: false,
                      //     ).currentPlant?.code ??
                      //     "";

                      Provider.of<PretreatmentBleachingFiltrationProvider>(
                        context,
                        listen: false,
                      ).fetchAllLogsheet();
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
            itemCount: provider.pretreatmentList.length,
            itemBuilder: (context, index) {
              final item = provider.pretreatmentList[index];
              log(
                "list from provider length ${provider.pretreatmentList.length}",
              );
              return Card(
                child: InkWell(
                  onTap: null,
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

  String _getStatusText(PretreatmentBleachingFiltrationEntity report) {
    if (report.checkedBy != null) {
      return "Approved";
    }

    if (report.checkedBy == null) {
      return "Rejected";
    }
    if (report.preparedBy != null) {
      return "Prepared ${report.shift}";
    }

    if (report.preparedBy == null) {
      return "Rejected";
    }
    return "Submitted";
  }

  Color _getStatusColor(PretreatmentBleachingFiltrationEntity report) {
    if (report.checkedBy != null) {
      return Colors.green;
    }

    if (report.checkedBy == null) {
      return Colors.red;
    }

    if (report.preparedBy != null) {
      return Colors.orangeAccent;
    }

    if (report.preparedBy == null) {
      return Colors.red;
    }
    return Colors.grey;
  }
}
