import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:provider/provider.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/data/dao/business_unit_dao.dart';
import 'package:logsheet_app/features/admin/admin_home_page.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../providers/master/user_provider.dart';

class MstBusinessUnitPage extends StatefulWidget {
  final String userName;
  final UserEntity userEntity;

  const MstBusinessUnitPage({
    super.key,
    required this.userName,
    required this.userEntity,
  });

  @override
  State<MstBusinessUnitPage> createState() => _BusinessUnitPageState();
}

class _BusinessUnitPageState extends State<MstBusinessUnitPage> {
  late final AppDatabase db;
  late final BusinessUnitDao businessUnitDao;

  final comCodeController = TextEditingController();
  final comNameController = TextEditingController();
  final plantCodeController = TextEditingController();
  final plantNameController = TextEditingController();

  String? selectedIsActive;
  String? selectedParent;

  String formattedDate = '';

  String? entryBy;

  // Variabel untuk menyimpan status checkbox
  bool isOtherFieldsEnabled = false;

  List<MBusinessUnitData> businessUnits = [];
  MBusinessUnitData? editingBusinessUnits;
  bool isLoading = false;

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    businessUnitDao = BusinessUnitDao(db);
    _loadBusinessUnit();
  }

  Future<void> _loadBusinessUnit() async {
    final data = await businessUnitDao.getAllBusinessUnits();
    setState(() => businessUnits = data);
  }

  void _resetForm() {
    comCodeController.clear();
    comNameController.clear();
    plantCodeController.clear();
    plantNameController.clear();
    selectedIsActive = null;
    selectedParent = null;
    setState(() => editingBusinessUnits = null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (entryBy == null && userProvider.userName.isNotEmpty) {
      setState(() {
        entryBy = userProvider.userName;
      });
    }
  }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _resetForm();
    await _loadBusinessUnit();
    setState(() => isLoading = false);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveBusinessUnit() async {
    final comcode = comCodeController.text.trim();
    final comname = comNameController.text.trim();
    final plantcode = plantCodeController.text.trim();
    final plantname = plantNameController.text.trim();
    final isactive = selectedIsActive;

    if (comcode.isEmpty || comname.isEmpty) {
      _showSnackbar('❗ Company code dan company name wajib diisi');
      return;
    }

    if (isactive == null) {
      _showSnackbar('❗ Status aktif dan parent wajib dipilih');
      return;
    }

    if (entryBy == null) {
      _showSnackbar('❗ Entry by wajib dipilih');
      return;
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final uuid = Uuid();

    // Pastikan parentvalue tidak null, dengan fallback sesuai status checkbox
    final parentvalue = selectedParent ?? (isOtherFieldsEnabled ? '2' : '1');

    final businessunit = MBusinessUnitCompanion(
      id: drift.Value(editingBusinessUnits?.id ?? uuid.v4()),
      companyCode: drift.Value(comcode),
      companyName: drift.Value(comname),
      plantCode:
          plantcode.isEmpty
              ? const drift.Value.absent()
              : drift.Value(plantcode),
      plantName:
          plantname.isEmpty
              ? const drift.Value.absent()
              : drift.Value(plantname),
      isactive: drift.Value(isactive),
      entryBy: drift.Value(userProvider.userName),
      entryDate: drift.Value(DateTime.now()),
      parent: drift.Value(parentvalue),
    );

    if (editingBusinessUnits == null) {
      await businessUnitDao.insertBusinessUnit(businessunit);
      _showSnackbar('✅ Business Unit berhasil ditambahkan');
    } else {
      final updateBusinessUnit = MBusinessUnitData(
        id: editingBusinessUnits!.id,
        companyCode: comcode,
        companyName: comname,
        plantCode: plantcode,
        plantName: plantname,
        isactive: isactive,
        entryBy: entryBy!,
        entryDate: DateTime.now(),
        parent: parentvalue,
      );
      await businessUnitDao.updateBusinessUnit(updateBusinessUnit);
      _showSnackbar('✅ Business Unit berhasil diperbarui');
    }
    if (entryBy == null || entryBy!.isEmpty) {
      _showSnackbar('❗ Entry by masih kosong');
      return;
    }

    _resetForm();
    await _loadBusinessUnit();
  }

  void _editBusinessUnit(MBusinessUnitData businessunit) {
    comCodeController.text = businessunit.companyCode;
    comNameController.text = businessunit.companyName;
    plantCodeController.text = businessunit.plantCode ?? ''; // 🛠️ null-safe
    plantNameController.text = businessunit.plantName ?? ''; // 🛠️ null-safe
    selectedIsActive = businessunit.isactive;
    selectedParent = businessunit.parent;
    entryBy = businessunit.entryBy;
    // Format tanggal ke string
    formattedDate = DateFormat('yyyy-MM-dd').format(businessunit.entryDate);
    setState(() => editingBusinessUnits = businessunit);
  }

  Future<void> _deleteBusinessUnit(String? id) async {
    if (id == null || id.isEmpty) {
      _showSnackbar('❌ Gagal menghapus: ID business unit tidak valid');
      return;
    }

    await businessUnitDao.deleteBusinessUnit(id);
    _showSnackbar('🗑️ Business unit berhasil dihapus');
    await _loadBusinessUnit();
  }

  @override
  void dispose() {
    comCodeController.dispose();
    comNameController.dispose();
    plantCodeController.dispose();
    plantNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFEFF3F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
            title: Text(
              editingBusinessUnits == null
                  ? 'Master Business Unit'
                  : 'Edit Business Unit : ${editingBusinessUnits!.companyCode}',
              style: const TextStyle(
                color: Color(0xFF655F5B),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AdminHomePage(
                          userName: widget.userName,
                          userEntity: widget.userEntity,
                        ),
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refreshPage,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          editingBusinessUnits == null
                              ? 'Tambah Business Unit'
                              : 'Edit Business Unit',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF655F5B),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: comCodeController,
                          decoration: InputDecoration(
                            hintText: 'Enter your company code',
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          readOnly: false,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: comNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your company name',
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: selectedIsActive,
                          decoration: InputDecoration(
                            hintText: 'Select active status',
                            prefixIcon: const Icon(Icons.check_circle_outline),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'T', child: Text('Aktif')),
                            DropdownMenuItem(
                              value: 'F',
                              child: Text('Tidak Aktif'),
                            ),
                          ],
                          onChanged:
                              (value) =>
                                  setState(() => selectedIsActive = value),
                        ),

                        const SizedBox(height: 20),

                        // Checkbox untuk enable/disable fields lain
                        Row(
                          children: [
                            Checkbox(
                              value: isOtherFieldsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  isOtherFieldsEnabled = value ?? false;

                                  // Autofill selectedParent berdasarkan status checkbox
                                  selectedParent =
                                      isOtherFieldsEnabled ? '2' : '1';

                                  // Hilangkan focus jika disable
                                  if (!isOtherFieldsEnabled) {
                                    FocusScope.of(
                                      context,
                                    ).unfocus(); // ⬅ Fokus hilang saat nonaktif
                                  }
                                });
                              },
                            ),
                            const Text('Enable other fields'),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // TextField
                        Opacity(
                          opacity: isOtherFieldsEnabled ? 1.0 : 0.5,
                          child: AbsorbPointer(
                            absorbing: !isOtherFieldsEnabled,
                            child: TextField(
                              controller: plantCodeController,
                              decoration: InputDecoration(
                                hintText: 'Enter your plant code',
                                prefixIcon: const Icon(Icons.lock),
                                filled: true,
                                fillColor: const Color(0xFFF0ECE9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              readOnly: false,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Opacity(
                          opacity:
                              isOtherFieldsEnabled
                                  ? 1.0
                                  : 0.5, // lebih samar saat disabled
                          child: AbsorbPointer(
                            absorbing:
                                !isOtherFieldsEnabled, // mencegah interaksi
                            child: TextField(
                              controller: plantNameController,
                              decoration: InputDecoration(
                                hintText: 'Enter your company plant',
                                prefixIcon: const Icon(Icons.lock),
                                filled: true,
                                fillColor: const Color(0xFFF0ECE9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAB2F2B),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _saveBusinessUnit,
                            child: Text(
                              editingBusinessUnits == null
                                  ? 'Add Business Unit'
                                  : 'Update Business Unit',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Daftar Business Unit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF655F5B),
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: businessUnits.length,
                  itemBuilder: (_, i) {
                    final businessunit = businessUnits[i];
                    return Card(
                      elevation: 4,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: const Icon(
                          Icons.person,
                          color: Color(0xFF6B7280),
                          size: 40,
                        ),
                        title: Text(
                          businessunit.companyName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF655F5B),
                          ),
                        ),
                        subtitle: Text(
                          'Active: ${businessunit.isactive == 'T' ? 'Aktif' : 'Tidak Aktif'} | Plant Name: ${businessunit.plantName}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Color(0xFF6B7280),
                              ),
                              onPressed: () => _editBusinessUnit(businessunit),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Color(0xFFB91C1C),
                              ),
                              onPressed:
                                  () => _deleteBusinessUnit(businessunit.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
