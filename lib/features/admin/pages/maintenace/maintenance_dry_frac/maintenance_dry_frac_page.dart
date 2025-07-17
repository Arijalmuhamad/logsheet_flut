import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_field.dart';
import 'package:logsheet_app/features/admin/widgets/custom_hour_picker.dart';

class MaintenanceDryFracPage extends StatefulWidget {
  final String userName;
  const MaintenanceDryFracPage({super.key, required this.userName});

  @override
  State<MaintenanceDryFracPage> createState() => _MaintenanceDryFracPageState();
}

class _MaintenanceDryFracPageState extends State<MaintenanceDryFracPage> {
  final shiftDropDownItems = [
    DropdownMenuItem(value: 'I', child: Text('I')),
    DropdownMenuItem(value: 'II', child: Text('II')),
    DropdownMenuItem(value: 'III', child: Text('III')),
  ];

  final jenisDropDownItems = [
    DropdownMenuItem(value: 'SSA', child: Text('SSA')),
  ];

  final dateController = TextEditingController();

  int? selectedHour;

  void _showHourPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => CustomHourPicker(
            selectedHour: selectedHour,
            onHourSelected: (hour) {
              setState(() => selectedHour = hour);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Monitoring Dry Frac'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monitoring Dry Frac Form',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'PIC',
                      filled: true,
                      fillColor: Color(0xFFF0ECE9),
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustomDateField(
                    controller: dateController,
                    label: 'Tanggal',
                    icon: Icons.date_range,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Pemilihan Shift (I, II, III)
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          items: shiftDropDownItems,
                          decoration: InputDecoration(
                            hintText: 'Shift',
                            // prefixIcon: Icon(Icons.timelapse),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        flex: 3,
                        child: CustomHourField(
                          selectedHour: selectedHour,
                          onTap: () => _showHourPicker(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          items: jenisDropDownItems,
                          decoration: InputDecoration(
                            hintText: 'Jenis',
                            // prefixIcon: Icon(Icons.category),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Jumlah',
                            prefixIcon: Icon(Icons.functions),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'LOT',
                            // prefixIcon: Icon(Icons.category),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Sisa',
                            prefixIcon: Icon(Icons.functions),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: () {
                      // Simpan data
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB91C1C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
