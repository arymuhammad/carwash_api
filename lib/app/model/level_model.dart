class Level {
  late String? id;
  late String? nama;

  Level({this.id, this.nama});
  Level.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
  }
}
