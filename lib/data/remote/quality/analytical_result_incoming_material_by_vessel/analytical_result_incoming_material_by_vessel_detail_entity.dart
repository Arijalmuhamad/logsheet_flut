class AnalyticalResultIncomingMaterialByVesselDetailEntity {
  final String id;
  final String idHdr;
  final double? palkaSNo;
  final double? palkaSFfa;
  final double? palkaSIv;
  final double? palkaSDobi;
  final double? palkaSMni;

  final double? palkaCNo;
  final double? palkaCFfa;
  final double? palkaCIv;
  final double? palkaCDobi;
  final double? palkaCMni;

  final double? palkaPNo;
  final double? palkaPFfa;
  final double? palkaPIv;
  final double? palkaPDobi;
  final double? palkaPMni;

  AnalyticalResultIncomingMaterialByVesselDetailEntity({
    required this.id,
    required this.idHdr,
    required this.palkaSNo,
    required this.palkaSFfa,
    required this.palkaSIv,
    required this.palkaSDobi,
    required this.palkaSMni,
    required this.palkaCNo,
    required this.palkaCFfa,
    required this.palkaCIv,
    required this.palkaCDobi,
    required this.palkaCMni,
    required this.palkaPNo,
    required this.palkaPFfa,
    required this.palkaPIv,
    required this.palkaPDobi,
    required this.palkaPMni,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_hdr': idHdr,

      'palka_s_no': palkaSNo,
      'palka_s_ffa': palkaSFfa,
      'palka_s_iv': palkaSIv,
      'palka_s_dobi': palkaSDobi,
      'palka_s_mni': palkaSMni,

      'palka_c_no': palkaCNo,
      'palka_c_ffa': palkaCFfa,
      'palka_c_iv': palkaCIv,
      'palka_c_dobi': palkaCDobi,
      'palka_c_mni': palkaCMni,

      'palka_p_no': palkaPNo,
      'palka_p_ffa': palkaPFfa,
      'palka_p_iv': palkaPIv,
      'palka_p_dobi': palkaPDobi,
      'palka_p_mni': palkaPMni,
    };
  }

  AnalyticalResultIncomingMaterialByVesselDetailEntity copyWith({
  String? id,
  String? idHdr,

  double? palkaSNo,
  double? palkaSFfa,
  double? palkaSIv,
  double? palkaSDobi,
  double? palkaSMni,

  double? palkaCNo,
  double? palkaCFfa,
  double? palkaCIv,
  double? palkaCDobi,
  double? palkaCMni,

  double? palkaPNo,
  double? palkaPFfa,
  double? palkaPIv,
  double? palkaPDobi,
  double? palkaPMni,
}) {
  return AnalyticalResultIncomingMaterialByVesselDetailEntity(
    id: id ?? this.id,
    idHdr: idHdr ?? this.idHdr,

    palkaSNo: palkaSNo ?? this.palkaSNo,
    palkaSFfa: palkaSFfa ?? this.palkaSFfa,
    palkaSIv: palkaSIv ?? this.palkaSIv,
    palkaSDobi: palkaSDobi ?? this.palkaSDobi,
    palkaSMni: palkaSMni ?? this.palkaSMni,

    palkaCNo: palkaCNo ?? this.palkaCNo,
    palkaCFfa: palkaCFfa ?? this.palkaCFfa,
    palkaCIv: palkaCIv ?? this.palkaCIv,
    palkaCDobi: palkaCDobi ?? this.palkaCDobi,
    palkaCMni: palkaCMni ?? this.palkaCMni,

    palkaPNo: palkaPNo ?? this.palkaPNo,
    palkaPFfa: palkaPFfa ?? this.palkaPFfa,
    palkaPIv: palkaPIv ?? this.palkaPIv,
    palkaPDobi: palkaPDobi ?? this.palkaPDobi,
    palkaPMni: palkaPMni ?? this.palkaPMni,
  );
}

}
