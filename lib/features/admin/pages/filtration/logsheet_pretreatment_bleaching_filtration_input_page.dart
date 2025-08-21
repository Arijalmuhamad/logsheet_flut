import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logsheet_app/providers/master/value_provider.dart';
import 'package:provider/provider.dart';

class FiltrationPerformInputPage extends StatefulWidget {
  final String userName;
  const FiltrationPerformInputPage({super.key, required this.userName});

  @override
  State<FiltrationPerformInputPage> createState() =>
      _FiltrationPerformInputPageState();
}

class _FiltrationPerformInputPageState
    extends State<FiltrationPerformInputPage> {
  String? selectedFilter;
  int? selectedHour;
  int currentStep = 0;
  String? selectedWorkCenter;
  final List<String> filterOptions = [
    'Niagara Filter',
    'Sleeve Filter',
    'BPO - Cartridge Filter',
  ];

  final Map<String, List<String>> niagaraFilters = {
    'FL621': ['pressure', 'step', 'clarity'],
    'FL622': ['pressure', 'step', 'clarity'],
    'FL623': ['pressure', 'step', 'clarity'],
  };

  final Map<String, TextEditingController> pressureControllers = {};
  final Map<String, int> stepValues = {};
  final Map<String, bool> clarityValues = {};

  final TextEditingController cleanlinessController = TextEditingController();
  final TextEditingController tekananAwalController = TextEditingController();
  final TextEditingController tekananAkhirController = TextEditingController();
  final TextEditingController tekananSleeveController = TextEditingController();

  // Pretreatment

  Future<void> _refreshPage() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  void _showHourPicker(BuildContext context) {
    int initialHour = selectedHour ?? TimeOfDay.now().hour;
    selectedHour = initialHour;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Pilih Jam Input',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF655F5B),
                  ),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialHour,
                  ),
                  onSelectedItemChanged: (int value) {
                    selectedHour = value;
                  },
                  children: List.generate(
                    24,
                    (index) => Center(
                      child: Text(
                        '${index.toString().padLeft(2, '0')}:00',
                        style: const TextStyle(color: Color(0xFF655F5B)),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text(
                  'Pilih',
                  style: TextStyle(color: Color(0xFFAB2F2B)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNiagaraForm() {
    List<Widget> inputs = [];

    niagaraFilters.forEach((label, fields) {
      pressureControllers.putIfAbsent(label, () => TextEditingController());
      stepValues.putIfAbsent(label, () => 0);
      clarityValues.putIfAbsent(label, () => false);

      inputs.add(
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF655F5B),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: pressureControllers[label],
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Color(0xFF655F5B)),
                  decoration: InputDecoration(
                    labelText: 'Press (Bar)',
                    labelStyle: const TextStyle(color: Color(0xFF655F5B)),
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Step (L/min)',
                        style: TextStyle(color: Color(0xFF655F5B)),
                      ),
                      Slider(
                        value: stepValues[label]!.toDouble(),
                        min: 0,
                        max: 9,
                        divisions: 9,
                        label: stepValues[label]!.toString(),
                        activeColor: const Color(0xFFAB2F2B),
                        onChanged: (double value) {
                          setState(() {
                            stepValues[label] = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: clarityValues[label],
                      activeColor: const Color(0xFFAB2F2B),
                      onChanged: (value) {
                        setState(() {
                          clarityValues[label] = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      'Clarity OK',
                      style: TextStyle(color: Color(0xFF655F5B)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });

    return Column(children: inputs);
  }

  Widget _buildFilterForm() {
    if (selectedFilter == null) return const SizedBox.shrink();

    Widget formWidget;

    InputDecoration inputStyle(String label) => InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF655F5B)),
      filled: true,
      fillColor: const Color(0xFFF0ECE9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );

    switch (selectedFilter) {
      case 'Niagara Filter':
        formWidget = _buildNiagaraForm();
        break;
      case 'Sleeve Filter':
        formWidget = Column(
          children: [
            TextFormField(
              controller: cleanlinessController,
              style: const TextStyle(color: Color(0xFF655F5B)),
              decoration: inputStyle('Cleanliness Index'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: tekananSleeveController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color(0xFF655F5B)),
              decoration: inputStyle('Tekanan (Bar)'),
            ),
          ],
        );
        break;
      case 'BPO - Cartridge Filter':
        formWidget = Column(
          children: [
            TextFormField(
              controller: tekananAwalController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color(0xFF655F5B)),
              decoration: inputStyle('Tekanan Awal (Bar)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: tekananAkhirController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color(0xFF655F5B)),
              decoration: inputStyle('Tekanan Akhir (Bar)'),
            ),
          ],
        );
        break;
      default:
        formWidget = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Card(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedFilter ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF655F5B),
                ),
              ),
              const SizedBox(height: 12),
              formWidget,
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAB2F2B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Data ${selectedFilter!} berhasil disimpan!',
                        ),
                        backgroundColor: Colors.green.shade600,
                      ),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in pressureControllers.values) {
      controller.dispose();
    }
    tekananAwalController.dispose();
    tekananAkhirController.dispose();
    tekananSleeveController.dispose();
    cleanlinessController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ValueProvider>().fetchWorkCenterLists(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.workCenterLists.isEmpty) {
                  return DropdownButtonFormField<String>(
                    value: null,
                    items: [],
                    onChanged: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Loading Work Center...',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  );
                }

                return DropdownButtonFormField(
                  value: selectedWorkCenter,
                  items:
                      provider.workCenterLists.map((machine) {
                        return DropdownMenuItem<String>(
                          value: machine.code,
                          child: Text("${machine.code} - ${machine.name}"),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedWorkCenter = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Pilih Work Center',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/icons/oil-refinery-tanks.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),
            InkWell(
              onTap: () => _showHourPicker(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF0ECE9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(
                    Icons.access_time,
                    color: Color(0xFF655F5B),
                  ),
                ),
                child: Text(
                  selectedHour != null
                      ? '${selectedHour.toString().padLeft(2, '0')}:00'
                      : 'Pilih jam input',
                  style: TextStyle(
                    color:
                        selectedHour != null
                            ? const Color(0xFF655F5B)
                            : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedFilter,
              items:
                  filterOptions
                      .map(
                        (filter) => DropdownMenuItem(
                          value: filter,
                          child: Text(
                            filter,
                            style: const TextStyle(color: Color(0xFF655F5B)),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (value) => setState(() => selectedFilter = value),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF0ECE9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Pilih filter',
                hintStyle: const TextStyle(color: Color(0xFF655F5B)),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    'assets/icons/filter-svgrepo-com.svg',
                    height: 24,
                    width: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF655F5B),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            // _buildFilterForm(),
            if (selectedWorkCenter != null && selectedHour != null) ...[
              // Step indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // children: List.generate(6, (index) {}),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String getStepTitle() {
    switch (currentStep) {
      case 0:
        return "Pretreatment";
      case 1:
        return "Bleacher";
      case 3:
        return "Pump";
      case 4:
        return "Niagara Filter";
      case 5:
        return "Filter Bag";
      case 6:
        return "Catridge Filter";
      case 7:
        return "Catridge Filter";
      case 8:
        return "Remarks";
      default:
        return "Step";
    }
  }

  // Widget _buildStepContent(){

  // }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: const Text(
        'Filtration Performance - Refinery',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshPage),
      ],
    );
  }
}
