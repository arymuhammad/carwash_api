import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../helper/base_client.dart';
import '../../../model/cabang_model.dart';
import '../../../model/karyawan_model.dart';
import '../../../model/kendaraan_model.dart';
import '../../../model/level_model.dart';
import '../../../model/services_model.dart';
import '../../../model/user_model.dart';

class MasterController extends GetxController {
  var selectedCabang = "".obs;
  var selectedCabangKaryawan = "".obs;
  var selectedjenisKendaraan = "".obs;
  var userList = [].obs;
  var karyawanList = [].obs;
  var selectedLevel = "".obs;
  var listDocUser = [].obs;
  var idLevel = 0;
  var idKendaraan = 0;
  var noUrut = 1.obs;
  var kodeUser = 0.obs;
  var cabang = <Cabang>[].obs;
  var userData = <User>[].obs;
  var karyawan = <Karyawan>[].obs;
  var level = <Level>[].obs;
  final bool running = true;
  var idService = 0;

  var jenisKendaran = [
    {"id": 1, "jenis": "Motor"},
    {"id": 2, "jenis": "Mobil"}
  ];
  TextEditingController email = TextEditingController();

  TextEditingController nama = TextEditingController();

  TextEditingController persentase = TextEditingController();
  TextEditingController namaMerk = TextEditingController();
  TextEditingController namaLevel = TextEditingController();

  TextEditingController namaCabang = TextEditingController();
  TextEditingController kotaCabang = TextEditingController();
  TextEditingController alamatCabang = TextEditingController();
  TextEditingController telpCabang = TextEditingController();
  String? kode;

  @override
  void onInit() {
    super.onInit();
  }

