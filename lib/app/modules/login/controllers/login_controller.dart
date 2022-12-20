import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/alert.dart';
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
  var levelUser = "".obs;
  final bool running = true;

  Future<Login> login(username, password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await BaseClient().get('https://saputracarwash.online/api',
        '/user/login.php?username=$username&password=$password');

    dynamic users = json.decode(response)['rows'];

    Login dtUser = Login.fromJson(users);
    dataUser.value = dtUser;
    if (dataUser.value.sukses != 0) {
      kodeCabang.value = dataUser.value.kodeCabang!;
      kodeUser.value = dataUser.value.kodeUser!;
      userName.value = dataUser.value.username!;
      levelUser.value = dataUser.value.level!;
      await pref.setString("kode_cabang", dataUser.value.kodeCabang!);
      await pref.setString("kode_user", dataUser.value.kodeUser!);
      await pref.setString("user", dataUser.value.username!);
      await pref.setString("level", dataUser.value.level!);
      isLogin.value = await pref.setBool("is_login", true);
      if (kIsWeb) {
        showSnackbar('Sukses', 'Selamat Datang $username');
      } else {
        Fluttertoast.showToast(
            msg: "Selamat Datang $username.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.greenAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      isLogin.value = false;
      isLoading.value = false;
      if (kIsWeb) {
        showSnackbar('Gagal', 'Username atau Password salah');
      } else {
        Fluttertoast.showToast(
            msg: "Username atau Password salah.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    return dtUser;
  }

  logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("kode");
    await pref.setBool("is_login", false);
    isLogin.value = false;
    isLoading.value = false;
  }

  handleError(error) {
    if (error is BadRequestException) {
      var message = error.message;
      Get.defaultDialog(
          barrierDismissible: false,
          radius: 5,
          title: 'Error',
          content: Text(message.toString()),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
              onPressed: () {
                Get.back();
              }));
    } else if (error is FetchDataException) {
      var message = error.message;
      Get.defaultDialog(
          radius: 5,
          barrierDismissible: false,
          title: 'Error',
          content: Text(message.toString()),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Periksa'),
              onPressed: () async {}));
    } else if (error is ApiNotRespondingException) {
      Get.defaultDialog(
          barrierDismissible: false,
          radius: 5,
          title: 'Error',
          content: const Text('Oops! Server terlalu lama merespon.'),
          confirm: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
              onPressed: () {
                Get.back();
              }),
          cancel: ElevatedButton.icon(
              icon: const Icon(Icons.wifi_protected_setup_rounded),
              onPressed: () async {},
              label: const Text('Cek koneksi')));
    }
  }
}
