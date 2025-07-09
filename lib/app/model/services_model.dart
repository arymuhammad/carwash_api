class Services {
  late String? id;
  late String? serviceName;
  late String? jenis;
  late String? harga;

  Services({this.id, this.serviceName, this.jenis, this.harga});
  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['nama'];
    jenis = json['jenis'];
    harga = json['harga'];
  }
}
