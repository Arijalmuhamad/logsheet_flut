import 'package:flutter/material.dart';

class MaintenanceChangeProductPageList extends StatefulWidget {
  const MaintenanceChangeProductPageList({super.key});

  @override
  State<MaintenanceChangeProductPageList> createState() =>
      _MaintenanceChangeProductPageListState();
}

class _MaintenanceChangeProductPageListState
    extends State<MaintenanceChangeProductPageList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Change Product")));
  }
}
