class User {
  late String? kodeCabang;
  late String? kodeUser;
  late String? namaCabang;
  late String? alamat;
  late String? kota;
  late String? telp;
  late String? namaUser;
  late String? password;
  late String? level;
  late String? idLevel;
  late String? status;

  User({
    this.kodeCabang,
    this.kodeUser,
    this.namaCabang,
    this.alamat,
    this.kota,
    this.telp,
    this.namaUser,
    this.password,
    this.level,
    this.idLevel,
    this.status,
  });

  User.fromJson(Map<String, dynamic> json) {
    kodeCabang = json['kodeCabang'];
    kodeUser = json['kodeUser'];
    namaCabang = json['namaCabang'];
    alamat = json['alamat'];
    kota = json['kota'];
    telp = json['telp'];
    namaUser = json['namaUser'];
    password = json['password'];
    level = json['level'];
    idLevel = json['idLevel'];
    status = json['status'];
  }
}
