// ignore_for_file: use_build_context_synchronously

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logsheet_app/core/database/app_database.dart';
import 'package:logsheet_app/data/dao/quality_report_refinery_dao.dart';

class QualityEditPage extends StatefulWidget {
  final String userName;
  final TQualityReportRefineryData item;

  const QualityEditPage({
    super.key,
    required this.item,
    required this.userName,
  });

  @override
  State<QualityEditPage> createState() => _QualityEditPageState();
}

class _QualityEditPageState extends State<QualityEditPage> {
  late final TextEditingController pflowRateController;
  late final TextEditingController pffaController;
  late final TextEditingController pivController;
  late final TextEditingController ppvController;
  late final TextEditingController panVController;
  late final TextEditingController pdobiController;
  late final TextEditingController pcaroteneController;
  late final TextEditingController pmnIController;
  late final TextEditingController pcolorController;

  bool _isLoading = false;

  final Color primaryBlue = const Color(0xFF007BFF);
  final Color backgroundGrey = const Color(0xFFEFF3F9);

  @override
  void initState() {
    super.initState();
    pflowRateController = TextEditingController(
      text: widget.item.p_flowrate?.toString() ?? '',
    );
    pffaController = TextEditingController(
      text: widget.item.p_ffa?.toString() ?? '',
    );
    pivController = TextEditingController(
      text: widget.item.p_iv?.toString() ?? '',
    );
    ppvController = TextEditingController(
      text: widget.item.p_pv?.toString() ?? '',
    );
    panVController = TextEditingController(
      text: widget.item.p_anv?.toString() ?? '',
    );
    pdobiController = TextEditingController(
      text: widget.item.p_dobi?.toString() ?? '',
    );
    pcaroteneController = TextEditingController(
      text: widget.item.p_carotene?.toString() ?? '',
    );
    pmnIController = TextEditingController(
      text: widget.item.p_m_i?.toString() ?? '',
    );
    pcolorController = TextEditingController(text: widget.item.p_color ?? '');
  }

  @override
  void dispose() {
    pflowRateController.dispose();
    pffaController.dispose();
    pivController.dispose();
    ppvController.dispose();
    panVController.dispose();
    pdobiController.dispose();
    pcaroteneController.dispose();
    pmnIController.dispose();
    pcolorController.dispose();
    super.dispose();
  }

  double? _parseDouble(TextEditingController c) {
    final text = c.text.trim();
    return text.isEmpty ? null : double.tryParse(text);
  }

  Future<void> _saveData() async {
    setState(() => _isLoading = true);

    final updatedItem = widget.item.copyWith(
      p_flowrate: drift.Value(_parseDouble(pflowRateController)),
      p_ffa: drift.Value(_parseDouble(pffaController)),
      p_iv: drift.Value(_parseDouble(pivController)),
      p_pv: drift.Value(_parseDouble(ppvController)),
      p_anv: drift.Value(_parseDouble(panVController)),
      p_dobi: drift.Value(_parseDouble(pdobiController)),
      p_carotene: drift.Value(_parseDouble(pcaroteneController)),
      p_m_i: drift.Value(_parseDouble(pmnIController)),
      p_color: drift.Value(pcolorController.text.trim()),
    );

    final db = AppDatabase();
    final dao = QualityReportRefineryDao(db);
    await dao.updateQualityReportRefinery(updatedItem);

    setState(() => _isLoading = false);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui ✅')),
      );
      Navigator.pop(context, true);
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
            borderSide: BorderSide(color: primaryBlue.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryBlue, width: 2),
          ),
        ),
        keyboardType:
            isText
                ? TextInputType.text
                : const TextInputType.numberWithOptions(decimal: true),
        inputFormatters:
            isText
                ? []
                : [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        title: const Text(
          'Edit Quality Data',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildTextField('Flow Rate', pflowRateController),
                        _buildTextField('FFA', pffaController),
                        _buildTextField('IV', pivController),
                        _buildTextField('PV', ppvController),
                        _buildTextField('ANV', panVController),
                        _buildTextField('DOBI', pdobiController),
                        _buildTextField('Carotene', pcaroteneController),
                        _buildTextField('M&I', pmnIController),
                        _buildTextField(
                          'Color',
                          pcolorController,
                          isText: true,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('Save Changes'),
                            onPressed: _saveData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
