class TrxCount {
  late String? notrx;
  late String? cabang;
  late String? kodeUser;
  late String? nopol;

  TrxCount({this.notrx, this.cabang, this.kodeUser});
  TrxCount.fromJson(Map<String, dynamic> json) {
    notrx = json['notrx'];
    cabang = json['cabang'];
    kodeUser = json['kodeUser'];
    nopol = json['nopol'];
  }
}
