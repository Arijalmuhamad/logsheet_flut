// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logsheet_app/core/database/database_instance.dart';
import 'package:logsheet_app/data/dao/quality_report_refinery_dao.dart';
import 'sync_result.dart';

class SyncQualityService {
  static Future<SyncResult> sync() async {
    print('📤 [SyncQualityService] Mulai sync quality report');

    final dao = QualityReportRefineryDao(db);
    final unsynced = await dao.getUnsentReports();
    int successCount = 0;

    for (final item in unsynced) {
      try {
        // Buat payload JSON manual
        final payload = {
          'id': item.id,
          'report_date': item.report_date.toIso8601String(),
          'time': item.time ?? '00:00:00',
          'p_cat': item.p_cat,
          'p_tank_source': item.p_tank_source,
          'p_flowrate': item.p_flowrate,
          'p_ffa': item.p_ffa,
          'p_iv': item.p_iv,
          'p_pv': item.p_pv,
          'p_anv': item.p_iv,
          'p_dobi': item.p_anv,
          'p_carotene': item.p_carotene,
          'p_m&i': item.p_m_i,
          'p_color': item.p_color,
          'c_cat': item.c_cat,
          'c_pa': item.c_pa,
          'c_be': item.c_be,
          'b_cat': item.b_cat,
          'b_color_r': item.b_color_r,
          'b_color_y': item.b_color_y,
          'b_break_test': item.b_break_test,
          'r_cat': item.r_cat,
          'r_ffa': item.r_ffa,
          'r_color_r': item.r_color_r,
          'r_color_y': item.r_color_y,
          'r_color_b': item.r_color_b,
          'r_pv': item.r_pv,
          'r_m&i': item.r_m_i,
          'r_product_tank_no': item.r_product_tank_no,
          'fp_cat': item.fp_cat,
          'fp_purity': item.fp_purity,
          'fp_product_tank_no': item.fp_product_tank_no,
          'spent_earth_oic': item.spent_earth_oic,
          'pic': item.pic,
          'remarks': item.remarks,
          'checked_by': item.checked_by,
          'checked_date': item.checked_date?.toIso8601String(),
          'checked_time': item.checked_time ?? '00:00:00',
          'approved_by': item.approved_by,
          'approved_date': item.approved_date?.toIso8601String(),
          'approved_time': item.approved_time ?? '00:00:00',
          'flag': item.flag,
          'company': item.company,
          'plant': item.plant,
          'entry_by': item.approved_by,
          'entry_date': item.entry_date.toIso8601String(),
        };

        final response = await http
            .post(
              Uri.parse('http://172.30.6.167:3000/api/upload_quality'),
              body: jsonEncode(payload),
              headers: {'Content-Type': 'application/json'},
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          print('✅ Upload sukses: ${response.body}');
          await dao.updateFlag(item.id, 'F');
          successCount++;
        } else {
          print('❌ Upload gagal: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        print('❌ Upload error: $e');
      }
    }

    return SyncResult(
      title: 'Quality Report',
      success: successCount == unsynced.length,
      message: 'Berhasil upload $successCount dari ${unsynced.length} data.',
    );
  }
}
