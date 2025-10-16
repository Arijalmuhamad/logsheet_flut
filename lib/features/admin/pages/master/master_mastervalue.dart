import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:logsheet_app/data/dao/mastervalue_dao.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/data/remote/master/user_entity.dart';
import 'package:provider/provider.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/features/admin/admin_home_page.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../providers/master/user_provider.dart';

class MstMastervaluePage extends StatefulWidget {
  final String userName;
  final UserEntity userEntity;

  const MstMastervaluePage({
    super.key,
    required this.userName,
    required this.userEntity,
  });

  @override
  State<MstMastervaluePage> createState() => _MasterValuePageState();
}

class _MasterValuePageState extends State<MstMastervaluePage> {
  late final AppDatabase db;
  late final MastervalueDao mastervalueDao;

  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final groupController = TextEditingController();
  final numberController = TextEditingController();

  String? selectedIsActive;
  String? entryBy;
  String formattedDate = '';

  List<MMastervalue> masterValue = [];
  MMastervalue? editingMastervalue;
  bool isLoading = false;

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    mastervalueDao = MastervalueDao(db);
    _loadMastervalue();
  }

  Future<void> _loadMastervalue() async {
    final data = await mastervalueDao.getAllMastervalues();
    setState(() => masterValue = data);
  }

  void _resetForm() {
    codeController.clear();
    nameController.clear();
    groupController.clear();
    numberController.clear();
    selectedIsActive = null;
    setState(() => editingMastervalue = null);
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
    await _loadMastervalue();
    setState(() => isLoading = false);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF655F5B),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveMastervalue() async {
    final code = codeController.text.trim();
    final name = nameController.text.trim();
    final group = groupController.text.trim();
    final numberText = numberController.text.trim();
    final isactive = selectedIsActive;

    if (code.isEmpty || name.isEmpty || group.isEmpty || numberText.isEmpty) {
      _showSnackbar('❗ Semua data wajib diisi');
      return;
    }

    if (isactive == null) {
      _showSnackbar('❗ Status aktif wajib dipilih');
      return;
    }

    if (entryBy == null || entryBy!.isEmpty) {
      _showSnackbar('❗ Entry by wajib diisi');
      return;
    }

    final parsedNumberTemp = int.tryParse(numberText);
    if (parsedNumberTemp == null) {
      _showSnackbar('❗ Nilai number tidak valid');
      return;
    }

    // ✅ setelah pengecekan, assign ke non-nullable variable
    final int parsedNumber = parsedNumberTemp;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final uuid = Uuid();

    final mastervalue = MMastervaluesCompanion(
      id: drift.Value(editingMastervalue?.id ?? uuid.v4()),
      code: drift.Value(code),
      name: drift.Value(name),
      group: drift.Value(group),
      number: drift.Value(parsedNumber),
      isactive: drift.Value(isactive),
      entryBy: drift.Value(userProvider.userName),
      entryDate: drift.Value(DateTime.now()),
    );

    if (editingMastervalue == null) {
      await mastervalueDao.insertMastervalue(mastervalue);
      _showSnackbar('✅ Mastervalue Unit berhasil ditambahkan');
    } else {
      final updateMasterValue = MMastervalue(
        id: editingMastervalue!.id,
        code: code,
        name: name,
        group: group,
        number: parsedNumber, // ✅ now parsedNumber is int (non-nullable)
        isactive: isactive,
        entryBy: entryBy!,
        entryDate: DateTime.now(),
      );
      await mastervalueDao.updateMastervalue(updateMasterValue);
      _showSnackbar('✅ Mastervalue berhasil diperbarui');
    }

    _resetForm();
    await _loadMastervalue();
  }

  void _editMastervalue(MMastervalue mastervalue) {
    codeController.text = mastervalue.code;
    nameController.text = mastervalue.name;
    groupController.text = mastervalue.group;
    numberController.text = mastervalue.number.toString();
    selectedIsActive = mastervalue.isactive;
    entryBy = mastervalue.entryBy;

    // Format tanggal ke string
    formattedDate = DateFormat('yyyy-MM-dd').format(mastervalue.entryDate);

    setState(() => editingMastervalue = mastervalue);
  }

  Future<void> _deleteMasterValue(String? id) async {
    if (id == null || id.isEmpty) {
      _showSnackbar('❌ Gagal menghapus: ID mastervalue unit tidak valid');
      return;
    }

    await mastervalueDao.deleteMastervalue(id);
    _showSnackbar('🗑️ Mastervalue berhasil dihapus');
    await _loadMastervalue();
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    groupController.dispose();
    numberController.dispose();
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
              editingMastervalue == null
                  ? 'Master Value'
                  : 'Edit Master Value : ${editingMastervalue!.code}',
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
                          editingMastervalue == null
                              ? 'Tambah Master Value'
                              : 'Edit Master Value',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF655F5B),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: codeController,
                          decoration: InputDecoration(
                            hintText: 'Enter your code',
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your name : ex SHIFT 01',
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
                        TextField(
                          controller: groupController,
                          decoration: InputDecoration(
                            hintText: 'Enter your group',
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
                        TextField(
                          controller: numberController,
                          decoration: InputDecoration(
                            hintText: 'Enter your number',
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            fillColor: const Color(0xFFF0ECE9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
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
                            onPressed: _saveMastervalue,
                            child: Text(
                              editingMastervalue == null
                                  ? 'Add Master Value'
                                  : 'Update Master value',
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
                  'List Master Value',
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
                  itemCount: masterValue.length,
                  itemBuilder: (_, i) {
                    final mastervalue = masterValue[i];
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text('Detail Mastervalue'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Table(
                                      columnWidths:
                                          const <int, TableColumnWidth>{
                                            0: FixedColumnWidth(100),
                                            1: FixedColumnWidth(10),
                                            2: FlexColumnWidth(),
                                          },
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      children: [
                                        TableRow(
                                          children: [
                                            const Text(
                                              "Kode",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(":"),
                                            Text(mastervalue.code),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            const Text(
                                              "Nama",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(":"),
                                            Text(mastervalue.name),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            const Text(
                                              "Group",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(":"),
                                            Text(mastervalue.group),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            const Text(
                                              "Number",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(":"),
                                            Text(mastervalue.number.toString()),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            const Text(
                                              "Status",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(":"),
                                            Text(
                                              mastervalue.isactive == 'T'
                                                  ? 'Aktif'
                                                  : 'Tidak Aktif',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon di sebelah kiri
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFFAB2F2B),
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Informasi utama
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mastervalue.code,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          size: 16,
                                          color: Color(0xFF6B7280),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          mastervalue.isactive == 'T'
                                              ? 'Aktif'
                                              : 'Tidak Aktif',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.apartment,
                                          size: 16,
                                          color: Color(0xFF6B7280),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Name: ${mastervalue.name}',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Aksi edit & delete
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color(0xFF6B7280),
                                    ),
                                    onPressed:
                                        () => _editMastervalue(mastervalue),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color(0xFFB91C1C),
                                    ),
                                    onPressed:
                                        () =>
                                            _deleteMasterValue(mastervalue.id),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
