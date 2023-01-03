class Login {
  late int? sukses;
  late String? username;
  late String? password;
  late String? kodeCabang;
  late String? kodeUser;
  late String? level;
  late int? total;

  Login(
      {this.sukses,
      this.username,
      this.password,
      this.kodeCabang,
      this.kodeUser,
      this.level,
      this.total});

  Login.fromJson(Map<String, dynamic> json) {
    sukses = json['success'];
    username = json['username'];
    password = json['password'];
    kodeCabang = json['kodeCabang'];
    kodeUser = json['kodeUser'];
    level = json['level'];
    total = json['total_row'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = sukses;
    data['username'] = username;
    data['password'] = password;
    data['kodeCabang'] = kodeCabang;
    data['kodeUser'] = kodeUser;
    data['level'] = level;
    data['total_row'] = total;
    return data;
  }
}
