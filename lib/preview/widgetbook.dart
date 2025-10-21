// Widgetbook file: widgetbook.dart
import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/pages/maintenace/maintenance_change_product/maintenance_change_product_page._input.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const HotReload());
}

class HotReload extends StatelessWidget {
  const HotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [],
      directories: [
        WidgetbookComponent(
          name: 'Test',
          useCases: [
            WidgetbookUseCase(
              name: 'Vertical Card',
              builder:
                  (context) => Center(
                    child: MaintenanceChangeChecklistPage(userName: "Alvin"),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
