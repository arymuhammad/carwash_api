import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/app_exceptions.dart';
import '../../../helper/base_client.dart';
import '../../../model/login_model.dart';

class LoginController extends GetxController {
  var dataUser = Login().obs;
  var isLoading = false.obs;
  var isLogin = false.obs;
  var kodeCabang = "".obs;
  var kodeUser = "".obs;
  var userName = "".obs;

  Future<Login> login(username, password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await BaseClient().get('http://103.112.139.155/api',
        '/user/login.php?username=$username&password=$password');
    // .catchError(handleError);
    dynamic users = json.decode(response)['rows'];
    // print(response);
    Login dtUser = Login.fromJson(users);
    dataUser.value = dtUser;
    if (dataUser.value.sukses != 0) {
      // isLogin.value = true;
      kodeCabang.value = dataUser.value.kodeCabang!;
      kodeUser.value = dataUser.value.kodeUser!;
      userName.value = dataUser.value.username!;
      await pref.setString("kode_cabang", dataUser.value.kodeCabang!);
      await pref.setString("kode_user", dataUser.value.kodeUser!);
      await pref.setString("user", dataUser.value.username!);
      isLogin.value = await pref.setBool("is_login", true);
      Fluttertoast.showToast(
          msg: "Selamat Datang $username.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent[700],
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      // isLogin.value = await pref.setBool("is_login", false);
      // await pref.setString("kode_cabang", dataUser.value.kodeCabang!);
      isLogin.value = false;
      isLoading.value = false;
      Fluttertoast.showToast(
          msg: "Username atau Password salah.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent[700],
          textColor: Colors.white,
          fontSize: 16.0);
    }
    // saveSession(dataUser.value.kode);
    return dtUser;
  }

  // saveSession(kode) async {

  // }

  // updateIsLogin(String id) async {
  //   DocumentReference user = firestore.collection("users").doc(id);
  //   try {
  //     await user.update({"isLogin": true});
  //     // ignore: empty_catches
  //   } catch (e) {}
  // }

  handleError(error) {
    // hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      // DialogHelper().showErroDialog(description: message);
      Get.defaultDialog(
          barrierDismissible: false,
          radius: 5,
          title: 'Error',
          content: Text(message.toString()),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
              onPressed: () {
                // fetchdataMaster();
                Get.back();
              }));
    } else if (error is FetchDataException) {
      var message = error.message;
      // DialogHelper().showErroDialog(description: message);
      Get.defaultDialog(
          radius: 5,
          barrierDismissible: false,
          title: 'Error',
          content: Text(message.toString()),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Periksa'),
              onPressed: () async {
                // await Get.to(() => SettingsView());

                // await Future.delayed(const Duration(milliseconds: 10), () {
                //   Get.back();
                //   isLoading.value = true;
                //   fetchdataMaster();
                // });
              }));
    } else if (error is ApiNotRespondingException) {
      // DialogHelper()
      //     .showErroDialog(description: 'Oops! It took longer to respond.');
      Get.defaultDialog(
          barrierDismissible: false,
          radius: 5,
          title: 'Error',
          content: const Text('Oops! Server terlalu lama merespon.'),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
              onPressed: () {
                // fetchdataMaster();
                Get.back();
              }),
          cancel: ElevatedButton.icon(
              icon: const Icon(Icons.wifi_protected_setup_rounded),
              onPressed: () async {
                // await Get.to(() => SettingsView());
                // await Future.delayed(const Duration(milliseconds: 10), () {
                //   Get.back();
                //   isLoading.value = true;
                //   fetchdataMaster();
                // });
              },
              label: const Text('Cek koneksi')));
    }
  }
}
