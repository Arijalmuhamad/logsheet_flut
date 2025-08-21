class ReportNotificationDataEntity {
  final String reportDate;
  final String workCenter;
  final String oilType;

  ReportNotificationDataEntity({
    required this.reportDate,
    required this.workCenter,
    required this.oilType,
  });

  factory ReportNotificationDataEntity.fromMap(Map<String, dynamic> map) {
    return ReportNotificationDataEntity(
      reportDate: map['report_date'],
      workCenter: map['work_center'],
      oilType: map['oil_type'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'report_date': reportDate,
      'work_center': workCenter,
      'oil_type': oilType,
    };
  }
}
