import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/data/utils/device/web_material_scroll.dart';
import 'app/model/login_model.dart';
import 'app/modules/home/views/home_add.dart';
import 'app/modules/home/views/home_view.dart';
import 'app/modules/home_web/views/home_web_view.dart';
import 'app/modules/login/controllers/login_controller.dart';
import 'app/modules/login/views/login_view.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('is_login') ?? false;
  var userDataLogin = prefs.getString('userDataLogin') ?? "";
  final auth = Get.put(LoginController());

  if (auth.isLogin.value == false) {
    auth.isLogin.value = status;
  }
  if (auth.logUser.value.username == null) {
    auth.logUser.value =
        userDataLogin != ""
            ? Login.fromJson(jsonDecode(userDataLogin))
            : Login();
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Nunito',
        primarySwatch: Colors.indigo,
        canvasColor: const Color.fromARGB(239, 180, 189, 199),
      ),
      title: "Saputra Car Wash",
      scrollBehavior: MyCustomScrollBehavior(),
      home: Obx(
        () =>
            auth.isLogin.value
                ? kIsWeb
                    ?
                    // HomeView(userData: auth.logUser.value)
                    HomeWebView(userData: auth.logUser.value)
                    : HomeAdd(
                      userData: auth.logUser.value,
                      // kodeCabang: auth.kodeCabang.value,
                      // kodeUser: auth.kodeUser.value,
                      // level: auth.levelUser.value,
                    )
                : LoginView(),
      ),
      localizationsDelegates: const [MonthYearPickerLocalizations.delegate],
      getPages: AppPages.routes,
    ),
  );
}
