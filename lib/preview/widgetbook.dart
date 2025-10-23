// // Widgetbook file: widgetbook.dart
// import 'package:flutter/material.dart';
// import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_input_page.dart';
// import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_report_list_page.dart';
// import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_lamp_glass/maintenance_lamps_glass_input_page.dart';
// import 'package:widgetbook/widgetbook.dart';

// void main() {
//   runApp(const HotReload());
// }

// class HotReload extends StatelessWidget {
//   const HotReload({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Widgetbook.material(
//       addons: [],
//       directories: [
//           WidgetbookComponent(
//           name: 'Maintenance Change Product',
//           useCases: [
//             WidgetbookUseCase(
//               name: 'Input Page',
//               builder: (context) => Center(child: MaintenanceChangeChecklistPage(userName: "Alvin",), ),
//             ),

//               WidgetbookUseCase(
//               name: 'Card',
//               builder: (context) => Center(child: MaintenanceChangeProductPageReportlist(), ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
