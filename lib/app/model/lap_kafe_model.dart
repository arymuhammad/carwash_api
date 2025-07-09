class LapKafe {
  late String? tanggal;
  late String? noTrx;
  late String? kodeCabang;
  late String? petugas;
  late String? services;
  late String? grandTotal;
  late String? payment;

  LapKafe(
      {this.tanggal,
      noTrx,
      kodeCabang,
      petugas,
      services,
      grandTotal,
      payment});

  LapKafe.fromJson(Map<String, dynamic> json) {
    tanggal = json['tanggal'];
    noTrx = json['no_trx'];
    kodeCabang = json['kode_cabang'];
    petugas = json['petugas'];
    services = json['services'];
    grandTotal = json['grand_total'];
    payment = json['payment'];
  }
}
