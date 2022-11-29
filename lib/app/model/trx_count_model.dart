class TrxCount {
  late String? notrx;
  late String? cabang;
  late String? kodeUser;

  TrxCount({this.notrx, this.cabang, this.kodeUser});
  TrxCount.fromJson(Map<String, dynamic> json) {
    notrx = json['notrx'];
    cabang = json['cabang'];
    kodeUser = json['kodeUser'];
  }
}
