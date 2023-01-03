class Cabang {
  late String? kodeCabang;
  late String? namaCabang;
  late String? alamat;
  late String? kota;
  late String? telp;

  Cabang({this.kodeCabang, this.namaCabang, this.alamat, this.kota, this.telp});

  Cabang.fromJson(Map<String, dynamic> json) {
    kodeCabang = json['kode'];
    namaCabang = json['cabang'];
    alamat = json['alamat'];
    kota = json['kota'];
    telp = json['telp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kode'] = kodeCabang;
    data['cabang'] = namaCabang;
    data['alamat'] = alamat;
    data['kota'] = kota;
    data['telp'] = telp;
    return data;
  }
}
