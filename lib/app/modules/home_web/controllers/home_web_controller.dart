// import 'package:auth/auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';

import 'package:carwash/app/helper/base_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/services_model.dart';
import '../../../model/trx_model.dart';
import '../../../model/user_model.dart';
import 'package:http/http.dart' as http;

class HomeWebController extends GetxController {
  // FirebaseAuth auth = FirebaseAuth.instance;
  // FirebaseFirestore home = FirebaseFirestore.instance;

  // Stream<DocumentSnapshot> login(String user, String pass) {
  //   QuerySnapshot users = firestore.collection("users").;

  //   return users.get().snapshots();
  // }
  var namaCabang = "";
  var alamatCabang = "";
  var kotaCabang = "";
  var total = 0;
  var serviceItem = [].obs;
  final bool running = true;
  var userData = <User>[].obs;
  List<String> metodpay = ["", "Cash", "BCA", "BRI", "BNI", "OVO", "DANA"];
  var paySelected = "".obs;
  var totalHarga = 0.obs;
  var byr = 0;
  var cpi = 0;
  var kembali = 0.obs;
  late TextEditingController bayar = TextEditingController();
  String? idService;
  @override
  void onInit() {
    super.onInit();
    servicesById(idService);
  }

  Stream<List<Trx>> getDatatrx(cabang, date, status) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get("http://103.112.139.155/api",
          "/transaksi/getTrxStatus.php?kode_cabang=$cabang&tanggal=$date&status=$status");
      List<dynamic> trx = json.decode(response)['rows'];
      // print(trx);
      List<Trx> dtTrx = trx.map((e) => Trx.fromJson(e)).toList();
      yield dtTrx;
    }
  }

  Future<List<User>> streamDataUser(username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await BaseClient().get("http://103.112.139.155/api",
        "/user/get_user_data.php?username=$username");
    List<dynamic> user = json.decode(response)['rows'];
    List<User> dtUser =user.map((e) => User.fromJson(e)).toList();
    userData.value = dtUser;
    await pref.setString("kode_cabang", dtUser[0].kodeCabang!);
    await pref.setString("nama_cabang", dtUser[0].namaCabang!);
    await pref.setString("level", dtUser[0].level!);
    await pref.setString("username", dtUser[0].namaUser!);
    return dtUser;
  }

  void pembayaran(String bayar) async {
    var result = int.parse(bayar) - totalHarga.value;
    kembali.value = result;
  }

  updateDataTrx(data) async {
    var response = await http.post(
        Uri.parse("http://103.112.139.155/api/transaksi/updateData.php"),
        body: data);
  }

  Future<List<Services>> servicesById(String? idService) async {
    // while (running) {
    // await Future.delayed(const Duration(seconds: 1));
    var response = await BaseClient().get(
        "http://103.112.139.155/api", "/master/get_services.php?id=$idService");
    List<dynamic> srv = json.decode(response)['rows'];
    List<Services> dtSrv = srv.map((e) => Services.fromJson(e)).toList();
    return dtSrv;
    // }
  }

  // updateService(data) async {
  //   var response = await http.post(
  //       Uri.parse("http://103.112.139.155/api/transaksi/updateData.php"),
  //       body: data);
  // }
  // Stream<User?> get userAuth => auth.authStateChanges();

  // Stream<QuerySnapshot<Object?>> streamDataUser(String? email) {
  //   CollectionReference user = home.collection("users");
  //   return user.where("email", isEqualTo: email).snapshots();
  // }

  // Stream<QuerySnapshot<Object?>> streamDataCabang(String cabang) {
  //   CollectionReference user = home.collection("cabang");
  //   return user.where("kode_cabang", isEqualTo: cabang).snapshots();
  // }
}
