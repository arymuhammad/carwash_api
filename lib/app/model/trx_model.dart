class Trx {
  late String? notrx;
  late String? idJenis;
  late String? kendaraan;
  late String? nopol;
  late String? masuk;
  late String? mulai;
  late String? selesai;
  late String? services;
  late String? harga;
  late String? petugas;
  late String? tanggal;
  late String? paid;

  Trx({
    this.notrx,
    this.idJenis,
    this.kendaraan,
    this.nopol,
    this.masuk,
    this.mulai,
    this.selesai,
    this.services,
    this.harga,
    this.petugas,
    this.tanggal,
    this.paid,
  });

  Trx.fromJson(Map<String, dynamic> json) {
    notrx = json['notrx'];
    idJenis = json['idJenis'];
    kendaraan = json['kendaraan'];
    nopol = json['nopol'];
    masuk = json['masuk'];
    mulai = json['mulai'];
    selesai = json['selesai'];
    services = json['services'];
    harga = json['harga'];
    petugas = json['petugas'];
    tanggal = json['tanggal'];
    paid = json['paid'];
  }
}
