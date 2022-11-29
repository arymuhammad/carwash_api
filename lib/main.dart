// import 'package:auth/auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/modules/home/views/home_add.dart';
import 'app/modules/login/controllers/login_controller.dart';
import 'app/modules/login/views/login_view.dart';

import 'package:get/get.dart';

// import 'app/modules/home/views/home_view.dart';
import 'app/modules/home_web/views/home_web_view.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('is_login') ?? false;
  var kC = prefs.getString("kode_cabang")??"";
  var kU = prefs.getString("kode_user")??"";
  var username = prefs.getString("username")??"";
  final auth = Get.put(LoginController());
  if (auth.isLogin.value == false) {
    auth.isLogin.value = status;
  }
  if (auth.kodeCabang.value =="") {
    auth.kodeCabang.value = kC;
  }
  if (auth.kodeUser.value =="") {
    auth.kodeUser.value = kU;
  }
 
  if (auth.userName.value =="") {
    auth.userName.value = username;
  }

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Nunito'),
    title: "Mobile Car Wash Online",
    home: Obx(() => auth.isLogin.value
        ? kIsWeb
            ? HomeWebView(kodeCabang: auth.kodeCabang.value, username:auth.userName.value)
            : HomeAdd(
                kodeCabang: auth.kodeCabang.value,
                kodeUser: auth.kodeUser.value)
        : LoginView()),
    getPages: AppPages.routes,
  ));
  print(auth.isLogin.value);
  // print(kodeUser);
}
