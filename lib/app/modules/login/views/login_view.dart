import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import '../../../helper/alert.dart';
import '../controllers/login_controller.dart';

// ignore: must_be_immutable
class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final loginC = Get.put(LoginController());

  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        await Get.defaultDialog(
            radius: 5,
            title: 'Peringatan',
            content: const Text('Anda yakin ingin keluar dari aplikasi ini?'),
            confirm: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent[700]),
                child: const Text('TIDAK')),
            cancel: ElevatedButton(
                onPressed: () {
                  willLeave = true;
                  Get.back();
                },
                child: const Text('IYA')));
        return willLeave;
      },
      child: Scaffold(
        // backgroundColor: Colors.lightBlue,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.jpg'),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                // borderRadius: BorderRadius.circular(10.0),
                child: Image.asset('assets/logo.png'),
              ),
              Center(
                  child: AlertDialog(
                elevation: 20,
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Selamat Datang',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito'),
                    ),
                    Text(
                      'Masuk untuk akses web carwash ',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontFamily: 'Nunito'),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 50,
                      // width: Get.mediaQuery.size.width / 3.5,
                      child: TextField(
                        controller: user,
                        decoration: const InputDecoration(
                            label: Text('Username'),
                            prefixIcon: Icon(Icons.account_circle),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        onSubmitted: ((username) {
                          if (kIsWeb) {
                            if (pass.text.isEmpty && username.isEmpty) {
                              showSnackbar('Error',
                                  'Username dan Password tidak boleh kosong');
                            } else if (username.isEmpty) {
                              showSnackbar('Error', 'Username belum di isi');
                            } else if (pass.text.isEmpty) {
                              showSnackbar('Error', 'Password belum di isi');
                            } else {
                              loginC.login(user.text, pass.text);
                              user.clear();
                              pass.clear();
                            }
                          } else {
                            if (pass.text.isEmpty && username.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Error, Username dan Password kosong.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.redAccent[700],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (username.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Error, Username Kosong.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.redAccent[700],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (pass.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Error, Password kosong.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.redAccent[700],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              loginC.login(user.text, pass.text);
                              Fluttertoast.showToast(
                                  msg:
                                      "Sukses, Anda berhasil Login.\nSedang Mengalihkan ke Home",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.greenAccent[700],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              user.clear();
                              pass.clear();
                            }
                          }
                        }),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      // width: Get.mediaQuery.size.width / 3.5,
                      child: TextField(
                        controller: pass,
                        decoration: const InputDecoration(
                            label: Text('Password'),
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        obscureText: true,
                        onSubmitted: ((password) {
                          if (kIsWeb) {
                            if (password.isEmpty && user.text.isEmpty) {
                              showSnackbar('Error',
                                  'Username dan Password tidak boleh kosong');
                            } else if (user.text.isEmpty) {
                              showSnackbar('Error', 'Username belum di isi');
                            } else if (password.isEmpty) {
                              showSnackbar('Error', 'Password belum di isi');
                            } else {
                              loginC.login(user.text, pass.text);
                              user.clear();
                              pass.clear();
                            }
                          } else {
                            if (password.isEmpty && user.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Error, Username dan Password kosong.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.redAccent[700],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (user.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Error, Username kosong.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.redAccent[700],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (password.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Error, Password kosong.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.redAccent[700],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              loginC.login(user.text, pass.text);
                              Fluttertoast.showToast(
                                  msg:
                                      "Sukses, Anda berhasil Login.\nSedang Mengalihkan ke Home",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.greenAccent[700],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              user.clear();
                              pass.clear();
                            }
                          }
                        }),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (kIsWeb) {
                              if (pass.text.isEmpty && user.text.isEmpty) {
                                loginC.isLoading.value = false;
                                showSnackbar('Error',
                                    'Username dan Password tidak boleh kosong');
                              } else if (user.text.isEmpty) {
                                loginC.isLoading.value = false;
                                showSnackbar('Error', 'Username belum di isi');
                              } else if (pass.text.isEmpty) {
                                loginC.isLoading.value = false;
                                showSnackbar('Error', 'Password belum di isi');
                              } else {
                                loginC.login(user.text, pass.text);
                                loginC.isLoading.value = true;
                              }
                            } else {
                              if (pass.text.isEmpty && user.text.isEmpty) {
                                loginC.isLoading.value = false;
                                Fluttertoast.showToast(
                                    msg: "Error, Username dan Password kosong.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.redAccent[700],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (user.text.isEmpty) {
                                loginC.isLoading.value = false;
                                Fluttertoast.showToast(
                                    msg: "Error, Username kosong.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.redAccent[700],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (pass.text.isEmpty) {
                                loginC.isLoading.value = false;
                                Fluttertoast.showToast(
                                    msg: "Error, Password kosong.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.redAccent[700],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                loginC.isLoading.value = true;
                                loginC.login(user.text, pass.text);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 100,
                              fixedSize: const Size(140, 35),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          child: loginC.isLoading.value
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Masuk',
                                  style: TextStyle(fontSize: 17),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