  Stream<List<Cabang>> getCabang(kode, level) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get('https://saputracarwash.online/api',
          '/cabang/get_cabang.php?kode=$kode&level=$level');
      List<dynamic> dtcabang = json.decode(response)['rows'];
      List<Cabang> dtCabang = dtcabang.map((e) => Cabang.fromJson(e)).toList();
      cabang.value = dtCabang;
      yield dtCabang;
    }
  }

  Future<List<Cabang>> getFutureCabang() async {
    var response = await BaseClient()
        .get('https://saputracarwash.online/api', '/cabang/get_cabang.php');
    List<dynamic> dtcabang = json.decode(response)['rows'];
    List<Cabang> dtCabang = dtcabang.map((e) => Cabang.fromJson(e)).toList();
    cabang.value = dtCabang;
    return dtCabang;
  }

  Stream<List<User>> getUsers(kode, level) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get('https://saputracarwash.online/api',
          '/user/get_user_data.php?kode=$kode&level=$level');
      List<dynamic> dtUser = json.decode(response)['rows'];
      List<User> users = dtUser.map((e) => User.fromJson(e)).toList();
      userData.value = users;
      yield users;
    }
  }

  Future<List<User>> futureUsers(kode) async {
    var response = await BaseClient().get('https://saputracarwash.online/api',
        '/user/get_user_data.php?kode=$kode');
    List<dynamic> dtUser = json.decode(response)['rows'];
    List<User> users = dtUser.map((e) => User.fromJson(e)).toList();
    userData.value = users;
    return users;
  }

  Stream<List<Karyawan>> getKaryawan(kode, level) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get('https://saputracarwash.online/api',
          '/master/get_karyawan.php?cabang=$kode&level=$level');
      List<dynamic> dtKaryawan = json.decode(response)['rows'];
      List<Karyawan> emp = dtKaryawan.map((e) => Karyawan.fromJson(e)).toList();
      karyawan.value = emp;
      yield emp;
    }
  }

  Future<List<Karyawan>> futureKaryawan(kode) async {
    var response = await BaseClient().get('https://saputracarwash.online/api',
        '/master/get_karyawan.php?cabang=$kode');
    List<dynamic> dtKaryawan = json.decode(response)['rows'];
    List<Karyawan> emp = dtKaryawan.map((e) => Karyawan.fromJson(e)).toList();
    karyawan.value = emp;
    return emp;
  }

  deleteCabang(id) async {
    var response = await http.post(
        Uri.parse("https://saputracarwash.online/api/cabang/delete_cabang.php"),
        body: id);
  }

  addCabang(data) async {
    var response = await http.post(
        Uri.parse(
            "https://saputracarwash.online/api/cabang/addupdate_cabang.php"),
        body: data);
  }

  updateDataCabang(data) async {
    var response = await http.post(
        Uri.parse(
            "https://saputracarwash.online/api/cabang/addupdate_cabang.php"),
        body: data);
  }

  Stream<List<Level>> getLevel(id) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get(
          "https://saputracarwash.online/api", "/master/get_level.php?id=$id");
      List<dynamic> dtLevel = json.decode(response)['rows'];
      List<Level> data = dtLevel.map((e) => Level.fromJson(e)).toList();
      level.value = data;
      yield data;
    }
  }

  Future<List<Level>> getFutureLevel(id) async {
    var response = await BaseClient().get(
        "https://saputracarwash.online/api", "/master/get_level.php?id=$id");
    List<dynamic> dtLevel = json.decode(response)['rows'];
    List<Level> data = dtLevel.map((e) => Level.fromJson(e)).toList();
    level.value = data;
    return data;
  }

  Stream<List<Kendaraan>> getKendaraan() async* {
    while (running) {
      Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get(
          "https://saputracarwash.online/api", "/master/get_kendaraan.php");
      List<dynamic> dtLevel = json.decode(response)['rows'];
      List<Kendaraan> data = dtLevel.map((e) => Kendaraan.fromJson(e)).toList();
      yield data;
    }
  }

  Stream<List<Services>> getServices() async* {
    while (running) {
      Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get(
          "https://saputracarwash.online/api", "/master/get_services.php?id=");
      List<dynamic> dtLevel = json.decode(response)['rows'];
      List<Services> data = dtLevel.map((e) => Services.fromJson(e)).toList();
      yield data;
    }
  }

  Stream<List<Services>> getFutureServices() async* {
    while (running) {
      Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get(
          "https://saputracarwash.online/api", "/master/get_services.php?id=");
      List<dynamic> dtLevel = json.decode(response)['rows'];
      List<Services> data = dtLevel.map((e) => Services.fromJson(e)).toList();
      yield data;
    }
  }

  deleteUser(id) async {
    await http.post(
        Uri.parse("https://saputracarwash.online/api/master/delete_user.php"),
        body: id);
  }

  deleteKaryawan(id) async {
    await http.post(
        Uri.parse(
            "https://saputracarwash.online/api/master/delete_karyawan.php"),
        body: id);
  }

  addKaryawan(data) async {
    await http.post(
        Uri.parse(
            "https://saputracarwash.online/api/master/addupdate_karyawan.php"),
        body: data);
  }

  updateKaryawan(data) async {
    await http.post(
        Uri.parse(
            "https://saputracarwash.online/api/master/addupdate_karyawan.php"),
        body: data);
  }

  addUser(data) async {
    var response = await http.post(
        Uri.parse(
            "https://saputracarwash.online/api/master/addupdate_user.php"),
        body: data);
  }

  deleteLevel(id) async {
    var response = await http.post(
        Uri.parse("https://saputracarwash.online/api/master/delete_level.php"),
        body: id);
  }

  addLevel(data) async {
    var response = await http.post(
        Uri.parse(
            "https://saputracarwash.online/api/master/addupdate_level.php"),
        body: data);
  }

  deleteMerk(data) async {
    var response = await http.post(
        Uri.parse("https://saputracarwash.online/api/merk/delete_merk.php"),
        body: data);
  }

  addService(data) async {
    var response = await http.post(
        Uri.parse(
            "https://saputracarwash.online/api/master/addupdate_services.php"),
        body: data);
  }

  deleteService(data) async {
    var response = await http.post(
        Uri.parse(
            "https://saputracarwash.online/api/master/delete_services.php"),
        body: data);
  }

  addUpdateMerk(data) async {
    var response = await http.post(
        Uri.parse("https://saputracarwash.online/api/merk/addupdate_merk.php"),
        body: data);
  }
}
