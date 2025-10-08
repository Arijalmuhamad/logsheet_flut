String getStatusText(dynamic report) {
  if (report.checkedStatus == "Approved") {
    return "Approved";
  }

  if (report.checkedStatus == "Rejected") {
    return "Rejected";
  }
  if (report.preparedStatus == "Approved") {
    return "Prepared ${report.shift}";
  }

  if (report.preparedStatus == "Rejected") {
    return "Rejected";
  }
  return "Submitted";
}
