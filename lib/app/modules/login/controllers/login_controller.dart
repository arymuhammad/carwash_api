import 'dart:convert';

import 'package:carwash/app/helper/service_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/alert.dart';
import '../../../helper/app_exceptions.dart';
import '../../../model/login_model.dart';

class LoginController extends GetxController {
  var dataUser = Login().obs;
  var isLoading = false.obs;
  var isLogin = false.obs;
  var kodeCabang = "".obs;
  var kodeUser = "".obs;
  var userName = "".obs;
  var levelUser = "".obs;
  var logUser = Login().obs;
  final bool running = true;

  Future<Login> login(username, password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final response = await ServiceApi().login(username, password);
    dataUser.value = response;

    if (dataUser.value.sukses! == 1) {
      await pref.setString(
        'userDataLogin',
        jsonEncode(
          Login(
            kodeUser: dataUser.value.kodeUser,
            kodeCabang: dataUser.value.kodeCabang,
            alamat: dataUser.value.alamat,
            idLevel: dataUser.value.idLevel,
            kota: dataUser.value.kota,
            level: dataUser.value.level,
            namaCabang: dataUser.value.namaCabang,
            telp: dataUser.value.telp,
            username: dataUser.value.username,
          ),
        ),
      );

      var tempUser = pref.getString('userDataLogin');
      logUser.value = Login.fromJson(jsonDecode(tempUser!));
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
          fontSize: 16.0,
        );
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
          fontSize: 16.0,
        );
      }
    }

    return response;
  }

  logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    logUser.value = Login();
    // await pref.remove("kode");
    // await pref.setBool("is_login", false);
    isLogin.value = false;
    isLoading.value = false;
    // showSnackbar('Sukses', 'Anda berhasil logout');
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
          },
        ),
      );
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
          onPressed: () async {},
        ),
      );
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
          },
        ),
        cancel: ElevatedButton.icon(
          icon: const Icon(Icons.wifi_protected_setup_rounded),
          onPressed: () async {},
          label: const Text('Cek koneksi'),
        ),
      );
    }
  }
}
