class Login {
  late int? sukses;
  // late String? username;
  // late String? password;
  // late String? kodeCabang;
  // late String? kodeUser;
  // late String? level;
  late String? kodeCabang;
  late String? kodeUser;
  late String? namaCabang;
  late String? alamat;
  late String? kota;
  late String? telp;
  late String? username;
  late String? password;
  late String? level;
  late String? idLevel;
  late int? total;

  Login({
    this.sukses,
    this.kodeCabang,
    this.kodeUser,
    this.namaCabang,
    this.alamat,
    this.kota,
    this.telp,
    this.username,
    this.password,
    this.level,
    this.idLevel,
    this.total,
  });

  Login.fromJson(Map<String, dynamic> json) {
    sukses = json['success'];
    // username = json['username'];
    // password = json['password'];
    // kodeCabang = json['kodeCabang'];
    // kodeUser = json['kodeUser'];
    // level = json['level'];
    kodeCabang = json['kodeCabang'];
    kodeUser = json['kodeUser'];
    namaCabang = json['namaCabang'];
    alamat = json['alamat'];
    kota = json['kota'];
    telp = json['telp'];
    username = json['namaUser'];
    password = json['password'];
    level = json['level'];
    idLevel = json['idLevel'];
    total = json['total_row'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
     json['kodeCabang']=kodeCabang;
    json['kodeUser']=kodeUser;
    json['namaCabang']=namaCabang;
    json['alamat']=alamat;
    json['kota']=kota;
    json['telp']=telp;
    json['namaUser']=username;
    json['password']=password;
    json['level']=level;
    json['idLevel']=idLevel;
    json['total_row']=total;
    json['sukses']=sukses;
    return json;
  }
}
