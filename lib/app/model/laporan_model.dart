class Laporan {
  late String? idJenis;
  late String? kendaraan;
  late String? nopol;
  late String? grandTotal;
  late String? services;
  late String? payment;

  Laporan(
      {this.idJenis,
      this.kendaraan,
      this.nopol,
      this.grandTotal,
      this.services,
      this.payment});
  Laporan.fromJson(Map<String, dynamic> json) {
    idJenis = json['idJenis'];
    kendaraan = json['kendaraan'];
    nopol = json['nopol'];
    grandTotal = json['grandTotal'];
    services = json['services'];
    payment = json['payment'];
  }
}
