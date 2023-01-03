class Karyawan {
  late String? id;
  late String? nama;
  late String? cabang;
  Karyawan({this.id, this.nama, this.cabang});
  Karyawan.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    nama = json["nama"];
    cabang = json["cabang"];
  }
}
