import 'dart:convert';

import 'package:carwash/app/helper/service_api.dart';
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
  // var userData = <User>[].obs;
  var karyawan = <Karyawan>[].obs;
  var level = <Level>[].obs;
  final bool running = true;
  var idService = 0;

  var jenisKendaran = [
    {"id": 1, "jenis": "Motor"},
    {"id": 2, "jenis": "Mobil"}
  ];
  late TextEditingController email;
  late TextEditingController nama;
  late TextEditingController persentase;
  late TextEditingController namaMerk;
  late TextEditingController namaLevel;
  late TextEditingController namaCabang;
  late TextEditingController kotaCabang;
  late TextEditingController alamatCabang;
  late TextEditingController telpCabang;
  // String? kode;

  @override
  void onInit() {
    super.onInit();
    getFutureCabang();
    email = TextEditingController();
    nama = TextEditingController();
    persentase = TextEditingController();
    namaMerk = TextEditingController();
    namaLevel = TextEditingController();
    namaCabang = TextEditingController();
    kotaCabang = TextEditingController();
    alamatCabang = TextEditingController();
    telpCabang = TextEditingController();
  }

  @override
  void onClose() {
    email.dispose();
    nama.dispose();
    persentase.dispose();
    namaMerk.dispose();
    namaLevel.dispose();
    namaCabang.dispose();
    kotaCabang.dispose();
    alamatCabang.dispose();
    telpCabang.dispose();
    super.dispose();
  }

  Stream<List<Cabang>> getCabang(kode, level) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      // var response = await BaseClient().get('https://saputracarwash.online/api',
      //     '/cabang/get_cabang.php?kode=$kode&level=$level');
      // List<dynamic> dtcabang = json.decode(response)['rows'];
      // List<Cabang> dtCabang = dtcabang.map((e) => Cabang.fromJson(e)).toList();
      // cabang.value = dtCabang;
      Stream<List<Cabang>> dtcabang = ServiceApi().getDataCabang(kode, level);
      yield* dtcabang;
    }
  }

  Future<List<Cabang>> getFutureCabang() async {
    // var response = await BaseClient()
    //     .get('https://saputracarwash.online/api', '/cabang/get_cabang.php');
    // List<dynamic> dtcabang = json.decode(response)['rows'];
    // List<Cabang> dtCabang = dtcabang.map((e) => Cabang.fromJson(e)).toList();
    final response = await ServiceApi().getCabang();
    cabang.value = response;
    return response;
  }

  Stream<List<User>> getUsers(kode, level) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      // var response = await BaseClient().get('https://saputracarwash.online/api',
      //     '/user/get_user_data.php?kode=$kode&level=$level');
      // List<dynamic> dtUser = json.decode(response)['rows'];
      // List<User> users = dtUser.map((e) => User.fromJson(e)).toList();
      Stream<List<User>> users = ServiceApi().getAllUser(kode, level);
      // userData.value = users;
      yield* users;
    }
  }

  Future<List<User>> futureUsers(kode) async {
    // var response = await BaseClient().get('https://saputracarwash.online/api',
    //     '/user/get_user_data.php?kode=$kode');
    // List<dynamic> dtUser = json.decode(response)['rows'];
    // List<User> users = dtUser.map((e) => User.fromJson(e)).toList();
    // userData.value = users;
    final response = await ServiceApi().getUserFuture(kode);
    return response;
  }

  Stream<List<Karyawan>> getKaryawan(kode, level) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      // var response = await BaseClient().get('https://saputracarwash.online/api',
      //     '/master/get_karyawan.php?cabang=$kode&level=$level');
      // List<dynamic> dtKaryawan = json.decode(response)['rows'];
      // List<Karyawan> emp = dtKaryawan.map((e) => Karyawan.fromJson(e)).toList();
      // karyawan.value = emp;
      Stream<List<Karyawan>> emp = ServiceApi().getDataKaryawan(kode, level);
      yield* emp;
    }
  }

  Future<List<Karyawan>> futureKaryawan(kode) async {
    // var response = await BaseClient().get('https://saputracarwash.online/api',
    //     '/master/get_karyawan.php?cabang=$kode');
    // List<dynamic> dtKaryawan = json.decode(response)['rows'];
    // List<Karyawan> emp = dtKaryawan.map((e) => Karyawan.fromJson(e)).toList();
    final response = await ServiceApi().getKaryawanFuture(kode);
    // karyawan.value = emp;
    return response;
  }

  deleteCabang(id) async {
    await ServiceApi().deleteCabang(id);
  }

  addCabang(kodeCabang) async {
    var data = {
      "kode": kodeCabang,
      "nama": namaCabang.text,
      "kota": kotaCabang.text,
      "alamat": alamatCabang.text,
      "telp": telpCabang.text,
      "sts": "add"
    };
    await ServiceApi().addCabang(data);
    alamatCabang.clear();
    namaCabang.clear();
    kotaCabang.clear();
    telpCabang.clear();
  }

  updateDataCabang(kode) async {
    var data = {
      "kode": kode,
      "nama": namaCabang.text,
      "kota": kotaCabang.text,
      "alamat": alamatCabang.text,
      "telp": telpCabang.text,
      "sts": "update"
    };
    await ServiceApi().addCabang(data);
    namaCabang.clear();
    kotaCabang.clear();
    alamatCabang.clear();
    telpCabang.clear();
  }

  Stream<List<Level>> getLevel(id) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      // var response = await BaseClient().get(
      //     "https://saputracarwash.online/api", "/master/get_level.php?id=$id");
      // List<dynamic> dtLevel = json.decode(response)['rows'];
      // List<Level> data = dtLevel.map((e) => Level.fromJson(e)).toList();
      // level.value = data;
      Stream<List<Level>> data = ServiceApi().getLevelById(id);
      yield* data;
    }
  }

  Future<List<Level>> getFutureLevel(id) async {
    // var response = await BaseClient().get(
    //     "https://saputracarwash.online/api", "/master/get_level.php?id=$id");
    // List<dynamic> dtLevel = json.decode(response)['rows'];
    // List<Level> data = dtLevel.map((e) => Level.fromJson(e)).toList();
    // level.value = data;
    final response = await ServiceApi().getLevelFutureById(id);
    return response;
  }

  Stream<List<Kendaraan>> getKendaraan() async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      // var response = await BaseClient().get(
      //     "https://saputracarwash.online/api", "/master/get_kendaraan.php");
      // List<dynamic> dtLevel = json.decode(response)['rows'];
      // List<Kendaraan> data = dtLevel.map((e) => Kendaraan.fromJson(e)).toList();
      Stream<List<Kendaraan>> data = ServiceApi().getDataKendaraan();
      yield* data;
    }
  }

  Stream<List<Services>> getServices() async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      // var response = await BaseClient().get(
      //     "https://saputracarwash.online/api", "/master/get_services.php?id=");
      // List<dynamic> dtLevel = json.decode(response)['rows'];
      // List<Services> data = dtLevel.map((e) => Services.fromJson(e)).toList();
      Stream<List<Services>> data = ServiceApi().getServices();
      yield* data;
    }
  }

  // Stream<List<Services>> getFutureServices() async* {
  //   while (running) {
  //     await Future.delayed(const Duration(seconds: 1));
  //     var response = await BaseClient().get(
  //         "https://saputracarwash.online/api", "/master/get_services.php?id=");
  //     List<dynamic> dtLevel = json.decode(response)['rows'];
  //     List<Services> data = dtLevel.map((e) => Services.fromJson(e)).toList();
  //     yield data;
  //   }
  // }

  deleteUser(id) async {
    await ServiceApi().deleteUser(id);
  }

  deleteKaryawan(id) async {
    await ServiceApi().deleteKaryawan(id);
  }

  addKaryawan(data) async {
    await ServiceApi().addKaryawan(data);
  }

  updateKaryawan(data) async {
    await ServiceApi().addKaryawan(data);
  }

  addUser(data) async {
    await ServiceApi().addUser(data);
  }

  deleteLevel(id) async {
    await ServiceApi().deleteLevel(id);
  }

  addLevel(data) async {
    await ServiceApi().addLevel(data);
  }

  deleteMerk(id) async {
    await ServiceApi().deleteMerk(id);
  }

  addService(data) async {
    await ServiceApi().addServices(data);
  }

  deleteService(id) async {
    await ServiceApi().deleteServices(id);
  }

  addUpdateMerk(data) async {
    await ServiceApi().addMerk(data);
  }
}
