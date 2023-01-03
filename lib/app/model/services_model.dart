class Services {
  late String? id;
  late String? serviceName;
  late String? harga;

  Services({this.id, this.serviceName, this.harga});
  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['nama'];
    harga = json['harga'];
  }
}
