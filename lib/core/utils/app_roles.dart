/// A centralized class for managing user roles and permissions.
class AppRoles {
  // This is a private constructor, which means you cannot create an
  // instance of this class. We only want to access its static members.
  AppRoles._();

  /// Roles with access to the general Quality Control (QC) section.
  static const List<String> qualityControlAccess = [
    "ADM",
    "LEAD",
    "LEAD_QC",
    "OPR",
    "OPR_QC",
    "MGR",
    "MGR_QC",
  ];

  static const List<String> leadQC = ["LEAD", "LEAD_QC"];
  static const List<String> leadProd = ["LEAD", "LEAD_PROD"];
  static const List<String> managerProd = ["MGR", "MGR_PROD"];

  /// Roles that can approve within the Quality Control (QC) section.
  static const List<String> qualityControlManagerApproval = [
    "MGR",
    "MGR_QC",
    "ADM",
  ];

  /// Roles with access to the Production quality reports section.
  static const List<String> productionQualityAccess = [
    "ADM",
    "OPR",
    "OPR_PROD",
    "LEAD",
    "LEAD_PROD",
    "MGR",
    "MGR_PROD",
  ];

  /// Roles that can approve within the Production quality reports section.
  static const List<String> productionQualityManagerApproval = [
    "MGR",
    "MGR_PROD",
    "ADM",
  ];

  /// Roles with general access to Production Logsheets (like Pretreatment and Deodorizing).
  static const List<String> logsheetAccess = [
    "ADM",
    "OPR",
    "OPR_PROD",
    "LEAD",
    "LEAD_PROD",
    "MGR",
    "MGR_PROD",
  ];

  /// Roles that can approve Production Logsheets.
  static const List<String> logsheetManagerApproval = [
    "MGR",
    "MGR_PROD",
    "ADM",
  ];

  /// Roles that can approve within the Production quality reports section.
  static const List<String> productionManagerApproval = [
    "MGR",
    "MGR_PROD",
    "ADM",
  ];
}
