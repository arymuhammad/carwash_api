// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/alert.dart';
import '../../../helper/base_client.dart';
import '../../../model/cabang_model.dart';
import '../../../model/karyawan_model.dart';
import '../../../model/kendaraan_model.dart';
import '../../../model/level_model.dart';
import '../../../model/services_model.dart';
import '../../../model/user_model.dart';
import 'package:http/http.dart' as http;

class MasterController extends GetxController {
  // FirebaseFirestore master = FirebaseFirestore.instance;

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
  TextEditingController email = TextEditingController();

  TextEditingController nama = TextEditingController();
  TextEditingController notelp = TextEditingController();

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
    // getCabang();
    // getUsers(kode);
    // getKaryawan(kode);
    // getLevel(kode);
  }

  Stream<List<Cabang>> getCabang() async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient()
          .get('http://103.112.139.155/api', '/cabang/get_cabang.php');
      // .catchError(handleError);
      List<dynamic> dtcabang = json.decode(response)['rows'];
      // print(response);
      List<Cabang> dtCabang = dtcabang.map((e) => Cabang.fromJson(e)).toList();
      cabang.value = dtCabang;
      yield dtCabang;
    }
  }

  Future<List<Cabang>> getFutureCabang() async {
    var response = await BaseClient()
        .get('http://103.112.139.155/api', '/cabang/get_cabang.php');
    // .catchError(handleError);
    List<dynamic> dtcabang = json.decode(response)['rows'];
    // print(response);
    List<Cabang> dtCabang = dtcabang.map((e) => Cabang.fromJson(e)).toList();
    cabang.value = dtCabang;
    return dtCabang;
  }

  Stream<List<User>> getUsers(kode) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get(
          'http://103.112.139.155/api', '/user/get_user_data.php?kode=$kode');
      // .catchError(handleError);
      List<dynamic> dtUser = json.decode(response)['rows'];
      // print(response);
      List<User> users = dtUser.map((e) => User.fromJson(e)).toList();
      userData.value = users;
      yield users;
    }
  }

  Future<List<User>> futureUsers(kode) async {
    var response = await BaseClient().get(
        'http://103.112.139.155/api', '/user/get_user_data.php?kode=$kode');
    // .catchError(handleError);
    List<dynamic> dtUser = json.decode(response)['rows'];
    // print(response);
    List<User> users = dtUser.map((e) => User.fromJson(e)).toList();
    userData.value = users;
    return users;
  }

  Stream<List<Karyawan>> getKaryawan(kode) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get('http://103.112.139.155/api',
          '/master/get_karyawan.php?cabang=$kode');
      // .catchError(handleError);
      List<dynamic> dtKaryawan = json.decode(response)['rows'];
      // print(response);
      List<Karyawan> emp = dtKaryawan.map((e) => Karyawan.fromJson(e)).toList();
      karyawan.value = emp;
      yield emp;
    }
  }

  Future<List<Karyawan>> futureKaryawan(kode) async {
    var response = await BaseClient().get(
        'http://103.112.139.155/api', '/master/get_karyawan.php?cabang=$kode');
    // .catchError(handleError);
    List<dynamic> dtKaryawan = json.decode(response)['rows'];
    // print(response);
    List<Karyawan> emp = dtKaryawan.map((e) => Karyawan.fromJson(e)).toList();
    karyawan.value = emp;
    return emp;
  }

  deleteCabang(id) async {
    var response = await http.post(
        Uri.parse("http://103.112.139.155/api/cabang/delete_cabang.php"),
        body: id);
  }

  addCabang(data) async {
    var response = await http.post(
        Uri.parse("http://103.112.139.155/api/cabang/add_cabang.php"),
        body: data);
  }

  Stream<List<Level>> getLevel(id) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient()
          .get("http://103.112.139.155/api", "/master/get_level.php?id=$id");
      List<dynamic> dtLevel = json.decode(response)['rows'];
      List<Level> data = dtLevel.map((e) => Level.fromJson(e)).toList();
      level.value = data;
      yield data;
    }
  }

  Future<List<Level>> getFutureLevel(id) async {
    var response = await BaseClient()
        .get("http://103.112.139.155/api", "/master/get_level.php?id=$id");
    List<dynamic> dtLevel = json.decode(response)['rows'];
    List<Level> data = dtLevel.map((e) => Level.fromJson(e)).toList();
    level.value = data;
    return data;
  }

  Future<List<Kendaraan>> getKendaraan() async {
    var response = await BaseClient()
        .get("http://103.112.139.155/api", "/master/get_kendaraan.php");
    List<dynamic> dtLevel = json.decode(response)['rows'];
    List<Kendaraan> data = dtLevel.map((e) => Kendaraan.fromJson(e)).toList();
    return data;
  }

  Stream<List<Services>> getServices() async* {
    while (running) {
      Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient()
          .get("http://103.112.139.155/api", "/master/get_services.php?id=");
      List<dynamic> dtLevel = json.decode(response)['rows'];
      List<Services> data = dtLevel.map((e) => Services.fromJson(e)).toList();
      yield data;
    }
  }

  deleteUser(id) async {
    await http.post(
        Uri.parse("http://103.112.139.155/api/master/delete_user.php"),
        body: id);
  }

  deleteKaryawan(id) async {
    await http.post(
        Uri.parse("http://103.112.139.155/api/master/delete_karyawan.php"),
        body: id);
  }

  addKaryawan(data) async {
    await http.post(
        Uri.parse("http://103.112.139.155/api/master/addupdate_karyawan.php"),
        body: data);
  }

  updateKaryawan(data) async {
    await http.post(
        Uri.parse("http://103.112.139.155/api/master/addupdate_karyawan.php"),
        body: data);
  }

  addUser(data) async {
    var response = await http.post(
        Uri.parse("http://103.112.139.155/api/master/addupdate_user.php"),
        body: data);
    // print(response.body);
  }

  deleteLevel(id) async {
    var response = await http.post(
        Uri.parse("http://103.112.139.155/api/master/delete_level.php"),
        body: id);
  }

  addLevel(data) async {
    var response = await http.post(
        Uri.parse("http://103.112.139.155/api/master/addupdate_level.php"),
        body: data);
  }

  void deleteMerk(String? id) {}

  // Stream<QuerySnapshot<Object?>> streamDataMerk() {
  //   CollectionReference kendaraan = master.collection("merk");
  //   return kendaraan.orderBy("id", descending: false).snapshots();
  // }

  // Stream<QuerySnapshot<Object?>> streamDataCabang() {
  //   CollectionReference cabang = master.collection("cabang");
  //   return cabang.snapshots();
  // }

  // Stream<QuerySnapshot<Object?>> streamDataLevel() {
  //   CollectionReference kendaraan = master.collection("level");
  //   return kendaraan.orderBy("id", descending: false).snapshots();
  // }

  // Stream<QuerySnapshot<Object?>> streamDataLevelByid(id) {
  //   CollectionReference level = master.collection("level");
  //   return level.where("id", isEqualTo: id).snapshots();
  // }

  // Stream<QuerySnapshot<Object?>> streamDataUsers() {
  //   CollectionReference kendaraan = master.collection("users");
  //   return kendaraan.snapshots();
  // }

  // Stream<QuerySnapshot<Object?>> streamDatajk() {
  //   CollectionReference kendaraan = master.collection("jenis_kendaraan");
  //   return kendaraan.snapshots();
  // }

  // Stream<QuerySnapshot<Object?>> streamDataKaryawan() {
  //   CollectionReference karyawan = master.collection("karyawan");
  //   return karyawan.snapshots();
  // }

  // Stream<QuerySnapshot<Object?>> streamDataUserByCabang(cabang) {
  //   CollectionReference user = master.collection("users");
  //   return user.where("kode_cabang", isEqualTo: cabang).snapshots();
  // }

  // Stream<QuerySnapshot<Object?>> streamDataKaryawanByCabang(cabang) {
  //   CollectionReference karyawan = master.collection("karyawan");
  //   return karyawan.where("cabang", isEqualTo: cabang).snapshots();
  // }

  // addKaryawan(int id, String nama, String cabang, String persentase) async {
  //   CollectionReference merk = master.collection("karyawan");
  //   try {
  //     await merk.add({
  //       "id": id,
  //       "nama": nama,
  //       "cabang": cabang,
  //       "persen": persentase,
  //     });
  //     Get.back();

  //     showDefaultDialog("Sukses", "Data karyawan berhasil di input");
  //     // ignore: empty_catches
  //   } catch (e) {}
  // }

  // updateKaryawan(id, String namaKaryawan, String persentase) async {
  //   DocumentReference kry = master.collection("karyawan").doc(id);
  //   try {
  //     await kry.update({
  //       "nama": namaKaryawan,
  //       "persen": persentase,
  //     });
  //     Get.back();
  //     await showSnackbar("Sukses", "Data Berhasil di Update");
  //     // ignore: empty_catches
  //   } catch (e) {}
  // }

  // deleteKaryawan(id) async {
  //   DocumentReference merk = master.collection("karyawan").doc(id);
  //   try {
  //     await merk.delete();
  //     Get.back();
  //     showDefaultDialog("Sukses", "Karyawan berhasil dihapus");
  //     // ignore: empty_catches
  //   } catch (e) {}
  // }

  // addMerk(id, int jenis, String nama) async {
  //   CollectionReference merk = master.collection("merk");
  //   try {
  //     await merk.add({
  //       "id": id,
  //       "id_jenis": jenis,
  //       "nama": nama,
  //     });
  //     Get.back();
  //     await showSnackbar("Sukses", "Data Berhasil ditambahkan");
  //     // ignore: empty_catches
  //   } catch (e) {}
  // }

  // updateMerk(id, String namaMerk) async {
  //   DocumentReference merk = master.collection("merk").doc(id);
  //   try {
  //     await merk.update({
  //       "nama": namaMerk,
  //     });
  //     Get.back();
  //     await showSnackbar("Sukses", "Data Berhasil di Update");
  //     // ignore: empty_catches
  //   } catch (e) {}
  // }

  // deleteMerk(id) async {
  //   DocumentReference merk = master.collection("merk").doc(id);
  //   try {
  //     await merk.delete();
  //     Get.back();
  //     await showSnackbar("Sukses", "Data Berhasil dihapus");
  //   } catch (e) {}
  // }

  // addLevel(int id, String nama) async {
  //   CollectionReference level = master.collection("level");
  //   try {
  //     await level.add({
  //       "id": id,
  //       "nama": nama,
  //     });
  //     Get.back();
  //     showSnackbar("Sukses", "Level baru berhasil ditambahkan");
  //   } catch (e) {
  //     showSnackbar("Error", "Terjadi Kesalahan");
  //   }
  // }

  // deleteLevel(String id) async {
  //   DocumentReference level = master.collection("level").doc(id);
  //   try {
  //     await level.delete();
  //     Get.back();
  //     await showSnackbar("Sukses", "Data Berhasil di hapus");
  //   } catch (e) {}
  // }

  // updateLevel(id, String level) async {
  //   DocumentReference levels = master.collection("level").doc(id);
  //   try {
  //     await levels.update({
  //       "nama": level,
  //     });
  //     Get.back();
  //     await showSnackbar("Sukses", "Data Berhasil di Update");
  //   } catch (e) {}
  // }

  // Future signUp() async {
  //   FirebaseApp secApp = await Firebase.initializeApp(
  //     name: 'ProWash',
  //     options: Firebase.app().options,
  //   );
  //   try {
  //     UserCredential user = await FirebaseAuth.instanceFor(app: secApp)
  //         .createUserWithEmailAndPassword(
  //             email: email.text, password: password.text);

  //     if (user.user == null) throw 'Error. Silahkan coba lagi';

  //     addUser('00$noUrut', nama.text, notelp.text, email.text,
  //         selectedCabang.value, selectedLevel.value);
  //     Get.back();
  //     Get.back();
  //     Get.back();
  //     email.clear();
  //     password.clear();
  //     nama.clear();
  //     notelp.clear();
  //     selectedLevel.value = "";
  //     selectedCabang.value = "";
  //     showDefaultDialog("Sukses", "User berhasil di daftarkan");
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       return showSnackbar("Error", "The password provided is too weak.");
  //     } else if (e.code == 'email-already-in-use') {
  //       return showSnackbar(
  //           "Error", "Email ini sudah terdaftar pada akun lain.");
  //     }
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  //   await secApp.delete();
  // }

  // // Future deleteUser() async {
  // //   // await FirebaseAuth.instance.;
  // // }

  // Future addUser(String kodeUser, String nama, String notelp, String email,
  //     String cabang, String level) async {
  //   await FirebaseFirestore.instance.collection("users").add({
  //     "kode_user": kodeUser,
  //     "nama": nama,
  //     "notelp": notelp,
  //     "email": email,
  //     "kode_cabang": cabang,
  //     "level": int.parse(level),
  //     // "status": status,
  //   });
  // }

  // updateUser(id, nama, telp, level, cabang) async {
  //   DocumentReference user = master.collection("users").doc(id);

  //   try {
  //     await user.update({
  //       "nama": nama,
  //       "notelp": telp,
  //       "level": int.parse(level),
  //       "kode_cabang": cabang,
  //     });
  //     Get.back();
  //     await showSnackbar("Sukses", "Data Berhasil di Update");
  //   } catch (e) {}
  // }

  // deleteUser(String id) async {
  //   DocumentReference user = master.collection("users").doc(id);
  //   try {
  //     user.delete();
  //     Get.defaultDialog(
  //         radius: 5,
  //         title: 'Sukses',
  //         middleText: 'User berhasil dihapus',
  //         onConfirm: () {
  //           Get.back();
  //           Get.back();
  //         },
  //         textConfirm: 'OK',
  //         confirmTextColor: Colors.white);
  //   } catch (e) {
  //     // print(e.toString());
  //   }
  // }

  // Stream<QuerySnapshot<Object?>> getUsers() {
  //   CollectionReference user = master.collection("users");
  //   return user.snapshots();
  // }

  // Stream<QuerySnapshot<Object?>> getUsersCab() {
  //   CollectionReference user = master.collection("users");
  //   return user
  //       .where("kode_cabang", isEqualTo: "")
  //       .where("level", isGreaterThan: 1)
  //       .snapshots();
  // }

  // updateDataCabang(id, nama, kota, alamat, telp) async {
  //   DocumentReference cabang = master.collection("cabang").doc(id);

  //   try {
  //     await cabang.update({
  //       "nama_cabang": nama,
  //       "kota": kota,
  //       "alamat": alamat,
  //       "telp": telp,
  //     });
  //     Get.back();
  //     await showSnackbar("Sukses", "Data Berhasil di Update");
  //   } catch (e) {}
  // }

  // deleteAllUser(id, users) async {
  //   DocumentReference cabang = master.collection("cabang").doc(id);
  //   try {
  //     await cabang.update({"users": []});
  //     // Get.back();
  //     removeUserCabang(users);
  //     showSnackbar("Sukses", "Data berhasil dihapus");
  //   } catch (e) {
  //     showSnackbar("Error", "Terjadi Kesalahan");
  //   }
  // }

  // removeUserCabang(List<dynamic> users) async {
  //   CollectionReference cabang = master.collection("users");
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //   try {
  //     await cabang.where("nama", whereIn: users).get().then((querySnapshot) {
  //       querySnapshot.docs.forEach((document) {
  //         batch.update(document.reference, {"kode_cabang": ""});
  //       });
  //       return batch.commit();
  //     });
  //     Get.back();
  //     // await showSnackbar("Sukses", "Data Berhasil di Update");
  //   } catch (e) {}
  // }

  // removeKaryawanCabang(List<dynamic> karyawan) async {
  //   CollectionReference cabang = master.collection("karyawan");
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //   try {
  //     await cabang.where("nama", whereIn: karyawan).get().then((querySnapshot) {
  //       for (var document in querySnapshot.docs) {
  //         batch.update(document.reference, {"cabang": ""});
  //       }
  //       return batch.commit();
  //     });
  //     Get.back();
  //     // await showSnackbar("Sukses", "Data Berhasil di Update");
  //   } catch (e) {}
  // }

  // updateUserCabang(idUser, List<dynamic> users) async {
  //   CollectionReference cabang = master.collection("users");
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //   try {
  //     await cabang.where("nama", whereIn: users).get().then((querySnapshot) {
  //       querySnapshot.docs.forEach((document) {
  //         batch.update(document.reference, {"kode_cabang": idUser});
  //       });
  //       return batch.commit();
  //     });
  //     // Get.back();
  //     // await showSnackbar("Sukses", "Data Berhasil di Update");
  //   } catch (e) {}
  // }

  // updateKaryawanCabang(idUser, List<dynamic> karyawan) async {
  //   CollectionReference cabang = master.collection("karyawan");
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //   try {
  //     await cabang.where("nama", whereIn: karyawan).get().then((querySnapshot) {
  //       for (var document in querySnapshot.docs) {
  //         batch.update(document.reference, {"cabang": idUser});
  //       }
  //       return batch.commit();
  //     });
  //     Get.back();
  //     await showSnackbar("Sukses", "Data Berhasil di Update");
  //   } catch (e) {}
  // }

  // Stream<QuerySnapshot<Object?>> getLevel() {
  //   CollectionReference kendaraan = master.collection("level");
  //   return kendaraan.orderBy("id", descending: false).snapshots();
  // }

  // @override
  // void onClose() {
  //   email.dispose();
  //   password.dispose();
  //   nama.dispose();
  //   notelp.dispose();
  //   namaLengkap.dispose();
  //   namaMerk.dispose();
  //   namaLevel.dispose();
  //   namaCabang.dispose();
  //   kotaCabang.dispose();
  //   alamatCabang.dispose();
  //   telpCabang.dispose();
  // }

  // addCabang(int id, String kode, String nama, String kota, String alamat,
  //     String telp) async {
  //   CollectionReference cabang = master.collection("cabang");
  //   try {
  //     await cabang.add({
  //       "id": id,
  //       "kode_cabang": kode,
  //       "kota": kota,
  //       "nama_cabang": nama,
  //       "alamat": alamat,
  //       "telp": telp,
  //     });
  //     Get.back();
  //     showSnackbar("Sukses", "Cabang baru berhasil ditambahkan");
  //   } catch (e) {
  //     showSnackbar("Error", "Terjadi Kesalahan");
  //   }
  // }

  // deleteCabang(String id) async {
  //   DocumentReference cabang = master.collection("cabang").doc(id);
  //   try {
  //     await cabang.delete();
  //     Get.back();
  //     showSnackbar("Sukses", "Cabang berhasil dihapus");
  //   } catch (e) {
  //     print(e.toString());
  //     showSnackbar("Error", "Terjadi Kesalahan");
  //   }
  // }
}
