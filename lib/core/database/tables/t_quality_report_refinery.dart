// ignore_for_file: non_constant_identifier_names

import 'package:drift/drift.dart';
import '../converters.dart';
import '../../utils/date_utils.dart';

class TQualityReportRefinery extends Table {
  @override
  String get tableName => 't_quality_report_refinery';

  // Primary key
  TextColumn get id => text()();

  // Report basic info
  TextColumn get report_date =>
      text().map(const DateTimeTextConverter()).named('report_date')();
  TextColumn get time => text().nullable()(); // time as HH:mm:ss

  // Parameters
  TextColumn get p_cat => text().withLength(min: 0, max: 10).nullable()();
  RealColumn get p_tank_source => real().nullable()();
  RealColumn get p_flowrate => real().nullable()();
  RealColumn get p_ffa => real().nullable()();
  RealColumn get p_iv => real().nullable()();
  RealColumn get p_pv => real().nullable()();
  RealColumn get p_anv => real().nullable()();
  RealColumn get p_dobi => real().nullable()();
  RealColumn get p_carotene => real().nullable()();
  RealColumn get p_m_i => real().named('p_m&i').nullable()(); // special char
  TextColumn get p_color => text().withLength(min: 0, max: 10).nullable()();

  // Chemical & BPO
  TextColumn get c_cat => text().withLength(min: 0, max: 20).nullable()();
  RealColumn get c_pa => real().nullable()();
  RealColumn get c_be => real().nullable()();
  TextColumn get b_cat => text().withLength(min: 0, max: 10).nullable()();
  IntColumn get b_color_r => integer().nullable()();
  IntColumn get b_color_y => integer().nullable()();
  TextColumn get b_break_test =>
      text().withLength(min: 0, max: 100).nullable()();

  // RPO
  TextColumn get r_cat => text().withLength(min: 0, max: 20).nullable()();
  RealColumn get r_ffa => real().nullable()();
  IntColumn get r_color_r => integer().nullable()();
  IntColumn get r_color_y => integer().nullable()();
  IntColumn get r_color_b => integer().nullable()();
  IntColumn get r_pv => integer().nullable()();
  IntColumn get r_m_i => integer().named('r_m&i').nullable()();
  RealColumn get r_product_tank_no => real().nullable()();

  // PFAD
  TextColumn get fp_cat => text().withLength(min: 0, max: 10).nullable()();
  RealColumn get fp_purity => real().nullable()();
  RealColumn get fp_product_tank_no => real().nullable()();

  // Spent Earth
  RealColumn get spent_earth_oic => real().nullable()();

  // Metadata
  TextColumn get pic => text().withLength(min: 0, max: 50).nullable()();
  TextColumn get remarks => text().withLength(min: 0, max: 255).nullable()();
  TextColumn get checked_by => text().withLength(min: 0, max: 50).nullable()();
  DateTimeColumn get checked_date => dateTime().nullable()();
  TextColumn get checked_time => text().nullable()(); // time as string
  TextColumn get approved_by => text().withLength(min: 0, max: 50).nullable()();
  DateTimeColumn get approved_date => dateTime().nullable()();
  TextColumn get approved_time => text().nullable()(); // time as string

  // System
  TextColumn get flag => text().withLength(min: 0, max: 1).nullable()();
  TextColumn get company => text().withLength(min: 0, max: 2).nullable()();
  TextColumn get plant => text().withLength(min: 0, max: 4).nullable()();
  TextColumn get entry_by => text().withLength(min: 0, max: 50).nullable()();
  // DateTimeColumn get entry_date => dateTime().nullable()();
  // Timestamps
  TextColumn get entry_date =>
      text()
          .map(const DateTimeFullTextConverter())
          .clientDefault(() => getCurrentDateTimeFormatted())
          .named('entry_date')();

  @override
  Set<Column> get primaryKey => {id};
}
