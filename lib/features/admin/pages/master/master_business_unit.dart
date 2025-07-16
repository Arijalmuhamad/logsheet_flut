import 'package:flutter/material.dart';
import 'package:logsheet_app/features/admin/widgets/master/master_add_business_unit_card.dart';
import 'package:provider/provider.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/data/dao/business_unit_dao.dart';
import 'package:logsheet_app/features/admin/admin_page.dart';
import 'package:logger/logger.dart';
import '../../../../providers/user_provider.dart';

class MstBusinessUnitPage extends StatefulWidget {
  final String userName;

  const MstBusinessUnitPage({super.key, required this.userName});

  @override
  State<MstBusinessUnitPage> createState() => _BusinessUnitPageState();
}

class _BusinessUnitPageState extends State<MstBusinessUnitPage> {
  late final AppDatabase db;
  late final BusinessUnitDao businessUnitDao;

  String? entryBy;

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

  Future<void> _saveBusinessUnit(MBusinessUnitCompanion businessUnit) async {
    if (editingBusinessUnits == null) {
      await businessUnitDao.insertBusinessUnit(businessUnit);
      _showSnackbar('Business Unit berhasil dibuat');
    } else {
      final updatedData = MBusinessUnitData(
        id: businessUnit.id.value,
        companyCode: businessUnit.companyCode.value,
        companyName: businessUnit.companyName.value,
        isactive: businessUnit.isactive.value,
        entryBy: businessUnit.entryBy.value,
        entryDate: businessUnit.entryDate.value,
        parent: businessUnit.parent.value,
      );
      await businessUnitDao.updateBusinessUnit(updatedData);
    }

    _resetForm();
    await _loadBusinessUnit();
  }

  void _editBusinessUnit(MBusinessUnitData businessunit) {
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
                    builder: (_) => AdminHomePage(userName: widget.userName),
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
                MasterAddBusinessUnitCard(
                  key: ValueKey(editingBusinessUnits?.id),
                  editingBusinessUnit: editingBusinessUnits,
                  onSave: _saveBusinessUnit,
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
