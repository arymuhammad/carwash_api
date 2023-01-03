class Kendaraan {
  late String? id;
  late String? idJenis;
  late String? nama;

  Kendaraan({this.id, this.idJenis, this.nama});

  Kendaraan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idJenis = json['idJenis'];
    nama = json['nama'];
  }
}
